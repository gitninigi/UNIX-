#!/bin/bash
#1. get two values z1-what we are going to change, z2-into what we are going to change
#2. saving the values in a string
#3. we divide variables from $a by a comma, crop "" chars and save to array
#4. we proceed in a similar manner with b
#5. in an infinite loop we provide text for change
#6. in a for loop we iterate through whole array arr1
	#a. if the word was found in a test, we change it into corresponding value in b
	#b. if not, continue
#7. additional oprions, are recognised by char - at the beginning
	#a. get string
	#b. divide by space
		#* if there is "-" before any variable goto special variable
		#**if not, there is no special variable
	#c. continue as before
	#d. if there is a special variable, after ordinary operation do switch
		#* -c - Caesar cipher
		#** -u - uppercase, changes all chars into uppercase
		#*** -l - lowercase, changes all chars into lowercase
#----------------------------------------------TR_WORDS-----------------------------------------------------------------------------
first_three="$1 $2 $3" #saves two first words in shared variable
c="$3";a="$1";b="$2" #divides words

a2=${a//['"']/} #deletes "" char from string
b2=${b//['"']/} #deletes "" char from string

IFS=', ' eval 'array1=($a2)' #for dividing IFS-with what we divide (here it is a comma), array1-where we save
IFS=', ' eval 'array2=($b2)' #for dividing IFS-with what we divide (here it is a comma), array2-where we save

tLen=${#array1[@]} #length of array1

splitC=$(echo $c | fold -w 1) #splits a into chars and outputs
arrC=($splitC)
var="-" #variable for checking if there is a special char

#checking wheather a special char exists
if [[ ${arrC[0]} == "$var" ]];then 
	specjalna=1 #special char exists
else
	specjalna=0 #special char doesn't exist
fi

#infinite loop allowing us constantly wiritng text for translating, can be stopped by e.g. ctrl+c
while read before
do 
	if [[ "$before" == "out" ]]; then
     		break
     	fi
	#loop for iterating over all elements of array1
	for (( i=0; i<${tLen}; i++ )); 
	do
		before=${before//${array1[i]}/${array2[i]}}  #changing corresponding word from array1 into variable under corresponding index in array2
		if (( $specjalna == 1 )); then
			zmiennaSpecjalna=${arrC[1]} #checking which option was chosen
			case $zmiennaSpecjalna in
				c) before2=$(echo $before| tr '[a-z]' '[n-za-m]') #coding
					;;
				u) before2=$(echo $before | tr '[:lower:]' '[:upper:]') #uppercase
					;;
				l) before2=$(echo $before | tr '[:upper:]' '[:lower:]') #lowercase
					;;
				*) echo "błędna komenda"
					;;
			esac
		fi
	done #ending for loop
	if (( $specjalna == 0 )); then
		echo $before
	fi
	if (( $specjalna == 1 )); then
		echo $before2
	fi
	sleep 1 #waits a second
done #ending while loop
 
