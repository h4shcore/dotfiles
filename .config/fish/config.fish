if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Direnv + Zoxide
    direnv hook fish | source
    zoxide init fish | source

    # Better ls
    alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    # git
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    # ls
    abbr l 'ls -l'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la --header'
    abbr lt 'ls --tree'

    # term
    abbr r 'yazi'
    abbr nv 'nvim'
    abbr c 'clear'
    abbr q 'exit'
    abbr sd 'shutdown now'
    abbr re 'reboot'

    # emacs
    alias e='emacs'
    abbr enw 'e -nw'
    abbr ec 'emacsclient'
    abbr ecc 'ec -c'
    abbr ecnw 'ec -nw'

    # env vars
    set -gx EDITOR nvim 
    set -gx MANPAGER 'nvim +Man!'

    # path
    set PATH $HOME/.local/bin $PATH
    set PATH /nix/var/nix/profiles/default/bin $PATH  

    # disable greeting message
    set fish_greeting ""

    # enable vi mode
    set -g fish_key_bindings fish_vi_key_bindings

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end
