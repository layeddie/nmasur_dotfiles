{ inputs, globals, ... }:

with inputs;

# System configuration for my work MacBook
darwin.lib.darwinSystem {
  system = "x86_64-darwin";
  specialArgs = { };
  modules = [
    (globals // {
      user = "Noah.Masur";
      gitName = "Noah-Masur_1701";
      gitEmail = "Noah.Masur@take2games.com";
    })
    home-manager.darwinModules.home-manager
    {
      identityFile = "/home/${globals.user}/.ssh/id_ed25519";
      gui.enable = true;
      colorscheme = (import ../../modules/colorscheme/gruvbox);
      mailUser = globals.user;
      networking.hostName = "noah-masur-mac";
      nixpkgs.overlays = [ nur.overlay ];
      # Set registry to flake packages, used for nix X commands
      nix.registry.nixpkgs.flake = nixpkgs;
    }
    ../common.nix
    ../../modules/darwin
    ../../modules/mail
    ../../modules/applications/alacritty.nix
    ../../modules/applications/kitty.nix
    ../../modules/applications/discord.nix
    ../../modules/repositories/notes.nix
    ../../modules/programming/nix.nix
    ../../modules/programming/terraform.nix
    ../../modules/programming/python.nix
    ../../modules/programming/lua.nix
    ../../modules/programming/kubernetes.nix
  ];
}
