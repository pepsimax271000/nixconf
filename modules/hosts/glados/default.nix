{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.glados = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      flaresolverr
      servicesConfig
      gladosDrives

      base
      git
      shell
      stylix
      gladosConfiguration
      gladosHardware
      gladosDisko
      inputs.disko.nixosModules.disko
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
      services = {
        openssh.enable = true;
      };

      boot.kernelParams = [
        "i915.enable_guc=3"
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
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
