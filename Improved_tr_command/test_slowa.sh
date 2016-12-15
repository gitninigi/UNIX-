#!/bin/bash
#1. saving chars which we want to change in a value and saving chars into which we want to change in variable b
#2. calling sed and scripts. Sed uses and changes sentences from file test2.txt while we pass file test.txt into script and save results in file test3.txt
#3. saving content of file test2.txt to val variable and saving content of tile test3.txt to val2 variable
#4. comparison of values

     a=bar
     b=foo
     c=-u
     echo "bar" >> test21.txt
     bash ./fis_tr_words.sh "$a" "$b" "$c" < test21.txt >> test32.txt
     
     case $c in 
     	-u)      sed -i -e 's/bar/FOO/g' test22.txt
     esac
     
   #  diff test21.txt test32.txt | echo
     val=$(<test22.txt)
     val2=$(<test32.txt)
     
     if [[ "$val" == "$val2" ]]; then
     	echo "test się powiódł"
     else
     	echo "test sie nie powiódł"
     fi
     
     rm -f test21.txt
     rm -f test32.txt
     

