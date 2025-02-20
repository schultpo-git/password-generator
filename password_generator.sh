#!/bin/bash


# Display script usage/helpful information
function display_usage() {
    echo "Usage: $0 -l <length> -f <filename> [-n] [-s]"
    echo "Options:"
    echo "  -l <length>: Length of the password (between 8 and 20)"
    echo "  -f <filename>: Name of the file the password will be stored in"
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
filename=""
include_numbers=false
include_symbols=false
letters="a-zA-Z"
numbers="0-9"
symbols="!@#$%^&*()-_=+[]{}|;:,.<>?/\`~"

# Process CL options
while getopts ":l:f: n s h" opt; do
    case $opt in
        l) # Length of password
            length=$OPTARG
            if [[ $length -lt 8 || $length -gt 20 ]]; then
                echo "Password length must be between 8 and 20"
                exit 1
            fi
        ;;
        f) #File name
            filename=$OPTARG
            echo $filename
        ;;
        n) # Include numbers
            include_numbers=true
        ;;
        s) # Include symbols
            include_symbols=true
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

# Check if there are any arguments after both -n and -s
shift $((OPTIND - 1))
if [[ $# -gt 0 ]]; then
    echo "Error: Unexpected argument detected. -n and -s should not be followed by any argument. Please see the usage documentation below."
    display_usage
    exit 1
fi

# If length was not set, display help page
if [[ $length -eq 0 ]]; then
    echo "Error: length of password must be specified. Please see the usage documentation below."
    display_usage
    exit 1
fi

# If file name was not set, display help page
if [[ -z $filename || $filename == "-n" || $filename == "-s" ]]; then
    echo "Error: The name of the file the password will be stored in must be specified. Please see the usage documentation below."
    display_usage
    exit 1
fi

# Characters to be used for password generation
characters=$letters

if $include_numbers; then
    characters+=$numbers
fi
if $include_symbols; then
    characters+=$symbols
fi

echo "$characters"

# Generate the password
password=$(head /dev/urandom | base64 | tr -dc "$characters" | head -c "$length")

# Store the password
echo "$password"
echo "$password" > ./$filename.txt