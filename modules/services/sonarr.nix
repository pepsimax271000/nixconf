{ config, ... }:
let
  service = "sonarr";
  hl = config.homelab;
in
{
  flake.nixosModules.arr =
    { ... }:
    {
      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:8989"
        '';
      };

      homepage.cfg = [
        {
          "Media" = [
            {
              "Sonarr" = {
                description = "TV Show Torrent Indexer";
                href = "https://${service}.${hl.domain}";
                icon = "sh-${service}.svg";
              };
            }
          ];
        }
      ];

      networking.firewall = {
        allowedUDPPorts = [
          7878
        ];
        allowedTCPPorts = [
          7878
        ];
      };

      services = {
        ${service} = {
          enable = true;
          user = hl.user;
          group = hl.group;
          dataDir = "${hl.appdataDir}/${service}";
        };
      };
    };
}
