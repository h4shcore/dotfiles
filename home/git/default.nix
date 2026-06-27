{...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "h4shcore";
        email = "97403914+h4shcore@users.noreply.github.com";
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
  };
}
