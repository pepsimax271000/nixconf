{ inputs, ... }:
{
  flake.nixosModules.desktop =
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
    { ... }:
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
            "SUPER,Q,killclient"
            "SUPER,F,togglefullscreen"
            "SUPER,H,resizewin,-100,0"
            "SUPER,J,focusdir,left"
            "SUPER,K,focusdir,right"
            "SUPER,L,resizewin,+100,0"

            "SUPER,W,spawn,zen-beta"
            "SUPER,R,reload_config"
            "SUPER,D,spawn,noctalia msg panel-toggle launcher"
            "SUPER,Return,spawn,foot"
          ];
        };
      };
    };
}
