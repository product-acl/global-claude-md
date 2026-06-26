# Global CLAUDE.md — Agile Catalyst Labs

## Identity

Solo founder running a mobile app company from Colombia. I build and ship AI-powered apps at high velocity (1–2 launches/week) across product, engineering, and growth. Treat every task with that context — speed matters, but so does quality that survives the App Store review process and real user scrutiny.

## Stack Principles

I work across mobile (iOS/Android), backend, AI, and infra. The specific tools change per project — don't assume or lock into any particular framework, cloud provider, or library unless the project already uses it.

When suggesting tools or architecture, optimize for:
1. **Speed to ship** — managed services and batteries-included frameworks over rolling your own
2. **Solo-founder economics** — low fixed costs, pay-as-you-scale pricing, free tiers where possible
3. **Ecosystem maturity** — strong docs, active community, not bleeding-edge-unstable
4. **Portability** — avoid deep vendor lock-in. Prefer open standards and easy migration paths
5. **Local-first dev** — minimize cloud build costs. Local simulators/emulators over remote CI for day-to-day work

If a project already has a stack, read the config files (`package.json`, `Podfile`, `build.gradle`, etc.) and work within what exists. Only suggest migrations when the current choice is causing real pain.

## Build & Delivery

- Always build for both iOS and Android. Never assume single-platform unless explicitly told otherwise.
- Always use Expo (EAS Build) for mobile builds. No bare React Native CLI builds.
- Enable OTA updates (EAS Update) from day 0. Every project must ship with OTA configured before the first release.
- CI/CD via GitHub Actions connected to EAS from day 0. Builds and OTA updates must be automated from the first commit — never "we'll add CI later."
- All backend services must be hosted on Google Cloud Run. No other compute provider unless there's a specific technical reason.

## CI/CD & OTA Discipline (EAS / Expo) — non-negotiable

These rules exist because we lost real time when the *deployed* app silently stopped matching `main` (an OTA shipped from a dirty working clone; a CD workflow that watched a branch nobody merged into; OTAs that bundled `undefined` env). Treat them as hard rules.

- **`main` is the only source of truth AND the only deploy source.** Develop on short-lived branches off `main` → PR → merge to `main`. Never let a long-lived feature branch or a working clone become the de-facto trunk.
- **Never run `eas update` / `eas build` from a dirty working tree or a feature branch.** An OTA inlines whatever is checked out — including *uncommitted* code — so the deployed app stops matching any commit and is unreproducible. Ship from a clean `main` checkout, via CI wherever possible.
- **The CD/auto-OTA workflow must trigger on the branch the team actually merges into** (`main`). If the integration branch changes, change the trigger — otherwise it silently never fires.
- **A green CI run is not proof of a ship.** A "skip / build-required" classification ships nothing. Verify the EAS step actually ran and published.
- **`EXPO_PUBLIC_*` vars are inlined at build/update time, and `eas update` does NOT read `eas.json` build `env`.** The OTA job must load the same env (from `eas.json` or secrets) or the bundle ships `undefined` for backend URLs, API keys, RevenueCat keys, etc. — breaking the app on the next OTA.
- **On Expo SDK 55+, `eas update` requires an explicit `--environment <env>`** (e.g. `--environment production`) — CI *and* manual ships fail without it (`Error: --environment flag is required`). It also selects which environment's vars get inlined, so it pairs with the env rule above. A workflow that omits it silently never ships (a likely cause of OTAs drifting to manual runs).
- **The OTA/CD job must use the project's package manager end-to-end.** If deps install with `bun`, ship with `bunx eas-cli`, not `npx` — `npx` runs through npm, which fails closed on strictnesses bun tolerates (e.g. `EOVERRIDE` when a package is listed as *both* a direct dependency and an `overrides` entry) and crashes the job *before* `eas update` runs, silently breaking every auto-OTA. One package manager for install **and** ship.
- **`eas update --rollout-percentage` accepts 1–99, not 100.** For a full rollout, **omit the flag** (a plain update targets the whole channel); to finish a staged rollout, `eas update:edit <group-id> --rollout-percentage 100`. Passing `100` to `--rollout-percentage` errors the publish (`Rollout percentage must be between 0 and 99`).
- **Give critical runtime config a hardcoded fallback in code** (`process.env.X || '<known-good-prod-value>'`) so a missing/empty env can never brick the app. Never let a local-only `.env` be the *only* place the real value lives.
- **Classify every change before shipping:** JS/TS only → OTA (`eas update`); native/config (`app.json`, `eas.json`, deps/lockfile, `ios/`, `android/`, `google-services`) → new **build** + submit, never an OTA.
- **`runtimeVersion` gates OTA delivery.** Keep it for JS-only changes (OTA-compatible); bump it + rebuild for native changes. An OTA only reaches builds with a matching `runtimeVersion`.
- **OTA does NOT change the native `version` / `buildNumber` / `versionCode`** — never use the version string to judge whether an OTA applied. Use `expo-updates` `updateId` / `isEmbeddedLaunch`. The build number must increase on every store build — but **automate it** (next two bullets), don't hand-bump.
- **Automate store build numbers — never hand-bump.** Set `cli.appVersionSource: "remote"` + `autoIncrement: true` (on the build profile) in `eas.json` from day 0, then seed once with `eas build:version:set` (to the last store build number). EAS then owns `buildNumber`/`versionCode` and increments them **server-side on every build** — so a rebuild after a failed submit can't reuse a number and get rejected as a duplicate. The default `local` source forces a manual `app.json` bump before every (re)build, and reusing a number = a store rejection — we burned paid builds on exactly this. The marketing `version` still comes from `app.json`; bump *that* only for a deliberate user-facing release.
- **Know your version source of truth: managed vs bare.** If `ios/`/`android/` are **committed** (bare / prebuild), EAS *ignores* `app.json`'s `version`/`buildNumber` and reads the native files (`MARKETING_VERSION` in pbxproj; `versionName`/`versionCode` in gradle) — bumping `app.json` does nothing and the store keeps rejecting the duplicate. If they're **gitignored** (managed), `app.json` is authoritative. Check before touching versions: `git ls-tree -r --name-only origin/main -- <appdir>/ios | wc -l` (0 = managed). Remote `appVersionSource` (above) sidesteps this for the build number entirely.
- **Verify what's actually deployed, not what you assume.** Confirm the live `updateId` (`eas update:list` / EAS dashboard / in-app), that it was built from the expected commit, and — for real confidence — that a device *ran* the new code (e.g. a code-only marker such as a GA4 user property set only in the new bundle), not merely that it published.
- **Ship an in-app debug surface** (long-press the version row → `updateId`, `channel`, `runtimeVersion`, `isEmbeddedLaunch`, + "force update") so OTA state is verifiable in the field without adb/Metro.
- **Back up signing credentials off-machine.** The Android upload keystore + `credentials.json` stay gitignored (never commit) but a lost keystore is unrecoverable — document where they live; a fresh clone won't have them.

