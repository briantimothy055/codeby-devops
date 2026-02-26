#!/usr/bin/env bash

echo "--------------------------------------------------------------"

DIR="$HOME/myfolder"
if [ ! -d $DIR ]; then
    mkdir $DIR
    echo "$DIR created"
fi

# Total files
file_count=$(ls -1 $DIR | wc -l)
echo "dir [$DIR] has [$file_count] files"


# Change perms
file2="$DIR/2"
if [ -f $file2 ]; then
    if [[ "$(stat -c "%a" $file2)" == "777" ]]; then
        chmod 664 $file2
        echo "perms of [$file2] changed to 664"
    fi
else
    echo "file [$file2] not found"
fi

echo "--------------------------------------------------------------"

for file in "$DIR"/*; do
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

echo "--------------------------------------------------------------"
