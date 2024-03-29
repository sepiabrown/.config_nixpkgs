  # How to install :
  #
  # 1.
  # For unstable : 
  # nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  # nix-channel --update
  # 
  # For specific version :
  # nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  # nix-channel --update
  #
  # 2.
  # nix-shell '<home-manager>' -A install
  #
  # Post install :
  # home-manager switch
  # 
  # Rollbacks :
  # home-manager generations
  # 2018-01-04 11:56 : id 765 -> /nix/store/kahm1rxk77mnvd2l8pfvd4jkkffk5ijk-home-manager-generation
  # 2018-01-03 10:29 : id 764 -> /nix/store/2wsmsliqr5yynqkdyjzb1y57pr5q2lsj-home-manager-generation
  # 2018-01-01 12:21 : id 763 -> /nix/store/mv960kl9chn2lal5q8lnqdp1ygxngcd1-home-manager-generation
  # 2017-12-29 21:03 : id 762 -> /nix/store/6c0k1r03fxckql4vgqcn9ccb616ynb94-home-manager-generation
  # 2017-12-25 18:51 : id 761 -> /nix/store/czc5y6vi1rvnkfv83cs3rn84jarcgsgh-home-manager-generation
  #
  # /nix/store/mv960kl9chn2lal5q8lnqdp1ygxngcd1-home-manager-generation/activate
  #
  # Nix Flake:
  #{
  #  description = "NixOS configuration";
  #
  #  inputs = {
  #    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  #    home-manager.url = "github:nix-community/home-manager";
  #  };
  # 
  #  outputs = { home-manager, nixpkgs, ... }: {
  #    nixosConfigurations = {
  #      hostname = nixpkgs.lib.nixosSystem {
  #        system = "x86_64-linux";
  #        modules = [
  #          ./configuration.nix
  #          home-manager.nixosModules.home-manager
  #          {
  #            home-manager.useGlobalPkgs = true;
  #            home-manager.useUserPackages = true;
  #            home-manager.users.jdoe = import ./home.nix;
  #          }
  #        ];
  #      };
  #    };
  #  };
  #}
  # When using flakes, switch to new configurations as you do for the whole system 
  # (e. g. nixos-rebuild switch --flake <path>) instead of using the home-manager command line tool.
  
{ config, pkgs, ... }:

let
  
  # On terminal,
  #
  # nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # nix-channel --add https://nixos.org/channels/nixos-20.03 nixos-2003
  # nix-channel --update

  overlay1 = 
    (self: super: {      
      emacs = (super.emacs.overrideAttrs(old: {
        buildInputs = old.buildInputs
          ++ [self.glib-networking];
      })).override {
        withXwidgets = true;
        withGTK3 = true;
        webkitgtk = super.webkitgtk;
      };
    });
  
  vivobook = import <vivobook> {};
  nixos-2003 =import <nixos-2003> {};
  nixos-2009 =import <nixos-2009> { overlays = [ overlay1 ]; };

in

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "sepiabrown";
    homeDirectory = "/home/sepiabrown";
    packages = with pkgs;[
    #system
      htop
      ripgrep
      zip
      unzip
      wget
      curl
      file
      rclone
      alacritty
  
    #utils
      vimHugeX
      nixos-2009.emacs
  
    #document tools
      texlive.combined.scheme-full
      poppler_utils
  
    #dev
      # nixos-2009.julia_13
      nixos-2003.julia_11
      #python3Packages.jupyterlab
      #jupyter
  
    #fonts
      anonymousPro # unfree, TrueType font set intended for source code 
      corefonts # unfree, Microsoft's TrueType core fonts for the Web has an unfree license (‘unfreeRedistributable’), refusing to evaluate.
      dejavu_fonts # unfree, A typeface family based on the Bitstream Vera fonts
      noto-fonts # Beautiful and free fonts for many languages
      freefont_ttf # GNU Free UCS Outline Fonts
      #### google-fonts # not working with emacs
      inconsolata # A monospace font for both screen and print
      liberation_ttf # Liberation Fonts, replacements for Times New Roman, Arial, and Courier New
      powerline-fonts  # unfree? Oh My ZSH, agnoster fonts  
      source-code-pro
      terminus_font  # unfree, A clean fixed width font
      ttf_bitstream_vera # unfree
      ubuntu_font_family
      d2coding
    ];
    file = {
      ".config/alacritty/alacritty.yaml".text = ''
        env:
          TERM: xterm-256color
      '';  
    };
  };
  
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  # nixpkgs.overlays = [
  #   (self: super: {      
  #     emacs = (super.nixos-2009.emacs.overrideAttrs(old: {
  #       buildInputs = old.buildInputs
  #         ++ [self.glib-networking];
  #     })).override {
  #       withXwidgets = true;
  #       withGTK3 = true;
  #       webkitgtk = super.webkitgtk;
  #     };
  #   })
  # ];

  

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Suwon Park";
    userEmail = "sepiabrown@naver.com";
    # signing = {
    #   key = "me@yrashk.com";
    #   signByDefault = true;
    # };
  };


  programs.gh.enable = true;
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
