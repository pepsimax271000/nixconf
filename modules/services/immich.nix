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

      services = {
        ${service} = {
          enable = true;
          user = hl.user;
          group = hl.group;
          mediaLocation = "${hl.mediaDir}/${service}/photos";
          accelerationDevices = null;
        };
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
        ];
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:2283"
        '';
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
