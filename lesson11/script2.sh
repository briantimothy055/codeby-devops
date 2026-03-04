#!/usr/bin/env bash

readonly DEFAULT_DIR="$HOME/myfolder"
readonly INSECURE_PERMS="777"

check_if_dir_exists(){
    local dir_path=$1
    if [[ ! -d "$dir_path" ]]; then
        echo "failed: dir '$dir_path' does not exist" >&2
        return 1
    fi
    return 0
}

get_dir_files_count(){
    local dir_path="$1"
    
    if [[ -z "$dir_path" ]]; then
        echo "failed: no dir path" >&2
        return 1
    fi
    
    if [[ ! -d "$dir_path" ]]; then
        echo "failed: dir '$dir_path' does not exist" >&2
        return 1
    fi
    
    local file_count
    file_count=$(find "$dir_path" -maxdepth 1 -type f 2>/dev/null | wc -l)
    
    echo "dir [$dir_path] has [$file_count] files"
    return 0
}

fix_insecure_perms(){
    local fpath=$1
    if [ -f $fpath ]; then
        if [[ "$(stat -c "%a" $fpath)" == "$INSECURE_PERMS" ]]; then
            chmod 664 $fpath
            echo "perms of [$fpath] changed to 664"
            return 0
        fi
    else
        echo "file [$fpath] not found"
        return 1
    fi
}

delete_empty_or_truncate(){
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        echo "failed: dir '$dir_path' does not exist" >&2
        return 1
    fi
    for file in "$dir_path"/*; do
        if [ -f $file ]; then
            if [ ! -s $file ]; then
                rm $file
                echo "empty file [$file] deleted"
            else
                sed -i '2,$d' $file
                echo "non empty file [$file] removing lines"
            fi
        fi
    done
    return 0
}

main(){
    check_if_dir_exists $DEFAULT_DIR      || return 1
    get_dir_files_count $DEFAULT_DIR      || return 1
    
    # Запуск скриптов в любой последовательности и количество запусков не должны вызывать ошибки
    fix_insecure_perms "$DEFAULT_DIR/2"   || echo "file $DEFAULT_DIR/2 not found, skip"
    
    delete_empty_or_truncate $DEFAULT_DIR || return 1
}
main




