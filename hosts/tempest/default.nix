# The Tempest
# System configuration for my desktop

{ inputs, globals, overlays, ... }:

with inputs;

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    globals
    home-manager.nixosModules.home-manager
    ../../modules/common
    ../../modules/nixos
    {
      nixpkgs.overlays = [ nur.overlay ] ++ overlays;

      # Hardware
      physical = true;
      networking.hostName = "tempest";

      boot.initrd.availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      boot.initrd.kernelModules = [ "amdgpu" ];
      boot.kernelModules = [ "kvm-amd" ];
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.enableRedistributableFirmware = true;
      powerManagement.cpuFreqGovernor = "performance";
      hardware.cpu.amd.updateMicrocode = true;
      hardware.fancontrol.enable = true;
      hardware.fancontrol.config = ''
        # Configuration file generated by pwmconfig, changes will be lost
        INTERVAL=10
        DEVPATH=hwmon0=devices/pci0000:00/0000:00:03.1/0000:06:00.0/0000:07:00.0/0000:08:00.0
        DEVNAME=hwmon0=amdgpu
        FCTEMPS=hwmon0/pwm1=hwmon0/temp1_input
        FCFANS= hwmon0/pwm1=hwmon0/fan1_input
        MINTEMP=hwmon0/pwm1=50
        MAXTEMP=hwmon0/pwm1=70
        MINSTART=hwmon0/pwm1=100
        MINSTOP=hwmon0/pwm1=10
        MINPWM=hwmon0/pwm1=10
        MAXPWM=hwmon0/pwm1=240
      '';

      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
      };

      # Must be prepared ahead
      identityFile = "/home/${globals.user}/.ssh/id_ed25519";
      passwordHash = nixpkgs.lib.fileContents ../../password.sha512;

      # Theming
      gui.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      wallpaper = "${wallpapers}/gruvbox/road.jpg";
      gtk.theme.name = nixpkgs.lib.mkDefault "Adwaita-dark";

      # Programs and services
      charm.enable = true;
      neovim.enable = true;
      media.enable = true;
      dotfiles.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      _1password.enable = true;
      discord.enable = true;
      nautilus.enable = true;
      obsidian.enable = true;
      mail.enable = true;
      mail.aerc.enable = true;
      mail.himalaya.enable = true;
      keybase.enable = true;
      mullvad.enable = false;
      nixlang.enable = true;
      yt-dlp.enable = true;
      gaming = {
        dwarf-fortress.enable = true;
        enable = true;
        steam.enable = true;
        legendary.enable = true;
        lutris.enable = true;
        leagueoflegends.enable = true;
        ryujinx.enable = true;
      };

    }
  ];
}
