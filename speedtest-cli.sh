#!/bin/bash

# Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Root access checking
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run script with root access.${NC}"
        echo "For example: sudo ./speedtest-cli.sh"
        exit
    fi
}

# Install/Update Speedtest function
install_or_update_speedtest() {
    echo -e "${YELLOW}--- Speedtest version checking ---${NC}"
    
    # 1. Installed checking
    if ! command -v speedtest &> /dev/null; then
        echo -e "${CYAN}Speedtest is not installed. New install is in progress...${NC}"
        
        # Dependencies installation
        apt-get update -qq
        apt-get install -y curl gnupg1 apt-transport-https dirmngr
        
        # Adding Ookla repo
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
        
        # Installation
        apt-get install -y speedtest
        echo -e "${GREEN}Installation complete!${NC}"
    else
        # 2. If it's already installed, do version checking
        echo -e "Update checking..."
        apt-get update -qq
        
        # Getting current version
        CURRENT_VER=$(dpkg -s speedtest 2>/dev/null | grep '^Version:' | awk '{print $2}')
        
        # Get newest version from repo (Candidate)
        CANDIDATE_VER=$(apt-cache policy speedtest | grep 'Candidate:' | awk '{print $2}')
        
        if [ "$CURRENT_VER" == "$CANDIDATE_VER" ]; then
            echo -e "${GREEN}You are using the newest version ($CURRENT_VER). No need update.${NC}"
        else
            echo -e "${YELLOW}New version found!${NC}"
            echo "Current: $CURRENT_VER"
            echo "Newest: $CANDIDATE_VER"
            echo -e "${CYAN}Updating...${NC}"
            
            apt-get install --only-upgrade -y speedtest
            echo -e "${GREEN}Update to $CANDIDATE_VER successfully!${NC}"
        fi
    fi
    read -p "Press enter to return menu..."
}

# Automatic speedtest function
run_auto_speedtest() {
    if ! command -v speedtest &> /dev/null; then
        echo -e "${RED}Error: Speedtest is not installed. Please select option 1 first.${NC}"
    else
        echo -e "${GREEN}--- Automatic speedtest is running (Auto Server) ---${NC}"
        # Add ACCEPT flag
        speedtest --accept-license --accept-gdpr
    fi
    read -p "Press enter to return menu..."
}

# Manual Speedtest function (Manual ID input)
run_manual_id_speedtest() {
    if ! command -v speedtest &> /dev/null; then
        echo -e "${RED}Error: Speedtest is not installed. Please select option 1 first.${NC}"
        read -p "Press enter to return menu..."
        return
    fi

    echo -e "${YELLOW}--- Manual Speedtest (Using server ID) ---${NC}"
    echo "You can get server ID at: https://c.speedtest.net/speedtest-servers-static.php"
    echo "Or using Google search."
    echo ""
    read -p "Input server ID that you want to test: " server_id

    # Check input ID is valid or invalid
    if [[ ! "$server_id" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid ID. Please input a valid ID containing numbers only.${NC}"
    else
        echo -e "${GREEN}Connecting to  Server ID: $server_id ...${NC}"
        speedtest -s "$server_id" --accept-license --accept-gdpr
    fi
    read -p "Press enter to return menu..."
}

# Uninstall function
uninstall_speedtest() {
    echo -e "${YELLOW}--- Uninstalling Speedtest ---${NC}"
    apt-get remove --purge -y speedtest
    
    # Delete list repo for system cleaning
    rm /etc/apt/sources.list.d/ookla_speedtest-cli.list 2>/dev/null
    rm /etc/apt/sources.list.d/ookla_speedtest-cli.list.save 2>/dev/null
    
    apt-get update -qq
    echo -e "${GREEN}Uninstallation complete.${NC}"
    read -p "Press enter to return menu..."
}

# Main menu
while true; do
    clear
    echo -e "${CYAN}=============================================${NC}"
    echo -e "${CYAN}   SPEEDTEST MANAGEMENT (OOKLA OFFICIAL)    ${NC}"
    echo -e "${CYAN}=============================================${NC}"
    echo "1. Install / Update Speedtest"
    echo "2. Automatic speedtest"
    echo "3. Manual speedtest"
    echo "4. Uninstall Speedtest"
    echo "5. Exit"
    echo -e "${CYAN}=============================================${NC}"
    read -p "Options [1-5]: " choice

    case $choice in
        1)
            check_root
            install_or_update_speedtest
            ;;
        2)
            run_auto_speedtest
            ;;
        3)
            run_manual_id_speedtest
            ;;
        4)
            check_root
            uninstall_speedtest
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Your option is invalid.${NC}"
            sleep 1
            ;;
    esac
done 
