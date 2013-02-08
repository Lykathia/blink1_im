#!/bin/bash
# Change Blink(1)'s colour based on Pidgin status.
# Copyright (C) 2013 Evan Lowry <lowry.e@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

BLINK1=`which blink1-tool`

# Pidgin's DBUS settings
DBUS_INTERFACE="im.pidgin.purple.PurpleInterface"
DBUS_SERVICE="im.pidgin.purple.PurpleService"
DBUS_PATH="/im/pidgin/purple/PurpleObject"

# Pigdin Status'
STATUS_OFFLINE=1
STATUS_AVAILABLE=2
STATUS_UNAVAILABLE=3
STATUS_INVISIBLE=4
STATUS_AWAY=5
STATUS_EXTENDED_AWAY=6
STATUS_MOBILE=7
STATUS_TUNE=8

# On exit, shut off the blink1
trap "{ $BLINK1 --off > /dev/null 2>&1; exit $?; }" SIGINT SIGTERM

# Daemon
dbus-monitor --profile "type='signal',interface='$DBUS_INTERFACE',member='SavedstatusChanged'" | 
while read -r line; do
    STATUS=`dbus-send --print-reply --dest=$DBUS_SERVICE $DBUS_PATH $DBUS_INTERFACE.PurpleSavedstatusGetCurrent`
    echo $STATUS
done
