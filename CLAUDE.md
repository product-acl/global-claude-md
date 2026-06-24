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

## Analytics & Attribution

- All events go through Firebase Analytics. No other analytics provider unless the project explicitly requires it.
- Every button must fire a `button_tap` event with the button name as a parameter.
- Every screen must fire a `screen_rendered` event with the screen name as a parameter.
- Onboarding flows must fire `onboarding_started` and `onboarding_finished` events.
- Wire these events during implementation, not as a follow-up task. No screen, button, or flow ships without them.
- Always install and configure the Meta (Facebook) SDK. Send `install` and `purchase` events back to Meta for ad attribution. This is non-negotiable — without it, campaign optimization is blind.

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
