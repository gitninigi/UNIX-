#!/bin/bash
#1. saving chars which we want to change in variable a and saving chars into which we want to change in variable b
#2. calling tr and script, passing them file test.txt for translating. Output of tr commend is saved in test2.txt, and output of script tr_znaki.sh is saved in test3.txt
#3. saving content of file test2.txt into val variable and saving content of file test3.txt into val2 variable
#4. comparing values

     a=ab
     b=AB
     c=-l
     echo "our script indicates you are using string comparisons.Assume server name could be a string instead of number only.For String comparisons:if thenNotes:Spacing around == is a must Spacing around = is a must" >> test.txt
     bash ./fis_tr.sh "$a" "$b" "$c" < test.txt >> test3.txt
     
     case $c in 
     	-u)     tr '[:lower:]' '[:upper:]' < test.txt >> test2.txt
					;;
     	-l)	 tr '[:upper:]' '[:lower:]'< test.txt >> test2.txt
					;;
	*) echo "błędna komenda"
					;;
     esac
     
     
     val=$(<test2.txt)
     val2=$(<test3.txt)
     
     
     if [[ "$val" == "$val2" ]]; then
     	echo "test się powiódł"
     else
     	echo "test sie nie powiódł" 
     fi
     rm -f test.txt
     rm -f test2.txt
     rm -f test3.txt

