if ! type antibody 1> /dev/null 2>&1; then
  curl -sL git.io/antibody | sh -s
fi

source <(antibody init)

antibody bundle zdharma/fast-syntax-highlighting
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-history-substring-search
antibody bundle zsh-users/zsh-completions
antibody bundle marzocchi/zsh-notify

# Enable autocompletions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
zmodload -i zsh/complist

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Options
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt hist_ignore_space # remove items that start with a space from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances
setopt interactive_comments # allow comments in interactive shells

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Prompt
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure

# Dir stack
DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome pushdignoredups pushdminus
alias dirs='dirs -v'

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Keybindings
bindkey -e # readline style bindings ^n/^p etc
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
bindkey '\^U' backward-kill-line

# Aliases
alias ls='ls --color -C'
alias ll='ls -larth --color'
alias grep='grep --color'
alias be='bundle exec'
alias vim=nvim

# Environment
export LANG=en_US.UTF-8

export EDITOR='nvim'
export GIT_EDITOR='nvim'

export GIT_DUET_GLOBAL=1
export GIT_DUET_ROTATE_AUTHOR=1
export GIT_DUET_CO_AUTHORED_BY=1

export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH

export PATH=/usr/local/go/bin:$PATH
export GOPATH=$HOME/workspace
export PATH=$GOPATH/bin:$PATH

export LD_LIBRARY_PATH=$(rustc --print sysroot)/lib

export SSOCA_ENVIRONMENT=bosh

# No duplicates in $PATH
typeset -U path

# Load utilities
eval "$(fasd --init auto)"
eval "$(direnv hook zsh)"
source $HOME/.config/zsh/*.zsh
eval "$(rbenv init -)"
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
source /usr/share/nvm/init-nvm.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/luan/google-cloud-sdk/path.zsh.inc' ]; then . '/home/luan/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/luan/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/luan/google-cloud-sdk/completion.zsh.inc'; fi
