#!/bin/bash

sudo systemctl start clean_up.service
sudo systemctl start motion_trigger.service
sudo systemctl start time_trigger.service
sudo systemctl start detect_rain.service
sudo systemctl start external_trigger.service
sudo systemctl start serial_to_mqtt_to_serial.service
sudo systemctl start photos.service
