# Research Notes

## Language Models are Few-Shot Learners (2020)

### Summary

1. Motivation: Pre-trained language representations have achieved substantial progress on NLP tasks, but still require task-specific fine-tuning datasets of thousands to hundreds of thousands of examples. This limits applicability since many useful language tasks lack large labeled datasets. Humans, by contrast, can perform new language tasks from brief instructions or a few demonstrations. The authors sought to create NLP systems with similar fluidity and generality.

2. Diff of ideas: Rather than fine-tuning on task-specific data, the authors hypothesize that scaling up language models improves in-context learning (meta-learning where the model develops skills during pre-training and adapts at inference time). This differs from the dominant paradigm of fine-tuning large pre-trained models on narrow task distributions, which can exploit spurious correlations and generalize poorly out-of-distribution. The key insight is that in-context learning abilities might show strong gains with model scale, just as language modeling loss does.

3. Method: The authors trained GPT-3, an autoregressive language model with 175 billion parameters (10x larger than any previous non-sparse model), using a filtered Common Crawl dataset (410B tokens), WebText2 (19B tokens), Books1 (12B tokens), Books2 (55B tokens), and Wikipedia (3B tokens) for a total of 300 billion tokens. They evaluated GPT-3 on over two dozen NLP datasets under three conditions: few-shot (10-100 demonstrations in context), one-shot (one demonstration), and zero-shot (natural language instruction only), with no gradient updates or fine-tuning. Eight model sizes from 125M to 175B parameters were trained to study scaling effects.

4. Results: GPT-3 achieves strong performance across many NLP tasks without fine-tuning. On TriviaQA, few-shot GPT-3 reaches 71.2% accuracy (state-of-the-art for closed-book settings). On LAMBADA, few-shot achieves 86.4% accuracy, an 18% improvement over prior SOTA. The model demonstrates few-shot proficiency at on-the-fly reasoning tasks: 100% accuracy on 2-digit addition, 65.2% on SAT analogies (vs. 57% human average), and can generate news articles that humans struggle to distinguish from human-written ones (52% detection accuracy, near chance). However, GPT-3 struggles on natural language inference (ANLI) and some reading comprehension datasets (RACE, QuAC). Performance scales smoothly with model size, and the gap between zero/one/few-shot grows with capacity, suggesting larger models are more proficient meta-learners.

5. Significance: This work demonstrates that scaling language models enables task-agnostic few-shot learning that approaches or matches fine-tuned SOTA on many benchmarks. The 175B parameter GPT-3 shows that in-context learning is a viable alternative to fine-tuning, reducing the need for task-specific labeled data. The systematic evaluation across 24+ datasets establishes few-shot learning as a research direction and identifies where progress is still needed (NLI, complex reasoning). The findings also raise important questions about bias, fairness, and societal impacts of large language models that can generate human-indistinguishable text.

---
