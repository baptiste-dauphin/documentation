#!/bin/bash
DIR="$(dirname "$0")"

$DIR/system_upgrade.bash
$DIR/keyboard-fr.sh
$DIR/pulseaudio-start.sh
$DIR/monitors-placement.sh
$DIR/ssh_agent.sh
# $DIR/run_keybase.bash