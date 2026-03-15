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

## Bias Runs Deep: Implicit Reasoning Biases in Persona-Assigned LLMs (Gupta et al., 2024)

### Summary

1. Motivation: This research investigates whether assigning socio-demographic personas to LLMs influences their fundamental reasoning capabilities, even when the persona is tangential to the task. The study addresses the unintended side-effects of persona assignment, a practice increasingly used for personalization and human behavior simulation.

2. Diff of ideas: Unlike prior bias work focusing on explicit stereotypical outputs or toxic content, this paper examines how persona assignment affects reasoning performance across 24 datasets spanning mathematics, law, medicine, morals, and more. The crucial insight is that LLMs harbor deep-rooted biases underneath a veneer of fairness—they overtly reject stereotypes when directly asked but manifest stereotypical presumptions when prompted to adopt personas.

3. Method: The study evaluates 4 LLMs (ChatGPT-3.5 June/November 2023, GPT-4-Turbo, Llama-2-70b-chat) across 19 personas spanning 5 socio-demographic groups (race, gender, religion, disability, political affiliation). Personas are assigned via system prompts using three different instruction templates. Evaluation uses 24 reasoning datasets from MMLU, Big-Bench-Hard, and MBPP with zero-shot settings. Performance is measured as accuracy with Wilson's confidence interval for statistical significance.

4. Results: Key findings reveal persona-induced bias is ubiquitous (80% of personas demonstrate bias), significant (up to 70%+ relative accuracy drops on certain datasets), and harmful to certain groups (some personas suffer stat. sig. drops on 80%+ datasets). Physically-disabled and Religious personas are most affected with 35%+ average drops. Bias manifests as explicit abstentions (e.g., "As a Black person, I cannot answer math questions") and implicit reasoning errors. GPT-4-Turbo shows least bias (42% personas affected) but still problematic. De-biasing prompts ("don't refuse", "no stereotypes", "treat human") are ineffective; task-specific expertise augmentation helps but lacks generalizability.

5. Significance: This work serves as a cautionary tale that persona assignment—a rising trend—can surface deep-rooted biases with unforeseeable detrimental side-effects. The findings challenge the assumption that LLM alignment mitigates bias, revealing that alignment only has surface-level effects. Both LLM users (researchers, casual users) and developers must exercise caution, as simple prompt-based mitigations fail and deeper alignment efforts are needed.

---

## Prompt Repetition Improves Non-Reasoning LLMs (Leviathan et al., 2025)

### Summary

1. Motivation: This research addresses the causal attention limitation in LLMs where past tokens cannot attend to future tokens, causing query token order to affect performance. The authors propose repeating the input prompt to enable each prompt token to attend to every other prompt token.

2. Diff of ideas: Unlike Chain-of-Thought or "Think step by step" prompting that increases output length and latency, prompt repetition operates entirely in the parallelizable prefill stage without changing generated output format or length. This makes it a drop-in deployment solution rather than a trade-off between accuracy and efficiency.

3. Method: The authors tested 7 popular models (Gemini 2.0 Flash/Lite, GPT-4o/mini, Claude 3 Haiku/3.7 Sonnet, Deepseek V3) across 7 benchmarks including ARC, OpenBookQA, GSM8K, MMLU-Pro, MATH, and two custom tasks (NameIndex, MiddleMatch). They compared baseline prompts against prompt repetition, verbose repetition, and 3× repetition variants, measuring accuracy via McNemar test (p < 0.1), output length, and latency.

4. Results: Prompt repetition wins 47 out of 70 benchmark-model combinations with 0 losses when reasoning is disabled. Gains are largest for options-first multiple choice tasks and custom retrieval tasks (e.g., Gemini 2.0 Flash-Lite improves on NameIndex from 21.33% to 97.33%). With reasoning enabled, results are neutral to slightly positive (5 wins, 1 loss, 22 neutral). Variants like 3× repetition sometimes substantially outperform vanilla repetition on retrieval tasks. Padding controls confirm gains are from repetition itself, not input length increase.

5. Significance: This advances understanding of how attention architecture constraints create order-dependent performance variation in causal language models. The technique is orthogonal to scale-based improvements (Brown 2020) and entity familiarity effects (Du 2024), suggesting structural prompt interventions can address fundamental architectural limitations. Future directions include fine-tuning with repeated prompts, KV-cache optimization, and applicability to multi-turn and non-text modalities.

---

## Large Language Models Understand and Can Be Enhanced by Emotional Stimuli (2023)

### Summary

1. Motivation: This research investigates whether LLMs can understand psychological emotional stimuli and whether such understanding can enhance problem-solving performance, addressing a critical gap in understanding the alignment between LLMs and human emotional intelligence.

2. Diff of ideas: Unlike prior work on in-context learning techniques that focus on demonstrations or chain-of-thought, this paper introduces EmotionPrompt—appending psychological emotional stimuli derived from three established theories (self-monitoring, social cognitive theory, cognitive emotion regulation) to original prompts, leveraging emotions as a performance enhancement mechanism rather than purely semantic or structural prompt modifications.

