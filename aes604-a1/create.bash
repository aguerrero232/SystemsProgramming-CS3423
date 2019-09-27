#!/bin/bash

# (a) From the terminal, read the following one at a time:
read -p "Enter the Department Code: " dept_code
dept_code=${dept_code^^} ## always uppercase the department code
read -p "Enter the Department Name: " dept_name
read -p "Enter the course Number: " course_num
read -p "Enter the course Name: " course_name
read -p "Enter the course Schedule: " course_sched
course_sched=${course_sched^^} ## wouldnt hurt to always have this uppercase as well!
read -p "Enter the course start date:  " startDate
read -p "Enter the course end date:  " endDate
read -p "Enter the course credit hours:  " creditHrs
read -p "Enter the initial course enrollment: " course_enroll
echo " "

## setting the name we are going to name the file to save on typing out all those variables!
fileName=$dept_code$course_num.crs

if [ ! -e "data/$fileName" ];then ## <- better just looks for one file in the current dir
##if [[ `find data/ -name "$fileName"` == "data/$fileName" ]]; then <- less effecient and effective way to search for the file 

    #(b) Using the values entered by the user, create a new file in the data folder based onthe instructions above.
    echo "$dept_code $dept_name"  > data/$fileName
    echo "$course_name"  >> data/$fileName
    echo "$course_sched  $startDate $endDate" >> data/$fileName
    echo "$creditHrs"  >> data/$fileName
    echo "$course_enroll" >> data/$fileName

    # (c) Update data/queries.log by adding the following line:
    chmod u+r data/queries.log
    echo `date`" CREATED: $dept_code $course_num $course_name" >> data/queries.log
else

    # what if the user inputs nothing?
    # (d) If the course already exists, print the following error and continue with the script.
    # The script should accept all seven inputs before checking if the record exists.
    echo "ERROR: course already exists 
    "
fi