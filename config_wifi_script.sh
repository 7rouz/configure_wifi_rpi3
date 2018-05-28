#/bin/sh
set -xe

SSID="$1"
WIFI_PASSWORD="$2"

sudo apt-get update && sudo apt-get upgrade -y 

# Update /etc/wpa_supplicant/wpa_supplicant.conf
sudo bash -c " echo -e 'network={\n ssid=\"$SSID\" \n psk=\"$WIFI_PASSWORD\" \n }' >> /etc/wpa_supplicant/wpa_supplicant.conf"

# Restart Networking service 
sudo service networking restart

# Restart WLAN0 interface
sudo ifconfig wlan0 down && sudo ifconfig wlan0 up

# Restart dhcpd
sudo systemctl daemon-reload
sudo systemctl restart dhcpcd

# wait 30 sec to make sure that the pi has obtained an ip adress
sleep 30

# get the wifi ip adress 
wifi_ip=$(sudo ifconfig wlan0 | grep -e "inet " | awk '{print$2}')

echo "Congratularions your RPI is now connected to WIFI "+$SSID+" and the ip @ is: "+$wifi_ip
