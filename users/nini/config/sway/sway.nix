# All the sway config options
{ ... }:
{
  # Sway config
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1";
        };
      };
    };

    # Remove default swaybar
    config.bars = [];

    extraConfig = ''
      # Set the super key
      set $mod Mod4

      ### ---- Create workspaces and run certain apps on boot ---- ###
      ## - Browser at workspace 1 - ##
      workspace 1 output DP-1

      # Launch Brave
      exec brave --ozone-platform-hint=wayland \
                 --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WaylandWindowDecorations

      # Make Brave windows tabbed on workspace 1
      for_window [app_id="brave-browser"] move to workspace 1, layout tabbed

      # --- Browser Tab Style --- #
      client.focused          #282828 #458588 #ebdbb2 #458588 #ebdbb2
      client.focused_inactive #3c3836 #928374 #ebdbb2 #928374 #ebdbb2
      client.unfocused        #3c3836 #504945 #a89984 #504945 #a89984
      client.urgent           #cc241d #cc241d #fbf1c7 #cc241d #fbf1c7

      # --- Move between tabs in stacked layout
      bindsym $mod+n focus next
      bindsym $mod+p focus prev

      # --- Fuzzel menu for Brave windows ---
      bindsym $mod+m exec ~/.config/sway/scripts/brave-switcher.sh

      # --- Toggle Fuzzel Menu ---
      bindsym $mod+Shift+m exec fuzzel

      ## - Dotfiles at workspace 4 -##
      workspace 4 output DP-1

      # Match by Alacritty app_id and send it to workspace 4
      for_window [app_id="dotfiles-term"] move to workspace 4

      # Launch terminal on workspace 4 in dotfiles dir running tmux
      exec alacritty --class dotfiles-term --working-directory ~/.dotfiles -e tmux new-session -A -s dotfiles -c ~/.dotfiles

      # --- Htop Scratchpad Setup ---

      # Start htop in its own terminal
      exec alacritty --class htop -e htop
      
      # Send it to the scratchpad and make it floating
      for_window [app_id="htop"] move to scratchpad, floating enable, resize set width 800 height 600, move position center
      
      # Unbind from default
      unbindsym $mod+h

      # Show or hide the htop scratchpad window from anywhere
      bindsym $mod+h [app_id="htop"] scratchpad show

      # --------- #

      # Ensures DBus knows about sway environment (needed for xdg-desktop-portal-wlr)
      exec_always dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

      # Hide cursor when not moving it
      seat seat0 hide_cursor 20000

      # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      # Volume controls with pamixer (limit at 100%)
      bindsym XF86AudioMute exec pamixer --toggle-mute
      bindsym XF86AudioRaiseVolume exec pamixer --increase 5 --set-limit 100
      bindsym XF86AudioLowerVolume exec pamixer --decrease 5

      # Keyboard and touchpad
      input "type:keyboard" {
        xkb_layout gb
        xkb_options "ctrl:nocaps"
      }

      input "type:touchpad" {
        tap enabled
      }

      # Waybar
      exec_always waybar

      # --- Wallpaper ---
      output * bg "${../image/wallpaper_1.jpg}" fill

      # Lock screen with Mod + Shift + s
      bindsym $mod+Shift+s exec swaylock -f -i ${../image/lockscreen_wallpaper.jpg}
    '';
  };
}
