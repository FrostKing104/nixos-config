{ config, pkgs, inputs, ... }:

{

  services.terraria = {
    enable = true;
    port = 7777;
    maxPlayers = 4;
  };

}

