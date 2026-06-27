{
  config,
  pkgs,
  ...
}: {
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;

    nix-direnv.enable = true;
  };

  xdg.configFile."fish/config.fish".source = ./fish/config.fish;
  xdg.configFile."alacritty".source = ./alacritty;
  xdg.configFile."foot".source = ./foot;
  xdg.configFile."kitty".source = ./kitty;
  xdg.configFile."starship.toml".source = ./starship/starship.toml;
  xdg.configFile."yazi".source = ./yazi;
}
