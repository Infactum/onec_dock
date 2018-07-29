#!/bin/bash

service dbus start
Xorg -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR +extension RENDER -logfile /tmp/Xorg.100.log "$DISPLAY" &>/dev/null &
