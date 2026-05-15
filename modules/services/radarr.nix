{ ... }:
let
  service = "radarr";
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
          7878
        ];
        allowedTCPPorts = [
          7878
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
          reverse_proxy "localhost:7878"
        '';
      };

      homelab.homepage.cfg.Media = [
        {
          "Radarr" = {
            description = "Movie Torrent Indexer";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
