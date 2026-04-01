#!/usr/bin/env bash
# dotfiles installer — idempotent, run as ooctl user on Ubuntu/Debian
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ok()         { echo "  ✓ $*"; }
info()       { echo ""; echo "→ $*"; }
cmd_exists() { command -v "$1" &>/dev/null; }
link() {
  mkdir -p "$(dirname "$2")"
  ln -sf "$1" "$2"
  ok "linked $2"
}

mkdir -p ~/.config

# ── 1. System packages ────────────────────────────────────────────────────────
info "System packages..."
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends \
  zsh vim tmux git curl wget unzip build-essential \
  fzf ripgrep fd-find bat jq

# Ubuntu renames these — expose standard names
[ -f /usr/bin/fdfind ] && sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd  || true
[ -f /usr/bin/batcat ] && sudo ln -sf /usr/bin/batcat /usr/local/bin/bat || true

# ── 2. Starship prompt ────────────────────────────────────────────────────────
if ! cmd_exists starship; then
  info "Starship prompt..."
  curl -fsSL https://starship.rs/install.sh | sudo sh -s -- --yes
else
  ok "starship already installed"
fi

# ── 3. tmux plugin manager (tpm) ──────────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "tmux TPM..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  ok "tpm already installed"
fi

# ── 4. GitHub CLI ─────────────────────────────────────────────────────────────
if ! cmd_exists gh; then
  info "GitHub CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y gh
else
  ok "gh already installed ($(gh --version | head -1))"
fi

# ── 5. Aliyun CLI ─────────────────────────────────────────────────────────────
if ! cmd_exists aliyun; then
  info "Aliyun CLI..."
  curl -fsSL https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz \
    | sudo tar -xzf - -C /usr/local/bin/
else
  ok "aliyun already installed"
fi

# ── 6. nvm + Node.js + Claude Code ────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
  info "nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! cmd_exists node; then
  info "Node.js LTS..."
  nvm install --lts
  nvm alias default node
else
  ok "node already installed ($(node --version))"
fi

if ! cmd_exists claude; then
  info "Claude Code..."
  npm install -g @anthropic-ai/claude-code
else
  ok "claude already installed"
fi

# ── 7. Dotfile symlinks ───────────────────────────────────────────────────────
info "Linking dotfiles..."

link "$DOTFILES_DIR/zsh/.zshrc"             ~/.zshrc
link "$DOTFILES_DIR/vim/.vimrc"             ~/.vimrc
link "$DOTFILES_DIR/tmux/.tmux.conf"        ~/.tmux.conf
link "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml

# Git config: copy template only if none exists
if [ ! -f ~/.gitconfig ]; then
  cp "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
  ok "copied ~/.gitconfig — set user.name and user.email!"
else
  ok "~/.gitconfig already exists, skipping"
fi

# ── 8. Default shell → zsh ───────────────────────────────────────────────────
if [ "$SHELL" != "$(which zsh)" ]; then
  info "Changing default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  dotfiles installed — next steps:"
echo ""
echo "  1. Edit ~/.gitconfig     (set user.name / user.email)"
echo "  2. gh auth login"
echo "  3. aliyun configure"
echo "  4. export ANTHROPIC_API_KEY=...  (add to ~/.zshrc)"
echo "  5. exec zsh"
echo "  6. Inside tmux: prefix + I  (install plugins)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
