{ self, ... }:
{
  flake.nixosModules.profileServer =
    { ... }:
    {
      imports = with self.nixosModules; [
        base
        shell
        git
        homelabConfig
      ];

      services.openssh.enable = true;
    };
}
