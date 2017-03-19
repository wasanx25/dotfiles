{ config, pkgs, ... }:

{
  services.openssh.enable   = true;
  services.dbus.enable      = true;
  services.timesyncd.enable = true;

  virtualisation.docker.enable = true;
  programs.fish.enable         = true;

  environment.systemPackages = with pkgs; [
    git
    zsh
    vim
    fish
    tmux
    tig
    tree
    peco
    docker
  ];
}
