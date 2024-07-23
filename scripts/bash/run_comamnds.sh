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
        read -p "Enter numbers (1-$num_commands) separated by commas or x to exit: " input
        if [[ $input == "x" || $input == "X" ]]; then
            echo "Exiting"
            exit 0
        elif [[ $input =~ ^[0-9,]+$ ]]; then
            IFS=',' read -ra indices <<< "$input"
            valid_input=true
            for index in "${indices[@]}"; do
                if ! (( index >= 1 && index <= num_commands )); then
                    valid_input=false
                    break
                fi
            done

            if $valid_input; then
                for index in "${indices[@]}"; do
                    command_index=$((index - 1))
                    command=${commands[command_index]}
                    echo "Executing command[$index]: $command"
                    # Execute the command corresponding to the entered number
                    if [[ $command =~ ^[^=]+= ]]; then
                        # If it's a variable assignment, evaluate it in the current shell
                        eval "$command"
                    else
                        # Otherwise, execute the command in a subshell
                        bash -c "$command"
                    fi
                    echo # Insert an empty line between command results
                done
                break
            else
                echo "Enter valid numbers separated by commas or x to exit"
            fi
        else
            echo "Enter valid numbers separated by commas or x to exit"
        fi
    done
done
