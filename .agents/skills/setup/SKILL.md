---
name: setup
description: Check and install required dependencies for this repository.
---

1. Find Python: try `python --version`, then `python3`. Stop if neither works.

2. Install uv if missing:
   - Linux/macOS: `curl -LsSf https://astral.sh/uv/install.sh | sh`
   - Windows: `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"`

3. Install pymupdf: `uv pip install pymupdf`. If uv failed, `python -m pip install pymupdf`.

4. Verify: `python -c "import fitz; print('ok')"`. Report result.