## Code Architecture

- Keep business logic out of UI components. Extract to hooks, services, or pure utility functions.
- Colocate related files by feature, not by type. Group a feature's logic, types, components, and tests together.
- Validate data at API boundaries with runtime checks (not just static types). Trust nothing from the network.
- Avoid premature abstraction. Duplicate twice before extracting a shared utility.
- Prefer composition over inheritance. Small, single-purpose modules over god objects.
- Follow the conventions already established in the project. Read existing code before adding new patterns.

## UX / UI Standards

- Design for mobile-first, always. Touch targets minimum 44x44pt.
- Skeleton loaders over spinners. Optimistic updates over loading states where safe.
- Respect system dark/light mode. Use semantic color tokens (e.g., `surface`, `textPrimary`), never raw hex values in components.
- Accessibility is not optional: all interactive elements need labels, images need roles. Test with VoiceOver / TalkBack.
- Error states are first-class UI. Every async operation needs: loading → success → error → empty states.
- Animations should use the platform's best-practice library (e.g., `reanimated` for RN, `SwiftUI` animations for iOS). Avoid deprecated or low-level animation APIs.
- Deep links must work. Test them.
- Every app must include the feedback form from `https://github.com/product-acl/feedback-form` in its Settings screen. No app ships without it.

## Analytics & Attribution

- All events go through Firebase Analytics. No other analytics provider unless the project explicitly requires it.
- Every button must fire a `button_tap` event with the button name as a parameter.
- Every screen must fire a `screen_rendered` event with the screen name as a parameter.
- Onboarding flows must fire `onboarding_started` and `onboarding_finished` events.
- The paywall view event must always carry a `screen_name` parameter identifying the screen it was shown from (e.g. `home`, `settings`, `scan`, `session_limit`). A bare paywall-view event is useless — you can't tell which surface drives paywall impressions (or which converts), so never fire one without it.
- Wire these events during implementation, not as a follow-up task. No screen, button, or flow ships without them.
- Always install and configure the Meta (Facebook) SDK. Send `install` and `purchase` events back to Meta for ad attribution. This is non-negotiable — without it, campaign optimization is blind.

## Growth Hypotheses & Experimentation

When forming any growth/product hypothesis (why a metric or behavior is what it is), follow this discipline. For the full guided workflow, run `/hypothesis`.

