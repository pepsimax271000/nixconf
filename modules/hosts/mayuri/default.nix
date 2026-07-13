{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.mayuri = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      gaming
      virtualization
      mayuriConfiguration
      mayuriHardware
      mayuriDisko
      homeManager
      inputs.nix-topology.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          discord
          profileDesktop
          gaming
          obs
        ];
      }
    ];
  };

  flake.nixosModules.mayuriConfiguration =
    { pkgs, ... }:
    {
      topology.self = {
        name = "mayuri";
        hardware.info = "Main Ryzen 5800x Desktop";
      };

      networking.hostName = "mayuri";

      powerManagement.cpuFreqGovernor = "performance";

      boot = {
        kernelParams = [
          "amd_iommu=on"
          "iommu=pt"
          "pcie_aspm=off"
          "mitigations=off"
          "amd_pstate=active"
        ];
        extraModprobeConfig = ''
          options amdgpu ppfeaturemask=0xffffffff
          options amdgpu overdrive=1
        '';
      };

      hardware = {
        cpu.amd.updateMicrocode = true;
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
            mesa-demos

            ffmpeg-full
            libva
            libva-utils
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            libva
          ];
        };
      };
    };
}
