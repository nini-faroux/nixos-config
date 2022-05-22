# tmux configuration

{ config, lib, pkgs, ... }:

{ 
  programs.tmux = { 
    enable = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "b";

    # Replacement for .tmux.conf
    extraConfig = ''
      # remap prefix from 'C-b' to 'C-s'
      unbind C-b
      set-option -g prefix C-s
      bind-key C-s send-prefix
      
      # split panes using | and - 
      bind | split-window -h 
      bind - split-window -v 
      unbind '"'
      unbind %
      
      # navigate panes
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # resize panes
      bind s resize-pane -L 4
      bind f resize-pane -R 4
      bind e resize-pane -U 4
      bind d resize-pane -D 4
      
      # change copy/paste to vim style
      setw -g mode-keys vi
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind P paste-buffer
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      
      set -g allow-rename off
      
      # log the session 
      run-shell /opt/tmux-logging/logging.tmux
      
      set-option -sg escape-time 10
      set-option -g focus-events on
      set -g default-terminal "screen-256color"
      set-option -sa terminal-overrides ',screen-256color:RGB'
      
      # log the session 
      run-shell /opt/tmux-logging/logging.tmux
      
      # List of plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      # Add more plugins below this line
      
      # Run Tmux Plugin Manager
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
