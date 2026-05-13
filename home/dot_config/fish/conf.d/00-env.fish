if test (uname) = Darwin
    set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
end

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share

set -gx LANG "en_US.utf-8"

set -gx VISUAL vim
set -gx EDITOR vim
set -gx KUBE_EDITOR vim

fish_add_path --global --prepend $HOME/.local/bin
