---
name: hypothesis
description: Form a rigorous, falsifiable growth/product hypothesis from an observation. Use when forming, sharpening, or pressure-testing a hypothesis about WHY a metric or user behavior is happening (e.g. "why is no one buying", "why do users drop at step X", "hypothesize why retention fell"). Separates the PROBLEM and the SOLUTION from the claim, grounds the mechanism in code/data, and calibrates against noise. Triggers: "form a hypothesis", "is this a good hypothesis", "hypothesize why", "/hypothesis".
---

# Form a rigorous hypothesis

Turn an observation into a **falsifiable, evidence-grounded hypothesis — not a restated problem, not a solution.**
Input: an observation / problem / question (from the user's args or the current context).
If the observation is vague (no metric or numbers), ask for the specific metric + figures first.

## Classify first: problem vs hypothesis vs solution

Three different things. Never collapse them — the lifecycle is **Problem → Hypothesis → Experiment**, one stage per artifact.

- **Problem / observation** — *WHAT* is happening: the metric or behavior + numbers. *"~80% of arrivals never scan."* It **describes**; it explains nothing. Template: *"We believe [problem], because [supporting data]."*
- **Hypothesis** — *WHY* it's happening: names a **cause that sits OUTSIDE the observation**. *"They don't scan because the Home leads with a sign-in wall instead of the scan."* It is a claim that could be wrong.
- **Solution / experiment** — the *ACTION* you'd take to test the why. *"Make scan the only primary CTA."*

Rules:
- **The problem comes first, and one problem usually has SEVERAL competing hypotheses** — each names a *different* cause (UI friction, unclear value, broken backend, wrong traffic…). Keep the problem as the parent; write each hypothesis as a separate child. A statement that is a "problem" at one level is explained by hypotheses at the next.
- **Circularity test — the #1 trap.** If the hypothesis's "because" just **restates the observation in other words**, it's the *problem*, not a hypothesis. *"No one buys because they never reach value"* is circular when the problem already IS "they never reach value." The cause must be an **independent, changeable lever that you are NOT already measuring as the outcome**.
- **Litmus:** point at the named cause — can you *change it* without changing the metric's definition? Yes → hypothesis. The "cause" is the metric reworded → it's the problem (ask "why?" once more). It's an action → it's a solution (extract the belief underneath).

## Method — work through these, then show the RESULT (not the scaffolding)

1. **State the problem (observation) precisely.** The metric or behavior + the actual numbers + the window.
   ("62 installs → 18 paywall views → 0 purchases over 14 days.")

2. **Ground it before claiming a mechanism.** Do NOT assert *why* until you've checked:
   - Read the relevant code path and/or query the events/data. Cite `file:line` or the query.
   - Separate **PROVEN** (logged events, traced code, queried data) from **INFERRED**. Label each.
   - Confirm the signal is **real users, not test devices**; note the **sample size**.
   - If you can't ground it, say so and cap confidence at **low**.

3. **Separate BOTH the problem and the solution from the claim.**
   - If what you wrote just restates the metric/behavior → it's the **problem**. Ask "why?" once more to name a cause.
   - If what you wrote is an action ("move X", "add Y", "remove Z") → it's a **solution**. Extract the underlying belief about *why* it would work.
   - The hypothesis is the causal belief in the middle: problem ← **hypothesis** → experiment.

4. **Write the hypothesis as a falsifiable causal claim — cause distinct from outcome.**
   - Explanatory (this skill's default — diagnosing *why*): *"[metric] is [low/high] because [independent cause/mechanism]"*, or *"[users] who [condition] show [higher/lower] [metric] than [comparison], because [mechanism]."*
   - Name the **independent variable** (the cause/lever), the **dependent variable (metric)**, the **direction**, the **population**. The IV must NOT be the DV reworded.
   - The matching **intervention** hypothesis is the *next* (experiment) artifact, not the diagnosis — CRO Hypothesis Kit form: *"Because we saw [data], we expect that [change] for [population] will cause [impact], measured by [metric]."* Keep it for the experiment card, not here.

5. **State the prediction + the falsifier.** The measurable prediction (success threshold + by-when),
   AND the result that would prove the hypothesis WRONG. If nothing could refute it, it isn't a
   hypothesis — rewrite it.

6. **Calibrate.** Scale confidence to sample size + source reliability. 0 from a small denominator is
   the *expected* outcome, not "broken." Correlation ≠ causation. List the competing hypotheses for the
   same problem that the data can't yet distinguish.

## Output — this exact shape

- **id:** `H-<YYYY-MM-DD>-<NN>`
- **problem (observation):** <WHAT — metric/behavior + numbers + window>
- **hypothesis:** <the WHY — a cause OUTSIDE the observation, not a restatement; variables + direction + mechanism>
- **variables:** IV (cause/lever) = … · DV (metric) = … · direction = …  *(IV ≠ DV reworded)*
- **prediction:** <measurable>; **success threshold:** …; **by:** <when>; **falsified if:** <result>
- **evidence:** PROVEN — … · INFERRED — … · sample size — … · real-users-verified? …
- **confidence:** low | med | high — <why, tied to n + source reliability>
- **competing hypotheses:** <the OTHER causes that could explain the same problem; what the data can/can't distinguish>
- **candidate experiment(s):** <kept SEPARATE from the claim — the intervention you'd run to test it; do NOT bake this into the hypothesis>

## Reject these anti-patterns
- **A problem/observation restated as a hypothesis** — a circular "because" where the named cause is the outcome reworded ("they don't convert because they don't reach value" when the problem IS not reaching value). This is the most common failure: the card needs a real cause, not the metric in a mirror.
- A **solution** dressed up as a hypothesis ("we should do X").
- A mechanism asserted without tracing it in code/data.
- "Broken / 0 = failure" inferred from a small denominator or a single proxy.
- A claim no result could falsify.
- Over-attributing a multi-cause drop to one cause without checking counter-evidence (when one problem has several live hypotheses, say so).

## Grounded in
- **Problem statement vs hypothesis** (Creative CX) — the problem identifies *what* + the data; the hypothesis predicts the *why/how*. The problem always comes first.
- **CRO Hypothesis Kit v3** (Craig Sullivan et al.) — the intervention/experiment template ("Because we saw … we expect that … will cause … measured by …").
- **Falsifiability** (Popper) — a hypothesis must be disprovable: some conceivable observation would refute it.
