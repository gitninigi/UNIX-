#!/bin/bash
#1. get two variables z1-what we are changing, z2-into what we are changing
#2. we save the values in an array
#3. int loop we save text provied by user in an array; the condition od stopping is ctrl c
#4. during every iteration of tab[i] we are iterating the whole z1 in search of corresponding values
	#a. if lack, continue search in next element of array
	#b. if found, change tabl[i] into z2 of corresponding index
#5. additional oprions, are recognised by char - at the beginning	
	#a. get string
	#b. divide by space
		#* if there is "-" before any variable goto special variable
		#**if not, there is no special variable
	#c. continue as before
	#d. if there is a special variable, after ordinary operation do switch
		#* -c - Caesar cipher
		#** -u - uppercase, changes all chars into uppercase
		#*** -l - lowercase, changes all chars into lowercase
#----------------------------------------------TR_CHARS-----------------------------------------------------------------------------
first_two="$1 $2 $3" #saves three first chars into one variable
c="$3";a="$1";b="$2" #divides chars

split1=$(echo $a | fold -w 1) #divides a into letters and outputs
split2=$(echo $b | fold -w 1) #divides b into letters and outputs
arr1=($split1) #saves string to array
arr2=($split2) #saves string to array

shift #deletes first argument
shift #deletes second argument


size1=${#arr1[@]} #saving size of arr1 into variable 
size2=${#arr2[@]} #saving size of arr2 into variable 

splitC=$(echo $c | fold -w 1) #splits a into letters and outputs
arrC=($splitC)

var="-" # variable for checking if special char exists

#checking if special char exists
if [[ ${arrC[0]} == "$var" ]];then 
	specjalna=1 #special char exitsts
else
	specjalna=0 #special char doesn't exitsts
fi


#infinite loop allowing us constantly wiritng text for translating, can be stopped by e.g. ctrl+c
while read tekst 
do 
	if [[ "$tekst" == "out" ]]; then
     		break
     	fi
	var2="1"

	mod=$tekst  #saves inputed text into variable
	for (( i=0; i<${size1}; i++ ));  
	do
		mod=${mod//[${arr1[i]}]/${arr2[i]}} #new variable containing change of value in arr into corresponding value in arr2
		# if special char exists
		if (( $specjalna == 1 )); then
			zmiennaSpecjalna=${arrC[1]} #checking which option was chosen
			case $zmiennaSpecjalna in
				c) mod2=$(echo $mod| tr '[a-z]' '[n-za-m]') #coding
					;;
				u) mod2=$(echo $mod | tr '[:lower:]' '[:upper:]') #uppercase
					;;
				l) mod2=$(echo $mod | tr '[:upper:]' '[:lower:]') #lowercase
					;;
				*) echo "wrong commend"
					;;
			esac
		fi
	done  #ending for loop
	if (( $specjalna == 1 )); then
		echo $mod2 #outputting changed text
	else
		echo $mod
	fi
	
done

 
