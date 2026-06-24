# Context brief — Growth experimentation machine

## Who we are

We build AI-powered apps and launch 1–2 per week. The goal is not to find one growth model and scale it — it is to build a **growth experimentation machine**: a repeatable system that tests hypotheses across every launch, extracts signal, and compounds learnings into the portfolio over time.

We are currently in early stage. We have 3 live apps.

---

## The three live apps

| App | Niche | Archetype | Monetization | Diagnosis |
|---|---|---|---|---|
| Gratitude Journal | Daily journaling | Daily compulsion | Lifetime purchase | Monetization mismatch — should be subscription |
| Encore | Daily affirmations | Daily compulsion | $2.99/mo or $29.99/yr | Well aligned — optimize paywall timing |
| Split Bite | Bill splitting at restaurants | Event-driven | $2.99/mo or $29.99/yr | Critical mismatch — subscription wrong for event-driven app, switch to one-time purchase or usage gate |

---

## The growth framework

### Core pillars
Every app hypothesis is built across three pillars:

- **Acquisition** — how users find the app (channel, hook, CAC target)
- **Retention** — what brings them back (core loop, habit trigger, D7/D30 target)
- **Monetization** — how value is captured (model, paywall trigger, ARPU target)

### The experimentation machine — 5-step loop

1. **Classify the niche** into an archetype before building. Physics first.
2. **Write the hypothesis card** — one written bet per pillar, pre-launch.
3. **Launch and observe** — 3-week minimum observation window per app.
4. **Score the hypotheses** — pass/fail per pillar, not "did it work overall."
5. **Feed the portfolio** — winners become defaults, losers get retired.

### Two-phase experiment design

**Phase 1 (apps 1–12):** Single-variable sweep. Hold 2 pillars constant, vary 1 per launch. Goal: identify winners per axis.

**Phase 2 (apps 13+):** Intentional combination testing. Fix winners on 2 axes, test the last variable. Then converge on validated combos.

---

## The six niche archetypes

Each archetype has different growth physics. Classify every app before designing its hypothesis.

### 1. Daily compulsion
Apps built around a daily habit. Value compounds with repetition.
- **Examples:** fitness, language learning, journaling, meditation, affirmations
- **Acquisition:** organic content + TikTok/short-form video
- **Retention:** streaks, daily prompts, push notifications
- **Monetization:** freemium → subscription (value is ongoing, recurring billing feels fair)
- **Key metrics:** D30 retention, average streak length, trial-to-paid conversion
- **Watch out for:** low D7 is a death signal here — if they don't come back in a week, they're gone

### 2. Event-driven
Apps that solve a specific problem occurring occasionally. Users come with high intent, complete the task, leave.
- **Examples:** tax tools, resume builders, bill splitters, wedding planners, travel planning
- **Acquisition:** SEO + paid search (high-intent queries)
- **Retention:** low by nature — this is normal, do not benchmark against D30
- **Monetization:** one-time purchase or usage gate at point of use (NOT subscription)
- **Key metrics:** conversion rate at paywall, sessions per user per month, revenue per install
- **Watch out for:** subscription model here will always churn — users realize they pay monthly for something they use twice a month

### 3. Creative output
Apps that help users make something — image, video, music, writing. Every output shared publicly is an acquisition touchpoint.
- **Examples:** AI image generators, video tools, music creation, writing assistants
- **Acquisition:** viral outputs + TikTok (outputs are the ad)
- **Retention:** saved outputs, gallery, creation history
- **Monetization:** usage-based / credits (heavy users produce more, should pay more)
- **Key metrics:** outputs created per user, outputs shared publicly, credit conversion rate
- **Watch out for:** flat subscription under-captures value from heavy users

### 4. Pro workflow
Apps that embed into how someone does their job. High switching costs once integrated.
- **Examples:** dev tools, legal drafting, marketing copy, data analysis
- **Acquisition:** Product Hunt, professional communities, word of mouth
- **Retention:** workflow integration (hardest to leave once embedded)
- **Monetization:** subscription (saves time daily — recurring billing feels justified)
- **Key metrics:** weekly active use, tasks completed per session, month 2 churn
- **Watch out for:** needs real domain depth to earn professional trust — harder to build fast

### 5. Social / identity
Apps about how users see themselves or present themselves to others.
- **Examples:** avatar generators, personality tests, AI companions, astrology apps
- **Acquisition:** viral sharing — users share because it says something about who they are
- **Retention:** identity lock-in, persona investment
- **Monetization:** freemium → subscription
- **Key metrics:** shares per user, viral coefficient, D7 retention
- **Watch out for:** explosive growth is possible but identity hooks can fade — retention is fragile

### 6. Reference / lookup
High-volume, low-engagement utilities. Users consult when they need a quick answer.
- **Examples:** recipe tools, plant ID, symptom checkers, dictionaries
- **Acquisition:** SEO dominant — people search for the answer and land on the app
- **Retention:** low — sessions are short, return frequency is low — this is normal
- **Monetization:** ads or one-time purchase (no recurring hook to justify subscription)
- **Key metrics:** sessions per month, avg session length, revenue per MAU
- **Watch out for:** do not build retention mechanics for a reference app — waste of resources

---

## Portfolio learning (current state)

What the machine has learned from the 3 live apps:

| Signal | Status |
|---|---|
| TikTok as acquisition channel | Validated for daily-compulsion archetype — make it default, stop testing |
| Subscription for daily-compulsion | Validated (Encore) — replicate, test edge cases (price, trial length) |
| Lifetime purchase for habit apps | Anti-pattern — never use again for daily-compulsion |
| Event-driven monetization | Untested — Split Bite is the live test after model fix |
| Event-driven + subscription | Likely mismatch — hypothesis to retire |

### Emerging rules
- Daily compulsion + TikTok + subscription = validated combo. Lock as default.
- Lifetime purchase on habit apps = anti-pattern. Archived.
- Need minimum 3 apps per archetype before drawing cross-archetype conclusions.
- Minimum 3-week observation window per app before scoring hypotheses.

---

## What we are working on next

We are about to enrich this framework with notes from a growth course. The goal is to:

1. Validate or challenge the archetype classifications with course material
2. Add named frameworks or mental models from the course to the hypothesis card
3. Replace generic metric targets with benchmarks that have a source
4. Rebuild the growth experimentation machine artifact with the enriched model

---

## Artifacts already built

- `growth_experimentation_machine.html` — interactive framework with pre-launch intake form, scorecard generator, portfolio tracker, and learning layer. Light theme. Built in a previous Claude session.
- `app_growth_analysis.html` — diagnosis of the 3 live apps with fit scores and recommendations.

---

## How to work with us

- We think in frameworks and systems, not one-off tactics
- We want models we can apply to every new launch, not advice specific to one app
- When we bring new material (course notes, data, research), integrate it into the existing framework — don't start over
- Flag when something in our current model contradicts the new material
- Prioritize actionable output: updated artifacts, hypothesis cards, decision rules
