

source ~/.bash_color


echo -e "${REDm}Executing COPY to IN${ENDC}"
echo -e "${CYANm}Files in Github will be overwritten by local computer files\n"

echo -e "${PURPLEm}using system $system ${ENDC}"


# Function to compare and move files
move_with_diff() {
    local src_file=$1
    local dest_file=$2

    if [[ -e "$dest_file" ]]; then
        echo -e "\n\nLooking for differences between $src_file and $dest_file:"
        if diff --color "$dest_file" "$src_file"; then
            echo "No differences found between $src_file and $dest_file. Skipping copy."
        else
	    echo -e "\tdifferences in RED are being eliminated in GitHub repo"
            echo "Do you want to overwrite $dest_file with $src_file? (y/n)"
            read -r answer
            if [[ "$answer" == "y" ]]; then
                cp -v "$src_file" "$dest_file"
                # cp -vi "$src_file" "$dest_file"
            else
                echo "Skipping $src_file"
            fi
        fi
    else
        cp -vi "$src_file" "$dest_file"
    fi
}


# Specify the files to be moved
src_files=("$HOME/.bashrc" "$HOME/.bash_user" "$HOME/.bash_aliases" "$HOME/.bash_os" "$HOME/.bash_color" )
dest_dir="."


# Perform the move operation with diff check
for src_file in "${src_files[@]}"; do
    dest_file="$dest_dir/$(basename "$src_file")"
    move_with_diff "$src_file" "$dest_file"
done
