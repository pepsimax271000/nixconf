{ ... }:
{
  flake.nixosModules.immich =
    { config, pkgs, ... }:
    {
      services.caddy.virtualHosts."immich.${config.homelab.domain}".extraConfig = ''
        reverse_proxy "localhost:2283"
      '';

      networking.firewall = {
        allowedUDPPorts = [ 2283 ];
        allowedTCPPorts = [ 2283 ];
      };
      services = {
        immich = {
          enable = true;
          user = config.homelab.user;
          group = config.homelab.group;
          mediaLocation = "${config.homelab.mediaDir}/immich/photos";
          accelerationDevices = null;
        };
      };
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
        ];
      };
    };
}
