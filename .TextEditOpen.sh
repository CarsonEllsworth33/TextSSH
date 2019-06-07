d#!/bin/bash

function textssh(){

while [ -n "$1" ]; do
	case "$1" in

		-c) #will be used to copy files over from host
			file_path="$2"
			file=""

			#this grabs the file name from the file path
			file_string=""
			for (( i="${#file_path}"; i>=0; i-- )); do
				if [ "${file_path:$i-1:1}" == "/" ]; then
					break
				else
					file_string+="${file_path:$i-1:1}"
				fi
			done
			file=$(echo "$file_string" | rev)

			#checks to see if a file is already present in .TESTSSH.d
			if [ -f ~/.TEXTSSH.d/"$file" ]; then
				#dont woory bout a thing
				echo "you exist!"
			else
				#touch file to remember host and directory
				echo "you dont exist"
				touch ~/.TEXTSSH.d/"$file".tsh
				echo "$TEXTSSH_HOSTNAME" >> ~/.TEXTSSH.d/"$file".tsh
				echo #TO DO file path >> ~/.TEXTSSH.d/"$file".tsh
			fi

			#add code here to copy from ssh to secure 
			#scp $TEXTSSH_HOSTNAME:\~/$file_path ~/.TEXTSSH.d
			#touch ~/.TEXTSSH.d/\.$file\.t
			#echo "$TEXTSSH_HOSTNAME":\~/"$file" ~/.TEXTSSH.d
			#directory then open file
			#open -a $TEXTSSH_APP_PATH $file


			
			echo $file
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
			ls ~/.TEXTSSH.d
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

			elif [[ $app_path =~ ^-  ]]; then # comparison not working atm
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
			dest="$3"
			#add code here to scp over old files and replace 
			scp ~/.TEXTSSH.d/$file $TEXTSSH_HOSTNAME:\~/$dest
			#with the newly editted ones
			shift
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
	file_path=~/.TEXTSSH.d/$file
    #attempt to open application at $EditorPath
	echo "attempting to open" $file
	open -a "$EditorPath" $file_path

done
 
}

