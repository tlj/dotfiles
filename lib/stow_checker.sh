check_and_backup_links() {
    local src_dir="${1:?Usage: check_and_backup_links /path/to/source}"

    _check_link_or_backup() {
        local source_path="$1"
        local dest_path="$2"
        if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
            if [ -L "$dest_path" ]; then
                local target_path
                target_path=$(readlink -f -- "$dest_path")
                local source_real
                source_real=$(readlink -f -- "$source_path")
                if [ "$target_path" = "$source_real" ]; then
                    return 0  # symlink correctly points to source
                fi
            fi
            mv -v -- "$dest_path" "${dest_path}.bak"
        fi
    }

    find "$src_dir" -mindepth 1 -maxdepth 1 | while IFS= read -r entry; do
        base=$(basename "$entry")
        if [ "$base" = "dot-config" ] && [ -d "$entry" ]; then
            # Only check top-level entries inside dot-config                          
            find "$entry" -mindepth 1 -maxdepth 1 | while IFS= read -r dotconfig_entry; do
                dotconfig_base=$(basename "$dotconfig_entry")
                destpath="$HOME/.config/$dotconfig_base"
                _check_link_or_backup "$dotconfig_entry" "$destpath"
            done
        else
            destname="${base/dot-/.}"
            destpath="$HOME/$destname"
            _check_link_or_backup "$entry" "$destpath"
        fi
    done
}

