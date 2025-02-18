#!/bin/bash


#Display script usage/helpful information
function display_usage() {
    echo "Usage: $0 -l <length> [-n] [-s]"
    echo "Options:"
    echo "  -l <length>: Length of the password (between 8 and 20)"
    echo "  -n: Include numbers in the password"
    echo "  -s: Include symbols in the password"
    echo "  -h: Display this help page"
}

#Check if any arguments are given. If none, display -h and exit
if [[ $# -eq 0 || "$1" == "-h" ]]; then
    display_usage
    exit 0
fi

#Initialize variables
length=0
include_numbers=false
include_symbols=false

