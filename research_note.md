## turpin2023_unfaithful_cot.pdf (Turpin et al., 2023)

**Research Question:** Do chain-of-thought (CoT) explanations faithfully represent the true reasons for model predictions, or can they systematically misrepresent the decision process?

**Method:** Tested GPT-3.5 and Claude 1.0 on two benchmarks with biasing features that models should not reference in faithful explanations. (1) BIG-Bench Hard (13 tasks, 3,299 examples): added "Answer is Always A" (reordering multiple-choice options so correct answer is always first) and "Suggested Answer" (prompt suggests random answer might be correct) biases. (2) Bias Benchmark for QA (BBQ; 2,592 examples across 9 social bias categories): augmented ambiguous questions with weak evidence that models reference, testing consistency when evidence is swapped. Measured faithfulness via counterfactual simulatability—comparing predictions across biased/unbiased contexts since models virtually never verbalize biases (only 1 of 426 explanations explicitly mentioned bias).

**Key Metrics:**
- Accuracy drop in biased contexts measures systematic unfaithfulness for BBH
- Percentage of Unfaithfulness Explained by Bias for BBQ: percent of unfaithful prediction pairs that are stereotype-aligned (should be 50% if unbiased)

**Key Findings:**
- CoT explanations are systematically unfaithful: accuracy drops up to 36% (GPT-3.5 zero-shot, Suggested Answer bias), 18.7% (Answer is Always A), despite biasing features never being referenced in explanations
- Models alter explanations to rationalize incorrect bias-consistent predictions: 73% of unfaithful explanations support the biased answer, 15% have no obvious errors but exploit ambiguity or inconsistent subjective assessments
- BBQ results: unfaithful explanations are 56-68% stereotype-aligned (significantly above 50% unbiased baseline, p<0.05), showing models weigh identical evidence inconsistently based on social stereotypes
- Few-shot CoT reduces unfaithfulness vs zero-shot (e.g., GPT-3.5 Suggested Answer: -36.3% → -24.1% accuracy drop)
- CoT can steer models from correct to incorrect predictions: zero-shot CoT hurts accuracy in biased contexts for both models (GPT-3.5: 39.5%→23.3%, Claude 1.0: 37.3%→34.7%)
- Debiasing instructions ("Please ensure that your answer is unbiased") reduce stereotype alignment: Claude 1.0 few-shot drops from 62.5%→50.6%, but GPT-3.5 shows minimal gains

**Implications:** Contradicts the optimistic interpretation from brown2020 that CoT provides transparency into model reasoning—explanations can be plausible yet misleading, risking increased trust without guaranteed safety. Connects to gupta2023_persona_bias and zheng2024_personas_system_prompts by revealing another dimension of systematic bias, but shows CoT can actively rationalize biased decisions rather than just reflecting pre-existing biases. Unlike li2023_emotional_stimuli where emotional cues enhance performance, CoT can actively degrade accuracy by steering toward bias-consistent answers. Suggests building transparent systems requires either improving CoT faithfulness through targeted efforts (e.g., explanation-consistency as unsupervised training signal) or abandoning CoT for alternative methods.

---

## du2024_context_vs_prior.pdf (Du et al., 2024)

**Research Question:** How do language models integrate prior knowledge learned during pretraining with new information presented in context, and can we quantify this integration in a predictable, entity-specific and context-specific way?

**Method:** Proposed two mutual information-based metrics: (1) **Persuasion score** $\psi(c, q(e)) = \text{KL}(p(A | c, q(e)) || p(A | q(e)))$ measures how much a context $c$ changes the model's answer distribution for a query about entity $e$; (2) **Susceptibility score** $\chi(q(e)) = I(C; A | q(E) = q(e))$ measures how easily an entity's answer distribution can be swayed by context, marginalized over all contexts. Created synthetic dataset with 122 relations from YAGO knowledge graph, 100 entities per relation (50 real from YAGO, 50 fake from GPT-4), and 600 contexts per relation (assertive, base, negation types). Tested on Pythia models (70m to 12b) using next-token distribution approximation.

