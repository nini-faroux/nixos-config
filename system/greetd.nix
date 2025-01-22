{
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
     default_session.command = ''
      ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --user-menu \
        --cmd sway
    '';
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';
}
