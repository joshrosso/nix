{
  pkgs,
  ...
}:

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
}
