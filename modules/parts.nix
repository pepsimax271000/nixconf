{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
    inputs.nix-topology.flakeModule
  ];
  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
