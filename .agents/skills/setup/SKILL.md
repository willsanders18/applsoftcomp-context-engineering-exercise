---
name: setup
description: Check and install required dependencies for this repository.
---

1. Check Python: `python --version` then `python3 --version`. Use whichever works. Stop if neither works.

2. Check uv: `uv --version`. If missing, install:
   - Linux/macOS: `curl -LsSf https://astral.sh/uv/install.sh | sh`
   - Windows: `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"`
   - Verify: `uv --version`. If still fails, skip uv and use pip.

3. Check pymupdf: `python -c "import fitz"`. If missing:
   - uv: `uv pip install pymupdf`
   - pip fallback: `python -m pip install pymupdf`
   - Verify: `python -c "import fitz; print('ok')"`. Report result.
