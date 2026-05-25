{ ... }:
{
  flake.homeModules.media =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ffmpeg
        imv
        jellyfin-media-player
        jellyfin-tui
      ];

      programs = {
        mpv.enable = true;
        yt-dlp.enable = true;
        zathura.enable = true;
      };
    };
}
