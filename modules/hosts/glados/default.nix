{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.glados = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      flaresolverr
      immich
      jellyfin
      prowlarr
      qbittorrent
      radarr
      seerr
      share
      slskd
      sonarr
      syncthing

      gladosDrives
      shareUser

      profileServer
      stylix
      gladosConfiguration
      gladosHardware
      gladosDisko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          neovim
          shell
        ];
      }
    ];
  };

  flake.nixosModules.gladosConfiguration =
    { pkgs, ... }:
    {
      networking.hostName = "glados";

      environment.systemPackages = with pkgs; [
        hddtemp
        hdparm
        intel-gpu-tools
        powertop
        smartmontools
      ];

      services = {
        openssh.enable = true;
      };

      #boot.kernelParams = [
      #  "i915.enable_guc=2"
      #];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "schedutil";
      };

      hardware.enableRedistributableFirmware = true;

      hardware = {
        cpu.intel.updateMicrocode = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            vpl-gpu-rt
            intel-compute-runtime
          ];
          enable32Bit = true;
        };
        enableAllFirmware = true;
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
}
