#!/bin/bash
DIR="$(dirname "$0")"

$DIR/keyboard-fr.sh
$DIR/pulseaudio-start.sh
$DIR/blueman-start.sh
$DIR/monitors-placement.sh
$DIR/ssh_agent.sh
