{ ... }:
let
  service = "speedtest-tracker";
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
          80
        ];
        allowedTCPPorts = [
          80
        ];
      };

      services = {
        ${service} = {
          enable = true;
          domain = "${service}.${hl.domain}";
        };
      };
    };
}
