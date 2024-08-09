#!/bin/bash

update_system() {
    echo "Updating and upgrading system..."
    sudo apt update -y
    sudo apt upgrade -y
    
    echo "Installing jq to check of PaperMC versions"
    sudo apt-get install -y jq
}

update_system