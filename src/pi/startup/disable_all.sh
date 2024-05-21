#!/bin/bash

sudo systemctl disable clean_up.service
sudo systemctl disable motion_trigger.service
sudo systemctl disable time_trigger.service
sudo systemctl disable detect_rain.service
sudo systemctl disable external_trigger.service
sudo systemctl disable serial_to_mqtt_to_serial.service
sudo systemctl disable photos.service
