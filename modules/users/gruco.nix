{
  flake.modules.nixos.gruco =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.gruco;
    in
    {
      # Options definitions
      options.features.gruco = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable gruco user";
        };

        hostType = lib.mkOption {
          type = lib.types.enum [
            "workstation"
            "server"
          ];
          default = "server";
          description = "Host profile type to determine system group assignments";
        };

        extraGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Additional host-specific groups to append";
        };
      };

      # Implementation of options
      config = lib.mkIf cfg.enable {
        users.users.gruco = {
          isNormalUser = true;
          description = "Primary User";

          # Base groups granted on ALL systems
          extraGroups = [
            "wheel"
          ]
          # Appended groups for Workstations
          ++ lib.optionals (cfg.hostType == "workstation") [
            "networkmanager" # Manage network connections
          ]
          # Appended groups for Servers
          ++ lib.optionals (cfg.hostType == "server") [
            "systemd-journal" # Read system logs without full root
          ]
          # Custom groups passed explicitly by individual hosts
          ++ cfg.extraGroups;
        };
      };
    };
}
