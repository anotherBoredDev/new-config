{
  flake.modules.nixos.nixos-nix-settings = {
    nix = {
      settings = {
        auto-optimise-store = true;
        use-xdg-base-directories = true;

        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      optimise = {
        automatic = true;
        dates = [ "12:00" ];
      };
    };
  };
}
