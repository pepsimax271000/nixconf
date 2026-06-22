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
          theme = {
            colorScheme = "catppuccin";
            builtin = "Catppuccin";
          };
          shell = {
            avatar_path = "${config.home.homeDirectory}/nixconf/assets/pfp.jpg";
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
          widget = {
            bongocat = {
              script = "scripts/bongocat.lua";
              type = "scripted";
              input_device = "/dev/input/event0";
            };
            workspaces = {
              empty_color = "primary";
              focused_color = "hover";
              occupied_color = "primary";
              minimal = true;
            };
          };
          nightLight = {
            autoSchedule = true;
            enabled = true;
            manualSunrise = "08:00";
            manualSunset = "23:00";
            nightTemp = "3500";
          };
          wallpaper = {
            directory = "${wallpaperDir}";
            default = {
              path = "${wallpaperDir}";
            };
            monitors = {
              DP-1 = {
                path = "${wallpaperDir}/flowers-21_hr.png";
              };
              DP-2 = {
                path = "${wallpaperDir}/nerv_catppuccinn_uw.jpg";
              };
              LVDS-1 = {
                path = "${wallpaperDir}/rei-ii.jpg";
              };
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
