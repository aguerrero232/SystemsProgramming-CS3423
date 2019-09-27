#!/bin/bash

function readVars() {
    read dept_code dept_name # first line reads
    read course_name # second line reads
    read course_sched course_start course_end # third line reads
    read course_hours # fourth line reads
    read initial_enrollment # fith line reads
}

# (a) Prompt the user for a string representing the course department and number (e.g.,“cs3423”):
read -p "Enter a course department code and number:" dept_code course_num
fileName=${dept_code^^}${course_num}.crs

# (b) Prompt the user for an enrollment change amount (e.g., entering a value of 3 would
# represent enrolling three new students in the class, while -2 would reflect two students having dropped the course):
read -p "Enter an enrollment change amount:" change_amt

# (c) Search for the specified course using the course number.
if [ -e "data/$fileName" ];then
    readVars < data/$fileName # storing all the data then access the inital_enrollment to update it
    
    # (d) Update the course record by adding the new enrollment count to the course’s current
    # enrollment count. Negative values are allowed. (i.e., students could drop the class).
    updated_enrollment=$(( $initial_enrollment + $change_amt ))
    
    ## five lines of info that goes to the .crs file
    echo "$dept_code $dept_name"  > data/$fileName
    echo "$course_name"  >> data/$fileName
    echo "$course_sched  $course_start $course_end" >> data/$fileName
    echo "$course_hours"  >> data/$fileName
    echo "$updated_enrollment" >> data/$fileName # put in our updated enrollment to be stored!
    echo ""
    # (e) Update data/queries.log by adding the following line:
    # [date] ENROLLMENT: dept_code course_num course_name changed by change_amt
    chmod u+r data/queries.log
    echo `date`" ENROLLMENT: $dept_code $course_num $course_name changed by $change_amt" >> data/queries.log
    
else
    # (f) If the course record is not found, print the following error and continue with the
    # script. The script should accept the enrollment change amount before checking if
    # the record exists.
    echo "ERROR: course not found"
    
fi
