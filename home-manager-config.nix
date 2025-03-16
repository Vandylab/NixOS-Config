{ pkgs, lib, ... } : {

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  nixpkgs.config = {
    allowUnfree = true;
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.packages = with pkgs; [
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    terminator
    docker
    emacs
    wget
    git
    zsh
    htop
    oh-my-zsh
    texliveSmall
    vscode
    firefox
    thunderbird
    python313
    python313Packages.pip
    discord
    slack
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      esprint = "sudo find / \\( -name \"*~\" -o -name \"#*#\" \\) -print 2> /dev/null";
	    esdelete = "sudo find / \\( -name \"*~\" -o -name \"#*#\" \\) -print -delete 2> /dev/null";
    };
    oh-my-zsh = {
      enable = true;
	    theme = "agnoster";
      plugins = [
        "git"
        "docker"
      ];
    };
  };

  programs.terminator = {
    config = {
      profiles.default = {
	      font = "JetBrainsMono Nerd Font Mono Semi-Bold 10";
        use_system_font = false;
        title_use_system_font = false;
        title_font = "Unifont 8";
      };
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.debugpy
	    ms-python.python
	    ms-toolsai.jupyter
	    ms-toolsai.jupyter-keymap
	    ms-toolsai.jupyter-renderers
	    ms-toolsai.vscode-jupyter-cell-tags
	    ms-toolsai.vscode-jupyter-slideshow
	    tuttieee.emacs-mcx
    ];
  };

  home.file = {
    ".emacs" = {
      source = ./emacs_conf;
      force = true;
    };
    "./.config/i3" = {
      source = ./i3_config;
      recursive = true;
      force = true;
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
