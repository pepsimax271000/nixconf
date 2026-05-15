{ ... }:
{
  flake.nixosModules.arr =
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
        flaresolverr = {
          enable = true;
        };
      };
    };
}
