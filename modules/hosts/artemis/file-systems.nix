{
  flake.modules.nixos.artemis = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/4688c4d3-b31e-408d-b2d9-6b637af29705";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/4688c4d3-b31e-408d-b2d9-6b637af29705";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/6419-4EA4";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [ ];
  };
}
