


if [ $system = "Windows" ]
then
    BASEPATH="/cygdrive/c/Users/ander"
    ONEDRIVE=$HOME/OneDrive
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
alias ander='cd $BASEPATH'
alias appdata='cd $BASEPATH/AppData'
alias programfiles='cd "/cygdrive/c/Program Files"'

### EASY NATIVE WINDOWS ###
alias downloads='cd $BASEPATH/Downloads'
alias desktop='cd $BASEPATH/Desktop'
alias documents='cd $BASEPATH/Documents'
alias pictures='cd $BASEPATH/Pictures'

### LOCAL FILES ###
alias screenshots='cd $BASEPATH/Pictures/Screenshots'
alias obs='cd $BASEPATH/Documents/Obsidian'
alias obse='cd $BASEPATH/Documents/Obsidian/engineering'
alias obsp='cd $BASEPATH/Documents/Obsidian/pathless'
alias recipes='cd $BASEPATH/Documents/Obsidian/pathless/recipes'
alias ccs='cd $BASEPATH/Documents/CCS/'
alias ncs='cd $BASEPATH/Documents/NCS/'
alias altium='cd $BASEPATH/Documents/Altium/'
alias kicad='cd $BASEPATH/Documents/KiCAD/'
alias github='cd ~/Documents/GitHub'


### ONE DRIVE ###
alias one='cd $ONEDRIVE/'
alias onepictures='cd $ONEDRIVE/Pictures'
alias onedocuments='cd $ONEDRIVE/Documents'
alias projects='cd $ONEDRIVE/Projects'
alias filetransfer='cd $ONEDRIVE/FileTransfer'
alias pcb='cd $ONEDRIVE/PCB_Library'

# Code
alias code='cd $ONEDRIVE/Code/'
alias arduino='cd $ONEDRIVE/Code/Arduino'
alias embedded='cd $ONEDRIVE/Code/embedded'
alias gopython='cd $ONEDRIVE/Code/python'
alias matlab='cd $ONEDRIVE/Code/MATLAB'

# Documents
alias education='cd $ONEDRIVE/Documents/education'
alias engineering='cd $ONEDRIVE/Documents/engineering'
alias living='cd $ONEDRIVE/Documents/living'
alias health='cd $ONEDRIVE/Documents/health'
alias writings='cd $ONEDRIVE/Documents/writings'

## financials
alias financials='cd $ONEDRIVE/Documents/financials'
alias monthlystatements='cd $ONEDRIVE/Documents/financials/2026/monthly_statements'


##############################
### NAV VARIABLES          ###
##############################
onedrive_t="$ONEDRIVE"
projects_t="$ONEDRIVE/Projects"
code_t="$ONEDRIVE/Code"
documents_t='/cygdrive/c/Users/ander/Documents/'
financials_t="$ONEDRIVE/Documents/financials/"
filetransfer_t="$ONEDRIVE/FileTransfer"


### specific projects
alias config='cd $BASEPATH/Documents/GitHub/config'


# WWD
alias wwd='cd $ONEDRIVE/Projects/WWD'
alias wwddatasheet='cd $ONEDRIVE/Projects/WWD/electrical/datasheets'
alias wwddocumentation='cd $ONEDRIVE/Projects/WWD/documentation'
alias wwdfirmware='cd $ONEDRIVE/Projects/WWD/firmware'
alias wwdprog='cd $BASEPATH/Documents/NCS/WWD-n/src'
alias wwdncs='cd $BASEPATH/Documents/NCS/WWD-n'
alias wwdcode='cd $ONEDRIVE/Code/python/WWD/'
#alias wwdlog='cd $BASEPATH/Documents/GitHub/wwd_gui_api/log/'
alias wwdlog='/home/anders/Code/bash/tail_recent.sh'
wwd_t="$ONEDRIVE/Projects/WWD"
wwdccs_t="$BASEPATH/Documents/CCS/workspace_WWD/WWD_prog/"

alias wwdapi='python3 ~/Documents/GitHub/wwd_gui_api/main.py'

# Hidden-Hydroponics
alias hydroponics='cd $ONEDRIVE/Projects/hidden_hydroponic'
alias vanlife='cd $ONEDRIVE/Projects/Van_Life'
if [ $system = "Windows" ]
then
    _FA_SCRIPT="$(cygpath -m "$BASEPATH/Documents/GitHub/Financial-Analyzer/src/main.py")"
elif [ $system = "Linux" ]
then
    _FA_SCRIPT="$HOME/Documents/GitHub/Financial-Analyzer/src/main.py"
fi
alias fa="python $_FA_SCRIPT"
alias fa-load="python $_FA_SCRIPT -41"
alias fa-spend="python $_FA_SCRIPT -51"
alias fa-balances="python $_FA_SCRIPT -61"
alias fa-invest="python $_FA_SCRIPT -91"

