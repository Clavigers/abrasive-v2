# Abrasive v2 — Marketing Site + Web App Refinement

You are working on the Abrasive marketing site and web app for Claviger. Your job is to clone the existing repo, extract two directories into a new unified repo, and apply a specific set of surgical changes. You are REFINING, not recreating. Remove and rearrange. Do not rewrite what isn't broken.

---

## STEP 1: SETUP

### Source and destination
- **Source repo:** `Clavigers/abrasive` on GitHub (private). The relevant directories inside it are `/website` (Astro marketing site, deploys to Netlify) and `/web_app` (the dashboard).
- **Destination repo:** `leopham00/abrasive-v2` on GitHub (does not yet exist — you will create it).
- **Local working directory:** `~/Desktop/Create/Sites+Project/Clients/Willbur/Abrasive/abrasive_website` (already exists, currently contains a `docs/` folder with this prompt). All work happens here. Do not create a new sibling folder.

### Authentication
- Git/`gh` CLI on this machine should already be authenticated as `leopham00`. Verify with `gh auth status` before proceeding.
- `leopham00` must be a collaborator on `Clavigers/abrasive` with at least read access. If `git clone` of the source repo fails with auth errors, stop and tell the user — do not attempt to bypass.
- Sharing the new `abrasive-v2` repo with `sadosystems` will be handled manually by the user after CC is done. Do not add collaborators.

### Setup sequence
1. From inside `~/Desktop/Create/Sites+Project/Clients/Willbur/Abrasive/abrasive_website`, clone the source repo into a temp location (e.g. `/tmp/abrasive-source`) — do **not** clone it into the working directory.
2. Copy `/website` and `/web_app` from the temp clone into the working directory root, preserving them as `./website` and `./web_app`. Preserve the existing `./docs` folder untouched.
3. Preserve all code, assets, dependencies, lockfiles (`bun.lock`, `package.json`, `tsconfig.json`, `vite.config.ts`, etc.), and configs (Astro config, Netlify config, env handling) inside `/website` and `/web_app`. Do not alter anything not explicitly listed below.
4. Initialize a fresh git repo in the working directory (`git init`). Do NOT preserve the source repo's git history.
5. Create the GitHub repo: `gh repo create leopham00/abrasive-v2 --private --source=. --remote=origin` (confirm `--private` is correct with the user if uncertain).
6. Delete the temp clone (`/tmp/abrasive-source`) once the copy is verified.
7. Confirm both subprojects install and build cleanly before making any changes:
   - `cd website && bun install && <existing build script>`
   - `cd web_app && bun install && <existing build script>`
   - If either fails, stop and report the failure — do not proceed to Step 2.
8. Make an initial commit (`chore: import website and web_app from Clavigers/abrasive`) and push to `origin/main` (or `master`, matching whatever branch the source uses) before starting any edits.

---

## STEP 2: MARKETING SITE CHANGES (`/website`)

Work file by file. Locate the existing markup and remove or reorder elements — do not rewrite pages from scratch.

### NAV (all pages)
**Remove:** Features, Pricing, Docs, Blog, existing GitHub link
**Keep (always):** Abrasive wordmark, linked to `/`
**Keep (logged-out state):** Sign in, Sign up free
**Keep (logged-in state):** avatar + dashboard button — exactly as-is, do not touch
**Add:** Demo link (→ `/demo`), GitHub link (→ `https://github.com/Clavigers/abrasive`)

Final nav order, logged out: `[Wordmark] ............. [Demo] [GitHub] [Sign in] [Sign up free]`
Final nav order, logged in: `[Wordmark] ............. [Demo] [GitHub] [avatar] [dashboard button]`

