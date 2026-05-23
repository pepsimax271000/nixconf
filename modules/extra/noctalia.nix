{ inputs, ... }:
{
  flake.homeModules.noctalia =
    { config, ... }:
    let
      wallpaperDir = "${config.home.homeDirectory}/nixconf/assets/wallpapers";
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia = {
        enable = true;
        settings = {
          shell = {
            font_family = "JetBrainsMono NF";
          };
          ui = {
            fontDefault = "JetBrainsMono Nerd Font";
            fontFixed = "JetBrainsMono Nerd Font";
          };
          appLauncher = {
            enableClipboardHistory = true;
            terminalCommand = "foot -e";
          };
          nightLight = {
            autoSchedule = true;
            enabled = true;
            manualSUnrise = "08:00";
            manualSunset = "23:00";
            ngihtTemp = "3500";
          };
          wallpaper = {
            directory = "${wallpaperDir}";
            default = {
              path = "${wallpaperDir}";
            };
            monitors.DP-1 = {
              path = "${wallpaperDir}/nerv_catppuccin_uw.png";
            };
            monitors.DP-2 = {
              path = "${wallpaperDir}/angel.jpg";
            };
            monitors.LVDS-1 = {
              path = "${wallpaperDir}/rei-ii.jpg";
            };
          };
          bar = {
            density = "mini";
            exclusive = true;
            outerCorners = false;
            showCapsule = false;
            monitors = [
              "DP-1"
              "DP-2"
              "DP-3"
              "eDP-1"
              "LVDS-1"
              "HDMI-A-1"
            ];
            bar = {
              capsule_radius = "3.0";
              font_weight = 700;
              margin_ends = 0;
              margin_edge = 0;
              position = "right";
              radius = 0;
              widget_spacing = 20;
              start = [
                "date"
                "clock"
                "media"
                "bongocat"
              ];
              center = [
                "workspaces"
              ];
              end = [
                "tray"
                "bluetooth"
                "volume"
                "brightness"
                "network"
                "battery"
                "control-center"
              ];
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
              ];
              right = [
                {
                  id = "Tray";
                  colorizeIcons = true;
                  drawerEnabled = false;
                }
                {
                  id = "Network";
                }
                {
                  id = "Bluetooth";
                }
                {
                  id = "Volume";
                  displayMode = "alwaysShow";
                }
                {
                  id = "Brightness";
                }
                {
                  id = "Battery";
                  alwaysShowPercentage = true;
                  warningThreshold = 30;
                }
                {
                  id = "Clock";
                  formatHorizontal = "HH:mm";
                  formatVertical = "MMM dd - HH mm";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
              ];
            };
          };
        };
      };
    };
}
