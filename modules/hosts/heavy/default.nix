{ self, inputs, ... }:
{
  flake.nixosConfigurations.heavy = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      audio
      base
      desktop
      git
      nfs
      services
      shell
      stylix
      heavyConfiguration
      heavyHardware
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          browser
          packages
          desktop
          mangowm
          media
          neovim
          noctalia
          shell
        ];
      }
    ];
  };

  flake.nixosModules.heavyConfiguration =
    { config, ... }:
    {
      my.wallpaper = ../../../assets/wallpapers/cool.jpg;
      networking.hostName = "heavy";

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
        extraModprobeConfig = ''
                  blacklist nouveau
          	      options nouveau modeset=0
        '';
        blacklistedKernelModules = [
          "nouveau"
          "nvidia"
          "nvidia_drm"
          "nvidia_modeset"
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

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
    };
}