- **A hypothesis is a falsifiable causal claim, NOT a solution.** "Move the paywall to the end screen" is a *solution*; the hypothesis is "asking for payment before the user experiences value suppresses conversion." Write the belief about *why*, not the action to take.
- **Make it specific + testable + falsifiable:** name the independent variable, the dependent variable (metric), the direction, and the population — plus a measurable prediction the data could prove wrong. Template: *"[users] who [condition/intervention] show [higher/lower] [metric] than [comparison], because [mechanism]."*
- **Ground the mechanism in code/data BEFORE asserting it.** Trace the causal path (read the code, query the events). Separate what's PROVEN (logged events, traced code) from what's INFERRED. Confirm the data is real users, not your own test devices.
- **Calibrate against noise — don't over-attribute.** 0 conversions from a small denominator is the *expected* outcome, not "broken." Correlation ≠ causation. State competing explanations and what the data can/can't distinguish; check counter-evidence before blaming a cause.
- **Keep Problem → Hypothesis → Experiment separate.** The ticket holds the observation + the claim; the solution (what to build) is defined later, not baked into the claim.
- **Every hypothesis carries:** a stable id, IV/DV + direction, the prediction + success threshold + by-when, the grounding evidence, and a confidence scaled to sample size + source reliability.

## Monetization

- Always use RevenueCat for paywalls and subscription management. No custom payment logic.
- RevenueCat handles receipt validation, entitlement checks, and cross-platform sync — don't reimplement any of that.

## Code Style

- Strict type safety. Use the strictest compiler/linter settings the language supports.
- No debug logging in committed code. Use a structured logger or remove before commit.
- Async error handling: always handle errors explicitly. Never let promises/tasks float unhandled.
- Exhaustive pattern matching / switch statements — handle every case, fail loudly on unknown variants.
- Let formatters and linters enforce style mechanically. Don't rely on discipline for whitespace and import order.

## Testing & QA (Test-Driven Development)

- Follow TDD: write the test first, watch it fail, then write the minimum code to make it pass, then refactor. No exceptions.
- Every new feature starts with a failing test that defines the expected behavior before any implementation code is written.
- Test behavior, not implementation details. Tests should survive refactors.
- Critical business logic (payments, auth, data transforms) requires unit tests with edge cases.
- Mock external dependencies at the network boundary, not by patching internal modules.
- Run the project's typecheck and lint commands before considering work complete.
- Test on all target platforms (iOS simulator, Android emulator, browser — whatever the project ships to).
- Snapshot tests are discouraged — they break constantly and catch nothing meaningful.

## Security

- NEVER hardcode API keys, tokens, or secrets in source code. Use the platform's recommended approach (env vars, secure config, keychain/keystore).
- Validate and sanitize all user input on both client and server.
- Use HTTPS everywhere. No exceptions.
- Auth tokens: store in the platform's secure storage (Keychain on iOS, Keystore on Android, `expo-secure-store` for Expo). Never use plaintext local storage.
- Implement certificate pinning for production builds handling payments or sensitive data.
- Audit dependencies regularly. Remove unused packages aggressively.
- Deep link and URL scheme parameters must be validated. Never trust external input without sanitization.
- Rate limit and debounce user-triggered API calls to prevent abuse.

## Git & Workflow

- Before starting any project, check if a GitHub repository exists. If not, create it under the `product-acl` GitHub account.
- Branch per feature or fix. Never commit directly to `main`.
- Conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`.
- Small, reviewable PRs. If a diff exceeds ~400 lines, break it up.
- Always pull and rebase before pushing.
- NEVER commit or push without asking first.
- NEVER delete files without explicit confirmation.
- Prefer fixing root causes over workarounds.

## Verification Checklist

Before considering any task complete:
1. Typecheck passes (the project's compiler with strict mode)
2. Lint passes with no new warnings
3. Existing tests pass
4. New tests written for new logic
5. Tested on target platform(s) — simulator, emulator, or browser as applicable
6. No hardcoded secrets or debug logging left behind
7. Every new button fires `button_tap`, every new screen fires `screen_rendered`
8. If the feature involves payments: RevenueCat integration, Meta `purchase` event wired

## XcodeBuildMCP Integration

Tools change across versions — never rely on a hardcoded list. Discover available tools at runtime.

### Usage Rules
- ALWAYS inspect the screen (`snapshot-ui`) before interacting — look first, act second.
- Use accessibility labels for taps (more reliable than coordinates).
- Capture logs before navigating, stop capture after — bracket every interaction.
- Take a screenshot after each major interaction to confirm the result.
- If a tool returns nothing, check that `xcodebuildmcp.yml` exists in the project root with the correct scheme and projectPath.

### QA Agent Workflow
When asked to QA an iOS app:
1. Discover the Xcode project
2. Build and launch on simulator
3. Start log capture
4. Inspect the current screen
5. Tap through every main screen using accessibility labels
6. Screenshot after each interaction
7. Log all bugs, crashes, and UI issues to `qa-report.md`
8. Stop log capture, include relevant logs in the report

### Coder Agent Workflow
When asked to fix bugs from a QA pass:
1. Read `qa-report.md`
2. Fix each issue in source
3. Log fixes to `fixes-log.md`
4. Never commit without explicit user approval

## When Unsure

- Read existing code in the project first. Match patterns already established.
- Ask me before introducing a new dependency or paradigm shift.
- If a task is ambiguous, present 2–3 concrete approaches with tradeoffs rather than guessing.
