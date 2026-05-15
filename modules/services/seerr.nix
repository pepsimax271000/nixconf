{ ... }:
let
  service = "seerr";
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
          5055
        ];
        allowedTCPPorts = [
          5055
        ];
      };

      services = {
        ${service} = {
          enable = true;
          configDir = "${hl.appdataDir}/${service}";
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:5055"
        '';
      };

      homelab.homepage.cfg.Media = [
        {
          "Seerr" = {
            description = "Easy *arr UI";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
