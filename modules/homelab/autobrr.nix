{ ... }:
let
  service = "autobrr";
  port = 7474;
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
          port
        ];
        allowedTCPPorts = [
          port
        ];
      };

      services = {
        ${service} = {
          enable = true;
          secretFile = config.sops.secrets.autobrr.path;
          settings = {
            host = "0.0.0.0";
          };
        };
      };
    };
}
