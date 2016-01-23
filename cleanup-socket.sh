#!/bin/bash

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

