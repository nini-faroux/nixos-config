{
  pkgs,
  ...
}:
{
  services.greetd = {
  enable = true;

  settings = {
    default_session.command = ''
      sh -c 'clear && ${pkgs.greetd.tuigreet}/bin/tuigreet \
        --time \
        --user-menu \
        --cmd sway \
        --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'
    '';

    tty = 7;
    };
  };
}
