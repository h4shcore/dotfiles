# remove the startip message
set -U fish_greeting

# enable vi mode
function fish_user_key_bindings
    fish_vi_key_bindings default 2>/dev/null
end

# enable transient prompt
function starship_transient_prompt_func
  starship module character
end
starship init fish | source
enable_transience

# zoxide and starship
zoxide init fish | source
starship init fish | source

# env vars
set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'

# alias
# alias ls='eza --icons --group-directories-first -1'
alias ls='eza --icons'

# abbrs
abbr yy "yazi"
abbr nr "nix run"
abbr vim "nvim"

# ls
abbr l 'ls -l'
abbr ll 'ls -l'
abbr la 'ls -a'
abbr lla 'ls -la --header'
abbr lt 'ls --tree'
