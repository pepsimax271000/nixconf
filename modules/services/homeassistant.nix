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
        allowedUDPPorts = [ 8080 ];
        allowedTCPPorts = [ 8080 ];
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers.homeassistant = {
          volumes = [ "${serviceAlt}:/config" ];
          environment.TZ = "Europe/Belfast";
          image = "ghcr.io/${serviceAlt}/${serviceAlt}:stable";
          extraOptions = [
            "--network=host"
            # "--device=/dev/ttyACM0:/dev/ttyACM0" ### it *needs* the /dev/ttyACM0 device plugged in or else it will fail to start homeassistant
          ];
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:8080"
        '';
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
