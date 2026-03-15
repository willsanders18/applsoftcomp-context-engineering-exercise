# Synthesis

## Synthesis

The unified picture across these nine papers is that in-context learning is fundamentally unstable and highly context-dependent, contradicting the early optimism from Brown et al. (2020) that scale alone produces reliable few-shot learners. Structural factors like demonstration order (Lu et al., 2022) and prompt repetition (Leviathan et al., 2025) interact with semantic factors like emotional stimuli (Li et al., 2023) and persona framing (Gupta et al., 2023; Zheng et al., 2024) to systematically modulate performance. Meanwhile, chain-of-thought reasoning can actively degrade accuracy by rationalizing biased predictions (Turpin et al., 2023), and prior knowledge learned during pretraining anchors model responses against contextual persuasion in predictable, entity-specific ways (Du et al., 2024). Together, these contributions reveal that building reliable LLM systems requires careful context engineering across multiple dimensions rather than relying on scale alone.

---

## Contradictions

The central tension runs between Brown et al. (2020)'s implicit assumption that scaling stabilizes in-context learning and every subsequent paper demonstrating persistent instabilities—order sensitivity survives across all model sizes (Lu et al., 2022), label distribution robustness remains incomplete even for 40B models (Gupta et al., 2023), and prompt repetition still helps state-of-the-art systems (Leviathan et al., 2025). On personas specifically, Gupta et al. (2023) found systematic reasoning failures with 35%+ accuracy drops for disabled and religious personas, while Zheng et al. (2024) found no overall persona benefit across 2,410 MMLU questions with effects being largely idiosyncratic—this discrepancy likely reflects task differences (reasoning benchmarks vs. factual QA) and measurement approaches (worst-case persona effects vs. average performance). Chain-of-thought presents another contradiction: Brown et al. (2020) treated CoT as enabling transparency and improved few-shot performance, but Turpin et al. (2023) showed CoT can steer models from correct to incorrect predictions while generating plausible but unfaithful explanations. Finally, Gupta et al. (2023)'s finding of robustness to majority label bias in binary classification appears orthogonal to Lu et al. (2022)'s order sensitivity results, suggesting distribution robustness does not imply permutation robustness.

---

## Open Questions

The most pressing unanswered question is how to achieve faithful reasoning—Turpin et al. (2023) showed debiasing instructions have modest gains but leave substantial unfaithfulness unaddressed, and it remains unclear whether alternative explanation methods or training objectives can guarantee transparency. The persona contradiction between Gupta et al. (2023) and Zheng et al. (2024) raises the question of when personas help versus harm: are effects task-domain dependent, persona-dependent, or question-specific, and can automatic selection ever outperform random assignment? Stabilizing ICL against order and permutation effects remains unsolved—Lu et al. (2022) showed good orderings are model-specific and non-transferable, while Leviathan et al. (2025)'s repetition fix addresses causal attention but not semantic ordering. How prior knowledge interacts with context in production retrieval-augmented generation settings needs exploration, particularly whether Du et al. (2024)'s susceptibility metrics can guide context selection or model editing. Finally, whether structural fixes like prompt repetition can substitute for or complement semantic fixes like emotional stimuli remains untested, leaving practitioners without clear guidance on which intervention to deploy when.

---
