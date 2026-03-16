# Context Engineering Exercise

This repository provides a step-by-step exercise to practice context engineering by building an AI skill from scratch. You will learn: 

1. principles of soft-ware development such as test-driven development and 80/20 planning. 
2. context engineering techniques through ralph wiggum style implementation
3. an end-to-end process for building AI agent skills, from ideation to testing to implementation. 


We will use [opencode](https://opencode.dev/) as our coding environment, but any AI coding tools (e.g., `claude code` ) can be used. For `claude code` users, simply rename `.agents` to `.claude` (ask claude to do so).


## Example skills: 

This repository includes example skills under `.agents/skills/`. Each skill has a `SKILL.md` file with instructions for the agent, and may include templates and tools as needed. 


> [!WARNING]
> Before starting the exercise, please set the LLM to `qwen3.5:35b`, `qwen3.5:397b`, or `glm-5`. 
> These models are accessible through [OpenRouter](https://openrouter.ai/) and [Ollama](https://ollama.com/) for free. If you don't have access to these models, please reach out to the instructor for assistance.
> To set the model, type `/model` and select the appropriate model from the list.

To run, open `opencode` and run:

```md
/skills
```

This will show you the list of available skills (found under `.agents/skills/`). Select:

```bash
/setup
```

This will set up the necessary environment for running the example skills. See [.agents/skills/setup/SKILL.md](.agents/skills/setup/SKILL.md) for details on what the setup does.

Now, let's try running `explain-paper` skill. See [.agents/skills/explain-paper/SKILL.md](.agents/skills/explain-paper/SKILL.md) on the instructions in this skill. 
Ask the agent to explain a paper of your choice in `papers/` folder by providing the file name. For example:

```bash 
Explain papers/brown2020_gpt3_few_shot.pdf
```

Next, try running `literature-review` skill. This skill runs a Ralph Wiggum loop to go through multiple papers and synthesize a literature review. See [.agents/skills/literature-review/SKILL.md](.agents/skills/literature-review/SKILL.md) for instructions. 

To run, just say something like: 

```bash
Literature-review papers in the papers/ folder. 
```

## Your task

Choose one of the following task goals of your choice. 

| Level | Skill | What it does |
|---|---|---|
| ⭐ | `study-notes` | Given a lecture PDF, produce structured notes: key concepts, definitions, practice questions |
| ⭐⭐ | `trip-planner` | Given budget, dates, and group size, plan a trip from Binghamton with itinerary and costs |
| ⭐⭐⭐ | `arxiv-recommender` | Given a research interest or paper abstract, recommend relevant arXiv papers with explanations |

Complete the following steps to build your chosen skill. The steps are designed to be iterative and flexible, so feel free to adapt them as needed while maintaining the core principles of good software development and context engineering.

## Step 1: Vibe coding for prototyping

Open opencode and build a prototype. No planning, no structure.

**Goal:** get a feel for what's hard. Your output will be messy. That's intentional.

## Step 2 — Plan

Remove your prototype (or git add and commit in a branch. Then change the branch and delete it.).

Open a **fresh** opencode session by running `/new`.

> **Why fresh?** Your vibe session has accumulated context — half-formed ideas, dead ends, implicit assumptions. A fresh agent has none of that. It will only know what you explicitly tell it, which forces you to articulate your idea clearly.

> **Why relentless questions?** Vague plans produce vague output. Every ambiguity you leave unresolved becomes a decision the agent makes silently during implementation — usually wrong. The goal is to make every decision explicit *before* writing a line of code.

> **Why a structured PRD format?** Each task subsection is a self-contained unit of context: the agent implementing it should need nothing else. If a task can't be written clearly in this format, it's not well-understood yet.

Write a prompt that does three things:
1. **States your goal** — what skill you're building and where it lives
2. **Instructs the agent to interview you** — one question at a time, until nothing is ambiguous
3. **Specifies the output format** — tell the agent exactly what `PRD.md` should look like per task

Use this scaffold — fill in every `[...]`:

```
I want to build [DESCRIBE YOUR SKILL] under .agents/skills/[SKILL-NAME].

[HOW SHOULD THE AGENT INTERVIEW YOU?
 — how many questions at a time?
 — what topics must it cover (inputs, outputs, edge cases, tools, format)?
 — how does it know when to stop asking?]

When the interview is complete, write PRD.md. Each task is a subsection:

## Task <N>: <name>
- Goal: [WHAT FORMAT?]
- Inputs: [WHAT FORMAT?]
- Outputs: [WHAT FORMAT?]
- Specification: [WHAT FORMAT?]
```

**Output:** `PRD.md`

---

## Step 3 — Test Design

Open a **fresh** opencode session. Paste this prompt:

> **Why tests before implementation?** Tests are a precise specification — they define "done" without ambiguity. Without them, the agent decides for itself when a task is complete. With them, correctness is checkable, not a matter of opinion.

> **Why confirm each task's tests with a human?** You are the authority on what success looks like. The agent proposes; you decide. This step is where you catch misunderstandings before they get built.

Write a prompt that does three things:
1. **Points the agent to your plan** — what file to read
2. **Defines what good tests look like** — what types of cases to cover, what each test must include
3. **Keeps you in the loop** — how the agent should get your approval before writing anything

Use this scaffold — fill in every `[...]`:

```
Read [WHICH FILE?].

For each task, propose test cases covering [WHAT TYPES OF CASES?].
Each test must specify [WHAT MUST EACH TEST INCLUDE — input? expected output? anything else?].

[HOW SHOULD THE AGENT INTERACT WITH YOU?
 — show one task at a time or all at once?
 — ask for confirmation before moving on?]

When all tests are approved, [WHERE AND HOW SHOULD IT WRITE THEM?].
```

**Output:** `PRD.md` (updated with test cases)

---

## Step 4 — Implement

> **Why one subagent per task?** Context accumulates — successes, failures, half-finished code, second-guessing. A long-running agent drifts. Starting fresh each task means each agent only carries what matters: the plan (`PRD.md`), what's been done (`progress.txt`), and lessons learned (`learning.txt`). Nothing else bleeds in.

> **Why `learning.txt`?** Fresh context means the agent can't remember what the previous agent learned. `learning.txt` is the controlled channel for passing forward only what matters — not the whole history, just the distilled insight.

### The Ralph Wiggum Approach

Ralph Wiggum does one thing at a time and keeps it simple. Applied to agents:

- **One task per agent.** Each Sub-Agent picks one task, executes it, and stops. No accumulation, no drift.
- **Shared files are the only memory.** `progress.txt` tracks what's done. `learning.txt` carries forward only the lessons that matter.
- **The Lead Agent just loops.** It doesn't do the work — it spawns Sub-Agents one at a time and waits.

### Spawning Sub-Agents

The Lead Agent spawns Sub-Agents using the **Task tool**. The key constraint: **the sub-agent has no context other than what you put in its prompt.** It cannot see the conversation, the files you've read, or anything else. Its prompt must be fully self-contained.

A sub-agent prompt typically tells it: which files to read, what to do, what to write, and when to stop.

### Write your SKILL.md

Read [`.agents/skills/literature-review/SKILL.md`](.agents/skills/literature-review/SKILL.md) first — it is a complete working example of this pattern.

Then write `.agents/skills/<skill-name>/SKILL.md` by working through these questions in order:

**1. What are the shared files?**
Agents cannot share memory — only files. Decide what files they communicate through. For each file, answer: who writes it, who reads it, and what exactly does it contain? Keep the list minimal.

**2. What does the Lead Agent do on the very first run?**
The shared files don't exist yet. What does the Lead Agent create, and what does it put in them? (e.g. listing all tasks in `progress.txt` as unchecked)

**3. What is the Lead Agent's loop?**
The Lead Agent's only job is to spawn and wait. Write out its loop as a numbered list: spawn one Sub-Agent, wait, check if done, repeat. When does it stop?

**4. What does one Sub-Agent do — in full detail?**
Assume the Sub-Agent knows absolutely nothing. Write every step it must take:
- What files does it read first, and why each one?
- How does it know which task to pick?
- What exactly does it produce? (files, code, output)
- How does it verify its work against the tests in `PRD.md`?
- What does it write to `learning.txt`? Be specific — not "what it learned" but what *kind* of things are worth recording.
- How does it signal that its task is done?
- How does it make sure it stops after one task and does not continue?

**5. What are the stop conditions?**
When is the whole skill complete? What should happen if a Sub-Agent fails? Who gets notified?

---

If you struggle to answer any question, that's a signal — your `PRD.md` is not concrete enough. Go back to Step 2.

Once `SKILL.md` is written, run it. The Lead Agent will work through all tasks automatically.

---

## What You're Building

By the end, your skill directory should contain:

```
.agents/skills/<skill-name>/
  SKILL.md          # agent instructions
  templates/        # output format templates
  tools/            # helper scripts (if needed)
```

Test your finished skill by running it on a real input and checking the output against `tests.md`.

---

## Reference: Existing Skills

Study these before you start — they show the patterns you'll use:

- `.agents/skills/explain-paper/` — simple single-agent skill
- `.agents/skills/literature-review/` — multi-agent loop with shared state
