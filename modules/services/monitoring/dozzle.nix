{
  flake.modules.nixos.monitoring =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.dozzle;
    in
    {
      options.features.dozzle = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable dozzle pod";
        };
      };

      config = lib.mkIf cfg.enable {
        virtualisation.oci-containers = {
          containers.dozzle = {
            image = "amir20/dozzle:latest";
            ports = [ "8080:8080" ];
            volumes = [
              "/run/podman/podman.sock:/var/run/docker.sock:ro"
            ];
          };
        };
      };
    };
}
