#!/bin/bash

sudo systemctl enable clean_up.service
sudo systemctl enable motion_trigger.service
sudo systemctl enable time_trigger.service
sudo systemctl enable detect_rain.service
sudo systemctl enable external_trigger.service
sudo systemctl enable serial_to_mqtt_to_serial.service
sudo systemctl enable photos.service
