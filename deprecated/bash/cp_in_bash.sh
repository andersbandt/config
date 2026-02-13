
source ../move_with_diff.sh
source ~/.bash_color


# TODO: add some option for user to input revision comments and keep that in the file system


echo -e "${REDm}Executing COPY to IN${ENDC}"
echo -e "${CYANm}Files in Github will be overwritten by local computer files\n"

echo -e "${PURPLEm}using system $system ${ENDC}"


# Specify the files to be moved
src_files=("$HOME/.bashrc" "$HOME/.bash_user" "$HOME/.bash_aliases" "$HOME/.bash_os" "$HOME/.bash_color" )
dest_dir="."


# Perform the move operation with diff check
for src_file in "${src_files[@]}"; do
    dest_file="$dest_dir/$(basename "$src_file")"
    move_with_diff "$src_file" "$dest_file"
done
