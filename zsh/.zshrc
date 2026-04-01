# ── zsh config ────────────────────────────────────────────────────────────────

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Key bindings
bindkey -e
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# ── nvm ───────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ll='ls -lh'
alias la='ls -lah'
alias g='git'
alias tf='terraform'
alias dc='docker compose'

# bat as cat replacement (if available)
cmd_exists() { command -v "$1" &>/dev/null; }
cmd_exists bat && alias cat='bat --paging=never'

# ── Starship prompt ───────────────────────────────────────────────────────────
eval "$(starship init zsh)"
