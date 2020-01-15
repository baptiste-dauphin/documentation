#!/bin/bash
DIR="$(dirname "$0")"

# $DIR/keyboard-fr.sh
# $DIR/monitors-placement.sh
# $DIR/pulseaudio-start.sh
# $DIR/run_keybase.bash
$DIR/ssh_agent.sh
$DIR/system_upgrade.bash