{ lib, ... }:
{
  options.my = with lib; {
    username = mkOption { type = types.str; };
    gitEmail = mkOption { type = types.str; };
    gitName = mkOption { type = types.str; };
    timezone = mkOption { type = types.str; };
    locale = mkOption { type = types.str; };
    stateVersion = mkOption { type = types.str; };
    homeDir = mkOption {
      type = types.str;
      default = "/home/${config.my.username}";
    };
    wallpaper = mkOption {
      type = types.path;
      default = ../../assets/wallpapers/nix-black_hr.png;
    };
  };

  config.my = {
    username = "ye";
    gitEmail = "248238336+pepsimax271000@users.noreply.github.com";
    gitName = "pepsimax271000";
    homeDir = "/home/ye";
    timezone = "Europe/Belfast";
    locale = "en_GB.UTF-8";
    stateVersion = "26.05";
  };
}
