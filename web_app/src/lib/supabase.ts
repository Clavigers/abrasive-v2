import { createClient, type SupabaseClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const isSupabaseConfigured = Boolean(url && anonKey)

const stubClient = {
  auth: {
    getSession: async () => ({ data: { session: null }, error: null }),
    onAuthStateChange: () => ({
      data: { subscription: { unsubscribe: () => {} } },
    }),
    signInWithOAuth: async () => {
      console.warn('[abrasive] Supabase is not configured — sign-in is disabled in placeholder mode.')
      alert('Sign-in is disabled in placeholder mode (VITE_SUPABASE_URL / VITE_SUPABASE_ANON_KEY not set).')
      return { data: { provider: 'github', url: null }, error: null }
    },
    signOut: async () => ({ error: null }),
  },
  from: () => {
    const builder: any = {
      select: () => builder,
      insert: () => builder,
      update: () => builder,
      delete: () => builder,
      eq: () => builder,
      order: () => builder,
      limit: () => builder,
      single: async () => ({ data: null, error: null }),
      then: (resolve: (value: { data: never[]; error: null }) => void) =>
        resolve({ data: [], error: null }),
    }
    return builder
  },
} as unknown as SupabaseClient

export const supabase: SupabaseClient = isSupabaseConfigured
  ? createClient(url as string, anonKey as string)
  : stubClient
