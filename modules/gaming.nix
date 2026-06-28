{ pkgs, ... }:{
  programs.steam = {
    enable = true;

    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    protonplus
    wineWowPackages.stable
    winetricks
  ];
}
