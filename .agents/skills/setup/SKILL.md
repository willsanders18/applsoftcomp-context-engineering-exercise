---
name: setup
description: Check and install required dependencies for this repository.
---

Verify Python is available and install required packages.

## Steps

### 1. Check Python

Run the following to find a working Python executable:

```
python --version   # try this first
python3 --version  # fallback on Linux/macOS
```

Use whichever succeeds (`python` or `python3`). If neither works, tell the user to install Python (https://www.python.org/downloads/) and stop.

### 2. Check and install `pymupdf`

Try importing `fitz` (pymupdf):

```
python -c "import fitz; print('pymupdf ok')"
```

If it fails, install it. Prefer `uv` if available, otherwise fall back to `pip`:

**Check for uv:**
```
uv --version
```

**Install with uv (preferred):**
```
uv pip install pymupdf
```

**Install with pip (fallback):**
```
python -m pip install pymupdf
```

On Windows, use `python` instead of `python3` in all commands above.

### 3. Verify

After installation, confirm the import works:

```
python -c "import fitz; print('pymupdf installed successfully')"
```

Report success or any errors to the user.
