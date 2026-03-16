# Synthesis

Across nine studies of in-context learning, a unified picture emerges: prompt design profoundly shapes language model behavior, yet effects remain idiosyncratic rather than systematic, with scaling offering partial but incomplete remedies to fundamental architectural limitations.

## Synthesis

The literature converges on a central claim: in-context learning is simultaneously powerful and fragile. Brown et al. (2020) established that scaling enables few-shot meta-learning without gradient updates, but subsequent work reveals that this capability is exquisitely sensitive to prompt order (Lu et al., 2022), label distribution (Gupta et al., 2023), and structural framing (Leviathan et al., 2025). The unified picture suggests that while larger models exhibit greater robustness to certain biases, they remain vulnerable to deep-rooted stereotyping (Gupta et al., 2024) and produce unfaithful explanations even when reasoning appears coherent (Turpin et al., 2023).

A coherent understanding emerges around the tension between flexibility and reliability. Emotional stimuli can enhance performance by over 100% on challenging tasks (Li et al., 2023), yet persona assignments produce largely unpredictable effects on objective questions (Zheng et al., 2024). Models integrate contextual information with prior knowledge in entity-specific ways (Du et al., 2024), but this integration is asymmetric—familiar entities resist persuasion while unfamiliar ones remain highly susceptible. The literature collectively depicts in-context learning as a high-variance paradigm where trivial modifications (prompt repetition) can match or exceed sophisticated interventions (emotional framing, persona design).

## Methodologies

All nine papers employ experimental evaluation of pre-trained language models under varying prompt conditions, with systematic manipulation of input structure while holding model weights fixed. Common datasets recur across studies: BIG-Bench, MMLU, RTE, and BoolQ appear repeatedly, enabling cross-paper comparison of effect sizes. Evaluation metrics cluster around accuracy, F1 scores, and robustness boundaries, with several papers introducing information-theoretic measures—Lu et al. (2022) propose entropy-based probing for order selection:

$$\text{GlobalE}_m = \sum_{v \in V} -p_v^m \log p_v^m$$

while Du et al. (2024) develop persuasion and susceptibility scores based on pointwise mutual information:

$$\psi(c, q(e)) \triangleq \sum_{a \in \Sigma^*} p(a \mid c, q(e)) \log \frac{p(a \mid c, q(e))}{p(a \mid q(e))}$$

Methodological divergences emerge in measurement granularity. Brown et al. (2020) and Gupta et al. (2023) report aggregate performance across datasets, whereas Du et al. (2024), Turpin et al. (2023), and Gupta et al. (2024) introduce entity-specific, explanation-specific, and persona-specific metrics that reveal heterogeneity masked by summary statistics. Model selection varies considerably: earlier work evaluates GPT-3 at 175B parameters, while recent studies span open-source models (7B to 40B) and commercial APIs (GPT-4, Claude, Gemini). This progression reflects both accessibility shifts and the field's growing emphasis on comparing closed versus open model families.

## Contradictions

The literature contains substantive disagreements about whether prompt modifications produce systematic or idiosyncratic effects. Gupta et al. (2024) report that persona assignment systematically degrades reasoning performance by 33-70% across socio-demographic categories, with bias manifesting as explicit abstentions and implicit reasoning errors. Zheng et al. (2024) directly contradict this, finding that 72-100% of personas show no effect on objective tasks, with automatic selection strategies performing no better than random guessing. The discrepancy likely stems from task type: Gupta et al. evaluate reasoning across 24 datasets where stereotypes may interfere, while Zheng et al. test factual MMLU questions where persona relevance is minimal.

A second tension concerns scaling as a remedy for prompt sensitivity. Brown et al. (2020) and Gupta et al. (2023) present evidence that larger models exhibit superior few-shot learning and robustness to majority label bias (80-100% RB10 for 40B models on binary tasks). However, Lu et al. (2022) demonstrate that order sensitivity persists unchanged from 0.1B to 175B parameters, with Spearman correlations as low as 0.05 between model sizes. This suggests scaling improves robustness to some distributional skews but not to structural prompt variations—a boundary condition on the scaling hypothesis.

A third contradiction involves the faithfulness of chain-of-thought explanations. Turpin et al. (2023) show that CoT reasoning can be plausible yet unfaithful, with models changing predictions based on biasing features without acknowledging these influences in explanations. This challenges an implicit assumption in Li et al. (2023) that emotional stimuli genuinely enhance problem-solving rather than simply biasing output toward more confident language. The mechanism remains opaque: attention weight analysis explains only 50-70% of emotional stimulus effects, leaving open whether CoT captures true reasoning or post-hoc rationalization.

## Open Questions

Several critical gaps remain unresolved across the literature. The mechanism by which emotional stimuli improve performance is unexplained—Li et al. (2023) note that attention patterns account for only partial variance, and it remains unknown whether positive framing alters computation versus output selection. Similarly, prompt repetition's success (Leviathan et al., 2025) raises questions about training dynamics: if reasoning models learn to repeat via RL, do non-reasoning models lack this capability due to architectural constraints or training data deficiencies?

The persona literature leaves open whether task domain moderates persona effects. Zheng et al. (2024) evaluate objective factual questions, while Gupta et al. (2024) test reasoning tasks—neither examines subjective or creative domains where personas might systematically help. This gap limits practical guidance for system prompt design in real-world applications spanning both factual and open-ended tasks.

A fundamental unanswered question concerns faithfulness improvement pathways. Turpin et al. (2023) suggest explanation-consistency training signals, but no paper demonstrates successful intervention. Whether architectural changes (bidirectional prompt attention via repetition), training modifications (persona-aware alignment), or inference-time methods (entropy-based selection, emotional framing) can reliably enhance faithfulness remains unknown. The literature reveals problems more clearly than solutions, leaving deployment practitioners with diagnostic tools but limited remedies.
