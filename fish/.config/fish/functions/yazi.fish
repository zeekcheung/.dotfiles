function yazi --description "Force yazi to use chafa"
    # NOTE: Make sure to restore the `DISPLAY` environment variable for `xdg-open` via the `[opener]` config in `~/.config/yazi/yazi.toml`
    env -u XDG_SESSION_TYPE -u WAYLAND_DISPLAY -u DISPLAY /usr/bin/yazi $argv
end
