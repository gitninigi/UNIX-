#!/bin/bash
dir_path=/home/wiktoria/UA/testy/pliki_testowe #path to dir
file_name="test.c" #file name
file_path="${dir_path}/${file_name}" #creates file path
report="report_test.txt" #creates name of report
path_to_report="${dir_path}/${report}" #creates path to report

if [ ! -e "$dir_path" ] ; then #chcecks if dir does not exits
	mkdir $dir_path #creates dir at provided path
	if [ ! -e "$path_to_report" ] ; then #chcecks if file does not exits
		touch $file_path #creates file at provided path
	fi
fi

function compare_reports { #checks if template and generated reports are the same
	if cmp --silent $1 $path_to_report ; then #compares template report and report generated by admin.sh
		echo "Test was successfull."
	else
		echo "Test was unsuccessfull."
	fi
	rm $path_to_report #removes report generated by admin.sh
}

echo "What test do you want to run?"
echo "1) checks situation when all rights are given" 
echo "2) checks situation when dir is not given x rights but all other are provided" 
echo "3) checks situation when dir is not given r rights but all other are provided" 
echo "4) checks situation when file is not given w rights but all other are provided" #poprawic
echo "5) checks situation when file is not given r rights but all other for file and dir are provided"
echo "6) check if function change_access_rights is working correctly for dir" 
echo "7) check if function change_access_rights is working correctly for file"
echo "8) check if function create_report_file is working correctly" 
echo "9) show menu" 
echo "10) exit" 

while : ; do 
	read choice
	
	case "$choice" in
		"1") 
			path_to_template_report=/home/wiktoria/UA/testy/reports/template_all_correct.txt #creates path to template report
			chmod 755 $dir_path
			chmod 755 $file_path
			./admin.sh $file_path #calls script
			compare_reports $path_to_template_report #calls function for comparing reports
			;;
		"2") 
			echo "Test cannot be run due to lack of rights."
			;;
		"3") 
			path_to_template_report=/home/wiktoria/UA/testy/reports/template_dir_r.txt #creates path to template report
			chmod u-r,g-r,o-r $dir_path
			chmod 755 $file_path
			./admin.sh $file_path #calls script
			chmod 755 $dir_path
			compare_reports $path_to_template_report #calls function for comparing reports
			;;
		"4")
			path_to_template_report=/home/wiktoria/UA/testy/reports/template_file_w.txt #creates path to template report
			chmod 755 $dir_path
			chmod u-w,g-w,o-w $file_path
			./admin.sh $file_path #calls script
			chmod 755 $file_path
			compare_reports $path_to_template_report #calls function for comparing reports
			;;
		"5")
			path_to_template_report=/home/wiktoria/UA/testy/reports/template_file_r.txt #creates path to template report
			chmod 755 $dir_path
			chmod u-r,g-r,o-r $file_path
			./admin.sh $file_path #calls script
			chmod 755 $file_path
			compare_reports $path_to_template_report #calls function for comparing reports
			;;
		"6")
			chmod 755 $dir_path
			chmod 755 $file_path
			source ./admin.sh $file_path #loads script for calling functions from it
			change_access_rights 1 2 u-w,g-w,o-w #calls function from admin.sh with parameters
			if [ -w "$dir_path" ] ; then #checks if operation changed w rights for dir
				echo "Test was unsuccessfull."
			else
				echo "Test was successfull."
			fi	
			chmod 755 $dir_path
			rm $path_to_report #removes report generated by admin.sh
			;;
		"7")
			chmod 755 $dir_path
			chmod 755 $file_path
			source ./admin.sh $file_path #loads script for calling functions from it
			change_access_rights 1 1 u-w,g-w,o-w #calls function from admin.sh with parameters
			if [ -w "$file_path" ] ; then #checks if operation changed w rights for file
				echo "Test was unsuccessfull."
			else
				echo "Test was successfull."
			fi	
			chmod 755 $file_path
			rm $path_to_report #removes report generated by admin.sh
			;;	
		"8")
			source ./admin.sh $file_path #for calling function from admin.sh	
			create_report_file #calls function from admin.sh
			if [ -e "$path_to_report" ] ; then #chceck if report file was created
				echo "Test was successfull."
				rm $path_to_report #deletes report 
			fi
			;;
		"9")
			echo "What test do you want to run?"
			echo "1) checks situation when all rights are given" 
			echo "2) checks situation when dir is not given x rights but all other are provided" 
			echo "3) checks situation when dir is not given r rights but all other are provided" 
			echo "4) checks situation when file is not given w rights but all other are provided" 
			echo "5) checks situation when file is not given r rights but all other for file and dir are provided"
			echo "6) check if function change_access_rights is working correctly for dir" 
			echo "7) check if function change_access_rights is working correctly for file" 
			echo "8) check if function create_report_file is working correctly" 
			echo "9) show menu"
			echo "10) exit" 
			;;
		"10")
			break
			;;
		*) echo "No option was chosen."
	esac
done