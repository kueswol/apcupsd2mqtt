#!/bin/bash
if [ "$DEBUG" == "true" ]; then
   MQTT_DEBUG="-v debug"
else
   MQTT_DEBUG=""
fi
if [ -z "$UPSNAME" ]; then
    echo "UPSNAME env variable not set"
    exit 1
fi
if [ -z "$USBDEVICE" ]; then
    echo "USBDEVICE env variable not set"
    exit 1
fi
if [ ! -e "$USBDEVICE" ]; then
    echo "Device file does not exist: $USBDEVICE"
    exit 1
fi

if [ -z "$MQTT_URL" ]; then
    echo "MQTT_URL env variable not set"
    exit 1
fi

sed -e "s#%%UPSNAME%%#$UPSNAME#" -e "s#%%USBDEVICE%%#$USBDEVICE#" template/apcupsd.conf.template > /etc/apcupsd/apcupsd.conf
# Start the first process
/sbin/apcupsd
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apcupsd: $status"
  exit $status
fi
echo "Waiting... for apcupsd to get ready"
sleep 2
# Start the second process
/usr/local/bin/apcupsd2mqtt $MQTT_DEBUG  -m $MQTT_URL -u $UPSNAME &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apcupsd2mqtt: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep -v mqtt| grep apcupsd |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep apcupsd2mqtt |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 2
  fi
done


