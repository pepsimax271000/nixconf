{ inputs, self, ... }:
{
  perSystem =
    { ... }:
    {
      topology.nixosConfigurations = {
        inherit (self.nixosConfigurations) chell glados atlas;
      };

      topology.modules = [
        (
          { config, ... }:
          let
            inherit (config.lib.topology)
              mkInternet
              mkRouter
              mkSwitch
              mkConnection
              ;
          in
          {
            networks.lan = {
              name = "LAN";
              cidrv4 = "10.1.10.0/24";
            };

            nodes.internet = mkInternet {
              connections = [ (mkConnection "router" "wan") ];
            };

            nodes.router = mkRouter "ThinkCentre M720q" {
              info = "OPNsense";
              interfaces.wan.addresses = [ "dhcp" ];
              interfaces.lan = {
                network = "lan";
                addresses = [ "10.1.10.1/24" ];
              };
              connections.lan = mkConnection "netgear" "uplink";
            };

            nodes.netgear = mkSwitch "Netgear GS108" {
              interfaces.uplink = { };
              interfaces.eth1 = { };
              interfaces.eth2 = { };
              interfaces.eth3 = { };
              connections.eth1 = mkConnection "chell" "eno1";
              connections.eth2 = mkConnection "ubiquiti" "uplink";
              connections.eth3 = mkConnection "u7-lr" "eth0";
            };

            nodes.u7-lr = {
              name = "Ubiquiti U7 LR";
              deviceType = "device";
              interfaces.eth0.network = "lan";
            };

            nodes.ubiquiti = mkSwitch "Ubiquiti USW-Flex-2.5G" {
              interfaces.uplink = { };
              interfaces.eth1 = { };
              interfaces.eth2 = { };
              interfaces.eth3 = { };
              interfaces.eth4 = { };
              connections.eth1 = mkConnection "atlas" "enp3s0";
              connections.eth2 = mkConnection "glados" "enp4s0";
              connections.eth3 = mkConnection "hp-z620" "eth0";
              connections.eth4 = mkConnection "capture-pc" "eth0";
            };

            nodes.chell = {
              interfaces.eno1.network = "lan";
              services.caddy.hidden = true;
            };

            nodes.glados = {
              interfaces.enp4s0.network = "lan";
              services.caddy.hidden = true;
            };

            nodes.atlas.interfaces.enp3s0.network = "lan";

            nodes.hp-z620 = {
              name = "HP Z620";
              deviceType = "device";
              hardware.info = "Windows 7 / XP";
              interfaces.eth0.network = "lan";
            };

            nodes.capture-pc = {
              name = "Capture PC";
              deviceType = "device";
              interfaces.eth0.network = "lan";
            };
          }
        )
      ];
    };
}
