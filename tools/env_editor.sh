#!/usr/bin/env bash

##############################################################################
# Chmod: chmod +x /root/azuracast_installer/tools/env_editor.sh
# Start with: /root/azuracast_installer/tools/env_editor.sh
#
# Check here: https://docs.azuracast.com/en/getting-started/settings
#
# Interactive Mode
#
# --add variable=value
# --update variable=value
# --delete variable
##############################################################################

# Set the path to your env file
ENV_FILE=/var/azuracast/www/azuracast.env

# Prompt for new variable and value
function add_variable_interactive {
    read -p "Enter the variable name: " name
    read -p "Enter the variable value: " value
    echo "$name=$value" >>$ENV_FILE
}

# New variable and value over cli
function add_variable_commandline {
    name="$1"
    value="$2"
    echo "$name=$value" >>$ENV_FILE
}

# Prompt for variable to delete
function delete_variable_interactive {
    read -p "Enter the variable name to delete: " name
    if grep -q "^$name=" $ENV_FILE; then
        sed -i "/^$name=/d" $ENV_FILE
        echo "Variable $name deleted."
    else
        echo "Variable $name not found."
    fi
}

# Delete variable over cli
function delete_variable_commandline {
    name="$1"
    if grep -q "^$name=" $ENV_FILE; then
        sed -i "/^$name=/d" $ENV_FILE
        echo "Variable $name deleted."
    else
        echo "Variable $name not found."
    fi
}

# Prompt for variable to update
function update_variable_interactive {
    read -p "Enter the variable name to update: " name
    if grep -q "^$name=" $ENV_FILE; then
        read -p "Enter the new variable value: " value
        sed -i "s/^$name=.*/$name=$value/" $ENV_FILE
        echo "Variable $name updated."
    else
        echo "Variable $name not found."
    fi
}

# Update variable over cli
function update_variable_commandline {
    name="$1"
    value="$2"
    if grep -q "^$name=" $ENV_FILE; then
        sed -i "s/^$name=.*/$name=$value/" $ENV_FILE
        echo "Variable $name updated."
    else
        echo "Variable $name not found."
    fi
}

# Display current env variables
function display_variables {
    echo ""
    echo "Current environment variables:"
    cat $ENV_FILE
}

# Parse command line arguments
if [[ $# -gt 0 ]]; then
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
        --add)
            var="$2"
            IFS='=' read -r name value <<<"$var"
            add_variable_commandline "$name" "$value"
            echo "Variable $name added."
            shift 2
            ;;
        --delete)
            name="$2"
            delete_variable_commandline "$name"
            shift 2
            ;;
        --update)
            var="$2"
            IFS='=' read -r name value <<<"$var"
            update_variable_commandline "$name" "$value"
            shift 2
            ;;
        *)
            echo "Invalid argument: $key"
            exit 1
            ;;
        esac
    done
else
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
        1) add_variable_interactive ;;
        2) delete_variable_interactive ;;
        3) update_variable_interactive ;;
        4) display_variables ;;
        q)
            echo "Exiting..."
            exit
            ;;
        *) echo "Invalid option" ;;
        esac
    done
fi
