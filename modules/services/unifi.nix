{ config, ... }:
let
  service = "unifi";
  hl = config.homelab;
in
{
  flake.nixosModules.${service} =
    { ... }:
    {
      services.caddy.virtualHosts."${service}.${hl.domain}".extraConfig = ''
        reverse_proxy "localhost:8443"
      '';

      homepage.cfg = [
        {
          "Cloud" = [
            {
              "Unifi" = {
                description = "Ubiuqiti Controller";
                href = "https://${service}.${hl.domain}";
                icon = "sh-${service}.svg";
              };
            }
          ];
        }
      ];

      networking.firewall = {
        allowedUDPPorts = [ 8443 ];
        allowedTCPPorts = [ 8443 ];
      };
      services = {
        ${service} = {
          enable = true;
          openFirewall = true;
        };
      };
    };
}
