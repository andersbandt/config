
source ../move_with_diff.sh
source ~/.bash_color


echo -e "${REDm}Executing COPY to OUT for EMACS${ENDC}"
echo -e "${CYANm}Files in LOCAL will be overwritten by GITHUB\n"

echo -e "${PURPLEm}using system $system ${ENDC}"


# Specify the files to be moved
src_files=(".emacs")
dest_dir="$HOME"



# Perform the move operation with diff check
for src_file in "${src_files[@]}"; do
    for file in $src_file; do
        if [[ -e "$file" ]]; then  # Check if the file exists
            dest_file="$dest_dir/$(basename "$file")"
            move_with_diff "$file" "$dest_file"
        else
            echo -e "${YELLOW}No files found matching $src_file${ENDC}"
        fi
    done
done



# Specify the files to be moved
src_files=("/.emacs.d/*el")
dest_dir="$HOME/.emacs.d/"


# perform the move for other files in .emacs.d
for src_file in "${src_files[@]}"; do
    dest_file="$dest_dir/$(basename "$src_file")"
    move_with_diff "$src_file" "$dest_file"
done



# old, simple but functional script
#\cp -vi .emacs ~/
#\cp -vrf .emacs.d ~/
