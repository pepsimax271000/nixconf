{ ... }:
let
  service = "homeassistant";
  serviceAlt = "home-assistant";
  port = 8123;
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
          port
        ];
        allowedTCPPorts = [
          port
        ];
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
            reverse_proxy "localhost:"${toString port}""
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
