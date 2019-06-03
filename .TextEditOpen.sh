#!/bin/bash

function TextSSH(){

while [ -n "$1" ]; do
	echo "$1"
	case "$1" in

		-c) #will be used to copy files over from host
			file="$2"
			#add code here
			shift
		;; 
		
		-u) #will be used to upload files over to host
			file="$2"
			#add code here
			shift
		;; 

		-h) #will be used for host setup
			hostname="$2"

			#setting up env vars
			export TEXTSSH_HOSTNAME=$hostname
			echo "TEXTSSH_HOSTNAME set ->" $TEXTSSH_HOSTNAME
			shift
			;;

		-p) #will be used for application path settup
			app_path="$2"

			#setting up env vars
			export TEXTSSH_APP_PATH=$app_path
			echo "TEXTSSH_APP_PATH set ->" $TEXTSSH_APP_PATH
			shift
			;;

		-m) #make a local directory to hold copied files
			dir_path="$2"
			shift
			;;

		-t) #test option
			echo "this is just a test"
			shift
			;;
		--)
        	shift # The double dash makes them parameters
        	break
        ;;

        *)
			echo "breaking @" "$1"
			break
		;;
		
	esac
	shift
done

#define path to editor
EditorPath=$TEXTSSH_APP_PATH
echo "entering for loop with" $1 "this param"
for file in $@; do
    #attempt to open application at $EditorPath
	echo "attempting to open" $file
	open -a "$EditorPath" $file
done


}

