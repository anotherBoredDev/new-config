{ self, ... }: {
  flake.modules.nixos.profiles-workstation = {
    imports = with self.modules.nixos; [
      profiles-base
      audio
      printing
      locale-en_es
    ];
  };
}
