# Config for locking screen when idle or when laptop shut
{ pkgs, ... }:
{
  # Suspend when idle for 5 minutes
  # Suspend after closing lid (lockscreen on reopening)
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -i ${../image/a_bridge_with_clouds_in_the_sky.jpg}"; }
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f -i ${../image/a_bridge_with_clouds_in_the_sky.jpg}"; }
    ];
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f -i ${../image/a_bridge_with_clouds_in_the_sky.jpg}"; }
      { timeout = 600; command = ''swaymsg "output * dpms off"''; resumeCommand = ''swaymsg "output * dpms on"''; }
    ];
    systemdTargets = [ "sway-session.target" ];
  };
}
