# ── completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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

# ── sudo plugin (inlined — no oh-my-zsh dependency) ──────────────────────────
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey '^[^[' sudo-command-line  # ESC ESC

# ── prompt ────────────────────────────────────────────────────────────────────
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr   '%F{green}✔%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{yellow}✗%f'
zstyle ':vcs_info:git:*' formats       ' | %F{green}git:%b%f %c%u'
zstyle ':vcs_info:git:*' actionformats ' | %F{green}git:%b%f %F{red}(%a)%f %c%u'

setopt PROMPT_SUBST
PROMPT=$'%(?.%F{white}.%B%F{red})%n@%m%f%b %F{white}[%*]%f${vcs_info_msg_0_} | %F{blue}%~%f\n%(?,%(!.#.>),%(!.#.!)) '

# ── plugins ───────────────────────────────────────────────────────────────────
# apt install zsh-autosuggestions zsh-syntax-highlighting
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax-highlighting MUST be last
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── aliases ───────────────────────────────────────────────────────────────────
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias zshrc-update='curl -fsSL https://raw.githubusercontent.com/paulriley/fizzsh/main/.zshrc -o ~/.zshrc && source ~/.zshrc'
