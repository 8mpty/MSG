#!/bin/bash

update_system() {
    echo "Updating and upgrading system..."
    sudo apt update -y
    sudo apt upgrade -y
    
    echo "Installing jq to check PaperMC versions"
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
    else
        echo "Cancelled."
        exit 1
    fi
}

# Main Stuff
# update_system
select_version_group