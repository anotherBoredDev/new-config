{
  flake.modules.nixos.atlas = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/f56a29f2-1eb7-4118-bd35-47166ffa6bfb";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    fileSystems."/var" = {
      device = "/dev/disk/by-uuid/f56a29f2-1eb7-4118-bd35-47166ffa6bfb";
      fsType = "btrfs";
      options = [ "subvol=@var" ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/f56a29f2-1eb7-4118-bd35-47166ffa6bfb";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/f56a29f2-1eb7-4118-bd35-47166ffa6bfb";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/3909-3348";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [ ];
  };
}
