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
filename=""
include_numbers=false
include_symbols=false
letters="a-zA-Z"
numbers="0-9"
symbols="!@#$%&*()"

# Process CL options
while getopts ":l: n s h" opt; do
    case $opt in
        l) # Length of password
            length=$OPTARG
            if [[ $length -lt 8 || $length -gt 40 ]]; then
                echo "Password length must be between 8 and 20"
                exit 1
            fi
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
while true; do
    password=$(head /dev/urandom | tr -dc "$characters" | head -c "$length")

    # Validation check if -n is used
    if $include_numbers && [[ ! "$password" =~ [0-9] ]]; then
        echo "Password does not contain a number. Regenerating..."
        continue
    fi
    
    # Validation check if -n is not used
    if ! $include_numbers && [[ "$password" =~ [0-9] ]]; then
        echo "Password should not contain numbers. Regenerating..."
        continue
    fi

    # Validation check if -s is used
    if $include_symbols && ! [[ "$password" =~ [!@#$%\&\*\(\)] ]]; then
        echo "Password does not contain a symbol. Regenerating..."
        continue
    fi

    # Validation check if -s is not used
    if ! $include_symbols && [[ "$password" =~ [!@#$%\&\*\(\)] ]]; then
        echo "Password should not contain symbols. Regenerating..."
        continue
    fi

    break
done

# Store the password
echo "$password" > ./super_secret.txt
echo "$password"
echo "Your new password has been stored in super_secret.txt"