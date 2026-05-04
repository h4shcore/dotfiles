# prompt
PROMPT='%F{#fb4934}[%f%F{#fabd2f}%n%f%F{#928374}@%F{#83a598}%m%f %F{#83a598}%~%f%F{#fb4934}]%f%(#.%F{#fb4934}#.%F{#b8bb26}$)%f '

# zsh-history 
HISTFILE=~/.zsh_history
export HISTFILESIZE=10000000 # history limit of the file on disk
export HISTSIZE=10000000 # current session's history limit, also following this https://unix.stackexchange.com/a/595475 $HISTSIZE should be at least 20% bigger than $SAVEHIST 
export SAVEHIST=500000 # zsh saves this many lines from the in-memory history list to the history file upon shell exit
setopt INC_APPEND_HISTORY # history file is updated immediately after a command is entered
setopt SHARE_HISTORY # allows multiple Zsh sessions to share the same command history 
setopt EXTENDED_HISTORY # records the time when each command was executed along with the command itself
setopt APPENDHISTORY # ensures that each command entered in the current session is appended to the history file immediately after execution
export HISTTIMEFORMAT="%d/%m/%Y %H:%M] "

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
  git
)

# EDITOR
export EDITOR=nvim
export VISUAL=nvim

# aliases
alias nv="nvim"
alias c="clear"
alias q="exit"
alias sd="shutdown now"
alias re="reboot"
alias r="yazi"
alias st="df -h"
alias battery="bat /sys/class/power_supply/BAT1/capacity"

# eza ls 
alias eza="eza --icons"
alias ls="eza"
alias l="ls -l"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la --header"
alias lt="ls --tree"

# git
alias gd="git diff"
alias ga="git add ."
alias gc="git commit -am"
alias gl="git log"
alias gs="git status"
alias gst="git stash"
alias gsp="git stash pop"
alias gp="git push"
alias gpl="git pull"
alias gsw="git switch"
alias gsm="git switch main"
alias gb="git branch"
alias gbd="git branch -d"
alias gco="git checkout"
alias gsh="git show"

# cd back
alias ..="cd .."

# xbps
# alias xi="doas xbps-install"
# alias xr="doas xbps-remove"
# alias xs="doas xbps-query -Rs"

# plugins
source /home/daksh/.config/zsh/F-Sy-H/F-Sy-H.plugin.zsh
source /home/daksh/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/daksh/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /home/daksh/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# custom scripts
export PATH="$HOME/.local/bin:$PATH"

# doom emacs
export PATH="$HOME/.config/emacs/bin:$PATH"

# manpage
export MANPAGER='nvim +Man!'

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

export PATH=$PATH:/home/daksh/.spicetify

if [ -e /home/daksh/.nix-profile/etc/profile.d/nix.sh ]; then . /home/daksh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
