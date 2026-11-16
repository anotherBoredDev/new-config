{
  flake.modules.nixos.tailscale = {
    services.tailscale.enable = true;

    # Allow traffic over the encrypted tailscale0 interface
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
    };
  };
}