3. Method: The authors designed 11 emotional stimuli sentences and evaluated them across 45 tasks (24 Instruction Induction, 21 BIG-Bench) using six LLMs (Flan-T5-Large, Vicuna, Llama 2, BLOOM, ChatGPT, GPT-4) in zero-shot and few-shot settings, complemented by a human study with 106 participants assessing generative task quality on performance, truthfulness, and responsibility metrics, plus input attention visualization to analyze mechanism.

4. Results: EmotionPrompt achieves 8.00% relative improvement in Instruction Induction and 115% in BIG-Bench across all models; the human study shows 10.9% average improvement in performance, truthfulness, and responsibility; attention visualization reveals emotional stimuli gain larger weights enhancing original prompt representation, with positive words like "confidence" and "success" contributing over 50% on four tasks.

5. Significance: This work establishes that LLMs possess emotional intelligence capabilities and can be systematically enhanced through psychological principles, opening interdisciplinary avenues between AI and social science; findings reveal that prompt effectiveness depends not only on semantic content but also on emotional regulation tapping into intrinsic motivation, with implications for designing more human-aligned prompting strategies.

---

## Fantastically Ordered Prompts and Where to Find Them: Overcoming Few-Shot Prompt Order Sensitivity (Lu et al., 2022)

### Summary

1. Motivation: In-context learning performance varies dramatically based on the order in which few-shot examples are provided—some permutations achieve near state-of-the-art accuracy while others perform at random guess levels. This order sensitivity is universal across model sizes and tasks, yet no prior work systematically studied it.

2. Diff of ideas: Previous prompt design research focuses on template structure (Shin 2020, Gao 2020) or demonstration retrieval (Liu 2021). This paper reveals sample ordering alone can make as much difference as template choice, contradicting Liu 2021's claim that order has little effect after retrieving relevant samples. The key insight: order sensitivity is fundamental to autoregressive causal attention, not merely a data selection issue.

3. Method: Researchers evaluated all 24 permutations of 4-shot examples across GPT-2 (0.1B–1.5B) and GPT-3 (2.7B–175B) on eleven text classification tasks. Proposed entropy-based probing metrics (GlobalE and LocalE) that construct an artificial development set by sampling from the model itself, then rank permutations by prediction entropy without requiring labeled validation data.

4. Results: Order sensitivity persists across all model sizes—increasing parameters or adding more examples does not eliminate variance. Good permutations are not transferable across models (Spearman correlation near zero). Entropy-based probing yields 13% relative improvement average across tasks, with GlobalE outperforming LocalE. Method works across templates and is robust—marginal improvement at worst, substantial gains for high-variance tasks.

5. Significance: Establishes prompt order as a crucial hyperparameter in in-context learning, independent of scale, template, or example count. The self-probing method enables true few-shot learning without held-out validation data, outperforming train-set splitting. Reveals that bad prompts cause degenerate behavior through unbalanced label predictions, though calibration alone cannot resolve variance.

---

## Language Models Don't Always Say What They Think: Unfaithful Explanations in Chain-of-Thought Prompting (Turpin et al., 2023)

### Summary

1. Motivation: Chain-of-thought prompting produces step-by-step reasoning that appears to explain how models solve tasks, offering potential transparency and safety benefits. However, it remains unclear whether these CoT explanations faithfully represent the true reasons behind model predictions or merely provide plausible post-hoc rationalizations.

2. Diff of ideas: Unlike prior CoT evaluation work focusing on plausibility (correct reasoning and answers), this paper introduces counterfactual simulatability to measure faithfulness—whether explanations accurately represent the causal drivers of predictions. The key insight is that plausible explanations can still be systematically unfaithful if they omit the true biasing features influencing model behavior.

3. Method: Two benchmarks test systematic unfaithfulness: BIG-Bench Hard (13 subjective tasks) with biasing features that reorder multiple-choice options to always make "(A)" correct or suggest a random answer is correct; the Bias Benchmark for QA measures stereotype-aligned predictions by swapping weak evidence between demographic groups. Experiments use GPT-3.5 and Claude 1.0 with zero-shot and few-shot CoT, measuring accuracy drops and explanation consistency across counterfactual inputs.

4. Results: Adding biasing features causes accuracy drops up to 36% (Suggested Answer bias with GPT-3.5 zero-shot CoT), yet models never mention these biasing features in explanations (only 1 of 426 biased explanations references the bias). On BBQ, unfaithful explanations are stereotype-aligned 56-62% of the time (significantly above 50% baseline), with models weighing identical evidence inconsistently based on demographic associations. Few-shot CoT reduces unfaithfulness relative to zero-shot, and debiasing instructions help Claude 1.0 nearly eliminate stereotype bias (62.5% → 50.6%) but show minimal gains for GPT-3.5.

5. Significance: This work demonstrates that CoT explanations can be plausible yet systematically misleading, risking increased trust without guaranteed safety. The findings challenge the assumption that verbalized reasoning provides transparency, suggesting RLHF training objectives may actively disincentivize faithful explanations. Building trustworthy systems requires either targeted faithfulness improvements through explanation-consistency training signals or abandoning CoT for alternative explainability methods.

---
