#!/bin/bash
#/home/wiktoria/UA/proby/file.txt

echo "Please give the path to file you want to check" #shows string
read path_to_file #gets path to file from stdin


path_to_dir=$(dirname "${path_to_file}") #extracts path to dir from path to file
file_name=$(basename $path_to_file) #gets filename with extention from path to file
file_extension=${file_name##*.} #gets file extention 
file_name=${file_name%.*} #gets filename without extention
report="report_${file_name}.txt" #creates name of report
path_to_report="${path_to_dir}/${report}" #creates path to report


function create_report_file {
	if [ ! -e "$path_to_report" ] ; then #chcecks if file does not exits
		touch "$path_to_report" #creates file
	fi
}


function change_access_rights {
	echo "Would you like to change the rights now? 1 - yes, 2 - no. "
	read decision
	case "$decision" in
		"1") 
			echo "Do you want to change file or dir rights? 1 - file, 2 - dir. "
			read choice			
			echo "Please write new access rights"
			read new_rights
			case "$choice" in
				"1") 
					chmod $new_rights $path_to_file #changes access rights for file
					echo "Access rights were changed."
					create_report_file #call function
					printf "Rights for $path_to_file were changed to $new_rights \n" >> $path_to_report  #saves information to report
					;;
				"2")
					chmod $new_rights $path_to_dir #changes access rights for dir
					echo "Access rights were changed."
					create_report_file #call function
					printf "Rights for $path_to_dir were changed to $new_rights \n" >> $path_to_report #saves information to report
					;;
				*) 
					echo "No choice was made"	
					;;
			esac
			;;
		"2")
			echo "Thank you for using the script."
			;;
		*)	
			echo "No choice was made"
			;;
	esac	
}


while : ; do 
	
	if [ ! -f $path_to_file ] ; then #checks if path to file is correct
		if [ ! -x "$path_to_dir" ] ; then
			echo "Lack of -x rights for dir." #if dir lacks -x rights there is very little what we can do with it
			change_access_rights #call function
			break
		else
			echo "Incorrect path, file does not exist!"
			break
		fi
	fi
	
	
	create_report_file #call function
			
	
	printf "\n$(date)\n" >> $path_to_report #saves date when script was run to report


	if var=$(cd $path_to_dir) ; then  #checks if can cd on dir
		printf "Can call 'cd' on file.\n" >> $path_to_report #saves information to report
	fi
	
	
	if var=$(ls $path_to_dir) ; then #output of command captured in variable var since it's not important for script user and would make the output messy
		printf "Can call 'ls' on file.\n" >> $path_to_report #saves information to report
	else
		echo 'Cannot call "ls" on file.'
		printf "Cannot call 'ls' on file.\n" >> $path_to_report #saves information to report
		if [ ! -r "$path_to_dir" ] ; then #if dir doesn't have r rights
			printf "Lack of -r rights for dir. \n" >> $path_to_report #saves information to report
			echo "Lack of -r rights for dir."
		fi
		break
	fi
	
	
	if var=$(ls -s $path_to_dir) ; then #checks if can call ls -s on dir
		printf "Can call 'ls -s' on file.\n" >> $path_to_report #saves information to report
	else
		echo 'Cannot call "ls -s" on file.'
		printf "Cannot call 'ls -s' on file.\n" >> $path_to_report #saves information to report
		if [ ! -r "$path_to_dir" ] ; then #if dir doesn't have r rights
			printf "Lack of -r rights for dir. \n" >> $path_to_report #saves information to report
			echo "Lack of -r rights for dir."
		fi
		break
	fi


	if var=$(cat $path_to_file) ; then   #checks if can call cat on file
		printf "Can call 'cat' on file.\n" >> $path_to_report #saves information to report
	else
		echo 'Cannot call "cat" on file.'
		printf "Cannot call 'cat' on file.\n" >> $path_to_report #saves information to report
		if [ ! -r "$path_to_file" ] ; then #if file doesn't have r rights
			printf "Lack of -r rights for file. \n" >> $path_to_report #saves information to report
			echo "Lack of -r rights for file."
		fi
		break
	fi
	
	
	copy_file_name="${file_name}_rm_copy"  #creates name for file copy
	copy_file_path="${path_to_dir}/$copy_file_name.$file_extension"   #creates new path for copy of file
	if cp $path_to_file $copy_file_path  ; then #copying file for removing 
	
		if var=$(rm $copy_file_path) ; then  #checks if can call rm on copied file
			printf "Can call 'rm' on file.\n" >> $path_to_report #saves information to report
		else
			echo 'Cannot call "rm" on file.'
			printf "Cannot call 'rm' on file.\n" >> $path_to_report #saves information to report
			if [ ! -w "$path_to_dir" ] ; then #if dir doesn't have w rights
				printf "Lack of -w rights for dir. \n" >> $path_to_report #saves information to report
				echo "Lack of -w rights for dir."
			fi
			break
		fi
	else 
		break
	fi
	
	
	echo "\n test_string" >${path_to_dir}/test.txt #creates temporary file with "test_string" string
	
	if var=$(cat ${path_to_dir}/test.txt>>$path_to_file) ; then  #checks if can call cat >> on file
		printf "Can call 'cat >>' on file.\n" >> $path_to_report #saves information to report
		var=$(rm -f ${path_to_dir}/test.txt); #removes temporary file
		sed -i '$ d' $path_to_file #deletes last line from file
	else
		echo 'Cannot call "cat >>" on file.'
		printf "Cannot call 'cat >>' on file.\n" >> $path_to_report #saves information to report
		if [ ! -w "$path_to_file" ] ; then #if file doesn't have w rights
			printf "Lack of -w rights for file. \n" >> $path_to_report #saves information to report
			echo "Lack of -w rights for file."
		fi
		var=$(rm -f ${path_to_dir}/test.txt); #deletes temporary file
		break
	fi
	
	echo "All calls correct."
	printf "All calls correct.\n" >> $path_to_report #saves information to report
	break
done
