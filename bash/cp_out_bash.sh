
source ./move_with_diff.sh
source ~/.bash_color


echo -e "${REDm}Executing COPY to OUT${ENDC}"
echo -e "${CYANm}Files in LOCAL will be overwritten by GITHUB\n"

echo -e "${PURPLEm}using system $system ${ENDC}"


# Specify the files to be moved
src_files=(".bashrc" ".bash_user" ".bash_aliases" ".bash_os" ".bash_color" )
dest_dir="$HOME"


# Perform the move operation with diff check
for src_file in "${src_files[@]}"; do
    dest_file="$dest_dir/$(basename "$src_file")"
    move_with_diff "$src_file" "$dest_file"
done





