DIR="$HOME/myfolder"
if [ ! -d $DIR ]; then
    mkdir $DIR
    echo "$DIR created"
fi

# Total files
file_count=$(ls -1 $DIR | wc -l)
echo "$DIR has $file_count files"

# Change perms
file_2="$DIR/2"
file_2_perms=$(stat -c "%a" $file_2)
if [ ! -f $file_2 ]; then
    touch $file_2
    echo "created: $file_2"
fi
if [[ "$file_2_perms" == "777" ]]; then
    chmod 664 $file_2
fi


for file in "$DIR"/*; do
    if [ -f $file ]; then
        if [ ! -s $file ]; then
            rm $file
            echo "deleted empty: $file"
        else
            sed -i '2,$d' $file
            echo "removed lines: $file"
        fi
    fi
done



