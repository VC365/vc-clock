#!/usr/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
DIR_APP="/usr/bin"
install() {
    echo -e "${YELLOW}installing vc-clock...${NC}"
    if [ ! -f vc-clock ]; then
        echo -e "${RED} vc-clock not found in current directory!${NC}"
        exit 1
    fi

	  if [ -f "$DIR_APP/vc-clock" ]; then
	      sudo rm "$DIR_APP/vc-clock"
  	fi
	  chmod a+x vc-clock
	  sudo cp vc-clock "$DIR_APP"
  	echo -e "${GREEN} vc-clock Installed!${NC}"
}

uninstall() {
    sudo rm -f "$DIR_APP/vc-clock" &> /dev/null
    echo -e "${GREEN} vc-clock Deleted!${NC}"
}

if [ "$1" == "install" ]; then
    install
elif [ "$1" == "uninstall" ]; then
    uninstall
else
    echo -e "${RED} Options $0 {install|uninstall}${NC}"
    exit 1
fi
