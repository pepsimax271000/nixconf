{ ... }:
let
  service = "slskd";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          5030
          5031
        ];
        allowedTCPPorts = [
          5030
          5031
        ];
      };

      services = {
        ${service} = {
          enable = true;
          domain = "${service}.${hl.domain}";
          user = hl.user;
          group = hl.group;
          settings = {
            shares.directories = [
              "${hl.mediaDir}/Music/share"
            ];
            directories.downloads = "${hl.mediaDir}/Music/downloads";
          };
          nginx.listen = [
            {
              addr = "10.1.10.3";
              port = 4343;
              ssl = true;
            }
            {
              addr = "10.1.10.3";
              port = 1488;
            }
          ];
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:5030"
        '';
      };

      homelab.homepage.cfg.Media = [
        {
          "Slskd" = {
            description = "SoulSeek WebUI";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
