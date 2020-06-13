# apcupsd2mqtt

> Publish values from apcupsd to MQTT 🔌🔋

[![mqtt-smarthome](https://img.shields.io/badge/mqtt-smarthome-blue.svg)](https://github.com/mqtt-smarthome/mqtt-smarthome)
[![NPM version](https://badge.fury.io/js/apcupsd2mqtt.svg)](http://badge.fury.io/js/apcupsd2mqtt)
[![Dependency Status](https://img.shields.io/gemnasium/hobbyquaker/apcupsd2mqtt.svg?maxAge=2592000)](https://gemnasium.com/github.com/hobbyquaker/apcupsd2mqtt)
[![Build Status](https://travis-ci.org/hobbyquaker/apcupsd2mqtt.svg?branch=master)](https://travis-ci.org/hobbyquaker/apcupsd2mqtt)
[![XO code style](https://img.shields.io/badge/code_style-XO-5ed9c7.svg)](https://github.com/sindresorhus/xo)
[![License][mit-badge]][mit-url]

This is a fork of https://github.com/hobbyquaker/apcupsd2mqtt which itself was forked from https://github.com/cyberjunky/node-apcupsd.

Below is the forked description:
https://github.com/hameedullah/apcupsd2mqtt - fixes and upgrades. see below changelog for details.
https://github.com/hobbyquaker/apcupsd2mqtt - modified to follow [mqtt-smarthome architectural proposal](https://mqtt-smarthome/mqtt-smarthome).
https://github.com/cyberjunky/node-apcupsd - Original

## Changelog

- fix mqt url param handling
- add authentication to mqtt client
- add custom ups name support

## Install

`$ sudo npm install -g apcupsd2mqtt`

## Usage

The following environment variables are available to run your container:

| Parameter | Mandatory | Default Value | Description | Example |
| --- | --- | --- | --- | --- |
| MQTT_URL | yes | - | mqtt URL, as the parameter name suggests | "mqtt://mqtt:1883" |
| MQTT_TOPIC | no | "ups" | mqtt topic to write values to | "infrastructure/ups" |
| UPSNAME | no | "ups" | used in apcupsd as devicename | "myFancyUPS" |
| USBDEVICE | no | "auto" | the USB device name - if set to auto apcupsd will try to find it on its own | "/dev/usb/hiddev0" |
| A2M_INTERVAL | no | "10" | the interval values should be written to mqtt | "11" |
| DEBUG | no | empty | verbose output if set to "true" | "true" |


## TODO

- Fix documentation
- Improve mqtt publishing
- Improve apcupsd handling

## License

MIT

Copyright (c) 2017 Sebastian Raff
Copyright (c) 2014 Ron Klinkien

[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: LICENSE
