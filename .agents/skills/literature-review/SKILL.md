---
name: literature-review
description: Write a literature review by iterating over papers one at a time, accumulating summaries and themes across iterations.
---

Stateless sub-agents per paper; lead agent = loop controller. All sub-agents via Task tool (`general`/`mode: subagent`).
Shared files: `progress.txt` (done/remaining), `learning.txt` (cross-paper insights), `research_note.md` (summaries+themes), `synthesis.md` (final synthesis).

## Lead Agent Loop
1. **Init** (first run only): copy templates `progress.txt`, `learning.txt`, `research_note.md`, `synthesis.md` from `./agents/skills/templates/` into working dir if not exist. List all PDFs; populate `progress.txt` with unchecked entries.
2. **Abstract extraction** (parallelizable, once per paper): `python3 tools/extract_pdf.py <input.pdf>` → append `filename.pdf: abstract text` to `abstracts.txt`. Append only; do not read.
3. **Planning** (once): read `abstracts.txt`; reorder `progress.txt` entries foundational-first. Do not mark done.
4. **Reading** (sequential, once per paper): repeat until stop condition:
   - Read `progress.txt` → pick next unreviewed. Read `learning.txt` for context.
   - Extract paper via `python3 tools/extract_pdf.py <input.pdf>`.
   - Read `templates/research_note.md` for format; append new entry to `research_note.md` (append only).
   - Append to `learning.txt` (format from `templates/learning.txt`): note contradictions, avoid restating existing themes, conversational tone, LaTeX for equations, define jargon on first use, max 3 sentences/paragraph, no bullets/tables.
   - Mark paper done in `progress.txt` with one-line note.
5. **Final synthesis** (once, after all done): read `research_note.md`, `learning.txt`, `templates/synthesis.md`; write complete `synthesis.md` (Synthesis, Contradictions, Open Questions). Same writing style; overwrite, do not append.

Writing style (all agents): clear+concise, define jargon, LaTeX for equations (display mode for key ones), max 3 sentences/paragraph, paragraph-based narrative, no bullets/tables, conversational tone.

## Stop Conditions
- All papers reviewed + `synthesis.md` written
- Worker fails repeatedly → escalate to user
- User cancels
