{ ... }:
let
  service = "unifi";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
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

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:8443"
        '';
      };

      homelab.homepage.cfg.Cloud = [
        {
          "Unifi" = {
            description = "Unifi Controller";
            href = "https://${service}.${hl.domain}";
            icon = "sh-ubiquiti-${service}.svg";
          };
        }
      ];
    };
}
