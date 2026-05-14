{
  inputs,
  lib,
  config,
  ...
}:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      hardware.graphics.enable = true;
      fonts = {
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          nerd-fonts.jetbrains-mono
          dejavu_fonts
          liberation_ttf
        ];
        fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [ "JetBrainsMono Nerd Font" ];
            sansSerif = [ "Noto Sans" ];
            serif = [ "Noto Serif" ];
          };
        };
      };
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      };
    };

  flake.homeModules.desktop =
    { config, pkgs, ... }:
    {
      programs = {
        foot = {
          enable = true;
          settings = {
            key-bindings = {
              scrollback-down-page = "Mod1+j";
              scrollback-up-page = "Mod1+k";
              clipboard-copy = "Mod1+c";
              clipboard-paste = "Mod1+v";
              font-decrease = "Mod1+Shift+j";
              font-increase = "Mod1+Shift+k";
              font-reset = "Mod1+Shift+l";
              search-start = "Mod1+slash";
            };
            main.pad = "0x0";
          };
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof noctalia || noctalia-shell ipc call lockScreen lock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 1800;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 2700;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 4500;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };

      # Use the HM module only for package/plugin wiring.
      # The actual config is managed as a Lua file below.
      stylix.targets.hyprland.enable = false;
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        plugins = [
          inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
        ];
        settings = {

        };
        # Disable HM's own config generation — we manage hyprland.lua ourselves.
        systemd.enable = true;
      };

      # Hyprland 0.55+ uses hyprland.lua instead of hyprland.conf.
      # HM's wayland.windowManager.hyprland.settings / extraConfig only generate
      # the old hyprlang format, so we write the Lua config directly.
      xdg.configFile."hypr/hyprland.lua".text = ''
        -- ==================
        -- MONITORS
        -- ==================
        hl.monitor({ output = "DP-1", mode = "3440x1440@165.0", position = "1270x1080", scale = 1.0 })
        hl.monitor({ output = "DP-2", mode = "1920x1080@120.0", position = "1963x0",   scale = 1.0 })
        hl.monitor({ output = "DP-3", mode = "1920x1200@60.0",  position = "70x787",   scale = 1.0, transform = 3 })
        hl.monitor({ output = "LVDS-1", mode = "1920x1080@60.0",  position = "0x0",   scale = 1.0 })
        hl.monitor({ output = "",     mode = "preferred",        position = "auto",     scale = "auto" })

        -- ==================
        -- GENERAL SETTINGS
        -- ==================
        hl.config({
          plugin = {
            split_monitor_workspaces = {
              count                      = 9,
              keep_focused               = 0,
              enable_notifications       = 0,
              enable_persistent_workspaces = 1,
              enable_wrapping            = 1,
              link_monitors              = 0,
            },
          },
          general = {
            gaps_in   = 0,
            gaps_out  = 0,
            border_size = 3,
            ["col.active_border"]   = "rgb(${config.lib.stylix.colors.base09})",
            ["col.inactive_border"] = "rgb(${config.lib.stylix.colors.base04})",
          },
          animations = {
            enabled = false,
          },
          decoration = {
            shadow = {
              enabled = true,
              offset  = "5 5",
              color   = "rgba(${config.lib.stylix.colors.base00}ff)",
            },
          },
          input = {
            kb_layout    = "gb",
            kb_options   = "ctrl:nocaps",
            repeat_delay = 300,
            repeat_rate  = 50,
          },
        })

        -- ==================
        -- AUTOSTART
        -- ==================
        hl.on("hyprland.start", function ()
          hl.exec_cmd("noctalia-shell")
        end)

        -- ==================
        -- WINDOW RULES
        -- ==================
        hl.window_rule({ match = { class = "mpv"     }, float = true })
        hl.window_rule({ match = { class = "waywall" }, float = true })
        hl.window_rule({ match = { class = "java"    }, float = true })
        hl.window_rule({ match = { title = "Open File"       }, float = true })
        hl.window_rule({ match = { title = "Select a File"   }, float = true })
        hl.window_rule({ match = { title = "Choose Wallpaper" }, float = true })
        hl.window_rule({ match = { title = "Save As"         }, float = true })
        hl.window_rule({ match = { title = "Library"         }, float = true })
        hl.window_rule({ match = { title = "File Upload"     }, float = true })

        -- ==================
        -- KEYBINDS
        -- ==================
        local mainMod = "SUPER"
        local smw     = hl.plugin.split_monitor_workspaces

        -- Mouse binds
        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Media / volume / brightness (repeat-on-hold)
        hl.bind("XF86AudioRaiseVolume",    hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume",    hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessUp",     hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown",   hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"), { locked = true, repeating = true })

        -- Media keys (locked / works on lockscreen)
        hl.bind("XF86AudioMute",  hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"), { locked = true })
        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("noctalia-shell ipc call media next"), { locked = true })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("noctalia-shell ipc call media previous"), { locked = true })
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("noctalia-shell ipc call media play"), { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia-shell ipc call media pause"), { locked = true })

        -- Window management
        hl.bind(mainMod .. " + Q",           hl.dsp.window.kill())
        hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
        hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. " + S",           hl.dsp.window.pin())
        hl.bind(mainMod .. " + h",           hl.dsp.window.resize({ x = -100, y = 0 }))
        hl.bind(mainMod .. " + l",           hl.dsp.window.resize({ x =  100, y = 0 }))
        hl.bind(mainMod .. " + j",           hl.dsp.focus({ direction = "left" }))
        hl.bind(mainMod .. " + k",           hl.dsp.focus({ direction = "right" }))
        hl.bind(mainMod .. " + CTRL + j",      hl.dsp.focus({ direction = "down" }))
        hl.bind(mainMod .. " + CTRL + k",      hl.dsp.focus({ direction = "up" }))
        hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.window.move({ direction = "left" }))
        hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.window.move({ direction = "down" }))
        hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.window.move({ direction = "up" }))
        hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.window.move({ direction = "right" }))

        -- App launchers
        hl.bind(mainMod .. " + Return",      hl.dsp.exec_cmd("foot"))
        hl.bind(mainMod .. " + Backspace",   hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))
        hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd("zen-beta"))
        hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd("noctalia-shell ipc call launcher emoji"))
        hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd("foot -e yazi"))
        hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd("noctalia-shell ipc call bar toggle"))
        hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
        hl.bind(mainMod .. " + V",           hl.dsp.exec_cmd("noctalia-shell ipc call launcher clipboard"))
        hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("foot -e jellyfin-tui"))

        -- Workspace switching + moving (split-monitor-workspaces)
        for i = 1, 9 do
          local key = tostring(i)
          hl.bind(mainMod .. " + " .. key, function() return smw.workspace(i) end)
          hl.bind(mainMod .. " + SHIFT + " .. key, function() return smw.move_to_workspace(i) end)
        end
      '';
    };
}
