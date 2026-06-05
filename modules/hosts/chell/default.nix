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
      caddy
      glance
      homeassistant
      homepage
      unbound
      unifi
      uptime-kuma
      vaultwarden

      homepageServices
      caddyVhosts
      shareUser

      profileServer
      nfs
      stylix
      chellConfiguration
      chellHardware
      chellDisko
      homeManager

      inputs.nix-topology.nixosModules.default
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
      topology.self = {
        name = "Chell";
        hardware.info = "Mini secondary network and essential server";
      };

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
