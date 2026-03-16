#!/bin/bash
set -e

echo "=== Setting up Context Engineering Exercise ==="

# ── 1. Install Python dependencies ────────────────────────────────────────
echo "Installing Python dependencies..."
UV_LINK_MODE=copy uv sync
uv run python -c "import fitz; print('pymupdf ok')"

# ── 2. Configure OpenCode ─────────────────────────────────────────────────
echo "Configuring OpenCode..."
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "autoshare": false,
  "model": "ollama/qwen3.5:35b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama",
      "options": {
        "baseURL": "https://ollama.com/v1"
      },
      "models": {
        "qwen3.5:35b": {
          "name": "qwen3.5:35b"
        }
      }
    }
  }
}
EOF

# ── 3. Update skill commands for this environment ─────────────────────────
echo "Updating skill commands..."
for skill_file in .agents/skills/*/SKILL.md; do
  if [ -f "$skill_file" ]; then
    sed -i "s/python3 /uv run python3 /g" "$skill_file"
    sed -i "s/python /uv run python3 /g" "$skill_file"
  fi
done

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Next steps:"
echo "  1. Open a terminal and run: opencode"
echo "  2. Enter your Ollama API key when prompted (get one at ollama.com/settings/keys)"
echo "  3. In OpenCode, type /setup to verify dependencies"
echo "  4. Follow the exercise in docs/task.md"
echo ""
