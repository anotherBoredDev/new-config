{ self, ... }: {
  flake.modules.nixos.profiles-server = {
    imports = with self.modules.nixos; [
      profiles-base
      locale-es_es

      containers
      monitoring
    ];
  };
}
