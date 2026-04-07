# ── completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# ── history ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ── options ───────────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# ── prompt ────────────────────────────────────────────────────────────────────
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{cyan}%n@%m%f %F{yellow}%~%f%F{green}${vcs_info_msg_0_}%f %(?.%F{green}❯%f.%F{red}❯%f) '

# ── plugins ───────────────────────────────────────────────────────────────────
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── aliases ───────────────────────────────────────────────────────────────────
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
