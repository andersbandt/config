

echo "executing COPY to IN"
echo "Files in Github will be overwritten by local computer files"


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    system="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    system="max"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    system="Windows"
elif [[ "$OSTYPE" == "msys" ]]; then
    system="msys"
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    # ...
    system="freebsd"
else
    # Unknown.
    system=0
fi


echo "using system $system"
echo "using onedrive '$ONEDRIVE'"


   

# Function to compare and move files
move_with_diff() {
    local src_file=$1
    local dest_file=$2

    if [[ -e "$dest_file" ]]; then
        echo -e "\n\nDifferences between $src_file and $dest_file:"
        if diff --color "$dest_file" "$src_file"; then
            echo "No differences found between $src_file and $dest_file. Skipping copy."
        else
            echo "Do you want to overwrite $dest_file with $src_file? (y/n)"
            read -r answer
            if [[ "$answer" == "y" ]]; then
                cp -vi "$src_file" "$dest_file"
            else
                echo "Skipping $src_file"
            fi
        fi
    else
        cp -vi "$src_file" "$dest_file"
    fi
}



# Specify the files to be moved
src_files=("$HOME/.bashrc" "$HOME/.bashrc_color")
dest_dir="."

# Perform the move operation with diff check
for src_file in "${src_files[@]}"; do
    dest_file="$dest_dir/$(basename "$src_file")"
    move_with_diff "$src_file" "$dest_file"
done



# move .bashrc_user
# location specific depending on OS
src_file_name=(".bashrc_user")
if [ $system = "Windows" ]
then
    src_dir="/cygdrive/c/Users/ander/OneDrive/"
elif [ $system = "Linux" ]
then
    src_dir="$HOME"
fi


src_file="$src_dir/$(basename "$src_file_name")"
dest_file="$dest_dir/$(basename "$src_file_name")"

move_with_diff "$src_file" "$dest_file"
