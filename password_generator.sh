#!/bin/bash


# Display script usage/helpful information
function display_usage() {
    echo "Usage: $0 -l <length> [-n] [-s]"
    echo "Options:"
    echo "  -l <length>: Length of the password (between 8 and 20)"
    echo "  -n: Include numbers in the password"
    echo "  -s: Include symbols in the password"
    echo "  -h: Display this help page"
}

# Check if any arguments are given. If none, display -h and exit
if [[ $# -eq 0 || "$1" == "-h" ]]; then
    display_usage
    exit 0
fi

# Initialize variables
length=0
include_numbers=false
include_symbols=false

# Process CL options
while getopts ":l:n:s:h" opt; do
    case $opt in
        l) # Length of password
            length=$OPTARG
            if [[ $length -lt 8 || $length -gt 20 ]]; then
                echo "Password length must be between 8 and 20"
                exit 1
            fi
        ;;
        n) # Include numbers
            include_numbers=true
            if [[ "$OPTARG" != "" && "$OPTARG" != "-s" ]]; then
                echo "Error: -n should not be followed by an argument. Please see the usage documentation below."
                display_usage
                exit 1
            fi
        ;;
        s) # Include symbols
            include_symbols=true
            if [[ "$OPTARG" != "" && "$OPTARG" != "-n" ]]; then
                echo "Error: -s should not be followed by an argument. Please see the usage documentation below."
                display_usage
                exit 1
            fi
        ;;
        h) # Display help page
            display_usage
            exit 0
        ;;
        \?) # Any other option
            echo "Invalid option: -$OPTARG"
            display_usage
            exit 1
        ;;
    esac
done

# Check if there are any arguments after if both -n and -s are used because for some reason it doesn't check after but checks in between?
shift $((OPTIND - 1))
if [[ $# -gt 0 ]]; then
    echo "Error: Unexpected argument detected. -n and -s should not be followed by any argument. Please see the usage documentation below."
    display_usage
fi

# If length was not set, display help page
if [[ $length -eq 0 ]]; then
    echo "Error: length of password must be specified. Please see the usage documentation below."
    display_usage
    exit 1
fi