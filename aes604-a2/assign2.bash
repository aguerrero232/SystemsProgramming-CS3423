#!/bin/bash 

chmod u+x mysedscript.sed
## using double quotes makes the $(date) command work here but not sure why 
## ask 9/25/2019 in class why 

for var in "$@"
do
sed -r -i "s_<date>_$(date "+%m/%d/%Y")_g" $var
sed -r -i -f mysedscript.sed $var
done

## s/()||()||()/\1/g
## append to the top of the input file 
## questions on assignment 2:
##
##         9/21/2019
##             1.) how to opertate a sed command if the previous 
##                 was a success
##             
##             2.) how to replace a something with a variable amount
##                 of tokens 
##              
##             3.) how to operate on a certain line without knowing that
##                 line 
##              
##             9/23/2019
##             4.) how to use a shell command in a sed script.... ie use `date` 
##                 to output date when a certain string is found 
##             
##             9/24/2019 
##             5.) figured out #4 but just used a command instead of a script, 
##                  but im wondering what else i could pass in                      <----- not important 
##                  besides date, like a variable thats a string or something
##
##             6.) "You should create your own test cases to test for the
##                 recursion feature." <-- what exactly does this mean from the   <-------- more important
##                  assignment?
##
##