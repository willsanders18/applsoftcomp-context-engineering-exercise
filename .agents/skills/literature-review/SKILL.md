---
name: literature-review
description: Write a literature review by iterating over papers one at a time, accumulating summaries and themes across iterations.
---

Shared files: `progress.txt` (done/remaining), `learning.txt` (cross-paper insights), `research_note.md` (summaries+themes), `synthesis.md` (final synthesis).

## Lead Agent (loop controller — no reading/writing of papers)
1. Init (first run only): copy `./agents/skills/templates/{progress,learning,research_note,synthesis}.*` into working dir if not exist. List all PDFs; populate `progress.txt` with unchecked entries.
2. Spawn Abstract Extraction Sub-Agent per paper in parallel via Task tool. Wait for all.
3. Spawn Planning Sub-Agent once. Wait.
4. Spawn Reading Sub-Agent for next unreviewed paper. Wait. Repeat until all done.
5. Spawn Synthesis Sub-Agent once. Then stop.

## Sub-Agents (all spawned via Task tool, `general`/`mode: subagent`)

Abstract Extraction (parallelizable, once per paper): run `python3 tools/extract_pdf.py <input.pdf>`; append `filename.pdf: abstract text` to `abstracts.txt`. Append only; do not read.

Planning (once): read `abstracts.txt`; reorder `progress.txt` entries foundational-first. Do not mark any paper done.

Reading (sequential, once per paper): read `progress.txt` → pick next unreviewed; read `learning.txt` for context; extract paper via `python3 tools/extract_pdf.py <input.pdf>`; read `templates/research_note.md` for format then append new entry to `research_note.md` (append only, do not read); append to `learning.txt` (format from `templates/learning.txt`) noting contradictions and avoiding restatement; mark paper done in `progress.txt` with one-line note.

Synthesis (once, after all papers done): read `research_note.md`, `learning.txt`, `templates/synthesis.md`; overwrite `synthesis.md` with all three sections (Synthesis, Contradictions, Open Questions).

Writing style (all sub-agents): clear+concise, define jargon, LaTeX for equations (display mode for key ones), max 3 sentences/paragraph, paragraph-based narrative, no bullets/tables, conversational tone.

## Stop Conditions
- All papers reviewed + `synthesis.md` written
- Sub-agent fails repeatedly → escalate to user
- User cancels
