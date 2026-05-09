{ ... }:
{
  flake.nixosModules.jellyfin =
    { config, pkgs, ... }:
    {
      services.caddy.virtualHosts."jellyfin.${config.homelab.domain}".extraConfig = ''
        reverse_proxy "localhost:8096"
      '';

      networking.firewall = {
        allowedUDPPorts = [ 8096 ];
        allowedTCPPorts = [ 8096 ];
      };
      services = {
        jellyfin = {
          enable = true;
          configDir = "${config.homelab.appdataDir}/jellyfin/config";
          dataDir = "${config.homelab.appdataDir}/jellyfin";
          cacheDir = "${config.homelab.appdataDir}/jellyfin/config/cache";
          logDir = "${config.homelab.appdataDir}/jellyfin/config/log";
          user = config.homelab.user;
          group = config.homelab.group;
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
        services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
        tmpfiles.rules = [
          "d ${config.homelab.appdataDir}/jellyfin 0775 ${config.homelab.user} ${config.homelab.group} -"
          "d ${config.homelab.mediaDir}/movies 0775 ${config.homelab.user} ${config.homelab.group} -"
          "d ${config.homelab.mediaDir}/shows 0775 ${config.homelab.user} ${config.homelab.group} -"
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
    };
}
