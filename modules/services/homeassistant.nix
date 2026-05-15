{ config, ... }:
let
  service = "homeassistant";
  hl = config.homelab;
in
{
  flake.nixosModules.${service} =
    { ... }:
    {
      services.caddy.virtualHosts."${service}.${hl.domain}".extraConfig = ''
        reverse_proxy "localhost:8080"
      '';

      homepage.cfg = [
        {
          "Cloud" = [
            {
              "Home Assistant" = {
                description = "Home Automation";
                href = "https://${service}.${hl.domain}";
                icon = "sh-${service}.svg";
              };
            }
          ];
        }
      ];

      networking.firewall = {
        allowedUDPPorts = [ 8080 ];
        allowedTCPPorts = [ 8080 ];
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.homeassistant = {
          volumes = [ "home-assistant:/config" ];
          environment.TZ = "Europe/Belfast";
          image = "ghcr.io/home-assistant/home-assistant:stable";
          extraOptions = [
            "--network=host"
            # "--device=/dev/ttyACM0:/dev/ttyACM0" ### it *needs* the /dev/ttyACM0 device plugged in or else it will fail to start homeassistant
          ];
        };
      };
    };
}
