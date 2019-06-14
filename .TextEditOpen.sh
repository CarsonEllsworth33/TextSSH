#!/bin/bash

function textssh(){

while [ -n "$1" ]; do
	case "$1" in

		-c) #will be used to copy files over from host
			file_path="$2" #full path of file
			file=""		   #name of file
			path_flag=0    #flag to diff between path to file and file
			file_string="" #string to assemble file name
			path_string="" #string to assemble path name

			#error checks for bad input
			if [ "$file_path" == "" ]; then
				echo "no file path given to copy from host"
				shift
				continue
			elif [ $file_path == ^- ]; then
				echo "option $file_path is not a valid parameter to copy"
				continue
			fi

			#picks apart the string to grab both file name and path
			for (( i="${#file_path}"; i>=0; i-- )); do
				if [ "${file_path:$i-1:1}" == "/"  -a  "$path_flag" == "0" ]; then
					path_flag=1
				elif [ "$path_flag" == "0" ]; then
					file_string+="${file_path:$i-1:1}"
				else
					path_string+="${file_path:$i:1}"
				fi
			done


			#reverses the strings to put the names in proper order
			file=$(echo "$file_string" | rev)
			path_string=$(echo "$path_string" | rev)

			#checks to see if a file is already present in TextSSH.d
			if [ -f /etc/TextSSH.d/"$file" -a -f /etc/TextSSH.d/."$file".tsh ]; then
				host=$(head -n1 /etc/TextSSH.d/"$file".tsh)
				path_to_origin=$(tail -n1 /etc/TextSSH.d/"$file".tsh)
				scp "$host":"$path_to_origin""$file" /etc/TextSSH.d/
			else
				#touch file to remember host and directory
				touch /etc/TextSSH.d/."$file".tsh
				echo "$TEXTSSH_HOSTNAME" > /etc/TextSSH.d/."$file".tsh
				echo "$path_string" >> /etc/TextSSH.d/."$file".tsh
				scp "$TEXTSSH_HOSTNAME":"$file_path" /etc/TextSSH.d/
			fi

			#open file
			open -a "$TEXTSSH_APP_PATH" /etc/TextSSH.d/"$file"

			shift
		;; 

		-h) #will be used for host setup
			hostname="$2"

			#setting up env vars
			export TEXTSSH_HOSTNAME=$hostname
			echo "TEXTSSH_HOSTNAME set ->" $TEXTSSH_HOSTNAME
			shift
			;;

		-l) #will be used to list the files in the hidden directory
			ls /etc/TextSSH.d
		;; 

		-lc) #will be used to edit files on the local machine
			file_path=$2
			open -a "$TEXTSSH_APP_PATH" "$file_path"
			shift
		;;

		-p) #will be used for application path settup
			app_path="$2"
			#setting up env vars

			#check to see if app_path is empty
			if [ "$app_path" == "" ]; then 
				echo "Error: No path given"
				echo "Usage: TextSSH -p 'path/to/application' "

			#regex app_path to see if it is actually an option
			elif [[ $app_path =~ ^-  ]]; then 
				echo "Error: No path given"
				echo "Usage: TextSSH -p 'path/to/application' "

		    else
				export TEXTSSH_APP_PATH=$app_path
				echo "TEXTSSH_APP_PATH set ->" $TEXTSSH_APP_PATH
				shift
		    fi
		;;

		-t) #test option
			echo "this is just a test"
		;;

		-u) #will be used to upload files over to host
			file="$2"

			if [ -f /etc/TextSSH.d/."$file".tsh ]; then
				#grab head and tail
				source=$(head -n1 /etc/TextSSH.d/."$file".tsh)
				file_path=$(tail -n1 /etc/TextSSH.d)
				scp /etc/TextSSH.d/$file $source:$file_path$file
			else
				#only need a destination if a tsh file has not been created
				dest="$3"
				if [ $dest =~ ^- -o "$dest" == "" ]; then
					echo "No destination was provided for the file"
					continue
				fi 
			    scp /etc/TextSSH.d/$file $TEXTSSH_HOSTNAME:\~/$dest$file
				shift
			fi
			shift
		;; 

		--) # The double dash makes them parameters
			shift
        	break
        ;;

        *)
			break
		;;
		
	esac
	shift
done

#Grab Editor Path from env variables
EditorPath=$TEXTSSH_APP_PATH

for file in $@; do
	file_path=/etc/TextSSH.d/$file
    #attempt to open application at $EditorPath
	echo "attempting to open" $file
	open -a "$EditorPath" $file_path

done
 
}
