{
  flake.modules.nixos.printing = { pkgs, ... }: {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        gutenprint # General printer drivers
      ];
    };

    # Enables auto-discovery of network printers
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
