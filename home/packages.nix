{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    spotify
    vesktop
    firefox
    brave
    qbittorrent
    mpv
    ani-cli
    woomer
    matugen
    inputs.vivy.packages.${pkgs.system}.default # github:h4shcore/vivy
  ];
}
