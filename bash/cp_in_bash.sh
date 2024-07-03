

source ~/.bash_color

# RED='\033[00;31m'
# GREEN='\033[00;32'
# YELLOW='\033[00;33'
# BLUE='\033[00;34'
# PURPLE='\033[00;35'
# CYAN='\033[00;36'
# WHITE='\033[00;37'

# ENDC='\033[0m'

echo -e "${REDm}Executing COPY to IN${ENDC}"
echo "Files in Github will be overwritten by local computer files"

echo "using system $system"
echo "using onedrive '$ONEDRIVE'"


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
src_files=("$HOME/.bashrc" "$HOME/.bash_user" "$HOME/.bash_aliases" "$HOME/.bash_os" "$HOME/.bash_color" )
dest_dir="."


# Perform the move operation with diff check
for src_file in "${src_files[@]}"; do
    dest_file="$dest_dir/$(basename "$src_file")"
    move_with_diff "$src_file" "$dest_file"
done



# move .bash_user
# location specific depending on OS
#src_file_name=(".bash_user")
#if [ $system = "Windows" ]
#then
#    src_dir="/cygdrive/c/Users/ander/OneDrive/"
#elif [ $system = "Linux" ]
#then
#    src_dir="$HOME"
#fi


#    src_dir="$HOME"
#src_file="$src_dir/$(basename "$src_file_name")"
#dest_file="$dest_dir/$(basename "$src_file_name")"
#move_with_diff "$src_file" "$dest_file"
