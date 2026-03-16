# Setup

![opencode](https://opencode.ai/social-share.png)

## 1. Get an API key

Two providers are pre-configured. Pick one (or both):

**Option A: Ollama Cloud** (default model: `qwen3.5:cloud`)
1. Go to [ollama.com](https://ollama.com/) and sign in (or create a free account)
2. Navigate to **Settings → Keys**
3. Click **Add API Key**, give it a name, and copy the key

**Option B: OpenRouter** (model: `qwen/qwen3.5-flash-02-23`)
1. Go to [openrouter.ai](https://openrouter.ai/) and sign in (or create a free account)
2. Navigate to **Settings → Keys**
3. Click **Create Key**, give it a name, and copy the key

## 2. Connect OpenCode to your provider

In the opencode terminal, type:

```
/connect
```

Select your provider (**Ollama Cloud** or **OpenRouter**) and paste your API key.
Switch models anytime with `/model`.

## 3. Install dependencies

Run the setup skill:

```
/setup
```

See [.agents/skills/setup/SKILL.md](../.agents/skills/setup/SKILL.md) for what this does.
