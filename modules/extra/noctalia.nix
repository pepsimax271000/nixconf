{ inputs, ... }:
{
  flake.homeModules.noctalia =
    { lib, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia-shell = {
        enable = true;
        settings = {
          # configure noctalia here
          settingsVersion = "41";
          bar = {
            density = "mini";
            position = "right";
            exclusive = true;
            outerCorners = false;
            monitors = [
              "DP-1"
              "DP-2"
              "HDMI-A-1"
              "LVDS-1"
            ];
            showCapsule = false;
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
              ];
              center = [
                {
                  hideUnoccupied = false;
                  id = "Workspace";
                  labelMode = "none";
                }
              ];
              right = [
                {
                  id = "Tray";
                  drawerEnabled = false;
                  colorizeIcons = true;
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
                  alwaysShowPercentage = false;
                  id = "Battery";
                  warningThreshold = 30;
                }
                {
                  formatHorizontal = "HH:mm";
                  formatVertical = "MMM dd - HH mm";
                  id = "Clock";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
              ];
            };
          };
          screenOverrides = [
            {
              enabled = true;
              density = "mini";
              name = "DP-2";
              position = "bottom";
              widgets = {
                left = [
                  {
                    id = "Workspace";
                  }
                ];
                center = [
                  {
                    id = "MediaMini";
                    maxWidth = "1000";
                  }
                ];
                right = [
                  {
                    id = "Clock";
                  }
                ];
              };
            }
          ];
          ui = {
            fontDefault = lib.mkForce "JetBrainsMono Nerd Font";
            fontFixed = "JetBrainsMono Nerd Font";
          };
          dock = {
            enabled = false;
          };
          wallpaper = {
            directory = "/home/ye/nixconf/assets/wallpapers";
          };
          appLauncher = {
            terminalCommand = "foot -e";
            enableClipboardHistory = true;
          };
          nightLight = {
            enabled = true;
            autoSchedule = false;
            nightTemp = "3500";
            manualSunset = "22:00";
            manualSunrise = "06:30";
          };
          brightness = {
            enableDdcSupport = true;
          };
          colorSchemes = {
            predefinedScheme = "Catppuccin";
          };
          audio = {
            cavaFrameRate = "165";
            visualizerType = "mirrored";
          };
          osd = {
            location = "top";
          };
        };
      };
    };
}
