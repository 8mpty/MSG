#!/bin/bash

start() {
    if (whiptail --title "System Update" --yesno "Would you like to update your system?" 0 0); then
        if (whiptail --title "Confirm Update" --yes-button "Yes" --no-button "No" --yesno "Are you sure you want to update the system?" 0 0); then
            update_system
            whiptail --title "Update Complete" --msgbox "Your system has been updated." 0 0
        else
            whiptail --title "Update Skipped" --msgbox "System update was skipped." 0 0
        fi
    else
        whiptail --title "Cancel" --msgbox "Exiting script." 0 0
        exit 1
    fi
}

update_system() {
    echo "Updating and upgrading system..."
    sudo apt update -y
    sudo apt upgrade -y
    
    echo "Installing curl, jq to check PaperMC versions"
    sudo apt install curl -y
    sudo apt-get install -y jq
    
    choose_type
}

choose_type(){
    local type
    type=$(whiptail --title "Download Server Version" \
        --menu "Choose Server Type: "\
        0 0 0\
        "Vanilla" ""\
        "ArcLight" ""\
        "PaperMC" "" \
        "Spigot" "" \
        "Bukkit" "" \
    3>&1 1>&2 2>&3)
    
    if [ $? -eq 0 ]; then
        case "$type" in
            "Vanilla")
                type="Vanila"
                download_vanilla
            ;;
            "ArcLight")
                type="ArcLight"
                download_arclight
            ;;
            "PaperMC")
                type="PaperMC"
                select_paper_version_group
            ;;
            "Spigot")
                type="Spigot"
            ;;
            "Bukkit")
                type="Bukkit"
            ;;
            *)
                echo "Unknown type"
                exit 1
            ;;
        esac
        echo "You selected type: $type"
    else
        echo "Cancelled."
        exit 1
    fi
}

select_paper_version_group() {
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
        select_specific_version "$version_group"
    else
        echo "Cancelled."
        exit 1
    fi
}

select_specific_version() {
    local version_group=$1
    local options
    case "$version_group" in
        "1.21")
            options=("1.21")
        ;;
        "1.20")
            options=("1.20.6" "1.20.5" "1.20.4" "1.20.3" "1.20.2" "1.20.1" "1.20")
        ;;
        "1.19")
            options=("1.19.4" "1.19.3" "1.19.2" "1.19.1" "1.19")
        ;;
        "1.18")
            options=("1.18.2" "1.18.1" "1.18")
        ;;
        "1.17")
            options=("1.17.1" "1.17")
        ;;
        "1.16")
            options=("1.16.5" "1.16.4" "1.16.3" "1.16.2" "1.16.1")
        ;;
        "1.15")
            options=("1.15.2" "1.15.1" "1.15")
        ;;
        "1.14")
            options=("1.14.4" "1.14.3" "1.14.2" "1.14.1" "1.14")
        ;;
        "1.13")
            options=("1.13.2" "1.13.1" "1.13" "1.13-prev7")
        ;;
        "1.12")
            options=("1.12.2" "1.12.1" "1.12")
        ;;
        "1.11")
            options=("1.11.2")
        ;;
        "1.10")
            options=("1.10.2")
        ;;
        "1.9")
            options=("1.9.4")
        ;;
        "1.8")
            options=("1.8.8")
        ;;
        *)
            echo "Unknown version group: $version_group"
            exit 1
        ;;
    esac
    
    local menu_options=""
    for opt in "${options[@]}"; do
        menu_options="${menu_options}${opt} >\n"
    done
    
    local selected_version
    selected_version=$(whiptail --title "Select PaperMC Version" \
        --menu "Select a specific version for $version_group:" \
        0 0 0 \
        $(echo -e "$menu_options") \
    3>&1 1>&2 2>&3)
    
    if [ $? -eq 0 ]; then
        echo "You selected version: $selected_version"
        download_papermc "$version_group" "$selected_version"
    else
        echo "Cancelled."
        exit 1
    fi
}

download_vanilla(){
    local vl="https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar"
    FILENAME=$(whiptail --title "Download Vanilla Version Script" \
        --inputbox "Enter filename for the download (default: server.jar)" \
    8 40 "server.jar" 3>&1 1>&2 2>&3)
    
    if [ $? -ne 0 ]; then
        echo "Cancelled."
        exit 1
    fi
    
    curl -o "${FILENAME}" $vl
    echo "Download completed: ${FILENAME}"
}

download_arclight(){
    local ar="https://github.com/IzzelAliz/Arclight/releases/download/Trials%2F1.0.5/arclight-forge-1.20.1-1.0.5.jar"
    FILENAMEARC=$(whiptail --title "Download ArcLight Version Script" \
        --inputbox "Enter filename for the download (default: server.jar)" \
    8 40 "server.jar" 3>&1 1>&2 2>&3)
    
    if [ $? -ne 0 ]; then
        echo "Cancelled."
        exit 1
    fi
    
    curl -o "${FILENAMEARC}" $ar
    echo "Download completed: ${FILENAMEARC}"
}

download_papermc() {
    local version_group=$1
    local selected_version=$2
    local MINECRAFT_VERSION="$version_group"
    local LATEST_BUILD
    local JAR_NAME
    local PAPERMC_URL
    local FILENAME
    
    echo "Fetching latest build for version $selected_version..."
    LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$selected_version/builds | \
    jq -r '.builds | map(select(.channel == "default") | .build) | .[-1]')
    
    if [ "$LATEST_BUILD" != "null" ]; then
        JAR_NAME=paper-${selected_version}-${LATEST_BUILD}.jar
        PAPERMC_URL="https://api.papermc.io/v2/projects/paper/versions/${selected_version}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}"
        
        FILENAME=$(whiptail --title "Download PaperMC Version Script" \
            --inputbox "Enter filename for the download (Selected Version: $selected_version)" \
        8 40 "server.jar" 3>&1 1>&2 2>&3)
        
        if [ $? -ne 0 ]; then
            echo "Cancelled."
            exit 1
        fi
        
        curl -o "${FILENAME}" $PAPERMC_URL
        echo "Download completed: ${FILENAME}"
    else
        echo "No stable build for version $selected_version found :("
    fi
}

# Main Stuff
start