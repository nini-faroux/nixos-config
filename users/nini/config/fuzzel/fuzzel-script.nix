{ ... }:
{
  home.file.".config/sway/scripts/brave-switcher.sh" = {
    text = ''
      #!/usr/bin/env bash
      swaymsg -t get_tree | \
        jq -r 'recurse(.nodes[], .floating_nodes[]) | select(.app_id == "brave-browser") | .name' | \
        fuzzel --dmenu --prompt "Brave windows >" | \
        while read -r title; do
          [ -n "$title" ] && swaymsg "[title=\"$title\"]" focus
        done
    '';
    executable = true;
  };
}
