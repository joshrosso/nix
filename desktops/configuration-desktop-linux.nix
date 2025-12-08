{
  config,
  lib,
  pkgs,
  ...
}:

# TODO(joshrosso): This is all temporary until my server parts arrive

{

  services.unifi.enable = true;

  # https://nixos.wiki/wiki/Mosquitto
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.emporia-svc-panel = {
          acl = [ "readwrite #" ];
          # nix shell nixpkgs#mosquitto --command mosquitto_passwd -c /tmp/passwd root
          hashedPassword = "$7$101$JdopfXMasddKQLdf$bz8rcvVEKG3I6Y6o+lSUgT44UE5RTBsAGpgEYHE4Sp43ETjOzqWRnxou46dMF3tKnOIefkNN0jjw9taQFOj7dA==";
        };
      }
    ];
  };

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
