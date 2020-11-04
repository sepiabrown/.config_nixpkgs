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
  home.username = "sepiabrown";
  home.homeDirectory = "/home/sepiabrown";

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

  home.packages = with pkgs;[
  #system
    htop
    ripgrep
    zip
    unzip
    wget
    curl
    file
    rclone


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
