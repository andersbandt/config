

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



# change environment executables
if [ $system = "Windows" ]
then
    alias python='/cygdrive/c/Users/ander/AppData/Local/Programs/Python/Python310/python'
    alias emacs="emacs -q --load ~/.emacs.d/base.el"
elif [ $system = "Linux" ]
then
    alias python="python3"
    alias emacs="emacs -q -nw --load ~/.emacs.d/base.el"
fi


# source user init file
if [ $system = "Windows" ]
then
    source ~/OneDrive/.bashrc_user
elif [ $system = "Linux" ]
then
    source ~/.bashrc_user
fi










