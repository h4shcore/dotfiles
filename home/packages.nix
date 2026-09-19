{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    spotify
    vesktop
    equibop
    firefox
    brave
    qbittorrent
    mpv
    ani-cli
    woomer
    matugen
    inputs.vivy.packages.${pkgs.stdenv.hostPlatform.system}.default # github:h4shcore/vivy
  ];
}
