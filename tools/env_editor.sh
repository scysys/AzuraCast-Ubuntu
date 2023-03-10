#!/usr/bin/env bash

##############################################################################
# Chmod: chmod +x /root/azuracast_installer/tools/env_editor.sh
# Start with: /root/azuracast_installer/tools/env_editor.sh
#
# Check here: https://docs.azuracast.com/en/getting-started/settings
##############################################################################

# Set the path to your env file
ENV_FILE=/var/azuracast/www/azuracast.env

# Prompt for new variable and value
function add_variable {
    read -p "Enter the variable name: " name
    read -p "Enter the variable value: " value
    echo "$name=$value" >>$ENV_FILE
}

# Prompt for variable to delete
function delete_variable {
    read -p "Enter the variable name to delete: " name
    sed -i "/^$name=/d" $ENV_FILE
}

# Prompt for variable to update
function update_variable {
    read -p "Enter the variable name to update: " name
    read -p "Enter the new variable value: " value
    sed -i "s/^$name=.*/$name=$value/" $ENV_FILE
}

# Display current env variables
function display_variables {
    echo "Current environment variables:"
    cat $ENV_FILE
}

# Loop through options until user chooses to quit
while true; do
    # Prompt for options
    echo ""
    echo "Select an option:"
    echo "1. Add a variable"
    echo "2. Delete a variable"
    echo "3. Update a variable"
    echo "4. Display current variables"
    echo "q. Quit"
    read -p "> " choice

    # Handle choices
    case $choice in
    1) add_variable ;;
    2) delete_variable ;;
    3) update_variable ;;
    4) display_variables ;;
    q)
        echo "Exiting..."
        exit
        ;;
    *) echo "Invalid option" ;;
    esac
done
