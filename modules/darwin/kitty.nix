{ config, pkgs, lib, ... }: {

  # MacOS-specific settings for Kitty
  home-manager.users.${config.user} = {
    programs.kitty = {
      darwinLaunchOptions = [ "--start-as=fullscreen" ];
      font.size = lib.mkForce 20;
      settings = {
        shell = "/run/current-system/sw/bin/fish";
        macos_traditional_fullscreen = true;
        macos_quit_when_last_window_closed = true;
        disable_ligatures = "always";
      };
    };
  };

}
