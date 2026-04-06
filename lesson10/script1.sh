#!/usr/bin/env bash
set -e

create_if_not_exists(){
    if [ ! -f $1 ]; then
        touch $1
        echo "created: $1"
    fi
}

trunc_if_not_empty(){
    if [ -s $1 ]; then
        truncate -s 0 $1
        echo "truncated: $1"
    fi
}

file_1(){
    create_if_not_exists $1
    echo "Hello!" > $1 
    date >> $1
}
file_2(){
    create_if_not_exists $1
    trunc_if_not_empty $1
    if [ $(stat -c "%a" $1) != "777" ]; then
        chmod 777 "$1"
        echo "set 777: $1"
    fi
}
file_3(){
    create_if_not_exists $1
    random_data=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 20)
    echo $random_data > $1
}
file_4(){
    create_if_not_exists $1
    trunc_if_not_empty $1
}
file_5(){
    create_if_not_exists $1
    trunc_if_not_empty $1
}


DIR="$HOME/myfolder"
if [ ! -d $DIR ]; then
    mkdir $DIR
    echo "$DIR created"
fi

file_1 "$DIR/1"
file_2 "$DIR/2"
file_3 "$DIR/3"
file_4 "$DIR/4"
file_5 "$DIR/5"
echo "DONE"