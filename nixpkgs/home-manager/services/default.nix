let
  more = {
    services = {
      flameshot.enable = true;

      gnome-keyring = {
        enable = true;
        components = [ "pkcs11" "secrets" "ssh" ];
      };
    };
  };
in
[
  ./dunst
  ./networkmanager
  ./picom
  ./polybar
  ./screenlocker
  ./udiskie
  more
]

