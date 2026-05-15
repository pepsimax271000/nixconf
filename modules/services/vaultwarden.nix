{ ... }:
let
  service = "vaultwarden";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      services = {
        ${service} = {
          enable = true;
          dbBackend = "sqlite";
          config = {
            DOMAIN = "https://${service}.${hl.domain}";
          };
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:8000"
        '';
      };

      homelab.homepage.cfg.Cloud = [
        {
          "Vaultwarden" = {
            description = "Password Manager";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
