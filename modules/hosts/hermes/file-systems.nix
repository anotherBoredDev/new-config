{
  flake.modules.nixos.hermes = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/a1b4355b-55c8-4538-bc2b-f86ffaec63e4";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/a1b4355b-55c8-4538-bc2b-f86ffaec63e4";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/var" = {
      device = "/dev/disk/by-uuid/a1b4355b-55c8-4538-bc2b-f86ffaec63e4";
      fsType = "btrfs";
      options = [
        "subvol=@var"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/a1b4355b-55c8-4538-bc2b-f86ffaec63e4";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/F08C-F71D";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [ ];
  };
}
