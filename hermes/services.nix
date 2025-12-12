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
      environmentFile = "/home/josh/mqtt-pass";
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
            targets = [ "192.168.0.54:9001" ];
          }
        ];
      }
    ];
  };

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
