# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "machine"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.awesome = {
	enable = true;
	luaModules = with pkgs.luaPackages; [
		luarocks
		luadbi-mysql
	];
  };
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = builtins.readFile /home/fakecrafter/.config/xmonad/xmonad.hs;
  };
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable shell.
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fakecrafter = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "input" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	alacritty
	anki
	awesome
	bspwm
	cmus
	dmenu
	dunst
	dwm
	emacs
	exa
	feh
	firefox
	git
	gnupg
	haskellPackages.ghc
	haskellPackages.xmobar
	haskellPackages.xmonad
	htop
	openjdk17-bootstrap
	kitty
	libnotify
	libreoffice
	libqalculate
	neofetch
	neovim
	nodePackages_latest.firebase-tools
	nodejs_20
	pass
	pinentry
	pinentry-gtk2
	pinentry-rofi
	pulsemixer
	python311
	qmk
	qrencode
	rofi
	(rofi.override { plugins = [ rofi-calc ]; })
	rofi-emoji
	rofi-power-menu
	steam
	steam-run
	stow
	sxhkd
	sxiv
	unzip
	vifm
	vim
	vscode
	w3m
	wget
	xclip
	xfce.thunar
	xorg.xinit
	xorg.libX11
	xorg.libX11.dev
	xterm
	zsh
  ];

  # Set Fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    noto-fonts
    noto-fonts-emoji
    fira-code
    cascadia-code
    jetbrains-mono
    iosevka
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };

	programs.steam = {
		enable = true;
	  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

