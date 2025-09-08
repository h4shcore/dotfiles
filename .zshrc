# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="intheloop"
# ZSH_THEME="nicoulaj"
# ZSH_THEME="refined"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
#
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# EDITOR
export EDITOR=nvim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias hyprconfig="nvim ~/.config/hypr/hyprland.conf"
alias nf="neofetch"
alias ff="fastfetch"
alias nv="nvim"
alias c="clear"
alias q="exit"
alias sd="shutdown now"
alias re="reboot"
alias r="yazi"
alias st="df -h"
alias clock="tty-clock -C3 -D"
alias hack="cmatrix"
alias v="cava"
alias ac="ani-cli"
alias cs="cowsay"
# alias usb="udisksctl mount --block-device /dev/sda1" # for my personal external hdd connection
# alias um="udisksctl unmount -b /dev/sda1" # unmount external drive
alias usb="sudo mount /dev/sda1 /run/media/daksh"
alias um="sudo umount /dev/sda1 /run/media/daksh"
alias hx="helix"
alias zz="zellij"
alias battery="bat /sys/class/power_supply/BAT1/capacity"

# eza ls 
alias eza="eza --icons"
alias ls="eza"
alias l="ls -l"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la --header"
alias lt="ls --tree"

# cd back
alias ..="cd .."

# emacs
alias e="emacs"
alias enw="e -nw"
alias ec="emacsclient"
alias ecc="ec -c"
alias ecnw="ec -nw"


# plugins
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /home/daksh/.config/zsh/F-Sy-H/F-Sy-H.plugin.zsh
source /home/daksh/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/daksh/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/daksh/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# custom scripts
export PATH="$HOME/.local/bin:$PATH"

# spicetify
export PATH=$PATH:/home/daksh/.spicetify

# emacs
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"

# zoxide
eval "$(zoxide init zsh)"

# starship 
eval "$(starship init zsh)"

# direnv
eval "$(direnv hook zsh)"

# bun completions
[ -s "/home/daksh/.bun/_bun" ] && source "/home/daksh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
