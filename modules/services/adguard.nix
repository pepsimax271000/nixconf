{ ... }:
let
  service = "adguardhome";
  serviceAlt = "adguard-home";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          53
        ];
        allowedTCPPorts = [
          53
        ];
      };

      services = {
        ${service} = {
          enable = true;
          openFirewall = true;
          port = 3000;
          settings = {
            dns = {
              bind_hosts = [ "0.0.0.0" ];
              port = 53;
              upstream_dns = [
                "127.0.0.1:5335"
              ];
              bootstrap_dns = [
                "1.1.1.1"
                "8.8.8.8"
              ];
              private_reverse_dns_upstream = [
                "127.0.0.1:5335"
              ];
              upstream_mode = "parallel";
              local_domain_name = "${hl.domain}";
              cache_enabled = true;
              cache_ttl_min = 3600;
              cache_ttl_max = 86400;
              enable_dnssec = true;
              ratelimit = 0;
            };

            filters = [
              {
                enabled = true;
                url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
                name = "AdGuard DNS filter";
                id = 1;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
                name = "AdAway Default Blocklist";
                id = 2;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_64.txt";
                name = "1Hosts (Pro)";
                id = 3;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt";
                name = "AdGuard DNS Popup Hosts filter";
                id = 4;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt";
                name = "AWAvenue ads rule";
                id = 5;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt";
                name = "Dan Pollock's List";
                id = 6;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt";
                name = "HaGeZi's Pro++ Blocklist";
                id = 7;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
                name = "Steven Black's list";
                id = 8;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt";
                name = "OISD Blocklist Big";
                id = 9;
              }
              {
                enabled = true;
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
                name = "Peter Lowe's Blocklist";
                id = 10;
              }
            ];
          };
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}".extraConfig = ''
          reverse_proxy "localhost:3000"
        '';
      };

      homelab.homepage.cfg.Cloud = [
        {
          "AdGuard Home" = {
            description = "DNS Ad Blocker";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${serviceAlt}.svg";
          };
        }
      ];
    };
}
