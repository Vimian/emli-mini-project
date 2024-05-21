#!/bin/bash

sudo systemctl stop clean_up.service
sudo systemctl stop motion_trigger.service
sudo systemctl stop time_trigger.service
sudo systemctl stop detect_rain.service
sudo systemctl stop external_trigger.service
sudo systemctl stop serial_to_mqtt_to_serial.service
sudo systemctl stop photos.service
