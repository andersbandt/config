
source ../move_with_diff.sh
source ~/.bash_color


echo -e "${REDm}Executing COPY to IN for EMCACS${ENDC}"
echo -e "${CYANm}Files in Github will be overwritten by local computer files\n"

echo -e "${PURPLEm}using system $system ${ENDC}"


# Specify the files to be moved
src_files=("$HOME/.emacs")
dest_dir="."


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
src_files=("$HOME/.emacs.d/*el")
dest_dir=".emacs.d/"


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
