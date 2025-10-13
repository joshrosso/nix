# nix-config

joshrosso's nix configuraitons for reproducibility from Linux, to Mac, to Hypervisors.

## Linux

* Boot host
* Set `passwd` on root and nixos users
* scp skelly/disk-layout to host

* lsblk and update `skelly/disk-layout.nix` with the correct disk UUIDs

* move disk setup over

  ```sh
  scp skelly/disk-layout.nix nixos@${NIX_ADDR}:~
  ```

* set encryption passphrase

  ```sh
  ssh root@${NIX_ADDR} 'echo -n "password" > /tmp/secret.key'
  ```

* run disk (disk layout (skelly))

  ```sh
  ssh root@${NIX_ADDR} 'nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /home/nixos/disk-layout.nix'
  ```

* gen hardware config

  ```sh
  ssh root@${NIX_ADDR} 'nixos-generate-config --root /mnt --show-hardware-config' > skelly/hardware-configuration.nix
  ```

* gen hardware config and update source control for hw config

* get partition UUID containing crypted root

```sh
lsblk -f
```

* In this case the UUID would be `5024cc49-06bf-4b4f-8b78-7ded9ca2e536`.

    ```
    nvme0n1
    ├─nvme0n1p1     vfat        FAT16                                       812C-E3A3                               499.7M     0% /mnt/boot
    └─nvme0n1p2     crypto_LUKS 2                                           5024cc49-06bf-4b4f-8b78-7ded9ca2e536
      └─crypted     LVM2_member LVM2 001                                    BEc6bR-FsCR-4znX-uiHD-s63T-cFgj-M4yU80
        ├─pool-home ext4        1.0                                         a87cf92f-7d04-44d1-9e2e-dd809a18ca15    746.4G     0% /mnt/home
        ├─pool-raw
        └─pool-root ext4        1.0                                         d5d90798-a9e4-4174-ab2f-991f5b322a9a    185.8G     0% /mnt
    ```

* add the following to the hardware-configuration.

```sh
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        # 30 is for HIDPI
        fontSize = 30;
        extraEntries = ''
          menuentry 'Windows 11' {
            search --fs-uuid --no-floppy --set=root A8C3-093C
            chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/5865bbe2-a5c4-4b6a-991f-c8eab8fb7bf8";
  };
```

> The windows entry is just a placeholder for when Windows is installed later.

* scp config over

```sh
ssh root@${NIX_ADDR} 'mkdir -p /mnt/tmp/install' && scp -r ./ root@${NIX_ADDR}:/mnt/tmp/install
```

* install nixos with flake

  ```sh
  ssh root@${NIX_ADDR} nixos-install --flake /mnt/tmp/install/skelly#skelly
  ```

* enter new system `nixos-enter` to set user/root pw

### Linux Updates

```
sudo nix flake update
```

## MPB

```sh
darwin-rebuild switch --flake ./mbp
```

### Windows Dual-Boot Notes

* Don't forget to disable fast startup. It can cause weird issues such as breaking linux wifi.
    * https://www.reddit.com/r/archlinux/comments/kuy8fq/wifi_not_working_iwlwifi_failed_with_error_110

* If you install windows after nix, likely going to need to reinstall the bootloader. Go back in through the installation media and mount the drives, then run:
    ```
    NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot
    ```
