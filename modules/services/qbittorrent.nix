{ ... }:
{
  flake.nixosModules.qbittorrent =
    { config, pkgs, ... }:
    {
      services.caddy.virtualHosts."qbittorrent.${config.homelab.domain}".extraConfig = ''
        reverse_proxy "localhost:8080"
      '';

      networking.firewall = {
        allowedUDPPorts = [ 8080 ];
        allowedTCPPorts = [ 8080 ];
      };
      services = {
        qbittorrent = {
          enable = true;
          profileDir = "${config.homelab.appdataDir}/qbittorrent";
          serverConfig = {
            LegalNotice.Accepted = true;
            Preferences = {
              General.Locale = "en";
              User = config.homelab.user;
              Group = config.homelab.group;
              Downloads = {
                SavePath = "${config.homelab.mediaDir}/torrents";
              };
              WebUI = {
                Username = "adam";
                Password_PBKDF2 = "${config.sops.secrets.qbittorrent_password.path}";
                ServerDomains = "${config.homelab.domain}";
              };
            };
          };
        };
      };
    };
}
