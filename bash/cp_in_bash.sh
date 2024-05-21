

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


source ~/OneDrive/.bashrc_user


echo "using system $system"
echo "using onedrive '$ONEDRIVE'"


cp -iv ~/.bashrc .
cp -iv ~/.bashrc_color .





if [ $system = "Windows" ]
then
    cp -iv $ONEDRIVE/.bashrc_user .
elif [ $system = "Linux" ]
then
    cp -iv ~/.bashrc_user .
fi

   

