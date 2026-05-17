{ ... }:
let
  service = "homeassistant";
  serviceAlt = "home-assistant";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [ 8123 ];
        allowedTCPPorts = [ 8123 ];
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.homeassistant = {
          volumes = [ "${serviceAlt}:/config" ];
          environment.TZ = "${config.my.timezone}";
          image = "ghcr.io/${serviceAlt}/${serviceAlt}:stable";
          extraOptions = [
            "--network=host"
            "--device=/dev/ttyUSB0:/dev/ttyUSB0" # ## it *needs* the /dev/ttyACM0 device plugged in or else it will fail to start homeassistant
          ];
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}" = {
          useACMEHost = "${hl.domain}";
          extraConfig = ''
            reverse_proxy "localhost:8123"
          '';
        };
      };

      homelab.homepage.cfg.Cloud = [
        {
          "Home Assistant" = {
            description = "Home Automation";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${serviceAlt}.svg";
          };
        }
      ];
    };
}
