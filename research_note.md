# Research Notes

## Language Models are Few-Shot Learners (Brown et al., 2020)

### Summary

1. Motivation: Pre-trained language models typically require task-specific fine-tuning on thousands of examples, which limits applicability and risks overfitting to narrow distributions. Humans can learn new language tasks from just a few examples or natural language instructions, but NLP systems struggle with this. The paper asks whether scaling language models enables task-agnostic, few-shot performance competitive with fine-tuning approaches.

2. Diff of ideas: Prior work used smaller models (up to 17B parameters) with fine-tuning or achieved poor few-shot results (e.g., 4% on Natural Questions). This paper trains GPT-3 with 175B parameters (10x larger than any previous non-sparse model) and evaluates purely via in-context learning without gradient updates. The key insight is that meta-learning abilities—using the model's context window to specify tasks via demonstrations—improve dramatically with scale.

3. Method: GPT-3 is an autoregressive transformer trained on 300 billion tokens from diverse web corpora. Evaluation uses three settings: few-shot (10-100 demonstrations in context), one-shot (single demonstration plus instruction), and zero-shot (instruction only). The model's 2048-token context window holds demonstrations as conditioning. A series of smaller models (125M to 13B parameters) enables scaling analysis.

4. Results: GPT-3 achieves strong performance across 42+ benchmarks. In few-shot settings it reaches state-of-the-art on some tasks: 71.2% on TriviaQA (closed-book), 85.0 F1 on CoQA. Performance scales smoothly with model size, and the gap between zero/one/few-shot widens with scale, suggesting larger models are better meta-learners. However, performance lags on NLI tasks (ANLI) and some reading comprehension (RACE, QuAC). Human evaluators struggle to distinguish GPT-3's synthetic news articles from human-written ones.

5. Significance: This work demonstrates that scale alone—without architectural innovation or fine-tuning—enables broad task adaptability through in-context learning. The 175B parameter model shows that few-shot learning can approach fine-tuning performance on many tasks while requiring no task-specific gradient updates. This suggests a path toward more general, fluid language systems that learn tasks at inference time rather than through expensive fine-tuning.

---

## Context versus Prior Knowledge in Language Models (Du et al., 2024)

### Summary

1. Motivation: Language models must integrate prior knowledge from pretraining with new information in context when answering questions. The authors hypothesize that models rely more on prior knowledge for familiar entities (due to higher training corpus exposure) and are more easily persuaded by some contexts than others.

2. Diff of ideas: Unlike prior work that produces single aggregate metrics for model reliance on entity bias (e.g., memorization ratio), this paper develops entity-specific and context-specific metrics grounded in information theory. This allows measuring the interplay of context and prior knowledge beyond adversarial knowledge conflict cases.

3. Method: Two mutual information-based metrics are proposed: the persuasion score $\psi(c, q(e)) = \text{KL}(p(A | c, q(e)) || p(A | q(e)))$ measures how much a context changes the model's answer distribution for a query about an entity; the susceptibility score $\chi(q(e)) = I(C; A | q(E) = q(e))$ measures how much the model's answer distribution can be swayed across all contexts. Experiments use 122 relations from YAGO, 100 entities per relation (real and GPT-4-generated fake), and 600 contexts varying in relevance, assertiveness, and negation across six Pythia models (70m to 12b).

4. Results: Relevant contexts are consistently more persuasive than irrelevant ones (95-100% of open queries, 83-100% of closed queries show significant results). Assertive contexts are more persuasive than base contexts for closed queries but not open queries, with strongest effects in medium-sized models (1.4b, 2.8b). Familiar entities have significantly lower susceptibility scores than unfamiliar fake entities (73/122 open queries, 61/122 closed queries for Pythia-6.9b). Susceptibility scores show a decreasing upper bound as training data co-occurrence frequency increases (Spearman $\rho = -0.23$). Case studies find enemy duos are less susceptible than friend duos, and masculine names have higher susceptibility than feminine names when swapping genders in stereotypical contexts.

5. Significance: The metrics provide valid, reliable, and interpretable tools for analyzing context-prior knowledge interactions in LMs. Applications include social science measurement (understanding annotation reliability for different entity types) and gender bias analysis. The framework enables greater control over model behavior and can extend to retrieval-augmented generation, model editing, and few-shot learning.

---

## How Robust are LLMs to In-Context Majority Label Bias? (Gupta et al., 2023)

### Summary

1. Motivation: In-context learning is susceptible to label biases when the distribution of labeled examples in prompts is skewed toward specific classes. Such skewness arises from logistical constraints, data collection biases, or limited data diversity in real-world industry settings. Prior work (Zhao et al. 2021) showed GPT-3 prefers frequent labels in-context, but did not exhaustively examine robustness across varying class proportions.

2. Diff of ideas: Unlike prior work that demonstrated susceptibility to majority label bias, this paper introduces the RobustnessBoundary@K metric to quantify the boundary of robustness across distributional shifts. The metric measures the percentage of label distribution settings where weighted F1-score stays within ±K% of the maximum achieved F1, providing a practical measure for real-world deployment under skewness. This shifts the question from whether bias exists to how much robustness different models exhibit.

3. Method: Five open-source LLMs (OpenLlama-7B/13B, MPT-7B/30B, Falcon-40B) are instruction-tuned on OASST and evaluated on BoolQ, RTE (binary), and COVID-5G Conspiracy (multi-class) datasets. Prompts vary label proportions systematically: for binary tasks, 11 settings from (0% True, 100% False) to (100% True, 0% False) in 10% steps; for multi-class, 15 carefully selected proportion combinations. Two prompt strategies are compared: with task-specific instructions versus without. The RB10 metric is computed alongside mean and standard deviation of weighted F1 across 5 random seeds.

4. Results: For binary classification, larger LLMs achieve RB10 in the range 80-100%, with Falcon-40B with instructions reaching 90.9% on BoolQ and 100% on RTE—contradicting prior claims that LLMs suffer from majority label bias. Robustness drops significantly for multi-class tasks (~50% RB10 on COVID-5G). Model size correlates positively with robustness: MPT-30B improves ~10.51% over 13B, Falcon-40B improves ~3.08% over 30B. Task-specific instructions substantially improve robustness at distribution tails (extreme skewness), with performance gaps amplifying with model size (~8.3% drop for 7B, ~27.9% drop for 30B/40B without instructions).

5. Significance: The work establishes that larger LLMs are resilient to majority label bias in binary tasks when equipped with informative instructions, refining the understanding of scale effects from Brown 2020. The RB_K metric provides practitioners a tool to assess fault tolerance under real-world label skewness. The finding that larger models are more sensitive to instructions (both positively and negatively) suggests scale amplifies instruction-following capability rather than just context integration.

---
