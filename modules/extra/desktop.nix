{
  inputs,
  ...
}:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      hardware.graphics.enable = true;
      stylix.cursor = {
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
      };
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
        xwayland.enable = true;
      };
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      };
      environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
        [Debounce]
        MatchUdevType=mouse
        ModelBouncingKeys=1
      '';
    };

  flake.homeModules.desktop =
    { config, pkgs, ... }:
    let
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          grim
          jq
          libnotify
          satty
          slurp
          wl-clipboard
        ];
        text = ''
          NAS=/media/NAS/storage/Pictures/Screenshots/$(date +%Y)/$(date +%m)
          mkdir -p "$NAS" 2>/dev/null && DIR=$NAS || DIR=$HOME/Pictures/Screenshots
          FILE="$DIR/$(date +%Y%m%d_%H%M%S).png"

          case "$1" in
            area)      grim -g "$(slurp)" - | tee "$FILE" | wl-copy
                       notify-send "Screenshot" "Area → $FILE" ;;
            display)   grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | tee "$FILE" | wl-copy
                       notify-send "Screenshot" "Display → $FILE" ;;
            window)    grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | tee "$FILE" | wl-copy
                       notify-send "Screenshot" "Window → $FILE" ;;
            area-s)    grim -g "$(slurp)" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy
                       notify-send "Screenshot" "Area (annotated) → $FILE" ;;
            display-s) grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy
                       notify-send "Screenshot" "Display (annotated) → $FILE" ;;
            window-s)  grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy
                       notify-send "Screenshot" "Window (annotated) → $FILE" ;;
          esac
        '';
      };

      toggle-monitor-mode = pkgs.writeShellApplication {
        name = "toggle-monitor-mode";
        runtimeInputs = with pkgs; [
          hyprland
          libnotify
        ];
        text = ''
          STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/monitor-mode.state"

          if [[ -f "$STATE_FILE" ]]; then
            CURRENT=$(cat "$STATE_FILE")
          else
            CURRENT="4k"
          fi

          if [[ "$CURRENT" == "4k" ]]; then
            hyprctl eval 'hl.monitor({ output = "DP-1", mode = "1920x1080@320.0", position = "960x1440",  scale = 1.0, bitdepth = 10 })'
            hyprctl eval 'hl.monitor({ output = "DP-2", mode = "3440x1440@165.0", position = "200x0",   scale = 1.0, })'
            echo "1080p" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 1080p @ 320hz"
          else
            hyprctl eval 'hl.monitor({ output = "DP-1", mode = "3840x2160@160.0", position = "0x1440",  scale = 1.0, bitdepth = 10 })'
            hyprctl eval 'hl.monitor({ output = "DP-2", mode = "3440x1440@165.0", position = "200x0",   scale = 1.0, })'
            echo "4k" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 4K @ 160hz"
          fi
        '';
      };

      jellyfin-add-to-playlist = pkgs.writeShellApplication {
        name = "jellyfin-add-to-playlist";
        runtimeInputs = with pkgs; [
          curl
          libnotify
          playerctl
          (python3.withPackages (ps: [ ps.pyyaml ]))
        ];
        text = ''
                    # Adds the currently playing jellyfin-tui track to a named Jellyfin playlist.
                    # Usage: jellyfin-add-to-playlist [playlist-name]   (default: "nu")

                    PLAYLIST_NAME="''${1:-nu}"

                    CONFIG_FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/jellyfin-tui/config.yaml"

                    if [[ ! -f "$CONFIG_FILE" ]]; then
                      notify-send -u critical "jellyfin-playlist" "Config not found: $CONFIG_FILE"
                      exit 1
                    fi

                    # Parse the first server entry from config.yaml using python3 + PyYAML.
                    # Fields: url, username, password
                    read -r SERVER_URL USERNAME PASSWORD < <(python3 -c "
          import sys, yaml
          cfg = yaml.safe_load(open(sys.argv[1]))
          s = cfg[\"servers\"][0]
          print(s[\"url\"], s[\"username\"], s[\"password\"])
          " "$CONFIG_FILE")

                    SERVER_URL="''${SERVER_URL%/}"

                    if [[ -z "$SERVER_URL" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
                      notify-send -u critical "jellyfin-playlist" "Could not parse server config from $CONFIG_FILE"
                      exit 1
                    fi

                    # ── Auth ──────────────────────────────────────────────────────────────
                    AUTH_HEADER='MediaBrowser Client="jellyfin-add-to-playlist", Device="hyprland-keybind", DeviceId="jellyfin-add-to-playlist-1", Version="1.0"'

                    auth_response=$(curl -sf \
                      -X POST \
                      -H "Content-Type: application/json" \
                      -H "Authorization: ''${AUTH_HEADER}" \
                      -d "{\"Username\":\"''${USERNAME}\",\"Pw\":\"''${PASSWORD}\"}" \
                      "''${SERVER_URL}/Users/AuthenticateByName")

                    TOKEN=$(echo "$auth_response"  | grep -o '"AccessToken":"[^"]*"' | cut -d'"' -f4)
                    USER_ID=$(echo "$auth_response" | grep -o '"Id":"[^"]*"'    | head -1 | cut -d'"' -f4)

                    if [[ -z "$TOKEN" || -z "$USER_ID" ]]; then
                      notify-send -u critical "jellyfin-playlist" "Authentication failed — check credentials in config.toml."
                      exit 1
                    fi

                    AUTH_FULL="MediaBrowser Client=\"jellyfin-add-to-playlist\", Device=\"hyprland-keybind\", DeviceId=\"jellyfin-add-to-playlist-1\", Version=\"1.0\", Token=\"''${TOKEN}\""

                    # ── Current track via MPRIS ───────────────────────────────────────────
                    if ! playerctl --player=jellyfin-tui status &>/dev/null; then
                      notify-send -u normal "jellyfin-playlist" "jellyfin-tui is not running or nothing is playing."
                      exit 0
                    fi

                    TRACK_TITLE=$(playerctl --player=jellyfin-tui metadata title 2>/dev/null || true)

                    if [[ -z "$TRACK_TITLE" ]]; then
                      notify-send -u critical "jellyfin-playlist" "Could not get track title from MPRIS."
                      exit 1
                    fi

                    # jellyfin-tui sets trackid to '/' so we always search by title+artist.
                    # Use env vars to pass title/artist to avoid shell quoting issues with apostrophes.
                    ENCODED_QUERY=$(JFTITLE="$TRACK_TITLE" python3 -c "
          import urllib.parse, os
          print(urllib.parse.quote(os.environ[\"JFTITLE\"]))
          ")
                    search_response=$(curl -sf \
                      -H "Authorization: ''${AUTH_FULL}" \
                      "''${SERVER_URL}/Users/''${USER_ID}/Items?searchTerm=''${ENCODED_QUERY}&IncludeItemTypes=Audio&Recursive=true&Limit=5")

                    # Pick the result whose artist matches (case-insensitive) to avoid wrong hits
                    ITEM_ID=$(echo "$search_response" | JFTITLE="$TRACK_TITLE" python3 -c "
          import sys, json, os
          data = json.load(sys.stdin)
          title = os.environ[\"JFTITLE\"].lower()
          for item in data.get(\"Items\", []):
              if item.get(\"Name\", \"\").lower() == title:
                  print(item[\"Id\"])
                  break
          " 2>/dev/null || true)

                    if [[ -z "$ITEM_ID" ]]; then
                      notify-send -u critical "jellyfin-playlist" "Could not find in Jellyfin: $TRACK_TITLE"
                      exit 1
                    fi

                    # ── Find playlist ─────────────────────────────────────────────────────
                    playlists_response=$(curl -sf \
                      -H "Authorization: ''${AUTH_FULL}" \
                      "''${SERVER_URL}/Users/''${USER_ID}/Items?IncludeItemTypes=Playlist&Recursive=true&Fields=Id,Name")

                    PLAYLIST_ID=$(echo "$playlists_response" | JFPLAYLIST="$PLAYLIST_NAME" python3 -c "
          import sys, json, os
          data = json.load(sys.stdin)
          name = os.environ[\"JFPLAYLIST\"].lower()
          for item in data.get(\"Items\", []):
              if item.get(\"Name\", \"\").lower() == name:
                  print(item[\"Id\"])
                  break
          ")

                    if [[ -z "$PLAYLIST_ID" ]]; then
                      notify-send -u critical "jellyfin-playlist" "Playlist $PLAYLIST_NAME not found on Jellyfin server."
                      exit 1
                    fi

                    # ── Add to playlist ───────────────────────────────────────────────────
                    http_status=$(curl -sf -o /dev/null -w "%{http_code}" \
                      -X POST \
                      -H "Authorization: ''${AUTH_FULL}" \
                      "''${SERVER_URL}/Playlists/''${PLAYLIST_ID}/Items?ids=''${ITEM_ID}&userId=''${USER_ID}")

                    if [[ "$http_status" == "204" || "$http_status" == "200" ]]; then
                      notify-send -u low "jellyfin-playlist" "Added to $PLAYLIST_NAME" "''${TRACK_TITLE}"
                    else
                      notify-send -u critical "jellyfin-playlist" "Failed to add track (HTTP ''${http_status})" "''${TRACK_TITLE} → $PLAYLIST_NAME"
                      exit 1
                    fi
        '';
      };
    in
    {
      home = {
        packages = [
          screenshot
          toggle-monitor-mode
          jellyfin-add-to-playlist
        ];
      };

      gtk.iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders;
      };
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
            lock_cmd = "pidof noctalia || noctalia msg session lock";
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

      stylix.targets.hyprland.enable = false;
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        settings = { };
        systemd.enable = true;

        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      xdg.configFile."hypr/hyprland.lua".text = ''
        -- ==================
        -- MONITORS
        -- ==================
        hl.monitor({ output = "DP-1", mode = "3840x2160@160.0",  position = "0x1440",   scale = 1.0, bitdepth = 10 })
        hl.monitor({ output = "DP-2", mode = "3440x1440@165.0", position = "200x0", scale = 1.0 })
        hl.monitor({ output = "LVDS-1", mode = "1920x1080@60.0",  position = "0x0",   scale = 1.0 })
        hl.monitor({ output = "",     mode = "preferred",        position = "auto",     scale = "auto" })

        for i = 1, 8 do
          hl.workspace_rule({
            workspace = tostring(i),
            monitor   = "DP-1",
            layout    = "dwindle",
            persistent = true,
            default   = (i == 1),
          })
        end

        -- Pin workspaces 10–19 to your second monitor
        for i = 9, 9 do
          hl.workspace_rule({
            workspace  = tostring(i),
            monitor    = "DP-2",
            layout     = "master",
            persistent = true,
            default    = (i == 9),
          })
        end

        local ipc = "noctalia msg"

        -- ==================
        -- GENERAL SETTINGS
        -- ==================
        hl.config({
          master = {
            orientation = center,
            slave_count_for_center_master = 0,
            mfact = 0.4,
          },
          general = {
            layout = "dwindle";
            gaps_in   = 10,
            gaps_out  = 15,
            border_size = 3,
            ["col.active_border"]   = "rgb(${config.lib.stylix.colors.base0D})",
            ["col.inactive_border"] = "rgb(${config.lib.stylix.colors.base01})",
          },
          animations = {
            enabled = false,
          },
          decoration = {
            rounding = 3,
            rounding_power = 2,
            blur = {
              enabled = true,
              size = 3,
              passes = 2,
              vibrancy = 0.1696,
            },
            shadow = {
              enabled = true,
              range = 4,
              render_power = 3,
              color   = "rgba(${config.lib.stylix.colors.base00}ff)",
            },
          },
          input = {
            force_no_accel = true,
            accel_profile = "flat",
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
          hl.exec_cmd("noctalia")

          -- Workspace 1: Terminal
          hl.exec_cmd("foot",          { workspace = "1" })

          -- Workspace 2: Browser
          hl.exec_cmd("zen-beta",      { workspace = "2" })

          -- Workspace 3: Gaming
          hl.exec_cmd("prismlauncher", { workspace = "3" })
          hl.exec_cmd("steam",         { workspace = "3" })

          -- Workspace 4: OrcaSlicer
          hl.exec_cmd("orca-slicer",   { workspace = "4" })
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

        hl.window_rule({ match = { class = "^(steam)$" },         workspace = "3" })
        hl.window_rule({ match = { class = "^(org.prismlauncher.PrismLauncher)$" }, workspace = "3" })
        hl.window_rule({ match = { class = "^(OrcaSlicer)$" },    workspace = "4" })

        hl.layer_rule({
          name = "noctalia",
          match = {
            namespace = "^noctalia-(bar-.+|notification|dock|panel)$",
          },
          ignore_alpha = 0.5,
          blur = true,
          blur_popups = true,
        })

        -- ==================
        -- KEYBINDS
        -- ==================
        local mainMod = "SUPER"

        -- Mouse binds
        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Media / volume / brightness (repeat-on-hold)
        hl.bind("XF86AudioRaiseVolume",    hl.dsp.exec_cmd(ipc .. " volume-up"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume",    hl.dsp.exec_cmd(ipc .. " volume-down"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessUp",     hl.dsp.exec_cmd(ipc .. " brightness-up"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown",   hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true, repeating = true })

        -- Media keys (locked / works on lockscreen)
        hl.bind("XF86AudioMute",  hl.dsp.exec_cmd(ipc .. " volume-mute"), { locked = true })
        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(ipc .. " media next"), { locked = true })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(ipc .. " media previous"), { locked = true })
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(ipc .. " media toggle"), { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. " media stop"), { locked = true })

        -- Window management
        hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
        hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
        hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. " + S",           hl.dsp.window.pin())
        hl.bind(mainMod .. " + H",           hl.dsp.window.resize({ x = -100, y = 0, relative=true }))
        hl.bind(mainMod .. " + J",           hl.dsp.focus({ direction = "left" }))
        hl.bind(mainMod .. " + K",           hl.dsp.focus({ direction = "right" }))
        hl.bind(mainMod .. " + L",           hl.dsp.window.resize({ x = 100, y = 0, relative=true }))
        hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
        hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
        hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
        hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
        hl.bind(mainMod .. " + CTRL + J",      hl.dsp.focus({ direction = "down" }))
        hl.bind(mainMod .. " + CTRL + K",      hl.dsp.focus({ direction = "up" }))

        -- App launchers
        hl.bind(mainMod .. " + Return",      hl.dsp.exec_cmd("foot"))
        hl.bind(mainMod .. " + Backspace",   hl.dsp.exec_cmd(ipc .. " session lock"))
        hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd("zen-beta"))
        hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(ipc .. " panel-toggle launcher /emo"))
        hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd("foot -e yazi"))
        hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd(ipc .. " bar-toggle"))
        hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
        hl.bind(mainMod .. " + V",           hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))
        hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("foot -e jellyfin-tui"))

        -- Monitor mode toggle
        hl.bind(mainMod .. " + SHIFT + M",   hl.dsp.exec_cmd("${toggle-monitor-mode}/bin/toggle-monitor-mode"))

        -- Screenshots
        hl.bind("Print",                hl.dsp.exec_cmd("${screenshot}/bin/screenshot area"))
        hl.bind("SUPER + Print",        hl.dsp.exec_cmd("${screenshot}/bin/screenshot display"))
        hl.bind("SHIFT + Print",        hl.dsp.exec_cmd("${screenshot}/bin/screenshot window"))
        hl.bind("CTRL + Print",         hl.dsp.exec_cmd("${screenshot}/bin/screenshot area-s"))
        hl.bind("CTRL + SUPER + Print", hl.dsp.exec_cmd("${screenshot}/bin/screenshot display-s"))
        hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("${screenshot}/bin/screenshot window-s"))

        -- Jellyfin: add current song to playlist "nu"
        hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("${jellyfin-add-to-playlist}/bin/jellyfin-add-to-playlist"))

        -- Workspace switching + moving (split-monitor-workspaces)
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
          hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
        end
      '';
    };
}
