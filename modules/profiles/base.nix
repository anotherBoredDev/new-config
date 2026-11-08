{ self, ... }: {
  flake.modules.nixos.profiles-base = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      bootloader
      networking
      nixos-nix-settings
      nixos-system
    ];

    environment.systemPackages = with pkgs; [
      btop
      git
      wget
    ];
  };
}
