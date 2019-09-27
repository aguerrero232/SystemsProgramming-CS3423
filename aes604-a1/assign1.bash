#!/bin/bash
#creating a new log to show what you did during the time the program was being used 
# resets the log every time also ..... not sure if this is how it was intended to work, need to ask if its right.
echo "" > data/queries.log
go=0
## as long as the user inputs a valid arg then this loop will continue to do its job
while [ $go ]; do
## printing the menu for the user to see it
 echo "  Enter one of the following actions or press CTRL-D to exit.
   C - create a new course record
   R - read an existing course record
   U - update an existing course record
   D - delete an existing course record
   E - update enrolled student count of existing course
   T - show total course count"

## if nothing is read then eof or nothing was entered
if ! read ans; then
 # got EOF
 break
 fi
 ## pretty much a switch statement that has all our options to go through
 ans=${ans^^}
 case "$ans" in
 C)  #call ./create to make a new .crs file for a class
  chmod u+x create.bash 
  ./create.bash  
 ;;
 R) # call ./read to read out a selected file if it exists
  chmod u+x read.bash
  ./read.bash
 ;;
 U) # call ./update and update the seleceted file if it exists
  chmod u+x update.bash
  ./update.bash
;;
 D) # call ./delete and delete the selected file if it exists
  chmod u+x delete.bash
  ./delete.bash
 ;;
 E) # call ./editStudentEnrollment to edit the amount of students in a selected class if the file exists
  chmod u+x enroll.bash
  ./enroll.bash
 ;;
 T) # call total to count the current total or .crs files
  chmod u+x total.bash
  ./total.bash
 ;;
 *) echo "ERROR:  invalid option"
 ;;
 esac
done