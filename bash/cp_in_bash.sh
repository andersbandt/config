


system="Linux"
echo "using system $system"

cp -iv ~/.bashrc .


echo "using onedrive '$ONEDRIVE'"
#cp -iv $ONEDRIVE/.bashrc_user .

if [ $system = "Windows" ]
   then
       cp -iv $ONEDRIVE/.bashrc_user .
elif [ $system = "Linux" ]
then
    cp -iv ~/.bashrc_user .
fi

   

