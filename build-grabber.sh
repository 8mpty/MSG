#!/bin/bash

update_system() {
    echo "Updating and upgrading system..."
    sudo apt update -y
    sudo apt upgrade -y
    
    echo "Installing jq to check of PaperMC versions"
    sudo apt-get install -y jq
}

select_version_group() {
    local version_group
    version_group=$(whiptail --title "Download PaperMC Version Script" \
        --menu "Select PaperMC Version Group:" \
        0 0 0 \
        "1.8" "" \
        "1.9" "" \
        "1.10" "" \
        "1.11" "" \
        "1.12" "" \
        "1.13" "" \
        "1.14" "" \
        "1.15" "" \
        "1.16" "" \
        "1.17" "" \
        "1.18" "" \
        "1.19" "" \
        "1.20" "" \
    "1.21" "" 3>&1 1>&2 2>&3)
    
    if [ $? -eq 0 ]; then
        echo "You selected version group: $version_group"
    else
        echo "Cancelled."
        exit 1
    fi
}

# Main Stuff
update_system
select_version_group