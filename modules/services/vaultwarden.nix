{ config, ... }:
let
  service = "vaultwarden";
  hl = config.homelab;
in
{
  flake.nixosModules.${service} =
    { ... }:
    {
      services.caddy.virtualHosts."${service}.${hl.domain}".extraConfig = ''
        reverse_proxy "localhost:8000"
      '';

      homepage.cfg = [
        {
          "Cloud" = [
            {
              "Vaultwarden" = {
                description = "Password Manager";
                href = "https://${service}.${hl.domain}";
                icon = "sh-${service}.svg";
              };
            }
          ];
        }
      ];

      services = {
        ${service} = {
          enable = true;
          dbBackend = "sqlite";
          config = {
            DOMAIN = "https://${service}.${hl.domain}";
          };
        };
      };
    };
}
