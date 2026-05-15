{ ... }:
let
  service = "prowlarr";
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
          9696
        ];
        allowedTCPPorts = [
          9696
        ];
      };

      services = {
        ${service} = {
          enable = true;
          user = hl.user;
          group = hl.group;
          dataDir = "${hl.appdataDir}/${service}";
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:9696"
        '';
      };

      homelab.homepage.cfg.Media = [
        {
          "Prowlarr" = {
            description = "Torrent Site Indexer";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