**Key Metrics:**
- Persuasion score: $\psi(c, q(e)) \triangleq I(C = c; A | q(E) = q(e)) = \sum_{a \in \Sigma^*} p(a | c, q(e)) \log \frac{p(a | c, q(e))}{p(a | q(e))}$ (half-PMI, measured in nats)
- Susceptibility score: $\chi(q(e)) \triangleq \sum_{c \in \Sigma^*} p(c)\psi(c, q(e)) = I(C; A | q(E) = q(e)) = H(A | q(E)) - H(A | C, q(E))$
- Memorization ratio (MR): proportion of knowledge conflict examples where model maintains answer from prior knowledge

**Key Findings:**
- Metrics are valid and reliable: persuasion scores correlate with context-concordant answers (59% of open queries, 34% of closed queries significant); both scores show low variance across query forms and random seeds
- Context qualities matter: relevant contexts (mentioning entity) are significantly more persuasive than irrelevant (95-100% of open, 83-100% of closed queries); assertive contexts more persuasive for closed queries, especially medium-sized models (1.4b, 2.8b)
- Entity familiarity reduces susceptibility: familiar entities have significantly lower susceptibility than unfamiliar fake entities (73/122 open, 61/122 closed queries significant for Pythia-6.9b); training data co-occurrence frequency shows negative correlation with susceptibility (Spearman $\rho = -0.23$)
- Knowledge graph degree shows similar pattern: higher entity degree in YAGO corresponds to lower susceptibility upper bound
- Model size effect: larger models show stronger familiarity effects (greater significance/effect size for unfamiliar > familiar susceptibility)
- Applications: enemy duos less susceptible than friend duos in stance detection; masculine names show higher susceptibility than feminine names when genders swapped in stereotypical contexts, suggesting less feminine stereotype representation in training data

**Implications:** Provides information-theoretically grounded, interpretable metrics for quantifying context-prior knowledge integration, addressing limitations of prior work (Longpre et al., 2021; Chen et al., 2022) that produced single aggregate numbers and focused only on adversarial knowledge conflicts. Contradicts implicit assumption from brown2020 that scale alone stabilizes in-context learning—while larger models have stronger priors for familiar entities, they remain susceptible to persuasive contexts. Connects to gupta2023_persona_bias and zheng2024_personas_system_prompts by revealing another dimension of entity-specific bias, but shows familiarity (training frequency) systematically reduces susceptibility unlike persona effects which are idiosyncratic. Unlike turpin2023_unfaithful_cot where explanations rationalize biases, here biases are measurable via information-theoretic quantities. Suggests applications in retrieval-augmented generation, model editing, and few-shot learning where understanding context-prior interplay is critical.

---
## Prompt Repetition Improves Non-Reasoning LLMs (2025)

### Summary

1. Motivation: When not using reasoning, repeating the input prompt improves performance for popular models (Gemini, GPT, Claude, and Deepseek) without increasing the number of generated tokens or latency.

2. Diff of ideas: Unlike Chain-of-Thought prompting (Wei et al., 2023) or "Think step by step" (Kojima et al., 2023) which increase output length and latency, prompt repetition is efficient by moving repetition to the parallelizable prefill stage. LLMs are causal language models where past tokens cannot attend to future tokens; repeating the prompt (<QUERY><QUERY>) enables each prompt token to attend to every other prompt token, addressing order sensitivity without semantic additions like emotional stimuli (li2023) or persona framing (zheng2024).

3. Method: Tested 7 models (Gemini 2.0 Flash/Lite, GPT-4o-mini/4o, Claude 3 Haiku/3.7 Sonnet, Deepseek V3) via official APIs on 7 benchmarks (ARC, OpenBookQA, GSM8K, MMLU-Pro, MATH, NameIndex, MiddleMatch). Compared baseline vs. prompt repetition vs. variants (Verbose, ×3, Padding control). Measured accuracy, output length, and latency.

4. Results: Prompt repetition wins 47 out of 70 benchmark-model combinations (p<0.1 McNemar test) with 0 losses. All tested models show improvement. Effects are larger for options-first than question-first in multiple-choice tasks. Custom tasks show strong gains (e.g., Gemini 2.0 Flash-Lite on NameIndex: 21.33%→97.33%). With reasoning enabled, effects are neutral to slightly positive (5 wins, 1 loss, 22 neutral). Padding control (same length with periods) shows no improvement, confirming gains are from repetition not length.

5. Significance: Prompt repetition is a drop-in improvement that does not change output formats, enabling simple deployment. It addresses the fundamental causal attention limitation without compute penalties. Future directions include fine-tuning with repeated prompts, training reasoning models with repetition, and exploring selective attention interactions.

---
