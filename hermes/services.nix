{
  pkgs,
  ...
}:

# ============================================
# [SYSTEMD_SERVICES]
# ============================================
{
  services.unifi = {
    enable = true;
    # using CE is needed since mongodb otherwise needs to be fully compiled
    # https://wiki.nixos.org/wiki/MongoDB
    mongodbPackage = pkgs.mongodb-ce;
  };

  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
      # optional:
      domain = "localhost";
    };
  };

  services.prometheus = {
    # https://wiki.nixos.org/wiki/Prometheus
    # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters-configuration
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/default.nix
    exporters.mqtt = {
      enable = true;
      mqttUsername = "mqtt-exporter";
      port = 9001;
      environmentFile = "/var/lib/extra/mqtt.env";
      esphomeTopicPrefixes = [
        "whitney-svc-panel-vue3/sensor"
        "xcel/sensor/Instantaneous_Demand"
      ];
    };
    enable = true;
    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "mqtt-broker";
        static_configs = [
          {
            targets = [ "localhost:9001" ];
          }
        ];
      }
    ];
  };

  # https://nixos.wiki/wiki/Mosquitto
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.mqtt-exporter = {
          acl = [ "read #" ];
          hashedPassword = "$7$101$JdopfXMasddKQLdf$bz8rcvVEKG3I6Y6o+lSUgT44UE5RTBsAGpgEYHE4Sp43ETjOzqWRnxou46dMF3tKnOIefkNN0jjw9taQFOj7dA==";
        };
        users.xcel_itron2mqtt = {
          acl = [ "readwrite #" ];
          hashedPassword = "$7$101$JdopfXMasddKQLdf$bz8rcvVEKG3I6Y6o+lSUgT44UE5RTBsAGpgEYHE4Sp43ETjOzqWRnxou46dMF3tKnOIefkNN0jjw9taQFOj7dA==";
        };
        users.emporia-svc-panel = {
          acl = [ "readwrite #" ];
          # nix shell nixpkgs#mosquitto --command mosquitto_passwd -c /tmp/passwd root
          hashedPassword = "$7$101$JdopfXMasddKQLdf$bz8rcvVEKG3I6Y6o+lSUgT44UE5RTBsAGpgEYHE4Sp43ETjOzqWRnxou46dMF3tKnOIefkNN0jjw9taQFOj7dA==";
        };
      }
    ];
  };

  services.jellyfin = {
    enable = true;
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # ============================================
  # [CONTAINERS]
  # ============================================
  virtualisation.oci-containers = {
    backend = "docker";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "America/Denver";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
      ];
    };
  };

}
