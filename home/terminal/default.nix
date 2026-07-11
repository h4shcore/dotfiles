{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./yazi
    ./zellij
  ];

  home.packages = with pkgs; [
    yazi
    fastfetch
    alacritty
    unzip
    p7zip
    ripgrep
    fish
    starship
    kitty
    foot
    eza
    btop
    cava
    wget
  ];

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
  xdg.configFile."foot".source = ./foot;
  xdg.configFile."kitty".source = ./kitty;
  xdg.configFile."starship.toml".source = ./starship/starship.toml;
}
