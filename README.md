# dotfiles

Personal dev environment for ooctl devbox (Ubuntu, x86_64).

## Install

```bash
git clone https://github.com/wlwu92/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

## What's included

| Tool | Notes |
|------|-------|
| zsh + starship | shell + prompt, no oh-my-zsh overhead |
| vim | editor with sane defaults |
| tmux + tpm | terminal multiplexer, resurrect plugin |
| fzf / ripgrep / fd / bat / jq | CLI utilities |
| gh | GitHub CLI |
| aliyun | Alibaba Cloud CLI |
| nvm + Node.js LTS | runtime |
| Claude Code | AI assistant |

## After install

```bash
# 1. Set git identity
vim ~/.gitconfig

# 2. Authenticate
gh auth login
aliyun configure

# 3. Set API key
echo 'export ANTHROPIC_API_KEY=sk-...' >> ~/.zshrc

# 4. Reload
exec zsh

# 5. Install tmux plugins (inside tmux)
# prefix + I
```
