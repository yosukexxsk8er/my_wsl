#!/bin/bash

# Command list file path
command_list_file="./command_list.txt"

while true; do
    # Read commands from the command list file
    commands=()
    while IFS= read -r line || [[ -n $line ]]; do
        commands+=("$line")
    done < "$command_list_file"

    # Get the number of commands
    num_commands=${#commands[@]}

    # Display the numbered command list
    echo -e "\n=== Command list:===="
    for i in "${!commands[@]}"; do
        echo "  $((i+1)): ${commands[i]}"
    done

    # Wait for user input
    while true; do
        read -p "Enter a number (1-$num_commands) or x to exit: " input
        if [[ $input =~ ^[0-9]+$ ]] && (( input >= 1 && input <= num_commands )); then
            command_index=$((input - 1))
            command=${commands[command_index]}
            echo "Executing command: $command"
            # Execute the command corresponding to the entered number
            eval "$command"
            break
        elif [[ $input == "x" || $input == "X" ]]; then
            echo "Exiting"
            exit 0
        else
            echo "Enter a valid number or x to exit"
        fi
    done
done