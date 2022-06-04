{ config, pkgs, lib, ... }: {

  options.gaming.leagueoflegends = lib.mkEnableOption "League of Legends";

  config = lib.mkIf config.gaming.leagueoflegends {

    nixpkgs.config.allowUnfree = true;

    # League of Legends anti-cheat requirement
    boot.kernel.sysctl = { "abi.vsyscall32" = 0; };

    environment.systemPackages = with pkgs; [

      # Lutris requirement to install the game
      lutris
      amdvlk
      wineWowPackages.stable
      # vulkan-tools

      # Required according to https://lutris.net/games/league-of-legends/
      openssl
      gnome.zenity

      # Don't remember if this is required
      dconf

    ];

    environment.sessionVariables = { QT_X11_NO_MITSHM = "1"; };

  };
}
