{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.atlas = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      audio
      base
      desktop
      gaming
      git
      nfs
      services
      shell
      stylix
      virtualization
      atlasConfiguration
      atlasHardware
      atlasDisko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          browser
          desktop
          gaming
          media
          neovim
          noctalia
          obs
          packages
          shell
        ];
      }
    ];
  };

  flake.nixosModules.atlasConfiguration =
    { pkgs, ... }:
    {
      my.wallpaper = ../../../assets/wallpapers/nerv_catppuccin_uw.png;
      networking.hostName = "atlas";

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

            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
            gst_all_1.gst-vaapi

            ffmpeg-full
            libva
            libva-utils
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
            libva
          ];
        };
      };
    };
}
