#!/bin/bash
set -e
set -o pipefail
volumio_host='http://192.168.100.200'
stop_music() {
	status=$(curl -s "$volumio_host/api/v1/getState" | jq -r .status)
	echo "$status"
	echo "$status" > volumio_last_state
	if [ $status = "play" ] ; then
		curl -s "$volumio_host/api/v1/commands/?cmd=pause"
	fi
}

resume_music() {
	last_state=$( cat volumio_last_state )
	echo "$last_state"
	if [ $last_state = "play" ] ; then
		curl -s "$volumio_host/api/v1/commands/?cmd=play"
	fi
}

while getopts 'sr' OPTION; do
  case "$OPTION" in
    s)
      echo "Stop the godamm music ! I'm calling"
      stop_music
      ;;

    r)
      echo "I'm done calling, we can put the music back"
      resume_music
      ;;

    ?)
      echo "script usage: $(basename $0) [-s] [-r] " >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

    
