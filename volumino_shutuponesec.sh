#!/bin/bash
set -e
set -o pipefail
volumio_host='http://192.168.100.200'
stop_music() {
	curl -s "$volumio_host/api/v1/getState" -o volumio_state
	status=$(jq -r .status volumio_state)
	type_media=$(jq -r .trackType volumio_state)
	echo "$status"
	echo "$type_media"
	if [ $status = "play" ] ; then
		if [ $type_media = "webradio" ] ; then
			curl -s "$volumio_host/api/v1/commands/?cmd=stop"
		else
			curl -s "$volumio_host/api/v1/commands/?cmd=pause"
		fi
	fi
}

resume_music() {
	last_state=$(jq -r .status volumio_state)
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
