{ ... }:
let
  service = "jellyfin";
in
{
  flake.nixosModules.${service} =
    { config, pkgs, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [ 8096 ];
        allowedTCPPorts = [ 8096 ];
      };

      services = {
        ${service} = {
          enable = true;
          configDir = "${hl.appdataDir}/${service}/config";
          dataDir = "${hl.appdataDir}/${service}";
          cacheDir = "${hl.appdataDir}/${service}/config/cache";
          logDir = "${hl.appdataDir}/${service}/config/log";
          user = hl.user;
          group = hl.group;
        };
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          libva-vdpau-driver
          intel-compute-runtime
          vpl-gpu-rt
          intel-ocl
        ];
      };

      systemd = {
        services.${service}.environment.LIBVA_DRIVER_NAME = "iHD";
        tmpfiles.rules = [
          "d ${hl.appdataDir}/${service} 0775 ${hl.user} ${hl.group} -"
          "d ${hl.mediaDir}/movies 0775 ${hl.user} ${hl.group} -"
          "d ${hl.mediaDir}/shows 0775 ${hl.user} ${hl.group} -"
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };

      nixpkgs.overlays = with pkgs; [
        (final: prev: {
          jellyfin-web = prev.jellyfin-web.overrideAttrs (
            finalAttrs: previousAttrs: {
              installPhase = ''
                	  runHook preInstall

                	  sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

                	  mkdir -p $out/share
                	  cp -a dist $out/share/jellyfin-web

                	  runHook postInstall
                	'';
            }
          );
        })
      ];

      homelab.caddy.virtualHosts = {
        useACMEHost = "${hl.domain}";
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "${hl.gladosIP}:8096"
        '';
      };

      homelab.homepage.cfg.Media = [
        {
          "Jellyfin" = {
            description = "Media Player";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
