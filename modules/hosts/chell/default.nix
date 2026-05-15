{
  lib,
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.chell = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      adguardhome
      unbound
      homeassistant
      homepage
      unifi
      vaultwarden
      servicesConfig

      base
      git
      nfs
      shell
      stylix
      chellConfiguration
      chellHardware
      chellDisko
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

  flake.nixosModules.chellConfiguration =
    { pkgs, ... }:
    {
      networking.hostName = "chell";
      services = {
        openssh.enable = true;
        resolved.settings.Resolve = lib.mkForce {
          DNSStubListener = false;
        };
      };

      boot.kernelParams = [
        "i915.enable_rc6=1"
        "i915.enable_fbc=1"
        "mitigations=off"
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
      };

      hardware = {
        cpu.intel.updateMicrocode = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-vaapi-driver
            libvdpau-va-gl
            intel-media-driver
          ];
          enable32Bit = true;
        };
        enableAllFirmware = true;
      };
    };
}
