{ ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      programs = {
        gamemode.enable = true;
        steam = {
          enable = true;
          gamescopeSession.enable = true;
          localNetworkGameTransfers.openFirewall = true;
          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = true;
              OBS_VKCAPTURE = true;
            };
          };
        };
      };
      hardware.steam-hardware.enable = true;
      environment.systemPackages = with pkgs; [
        waywall
        zulu
        steamtinkerlaunch
        winetricks
        wineWow64Packages.staging
        gamemode
        mangohud
        protonup-qt
        heroic
        protontricks
      ];
    };

  flake.homeModules.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (prismlauncher.override {
          textToSpeechSupport = false;
          additionalLibs = [
            libxt
            libxtst
            libxkbcommon
            libxinerama
          ];
          jdks = [
            graalvmPackages.graalvm-ce
            zulu
            zulu8
            zulu17
          ];
        })
      ];
    };
}
