#!/bin/bash

# set a default value for UPSNAME so one can ommit this variable
UPSNAME="${UPSNAME:-ups}"

# set a default value for USBDEVICE, if not already provided
#   setting it to "auto" will trigger auto detection by apcupsd
USBDEVICE="${USBDEVICE:-auto}"

if [ "$USBDEVICE" != "auto" ] && [ ! -e "$USBDEVICE" ]; then
    echo "Device file does not exist: $USBDEVICE"
    exit 1
fi

if [ -z "$MQTT_URL" ]; then
    echo "MQTT_URL env variable not set"
    exit 1
fi

# replace parameters in template
#   we'll delete the device, if it is set to "auto"
if [ "$USBDEVICE" == "auto" ]; then
    sed -e "s#%%UPSNAME%%#$UPSNAME#" -e "#%%USBDEVICE%%#d" template/apcupsd.conf.template > /etc/apcupsd/apcupsd.conf
else
    sed -e "s#%%UPSNAME%%#$UPSNAME#" -e "s#%%USBDEVICE%%#$USBDEVICE#" template/apcupsd.conf.template > /etc/apcupsd/apcupsd.conf
fi

# Start the first process
/sbin/apcupsd
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apcupsd: $status"
  exit $status
fi
echo "Waiting... for apcupsd to get ready"
sleep 2

# build apcupsd2mqtt parameters
A2M_PARAMS="-m ${MQTT_URL} -u ${UPSNAME}"

if [ "$DEBUG" == "true" ]; then
    A2M_PARAMS="${A2M_PARAMS} -v debug"
fi
if [ ! -z "${MQTT_TOPIC}" ]; then
    A2M_PARAMS="${A2M_PARAMS} -n ${MQTT_TOPIC}"
fi
if [ ! -z "${A2M_INTERVAL}" ]; then
    A2M_PARAMS="${A2M_PARAMS} -i ${A2M_INTERVAL}"
fi

# Start the second process
/usr/local/bin/apcupsd2mqtt ${A2M_PARAMS} &
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


