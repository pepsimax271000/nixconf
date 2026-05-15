{ config, ... }:
let
  service = "prowlarr";
  hl = config.homelab;
in
{
  flake.nixosModules.arr =
    { ... }:
    {
      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:9696"
        '';
      };

      homepage.cfg = [
        {
          "Media" = [
            {
              "Prowlarr" = {
                description = "Torrent Site Indexer";
                href = "https://${service}.${hl.domain}";
                icon = "sh-${service}.svg";
              };
            }
          ];
        }
      ];

      networking.firewall = {
        allowedUDPPorts = [
          9696
        ];
        allowedTCPPorts = [
          9696
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
