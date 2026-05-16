{ ... }:
let
  service = "flaresolverr";
in
{
  flake.nixosModules.${service} =
    { ... }:
    {
      networking.firewall = {
        allowedUDPPorts = [
          8191
        ];
        allowedTCPPorts = [
          8191
        ];
      };
      services = {
        ${service} = {
          enable = true;
        };
      };
    };
}
