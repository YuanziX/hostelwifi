#!/bin/bash
# shell script to log in and log out of the hostel wifi portal using curl requests

# credentials
USERNAME=''
PASSWORD=''

# URLs for the wifi portal
LOGIN_URL="https://hfw.vitap.ac.in:8090/login.xml"
LOGOUT_URL="https://hfw.vitap.ac.in:8090/logout.xml"

login() {
    response=$(curl -s -k -X POST -d "mode=191&username=$USERNAME&password=$PASSWORD&producttype=0" "$LOGIN_URL")

    # Check the response
    if echo "$response" | grep -q "signed in as"; then
        echo "Logged in successfully."
    elif echo "$response" | grep -q "maximum login limit"; then
        echo "Maximum login limit reached."
    else
        echo "Something went wrong. Failed to log in."
    fi
}

logout() {
    curl -s -k -X POST -d "mode=193&username=$USERNAME&password=$PASSWORD&producttype=0" "$LOGOUT_URL" > /dev/null
    echo "Logged out successfully."
}

print_usage() {
    echo "Usage: $0 [-l|-L] [-o|-O]"
    echo "  -l, --login    Log in to the Sophos Client"
    echo "  -o, --logout   Log out from the Sophos Client"
    echo "  -h, --help     Show this help message"
}

while \[ "$1" != "" \]; do
    case $1 in
        -l | --login )
            shift
            login
            ;;
        -o | --logout )
            shift
            logout
            ;;
        -h | --help )
            shift
            print_usage
            exit 0
            ;;
        * )
            echo "Invalid option: $1"
            print_usage
            exit 1
            ;;
    esac
done

if \[ -z "$USERNAME" \] || \[ -z "$PASSWORD" \]; then
    echo "Error: Username and password must be set."
    exit 1
fi
