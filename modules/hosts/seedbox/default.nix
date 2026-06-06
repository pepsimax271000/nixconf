{ self, inputs, ... }:
{
  flake.nixosConfigurations.seedbox = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      autobrr
      qbittorrent
      shareUser

      profileServer
      stylix
      seedboxConfiguration
      seedboxHardware
      seedboxDisko
      seedboxDrives
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          neovim
          shell
        ];
      }
    ];
  };

  flake.nixosModules.seedboxConfiguration =
    { ... }:
    {
      networking.hostName = "seedbox";
      hardware.graphics.enable = true;
    };
}
