---
name: setup
description: Check and install required dependencies for this repository.
---

1. Check Python: `uv run uv run uv run uv run uv run uv run python3 --version` then `uv run uv run uv run uv run uv run uv run python3 --version`. Use whichever works. Stop if neither works.

2. Check uv: `uv --version`. If missing, install:
   - Linux/macOS: `curl -LsSf https://astral.sh/uv/install.sh | sh`
   - Windows: `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"`
   - Verify: `uv --version`. If still fails, skip uv and use pip.

3. Check pymupdf: `uv run uv run uv run uv run uv run uv run python3 -c "import fitz"`. If missing:
   - uv: `uv sync` (uses `pyproject.toml` in repo root)
   - pip fallback: `uv run uv run uv run uv run uv run uv run python3 -m pip install pymupdf`
   - Verify: `uv run uv run uv run uv run uv run uv run python3 -c "import fitz; print('ok')"`. Report result.

4. Update skills: Modify `literature-review/SKILL.md` and `explain-paper/SKILL.md`:
   - Replace `python3` with the working uv run uv run uv run uv run uv run uv run python3 command (`python` or `python3`)
   - If uv is available, prepend `uv run` to uv run uv run uv run uv run uv run uv run python3 commands
   - Keep changes minimal (only update command invocations)
