#!/bin/bash

## this function is used to store all the old data in case of a blank
function readVars() {
    read dept_codeOrg dept_nameOrg # first line reads
    read course_nameOrg # second line reads
    read course_schedOrg course_startOrg course_endOrg # third line reads
    read course_hoursOrg # fourth line reads
    read initial_enrollmentOrg # fith line reads
}

# (a) Prompt the user for the following one at a time:
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

#(b) Search for the specified course using the course department and course number (e.g.,“cs3423”).
## setting the name we are going to name the file to save on typing out all those variables!
fileName=${dept_code^^}$course_num.crs
if [ -e "data/$fileName" ];then
    
    readVars < data/$fileName
    
    # (c) Update each of the corresponding fields based on the user input. If the user input
    # is blank for a particular field, keep the original value from the file
    if [ -z "$dept_name" ]
    then
        dept_name=$dept_nameOrg
    fi
    if [ -z "$course_name" ]
    then
        course_name=$course_nameOrg
    fi
    if [ -z "$course_sched" ]
    then
        course_sched=$course_schedOrg
    fi
    if [ -z "$startDate" ]
    then
        startDate=$course_startOrg
    fi
    if [ -z "$endDate" ]
    then
        endDate=$course_endOrg
    fi
    if [ -z "$creditHrs" ]
    then
        creditHrs=$course_hoursOrg
    fi
    if [ -z "$course_enroll" ]
    then
        course_enroll=$initial_enrollmentOrg
    fi
    
    ## five lines of info that goes to the .crs file
    echo "$dept_code $dept_name"  > data/$fileName
    echo "$course_name"  >> data/$fileName
    echo "$course_sched  $startDate $endDate" >> data/$fileName
    echo "$creditHrs"  >> data/$fileName
    echo "$course_enroll" >> data/$fileName
    # (d) Update data/queries.log by adding the following line:
    chmod u+r data/queries.log
    echo `date`" UPDATED: $dept_code $course_num $course_name" >> data/queries.log
else
    # (e) If the course is not found, print the following error and continue with the script. The
    # script should accept all nine inputs before checking if the record exists.
    echo "ERROR: course not found"
    exit 1
fi