{
  flake.modules.nixos.containers = {
    virtualisation.podman = {
      enable = true;
      # Optional: creates a `docker` alias for podman commands
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    virtualisation.oci-containers.backend = "podman";
  };
}
