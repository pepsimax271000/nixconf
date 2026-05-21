{ ... }:
let
  service = "immich";
in
{
  flake.nixosModules.${service} =
    { config, pkgs, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [ 2283 ];
        allowedTCPPorts = [ 2283 ];
      };

      systemd.tmpfiles.rules = [ "d ${hl.mediaDir}/${service} 0775 immich ${hl.group} - -" ];
      users.users."${service}".extraGroups = [
        "video"
        "render"
      ];

      services = {
        ${service} = {
          enable = true;
          group = hl.group;
          host = "0.0.0.0";
          openFirewall = true;
          mediaLocation = "${hl.mediaDir}/${service}/photos";
          accelerationDevices = [
            "/dev/dri/renderD128"
          ];
        };
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
        ];
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}" = {
          useACMEHost = "${hl.domain}";
          extraConfig = ''
            reverse_proxy "localhost:2283"
          '';
        };
      };

      homelab.homepage.cfg.Cloud = [
        {
          "Immich" = {
            description = "Photo Library";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
