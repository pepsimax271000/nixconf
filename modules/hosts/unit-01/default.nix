{ self, inputs, ... }:
{
  flake.nixosConfigurations.unit-01 = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      audio
      base
      desktop
      git
      nfs
      services
      shell
      stylix
      unit-01Configuration
      unit-01Hardware
      unit-01Disko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          browser
          packages
          desktop
          media
          neovim
          noctalia
          shell
        ];
      }
    ];
  };

  flake.nixosModules.unit-01Configuration =
    { config, ... }:
    {
      my.wallpaper = ../../../assets/wallpapers/flowers-21.png;
      networking.hostName = "unit-01";

      boot = {
        kernelModules = [
          "acpi_call"
          "tp_smapi"
        ];
        extraModulePackages = with config.boot.kernelPackages; [
          acpi_call
          tp_smapi
        ];
        kernelParams = [
          "pcie_aspm=off"
          "i915.enable_rc6=1"
          "i915.enable_fbc=1"
        ];
      };

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
        powertop.enable = true;
      };

      services = {
        thermald.enable = true;
        fprintd.enable = true;
        tlp = {
          enable = true;
          settings = {
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 85;
          };
        };
      };

      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
}
