{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        # Use alacritty terminal
        terminal = "${pkgs.alacritty}/bin/alacritty";

        # Float on top of windows
        layer = "overlay";

        # Font style and size
        font = "Monospace 12";

        # Padding between prompt and first entry
        inner-pad = 25;
      };

      # Use 'Alt + vim keys' for next and prev
      key-bindings = {
        next = "Down Mod1+j";
        prev = "Up Mod1+k";
      };

      colors = {
        background = "222222ff";
        foreground = "bbbbbbff";
        selected_bg = "285577ff";
        selected_fg = "ffffffff";
      };

      border = {
        width = 7;
        radius = 8;
      };
    };
  };
}
