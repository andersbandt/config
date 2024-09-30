


if [ $system = "Windows" ]
then
    BASEPATH="/cygdrive/c/Users/ander"
    ONEDRIVE="$HOME/OneDrive"
elif [ $system = "Linux" ]
then
    BASEPATH="/home/anders"
    ONEDRIVE="$HOME"
fi

#############################
### NAVIGATION ALLIAS      ###
##############################
#### GENERAL ###
alias c='cd /cygdrive/c'
alias d='cd /cygdrive/d'
alias ti='cd $BASEPATH/ti'
alias tmp='cd ~/tmp'
alias ander='cd /cygdrive/c/Users/ander'

### EASY NATIVE WINDOWS ###
alias downloads='cd $BASEPATH/Downloads'
alias desktop='cd $BASEPATH/Desktop'
alias documents='cd $BASEPATH/Documents'


### ONE DRIVE ###
alias onedrive='cd $ONEDRIVE/'
alias filetransfer='cd $ONEDRIVE/FileTransfer'

alias engineering='cd "$ONEDRIVE/Documents/engineering"'
alias financials='cd $ONEDRIVE/Documents/financials'
alias monthlystatements='cd $ONEDRIVE/Documents/financials/2023/monthly_statements'


alias code='cd $ONEDRIVE/Code/'
alias arduino='cd $ONEDRIVE/Code/Arduino'
alias embedded='cd $ONEDRIVE/Code/embedded'
alias gopython='cd $ONEDRIVE/Code/python'
alias matlab='cd $ONEDRIVE/Code/MATLAB'
alias obsidian='cd $BASEPATH/Documents/Obsidian'
alias ccs='cd $BASEPATH/Documents/CCS/'
alias altium='cd $BASEPATH/Documents/Altium/'
alias github='cd ~/Documents/GitHub'
alias projects='cd $ONEDRIVE/Projects'


##############################
### NAV VARIABLES          ###
##############################
onedrive_t='$ONEDRIVE/'
projects_t='$ONEDRIVE/Projects'
code_t='$ONEDRIVE/Code'
documents_t='/cygdrive/c/Users/ander/Documents/'
financials_t='$ONEDRIVE/Documents/Financials/'
filetransfer_t='$ONEDRIVE/FileTransfer'


### specific projects
alias config='cd $BASEPATH/Documents/GitHub/config'


# WWD
alias wwd='cd $ONEDRIVE/Projects/WWD'
alias wwddatasheet='cd $ONEDRIVE/Projects/WWD/electrical/datasheets'
alias wwddocumentation='cd $ONEDRIVE/Projects/WWD/documentation'
alias wwdfirmware='cd $ONEDRIVE/Projects/WWD/firmware'
alias wwdccs='cd $BASEPATH/Documents/CCS/workspace_WWD/WWD_prog'
alias wwdcode='cd $ONEDRIVE/Code/python/WWD/'
#alias wwdlog='cd $BASEPATH/Documents/GitHub/wwd_gui_api/log/'
alias wwdlog='/home/anders/Code/bash/tail_recent.sh'
wwd_t='$ONEDRIVE/Projects/WWD'
wwdccs_t="$BASEPATH/Documents/CCS/workspace_WWD/WWD_prog/"

alias wwdapi='python ~/Documents/GitHub/wwd_gui_api/main.py'

# Hidden-Hydroponics
alias hydroponics='cd $ONEDRIVE/Projects/hidden_hydroponic'
alias vanlife='cd $ONEDRIVE/Projects/Van_Life'
alias financeanalyzer='$HOME/Documents/GitHub/Financial-Analyzer/run_finance.sh'

