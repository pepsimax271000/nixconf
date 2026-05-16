{ ... }:
let
  service = "qbittorrent";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [ 8080 ];
        allowedTCPPorts = [ 8080 ];
      };

      services = {
        ${service} = {
          enable = true;
          user = "${hl.user}";
          group = "${hl.group}";
          profileDir = "${hl.appdataDir}/${service}";
          serverConfig = {
            LegalNotice.Accepted = true;
            Preferences = {
              General.Locale = "en";
              User = hl.user;
              Group = hl.group;
              Downloads = {
                SavePath = "${hl.mediaDir}/torrents";
              };
              WebUI = {
                Username = "adam";
                Password_PBKDF2 = "${config.sops.secrets.qbittorrent_password.path}";
                ServerDomains = "${hl.domain}";
              };
            };
          };
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:8080"
        '';
      };

      homelab.homepage.cfg.Media = [
        {
          "qBittorrent" = {
            description = "Torrent Client";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
