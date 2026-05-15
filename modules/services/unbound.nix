{ ... }:
{
  flake.nixosModules.unbound =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          5335
        ];
        allowedTCPPorts = [
          5335
        ];
      };

      services = {
        unbound = {
          enable = true;
          settings = {
            server = {
              interface = [
                "127.0.0.1"
                "::1"
              ];
              port = 5335;
              access-control = [
                "127.0.0.0/8 allow"
                "::1/128 allow"
              ];
              local-zone = "\"${hl.domain}.\" static";

              do-ip4 = true;
              do-ip6 = false;
              prefetch = true;
              num-threads = 2;
            };
            forward-zone = [
              {
                name = ".";
                forward-addr = [
                  "1.1.1.1@853#cloudflare-dns.com"
                  "1.0.0.1@853#cloudflare-dns.com"
                ];
                forward-tls-upstream = true;
              }
            ];
          };
        };
      };
    };
}
