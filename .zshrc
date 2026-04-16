# =============================================================================
# FASTFETCH
# =============================================================================
if [[ -o interactive ]]; then
    neofetch
fi

# =============================================================================
# POWERLEVEL10K
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# ZINIT — Auto-installer + loader
# =============================================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# =============================================================================
# PLUGINS
# =============================================================================
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit wait lucid for \
    atinit"zicompinit; zicdreplay" blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::sudo \
    OMZP::archlinux \
    OMZP::command-not-found \
    zsh-users/zsh-syntax-highlighting

zinit light Aloxaf/fzf-tab

# =============================================================================
# POWERLEVEL10K — Config
# =============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================================================
# HISTORY
# =============================================================================
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"   # $HOME selalu valid; $ZDOTDIR bisa kosong
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space        # baris diawali spasi tidak masuk history
setopt hist_ignore_all_dups     # hapus duplikat lama saat menulis
setopt hist_save_no_dups        # tidak simpan duplikat ke file
setopt hist_ignore_dups         # tidak simpan duplikat berturutan
setopt hist_find_no_dups        # Ctrl+R tidak tampilkan duplikat

# =============================================================================
# KEYBINDINGS
# =============================================================================
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# =============================================================================
# COMPLETION STYLING
# =============================================================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no              
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# =============================================================================
# SHELL INTEGRATIONS
# =============================================================================
eval "$(fzf --zsh)"                         # Ctrl+R / Ctrl+T / Alt+C
eval "$(zoxide init --cmd cd zsh)"

# =============================================================================
# ALIASES
# =============================================================================
alias ls='eza --icons --group-directories-first --color=always'
alias ll='eza -lah --icons --group-directories-first --color=always'
alias tree='eza --tree --icons --color=always'

alias vim='nvim'
alias c='clear'
alias n='nano'
alias cekpower='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias setpower='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias 75='echo 75 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct'

# =============================================================================
# NVIDIA SHADER CACHE
# =============================================================================
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH="$HOME/.cache/nvidia"
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
export __GL_SHADER_DISK_CACHE_SIZE=10737418240


