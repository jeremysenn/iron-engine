# TODOS

Items deferred from the KILO Engine MVP (CEO review 2026-04-03).

## P1 — First post-MVP features

### LLM Coaching Explanations
**What:** Integrate Anthropic Claude API to generate natural language explanations of program
decisions. "Your front squat ratio is 80%, optimal is 85%. This is your lower body limiting lift."
**Why:** Differentiates ShapeTrak from every other coaching platform. Helps coaches communicate
"why" to clients without writing prose themselves.
**Effort:** M (human: ~2 weeks / CC: ~4 hours)
**Depends on:** MVP complete, Anthropic API key
**Context:** Design doc Phase 5. The rule engine generates `generation_metadata` JSONB that
serves as input to the LLM. Explanations are cached per program. Estimated API cost: ~$1-2/year
per coach with 15 clients.

### Stripe Billing Integration
**What:** Subscription paywall for coach accounts. Free trial → paid.
**Why:** Revenue. Can't have paying customers without a payment system.
**Effort:** M (human: ~1 week / CC: ~2 hours)
**Depends on:** MVP validated with real coaches, pricing model decided
**Context:** Design doc Phase 1. Port billing patterns (not code) from old syd_api. Stripe API
has changed since Rails 4 era. Consider a `billing_status` field on User model.

### Body Composition Goal + GBC Templates
**What:** Add `body_composition` as a goal enum value with Full Body GBC (German Body Comp)
templates from the KILO Training Split Database.
**Why:** Covers another goal type. Deferred from the body part template plan because it's a
cross-cutting concern (touches split selection, rep schemes, rest periods, periodization model,
and phase structure). Needs its own periodization model rows in the seed data.
**Effort:** M (human: ~1 week / CC: ~30 min)
**Depends on:** Body part template system complete
**Context:** The Training Split Database PDF has a dedicated Body Composition section with Full
Body sessions that alternate upper/lower exercises for peripheral heart action. Run /office-hours
to scope this properly before implementation.

## P2 — Post-MVP polish

### PDF Export
**What:** Generate downloadable PDF of the 12-week program with all sessions, exercises, sets,
reps, tempo, rest periods laid out in a printable format.
**Why:** Coaches need to hand programs to clients. Without this, they screenshot or copy/paste.
**Effort:** S (human: ~3 days / CC: ~1 hour)
**Depends on:** MVP complete
**Context:** Use Prawn gem or wicked_pdf. Design the PDF layout to match the program display view.

### Seed Data Admin Viewer
**What:** Read-only web UI for browsing KILO reference tables (periodization models, rep schemes,
exercises, splits, training methods).
**Why:** Essential before onboarding external coaches who need to verify the data against their
own KILO training. Without it, all corrections require a developer in the database.
**Effort:** S (human: ~2 days / CC: ~30 min)
**Depends on:** Seed data populated
**Context:** Simple scaffolded index/show views for each Kilo* model. Admin-only access.

### Program Diff / Reassessment Comparison
**What:** When a client is reassessed and a new program generated, show what changed and why.
**Why:** Coaches need to explain progress to clients. "Front squat improved 5%, no longer your
limiting lift. Program shifts to prioritize overhead press."
**Effort:** M (human: ~1 week / CC: ~2 hours)
**Depends on:** Program versioning (status enum + archived_at, in MVP scope)
**Context:** Compare `generation_metadata` JSONB between active and most recent archived program.
Highlight changes in limiting lifts, model selection, phase structure.

## P3 — Future phases

### Body Comp Calculator
Port Jackson-Pollock 3/7-site, BMI, waist-hip ratio from old syd_api. Design doc Phase 4.

### Client Invitation Flow
Allow coaches to invite clients. Clients get accounts. Design doc Phase 4.

### Messaging
Coach-to-client messaging. Design doc Phase 4.

### Landing Page / Marketing
Public-facing marketing site. Design doc Phase 6.
