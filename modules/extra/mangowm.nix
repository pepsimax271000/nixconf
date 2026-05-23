{ inputs, ... }:
{
  flake.nixosModules.mangowm =
    { ... }:
    {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];
      programs.mango = {
        enable = true;
      };
    };

  flake.homeModules.mangowm =
    { pkgs, ... }:
    let
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          grim
          slurp
          satty
          wl-clipboard
          jq
        ];
        text = ''
          NAS=/media/NAS/storage/Pictures/Screenshots/$(date +%Y)/$(date +%m)
          mkdir -p "$NAS" 2>/dev/null && DIR=$NAS || DIR=$HOME/Pictures/Screenshots
          FILE="$DIR/$(date +%Y%m%d_%H%M%S).png"

          case "$1" in
            area)       grim -g "$(slurp)" - | tee "$FILE" | wl-copy ;;
            display)    grim -g "$(hyprctl monitors -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | tee "$FILE" | wl-copy ;;
            window)     grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | tee "$FILE" | wl-copy ;;
            area-s)     grim -g "$(slurp)" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy ;;
            display-s)  grim -g "$(hyprctl monitors -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy ;;
            window-s)   grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy ;;
          esac
        '';
      };
    in
    {
      imports = [
        inputs.mangowm.hmModules.mango
      ];
      wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;
        autostart_sh = ''
          noctalia &
        '';
        settings = {
          mouse_accel_profile = "flat";
          repeat_rate = 50;
          repeat_delay = 300;
          blur = 1;
          blur_optimized = 1;
          border_radius = 3;
          blur_params = {
            radius = 5;
            num_passes = 2;
          };

          bind = [
            "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
            "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
            "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
            "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
            "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"

            "NONE,XF86AudioNext,spawn,noctalia msg media next"
            "NONE,XF86AudioPrev,spawn,noctalia msg media previous"
            "NONE,XF86AudioPlay,spawn,noctalia msg media toggle"
            "NONE,XF86AudioPause,spawn,noctalia msg media stop"

            "SUPER,1,view,1"
            "SUPER,2,view,2"
            "SUPER,3,view,3"
            "SUPER,4,view,4"
            "SUPER,5,view,5"
            "SUPER,6,view,6"
            "SUPER,7,view,7"
            "SUPER,8,view,8"
            "SUPER,9,view,9"

            "SUPER+SHIFT,1,tag,1"
            "SUPER+SHIFT,2,tag,2"
            "SUPER+SHIFT,3,tag,3"
            "SUPER+SHIFT,4,tag,4"
            "SUPER+SHIFT,5,tag,5"
            "SUPER+SHIFT,6,tag,6"
            "SUPER+SHIFT,7,tag,7"
            "SUPER+SHIFT,8,tag,8"
            "SUPER+SHIFT,9,tag,9"

            "SUPER,Q,killclient"
            "SUPER,F,togglefullscreen"
            "SUPER,S,toggleglobal"

            "SUPER,H,resizewin,-100,0"
            "SUPER,J,focusdir,left"
            "SUPER,K,focusdir,right"
            "SUPER,L,resizewin,+100,0"

            "SUPER+SHIFT,H,exchance_client,left"
            "SUPER+SHIFT,J,exchance_client,down"
            "SUPER+SHIFT,K,exchance_client,up"
            "SUPER+SHIFT,L,exchance_client,right"

            "SUPER+CTRL,J,focusdir,down"
            "SUPER+CTRL,k,focusdir,up"

            "SUPER+SHIFT,SPACE,togglefloating"

            "SUPER,W,spawn,zen-beta"
            "SUPER,E,spawn,noctalia msg panel-toggle launcher /emo"
            "SUPER,R,reload_config"
            "SUPER,A,spawn,noctalia msg bar-toggle"
            "SUPER,D,spawn,noctalia msg panel-toggle launcher"
            "SUPER,V,spawn,noctalia msg panel-toggle clipboard"
            "SUPER,M,spawn,foot -e jellyfin-tui"
            "SUPER,Return,spawn,foot"

            "NONE,Print,spawn,${screenshot}/bin/screenshot area"
            "SUPER+Print,spawn,${screenshot}/bin/screenshot window"
            "NONE+SHIFT+Print,spawn,${screenshot}/bin/screenshot display"
            "CTRL+NONE,Print,spawn,${screenshot}/bin/screenshot area-s"
            "CTRL+SUPER+Print,spawn,${screenshot}/bin/screenshot window-s"
            "CTRL+NONE+SHIFT+Print,spawn,${screenshot}/bin/screenshot display-s"
          ];
        };
      };
    };
}