### HOME PAGE (`/`)
**Remove:**
- The abrasive box product image and its "Please excuse my slop" caption
- The RedBubble dog image/link
- The "Wouldn't it be nice if Bazel and Rust got along?" section AND all body copy beneath it (the full Bazel/Cargo/Sccache/Nextest exposition, Will's founder note, etc.)
- The "More installation methods" link beneath the install command
- The "Get Started" CTA button (the one linking to `/getting-started`)

**Keep (do not alter copy or styling):**
- "FAST RUST BUILDS" hero headline
- The install command block (`cargo install abrasive`)
- The "Demo ▷" CTA (links to `/demo`)
- The WARNING pre-alpha notice — copy must remain word-for-word identical
- The user cap block: "I can handle about 20 users right now. If we hit the cap, new signups will pause. 3 of 20 signed up" + progress bar + "Sign up free" CTA — copy must remain word-for-word identical

### HOME PAGE FLOW (top to bottom, after changes)
1. Nav
2. "FAST RUST BUILDS" hero
3. Install command (`cargo install abrasive`) + "Demo ▷" CTA
4. Getting Started steps (inlined from former `/getting-started` page — see below)
5. WARNING pre-alpha notice
6. User cap block (20 users, progress bar, Sign up CTA)
7. Footer

### INLINE GETTING STARTED CONTENT
Pull the 5-step content from the existing `/getting-started` page and render it inline on the home page in the position shown above (between the install CTA and the WARNING). Reuse the existing components/markup — do not rewrite the steps.

**Then delete the `/getting-started` page entirely.** Remove the route file, any imports of it, and any remaining references in nav, footer, sitemap, or internal links. After this change, `/getting-started` should 404 — the content lives only on the home page.

Steps to inline (titles + content, preserving existing copy):
1. **Install abrasive** — `cargo install abrasive`
2. **Authenticate** — `abrasive auth`
3. **Initialize your project** — `abrasive setup` (with the existing `abrasive.toml` explanation)
4. **Build** — `abrasive build`, `abrasive run -- --help`, `abrasive test`
5. **Set up a cargo alias (optional)** — bash/zsh/fish variants

### FOOTER (marketing site)
Simplify to a single row. Flatten existing footer nav links to one line.
Layout: `[Home] [Demo] [GitHub] [TOS] [Privacy Policy] .... © 2026 Claviger.`

- Home → `/`
- Demo → `/demo`
- GitHub → `https://github.com/Clavigers/abrasive`
- TOS → `/tos`
- Privacy Policy → `/privacy`

### NEW PAGES
Create `/tos` and `/privacy` as minimal placeholder pages using the existing site layout (same nav, same footer, same global styles).

Body content for each:
- H1: "Terms of Service" (or "Privacy Policy")
- One paragraph: `This page is a placeholder. Full Terms of Service coming soon.` (or `…Full Privacy Policy coming soon.`)

No other content.

---

## STEP 3: WEB APP / DASHBOARD CHANGES (`/web_app`)

Make only these changes:

1. **Dashboard footer:** Simplify to just `© 2026 Claviger.` Remove all other footer content. Apply this by editing the shared dashboard footer component so every page using it updates at once.
2. **Everything else** in the dashboard (API tokens page, all other pages, nav, layout, routing, auth, styling) stays exactly as-is. Do not touch it.

---

## STEP 4: VERIFY

Before finishing, confirm each item:
- Home page renders the inlined getting-started steps in the correct position
- `/getting-started` route returns 404 (page and all references fully removed)
- Nav is correct in both logged-in and logged-out states (correct items, correct order, correct links)
- WARNING copy is word-for-word identical to the original
- User cap copy is word-for-word identical to the original
- `/tos` and `/privacy` exist, render with the site's nav and footer, and contain only H1 + the placeholder paragraph
- Dashboard footer reads only `© 2026 Claviger.` on every dashboard page
- No other dashboard changes were made (diff `/web_app` against the source — only the footer component should differ)
- `/website` runs locally with no broken imports, no missing assets from removed elements, no console errors
- `/web_app` runs locally with no regressions
- `/website` builds cleanly for Netlify deploy with no config changes needed

---

## CONSTRAINTS
- Do not rewrite any component from scratch if it can be edited in place
- Do not change any copy unless explicitly instructed
- Do not alter styling, color, typography, or layout beyond what is listed
- Preserve all Astro/framework configs, Netlify config, env handling
- The new repo should be deployable to Netlify from day one with no additional config changes
- If you encounter ambiguity not covered above, stop and ask before guessing
