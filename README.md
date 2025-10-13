# nix-config

joshrosso's nix configuraitons for reproducibility from Linux, to Mac, to Hypervisors.

## Linux

* Boot host
* Set `passwd` on root and nixos users
* scp skelly/disk-layout to host

* lsblk and update `skelly/disk-layout.nix` with the correct disk UUIDs

* move disk setup over

  ```sh
  scp skelly/disk-layout.nix nixos@192.168.0.11:~
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

* add it to `desktops/configuration.nix` in the efi section.

* scp config over

```sh
ssh root@${NIX_ADDR} 'mkdir -p /mnt/tmp/install' && scp -r ./ root@192.168.0.11:/mnt/tmp/install
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
