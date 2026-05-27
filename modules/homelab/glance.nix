{ ... }:
let
  service = "glance";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
      port = 8090;
    in
    {
      stylix.targets.glance.enable = false;

      services."${service}" = {
        enable = true;
        openFirewall = true;

        settings = {
          server = {
            host = "0.0.0.0";
            port = port;
          };

          theme = {
            background-color = "240 21 15";
            contrast-multiplier = 1.2;
            primary-color = "217 92 83";
            positive-color = "115 54 76";
            negative-color = "347 70 65";
          };

          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "group";
                      widgets = [
                        {
                          type = "custom-api";
                          title = "Day";
                          body-type = "string";
                          skip-json-validation = true;
                          cache = "1s";
                          template = ''
                            {{ $localTime := now }}
                            {{ $secondsPerDay := 86400 }}
                            {{ $elapsedSeconds := add (mul $localTime.Hour 3600) (mul $localTime.Minute 60) | add $localTime.Second }}
                            {{ $dayProgress := div (mul $elapsedSeconds 100.0) $secondsPerDay }}

                            {{ $gradient := "" }}
                            {{ if lt $dayProgress 10.0 }}
                              {{ $gradient = "#70a1ff" }}
                            {{ else if lt $dayProgress 25.0 }}
                              {{ $gradient = "#ff6b6b, #70a1ff" }}
                            {{ else if lt $dayProgress 50.0 }}
                              {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df" }}
                            {{ else }}
                              {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df, #70a1ff" }}
                            {{ end }}

                            <div style="font-family: sans-serif; text-align: center;">
                              <div style="width: 100%; height: 12px; background: #23262F; border:1px solid gray; border-radius: 10px; overflow: hidden;">
                                <div style="
                                  height: 100%;
                                  width: {{ $dayProgress }}%;
                                  background: linear-gradient(90deg, {{ $gradient }});
                                "></div>
                              </div>
                              <div class="size-h1" style="margin-top: 6px;">{{ printf "%.2f" $dayProgress }}% of the day has passed</div>
                            </div>
                          '';
                        }
                        {
                          type = "custom-api";
                          title = "Month";
                          body-type = "string";
                          skip-json-validation = true;
                          cache = "1s";
                          template = ''
                            {{ $localTime := now }}

                            {{ $month := $localTime.Month }}
                            {{ $dayOfMonth := $localTime.Day }}

                            {{ $secondsToday := add (mul $localTime.Hour 3600) (mul $localTime.Minute 60) | add $localTime.Second }}
                            {{ $fractionOfDay := div $secondsToday 86400.0 }}

                            {{ $daysInMonth := 31 }}
                            {{ if eq $month 2 }} {{ $daysInMonth = 28 }} {{ end }}
                            {{ if or (eq $month 4) (eq $month 6) (eq $month 9) (eq $month 11) }} {{ $daysInMonth = 30 }} {{ end }}

                            {{ $daysElapsed := add (sub $dayOfMonth 1) $fractionOfDay }}
                            {{ $monthProgress := mul (div $daysElapsed $daysInMonth) 100.0 }}

                            {{ $gradient := "" }}
                            {{ if lt $monthProgress 10.0 }}
                              {{ $gradient = "#70a1ff" }}
                            {{ else if lt $monthProgress 25.0 }}
                              {{ $gradient = "#ff6b6b, #70a1ff" }}
                            {{ else if lt $monthProgress 50.0 }}
                              {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df" }}
                            {{ else }}
                              {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df, #70a1ff" }}
                            {{ end }}

                            <div style="font-family: sans-serif; text-align: center;">
                              <div style="width: 100%; height: 12px; background: #23262F; border:1px solid gray; border-radius: 10px; overflow: hidden;">
                                <div style="
                                  height: 100%;
                                  width: {{ $monthProgress }}%;
                                  background: linear-gradient(90deg, {{ $gradient }});
                                "></div>
                              </div>
                              <div class="size-h1" style="margin-top: 6px;">{{ printf "%.2f" $monthProgress }}% of the month has passed</div>
                            </div>
                          '';
                        }
                        {
                          type = "custom-api";
                          title = "Year";
                          body-type = "string";
                          skip-json-validation = true;
                          cache = "1s";
                          template = ''
                            {{ $localTime := now }}

                            {{ $secondsToday := add (mul $localTime.Hour 3600) (mul $localTime.Minute 60) | add $localTime.Second }}
                            {{ $dayOfYear := $localTime.YearDay }}
                            {{ $secondsElapsed := add (mul (sub $dayOfYear 1) 86400) $secondsToday }}

                            {{ $totalSecondsInYear := mul 365 86400 }}
                            {{ $yearProgress := div (mul $secondsElapsed 100.0) $totalSecondsInYear }}

                            {{ $gradient := "" }}
                            {{ if lt $yearProgress 10.0 }}
                              {{ $gradient = "#70a1ff" }}
                            {{ else if lt $yearProgress 25.0 }}
                              {{ $gradient = "#ff6b6b, #70a1ff" }}
                            {{ else if lt $yearProgress 50.0 }}
                              {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df" }}
                            {{ else }}
                              {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df, #70a1ff" }}
                            {{ end }}

                            <div style="font-family: sans-serif; text-align: center;">
                              <div style="width: 100%; height: 12px; background: #23262F; border:1px solid gray; border-radius: 10px; overflow: hidden;">
                                <div style="
                                  height: 100%;
                                  width: {{ $yearProgress }}%;
                                  background: linear-gradient(90deg, {{ $gradient }});
                                "></div>
                              </div>
                              <div class="size-h1" style="margin-top: 6px;">{{ printf "%.2f" $yearProgress }}% of the year has passed</div>
                            </div>
                          '';
                        }
                      ];
                    }
                    {
                      type = "clock";
                      hour-format = "24h";
                      timezones = [
                        {
                          timezone = "Europe/Belfast";
                          label = "Home";
                        }
                      ];
                    }
                    {
                      type = "calendar";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "monitor";
                      title = "Media";
                      sites = [
                        {
                          title = "Jellyfin";
                          url = "https://jellyfin.${hl.domain}";
                          icon = "sh:jellyfin";
                        }
                        {
                          title = "Immich";
                          url = "https://immich.${hl.domain}";
                          icon = "sh:immich";
                        }
                        {
                          title = "Seerr";
                          url = "https://seerr.${hl.domain}";
                          icon = "sh:seerr";
                        }
                        {
                          title = "Radarr";
                          url = "https://radarr.${hl.domain}";
                          icon = "sh:radarr";
                        }
                        {
                          title = "Sonarr";
                          url = "https://sonarr.${hl.domain}";
                          icon = "sh:sonarr";
                        }
                        {
                          title = "Prowlarr";
                          url = "https://prowlarr.${hl.domain}";
                          icon = "sh:prowlarr";
                        }
                        {
                          title = "qBittorrent";
                          url = "https://qbittorrent.${hl.domain}";
                          icon = "sh:qbittorrent";
                        }
                        {
                          title = "FlareSolverr";
                          url = "https://flaresolverr.${hl.domain}";
                          icon = "sh:flaresolverr";
                        }
                        {
                          title = "Slskd";
                          url = "https://slskd.${hl.domain}";
                          icon = "sh:slskd";
                        }
                      ];
                    }
                    {
                      type = "monitor";
                      title = "Cloud";
                      sites = [
                        {
                          title = "Home Assistant";
                          url = "https://homeassistant.${hl.domain}";
                          icon = "sh:home-assistant";
                        }
                        {
                          title = "Zigbee2MQTT";
                          url = "https://zigbee2mqtt.${hl.domain}";
                          icon = "sh:zigbee";
                        }
                        {
                          title = "Vaultwarden";
                          url = "https://vaultwarden.${hl.domain}";
                          icon = "sh:vaultwarden";
                        }
                        {
                          title = "Homepage";
                          url = "https://homepage.${hl.domain}";
                          icon = "sh:homepage";
                        }
                        {
                          title = "Uptime Kuma";
                          url = "https://uptime-kuma.${hl.domain}";
                          icon = "sh:uptime-kuma";
                        }
                      ];
                    }
                    {
                      type = "monitor";
                      title = "Network";
                      sites = [
                        {
                          title = "AdGuard Home";
                          url = "https://adguardhome.${hl.domain}";
                          icon = "sh:adguard-home";
                        }
                        {
                          title = "UniFi";
                          url = "https://unifi.${hl.domain}";
                          icon = "sh:ubiquiti-unifi";
                        }
                        {
                          title = "OPNSense";
                          url = "https://opnsense.${hl.domain}";
                          icon = "sh:opnsense";
                        }
                        {
                          title = "Proxmox";
                          url = "https://proxmox.${hl.domain}";
                          icon = "sh:proxmox";
                        }
                        {
                          title = "Proxmox 2";
                          url = "https://proxmox2.${hl.domain}";
                          icon = "sh:proxmox";

                        }
                      ];
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "server-stats";
                      servers = [
                        {
                          type = "local";
                          name = "chell";
                          mountpoints = {
                            "/" = {
                              name = "Root";
                            };
                          };
                        }
                      ];
                    }
                    {
                      type = "releases";
                      show-source-icon = true;
                      repositories = [
                        "nixos/nixpkgs"
                        "jellyfin/jellyfin"
                        "immich-app/immich"
                        "slskd/slskd"
                        "home-assistant/core"
                        "glanceapp/glance"
                      ];
                    }
                    {
                      type = "custom-api";
                      title = "Immich Stats";
                      cache = "1d";
                      url = "https://immich.${hl.domain}";
                      headers = {
                        x-api-key = "placeholder";
                        Accept = "application/json";
                      };
                      template = ''
                        <div class="flex justify-between text-center">
                          <div>
                              <div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
                              <div class="size-h6">PHOTOS</div>
                          </div>
                          <div>
                              <div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
                              <div class="size-h6">VIDEOS</div>
                          </div>
                          <div>
                              <div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
                              <div class="size-h6">USAGE</div>
                          </div>
                        </div>
                      '';
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

      services.caddy.virtualHosts = {
        "${service}.${hl.domain}" = {
          useACMEHost = "${hl.domain}";
          extraConfig = ''
            reverse_proxy "localhost:${toString port}"
          '';
        };
      };

      homelab.homepage.cfg.Network = [
        {
          "Glance" = {
            description = "Homepage alternative 🤷🤷‍♂️";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}
