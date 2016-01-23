#!/bin/bash
#
# Cleans up (removes) the unix socket used by gcp-cups-connector if somehow the program
# didn't have a chance to do so itself on orderly shutdown, such as after a power outage.
#
# Accepts the location of the config file and the full path to the gcp-cups-connector
# executable as first and second arguments, respectively. Both have defaults, though.
# The full program path is needed to determine whether the program is running or not.
#
# This can be set as the ExecStartPre task in the systemd.service description.
#
set -e

socket_key=monitor_socket_filename
config=${1:-/etc/gcp-cups/gcp-cups-connector.config.json}
prg=${2:-/opt/gcp-cups/gcp-cups-connector}
if [ ! -e $config ] ; then
	echo "Unable to find gcp-cups-connector config file"
	exit 1
fi
socket=$(grep $socket_key $config | sed -e 's/.*: *"//' -e 's/".*//')

if [ -e $socket ] && ! ps ax | grep $prg | grep -v grep >/dev/null; then
	rm -f $socket
fi

