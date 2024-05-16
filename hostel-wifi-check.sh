#!/bin/bash
# shell script to login into hostel wifi using caa bin provided by the college

SSID="VITAP-HOSTEL"

CMD="/home/yuanzix/.scripts/caa"

MAX_WIFI_ATTEMPTS=10
MAX_NM_CHECKS=15

WIFI_DELAY=30
NM_DELAY=10

nm_check=1

while ! systemctl is-active --quiet NetworkManager; do
    if [ $nm_check -ge $MAX_NM_CHECKS ]; then
        echo "NetworkManager did not start after $MAX_NM_CHECKS checks. Exiting."
        exit 1
    fi
    echo "NetworkManager is not running. Retrying check $nm_check/$MAX_NM_CHECKS in $NM_DELAY seconds..."
    nm_check=$((nm_check+1))
    sleep $NM_DELAY
done

echo "NetworkManager is running. Attempting to connect to $SSID..."

attempt=1

while true; do
    CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F':' '/^yes/ {print $2}')

    if [ "$CURRENT_SSID" == "$SSID" ]; then
        $CMD
        exit 0
    elif [ $attempt -ge $MAX_WIFI_ATTEMPTS ]; then
        echo "Failed to connect to $SSID after $MAX_WIFI_ATTEMPTS attempts."
        exit 1
    else
        echo "Attempt $attempt/$MAX_WIFI_ATTEMPTS: Not connected to $SSID. Retrying in $WIFI_DELAY seconds..."
        attempt=$((attempt+1))
        sleep $WIFI_DELAY
    fi
done