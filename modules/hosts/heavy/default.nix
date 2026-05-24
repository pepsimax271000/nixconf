{ self, inputs, ... }:
{
  flake.nixosConfigurations.heavy = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      profileLaptop
      heavyConfiguration
      heavyHardware
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileDesktop
          #mangowm
        ];
      }
    ];
  };

  flake.nixosModules.heavyConfiguration =
    { ... }:
    {
      my.wallpaper = ../../../assets/wallpapers/cool.jpg;
      networking.hostName = "heavy";

      # Unique to heavy: blacklist dGPU entirely
      boot = {
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

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
    };
}
