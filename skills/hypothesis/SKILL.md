---
name: hypothesis
description: Form a rigorous, falsifiable growth/product hypothesis from an observation. Use when forming, sharpening, or pressure-testing a hypothesis about WHY a metric or user behavior is happening (e.g. "why is no one buying", "why do users drop at step X", "hypothesize why retention fell"). Separates the claim from the solution, grounds the mechanism in code/data, and calibrates against noise. Triggers: "form a hypothesis", "is this a good hypothesis", "hypothesize why", "/hypothesis".
---

# Form a rigorous hypothesis

Turn an observation into a **falsifiable, evidence-grounded hypothesis — not a solution.**
Input: an observation / problem / question (from the user's args or the current context).
If the observation is vague (no metric or numbers), ask for the specific metric + figures first.

## Method — work through these, then show the RESULT (not the scaffolding)

1. **State the observation precisely.** The metric or behavior + the actual numbers + the window.
   ("62 installs → 18 paywall views → 0 purchases over 14 days.")

2. **Ground it before claiming a mechanism.** Do NOT assert *why* until you've checked:
   - Read the relevant code path and/or query the events/data. Cite `file:line` or the query.
   - Separate **PROVEN** (logged events, traced code, queried data) from **INFERRED**. Label each.
   - Confirm the signal is **real users, not test devices**; note the **sample size**.
   - If you can't ground it, say so and cap confidence at **low**.

3. **Separate the solution from the claim.** If what you wrote is an action ("move X", "add Y",
   "remove Z"), that's a *solution* — extract the underlying belief about WHY it would work. The
   belief is the hypothesis; the action is just one experiment that could test it.

4. **Write the hypothesis as a falsifiable causal claim.** Use a template:
   - Causal/directional: *"[users] who [condition/intervention] show [higher/lower] [metric] than
     [comparison], because [mechanism]."*
   - Associative: *"Among [users], [variable A] is [positively/negatively] associated with [metric B]."*
   Name the **independent variable**, the **dependent variable (metric)**, the **direction**, the **population**.

5. **State the prediction + the falsifier.** The measurable prediction (success threshold + by-when),
   AND the result that would prove the hypothesis WRONG. If nothing could refute it, it isn't a
   hypothesis — rewrite it.

6. **Calibrate.** Scale confidence to sample size + source reliability. 0 from a small denominator is
   the *expected* outcome, not "broken." Correlation ≠ causation. List competing explanations the data
   can't yet distinguish.

## Output — this exact shape

- **id:** `H-<YYYY-MM-DD>-<NN>`
- **observation:** <metric/behavior + numbers + window>
- **hypothesis:** <the falsifiable causal claim — variables + direction + mechanism>
- **variables:** IV = … · DV = … · direction = …
- **prediction:** <measurable>; **success threshold:** …; **by:** <when>; **falsified if:** <result>
- **evidence:** PROVEN — … · INFERRED — … · sample size — … · real-users-verified? …
- **confidence:** low | med | high — <why, tied to n + source reliability>
- **competing explanations:** <what else could cause this; what the data can/can't distinguish>
- **candidate experiment(s):** <kept SEPARATE from the claim — what you'd build/run to test it; do NOT bake this into the hypothesis>

## Reject these anti-patterns
- A solution dressed up as a hypothesis ("we should do X").
- A mechanism asserted without tracing it in code/data.
- "Broken / 0 = failure" inferred from a small denominator or a single proxy.
- A claim no result could falsify.
- Over-attributing a multi-cause drop to one cause without checking counter-evidence.
