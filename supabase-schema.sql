-- Canonical schema for api_tokens. Run in Supabase SQL editor.

drop table if exists api_tokens cascade;

create table api_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  token_hash text not null unique,
  prefix text not null,
  scope text not null default 'read-write' check (scope in ('read', 'read-write')),
  created_at timestamptz not null default now(),
  expires_at timestamptz,
  last_used_at timestamptz
);

create index api_tokens_user_id_idx on api_tokens (user_id);

alter table api_tokens enable row level security;

create policy "users read own tokens" on api_tokens for select
  using (auth.uid() = user_id);
create policy "users create own tokens" on api_tokens for insert
  with check (auth.uid() = user_id);
create policy "users delete own tokens" on api_tokens for delete
  using (auth.uid() = user_id);

create view api_tokens_public with (security_invoker = true) as
  select id, user_id, name, prefix, scope, created_at, expires_at, last_used_at
  from api_tokens;

grant select on api_tokens_public to authenticated;

-- Public user count for the marketing site's "X of N signed up" gate.
-- SECURITY DEFINER lets it read auth.users; anon may call it to get just the count.
create or replace function public.user_count()
returns integer
language sql
security definer
set search_path = public
stable
as $$
  select count(*)::int from auth.users;
$$;

grant execute on function public.user_count() to anon, authenticated;

-- Single-row config holding the signup cap. Source of truth for both the
-- enforcement trigger and the marketing UI.
create table if not exists public.signup_config (
  id boolean primary key default true,
  user_cap integer not null default 20,
  constraint signup_config_singleton check (id = true)
);

insert into public.signup_config (id, user_cap)
values (true, 20)
on conflict (id) do nothing;

-- Combined count + cap, exposed to anon so the marketing page can render with one round-trip.
create or replace function public.signup_status()
returns json
language sql
security definer
set search_path = public
stable
as $$
  select json_build_object(
    'count', (select count(*)::int from auth.users),
    'cap', (select user_cap from public.signup_config where id = true)
  );
$$;

grant execute on function public.signup_status() to anon, authenticated;

-- Hard enforcement: reject inserts into auth.users once the cap is hit.
-- Runs for every auth provider (OAuth, email/password, magic link, etc.).
create or replace function public.enforce_signup_cap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  current_cap integer;
  current_count integer;
begin
  select user_cap into current_cap from public.signup_config where id = true;
  if current_cap is null then
    return new; -- no cap configured, allow signup
  end if;
  select count(*) into current_count from auth.users;
  if current_count >= current_cap then
    raise exception 'Signup cap reached (% of %).', current_count, current_cap
      using errcode = 'P0001';
  end if;
  return new;
end;
$$;

drop trigger if exists enforce_signup_cap_trigger on auth.users;
create trigger enforce_signup_cap_trigger
  before insert on auth.users
  for each row execute function public.enforce_signup_cap();
