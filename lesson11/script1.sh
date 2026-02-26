#!/usr/bin/env bash
set -e

readonly DEFAULT_DIR="$HOME/myfolder"
readonly INSECURE_PERMS="777"
readonly RAND_CHARSET="A-Za-z0-9!@#$%^&*"
readonly RAND_LENGTH=20

create_if_not_exists(){
    local fpath=$1
    if [[ ! -f "$fpath" ]]; then
        if touch "$fpath"; then
            echo "created: $fpath"
        else
            echo "failed to create: $fpath"
            return 1
        fi
    fi
    return 0
}


trunc_if_not_empty(){
    local fpath=$1
    if [[ -s "$fpath" ]]; then
        if truncate -s 0 $fpath; then
            echo "truncated: $fpath"
        else
            echo "failed to truncate: $fpath"
            return 1
        fi
    fi
    return 0
}


file_1(){
    local $fpath=$1
    create_if_not_exists $fpath || return 1
    echo "Hello!" > $fpath 
    date >> $fpath
}

file_2(){
    local $fpath=$1
    create_if_not_exists $fpath || return 1
    trunc_if_not_empty $fpath || return 1

    local curr_perms
    curr_perms=$(stat -c "%a" "$fpath")

    if [[ "$curr_perms" != "$INSECURE_PERMS" ]]; then
        if chmod "$INSECURE_PERMS" "$fpath"; then
            echo "set '$INSECURE_PERMS': $fpath"
        else
            echo "failed to set '$INSECURE_PERMS': $fpath"
            return 1
        fi
    fi
    return 0
}

file_3(){
    local $fpath=$1
    create_if_not_exists $fpath || return 1
    local random_data
    random_data=$(tr -dc "$RAND_CHARSET" < /dev/urandom | head -c "$RAND_LENGTH")
    echo $random_data > $fpath
    echo "random data writen: $fpath"
}

file_45(){
    local $fpath=$1
    create_if_not_exists "$fpath" || return 1
    trunc_if_not_empty "$fpath" || return 1
    echo "empty file created: $fpath"
}

main(){
    if [[ ! -d "$DEFAULT_DIR" ]]; then
        if mkdir -p "$DEFAULT_DIR"; then
            echo "created dir: $DEFAULT_DIR"
        else
            echo "failed to create dir: $DEFAULT_DIR"
            exit 1
        fi
    fi

    file_1 "$DEFAULT_DIR/1"
    file_2 "$DEFAULT_DIR/2"
    file_3 "$DEFAULT_DIR/3"
    file_45 "$DEFAULT_DIR/4"
    file_45 "$DEFAULT_DIR/5"
    echo "DONE"
}
