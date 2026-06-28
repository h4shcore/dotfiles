{...}: {
  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          name = "h4shcore";
          email = "97403914+h4shcore@users.noreply.github.com";
        };
        url = {
          "git@git.sr.ht:".insteadOf = "sh:";
          "git@codeberg.org:".insteadOf = "cb:";
          "git@github.com:".insteadOf = "gh:";
          "git@gitlab.com:".insteadOf = "gl:";
          "git@git.sr.ht:~h4shcore/".insteadOf = "me@sh:";
          "git@github.com:h4shcore/".insteadOf = "me@gh:";
        };
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = false;
        };
      };
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "h4shcore";
          email = "97403914+h4shcore@users.noreply.github.com";
        };
        ui = {
          default-command = "log";
        };
        git = {
          auto-local-bookmark = true;
        };
      };
    };
  };
}
