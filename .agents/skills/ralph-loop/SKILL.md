---
name: ralph-loop
description: Orchestrates iterative work by spawning stateless sub-agents. The lead agent selects one task at a time, hands it to a fresh sub-agent with shared context files, collects results, and updates those files before the next iteration.
---

# Ralph Loop

The **lead agent** is the orchestrator. It never does the work itself — it selects tasks, delegates them to sub-agents, and maintains shared state between iterations.

Each **sub-agent** is stateless. It has no memory of previous iterations. Instead, it reads two files at the start of every task:

- `progress.txt` — a log of what has been completed so far
- `learning.txt` — lessons, pitfalls, and insights from previous iterations

---

## Lead Agent Instructions

### 1. Initialize (first run only)

If `progress.txt` or `learning.txt` do not exist, create them as empty files with a brief header:

```
progress.txt:
# Progress Log
(empty — no tasks completed yet)

learning.txt:
# Lessons Learned
(empty — no lessons yet)
```

### 2. Select the next task

Review `progress.txt` to understand what has already been done. Choose the next task that:
- Has not been completed yet
- Is unblocked (its dependencies are done)
- Is small and concrete enough for a single sub-agent to finish in one pass

If no tasks remain, the loop is done. Write a final summary and stop.

### 3. Spawn a sub-agent

Launch a single sub-agent. In the prompt, include:

1. The **task description** — what to do, and what "done" looks like
2. The **contents of `progress.txt`** — so the sub-agent knows what exists
3. The **contents of `learning.txt`** — so the sub-agent avoids known pitfalls
4. The **output format** — how the sub-agent should report its result (e.g., what files to write, what to return)

Tell the sub-agent explicitly: *"You have no memory of previous iterations. Rely only on the context provided here and the files listed above."*

### 4. Collect results

When the sub-agent returns, review its output. Determine:
- Was the task completed successfully?
- Were there errors, partial results, or new discoveries?
- What should future sub-agents know?

### 5. Update shared state

Append to `progress.txt`:
```
[DONE] <task name>
  - What was done
  - Output artifacts (file paths, key values, etc.)
  - Date/iteration number
```

Append to `learning.txt` only when there is something genuinely useful:
```
[<task name>] <lesson>
  - What happened
  - What to do (or avoid) next time
```

Do **not** pad these files with noise. Keep entries factual and actionable.

### 6. Loop

Return to step 2 and select the next task.

---

## Sub-Agent Instructions

At the start of your task:

1. Read `progress.txt` — understand what work is already done and what artifacts exist
2. Read `learning.txt` — apply all lessons before you begin
3. Do the task described in your prompt
4. Report your results clearly so the lead agent can update shared state

You do not write to `progress.txt` or `learning.txt`. That is the lead agent's responsibility.

---

## File Conventions

| File | Owner | Purpose |
|---|---|---|
| `progress.txt` | Lead agent | Persistent log of completed work |
| `learning.txt` | Lead agent | Accumulated lessons across iterations |

Both files live in the working directory of the project unless otherwise specified.

---

## When to Stop

The lead agent stops the loop when:
- All tasks are marked done in `progress.txt`
- A task fails repeatedly and `learning.txt` has captured the blocker — escalate to the user
- The user explicitly cancels

---

## Example Prompt to Sub-Agent

```
You are a stateless sub-agent. You have no memory of previous iterations.

## Your task
<specific task description and done criteria>

## What has been done so far (progress.txt)
<contents of progress.txt>

## Lessons from previous iterations (learning.txt)
<contents of learning.txt>

## Output
Return a brief summary of what you did and what you produced.
Do NOT modify progress.txt or learning.txt.
```
