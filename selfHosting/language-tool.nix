{ config, pkgs, inputs, ... }:

{
  virtualisation.oci-containers.containers.languagetool = {
    image = "erikvl87/languagetool";
    ports = [ "8010:8010" ];
  };
}
