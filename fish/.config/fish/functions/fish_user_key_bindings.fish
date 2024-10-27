function fish_user_key_bindings
    set -g fish_escape_delay_ms 10
    set -g fish_sequence_key_delay_ms 200
    set -g fish_key_bindings fish_vi_key_bindings

    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    bind -M insert -m default jj cancel repaint-mode

    # Copy/Paste with system clipboard
    bind yy fish_clipboard_copy
    bind p fish_clipboard_paste
end
