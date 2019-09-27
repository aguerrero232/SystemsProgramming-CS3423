#!/bin/bash

function readVars() {
    read dept_code dept_name # first line reads
    read course_name # second line reads
    read course_sched course_start course_end # third line reads
    read course_hours # fourth line reads
    read initial_enrollment # fith line reads
}

# (a) Prompt the user for a course department and course number: (e.g., “cs3423”)
read -p "Enter a course department code and number:" dept_code course_num
fileName=${dept_code^^}${course_num}.crs # wouldnt hurt to uppercase this

# (b) Search for the specified course using the provided department and number (e.g.,“cs3423”).
if [ -e "data/$fileName" ];then ## <- better just looks for one file in the current dir
 
    #redirecting the input from the file instead of the keyboard!
    readVars < data/$fileName
    # (c) Print the course information in the following format:
    echo ""
    echo "Course department: $dept_code $dept_name"
    echo "Course number: $course_num"
    echo "Course name: $course_name"
    echo "Scheduled days: $course_sched"
    echo "Course start: $course_start"
    echo "Course end: $course_end"
    echo "Credit hours: $course_hours"
    echo "Enrolled Students: $initial_enrollment "
    echo ""
    
else
    # (d) If the course is not found, print the following error instead and continue with the script.
    echo "ERROR: course not found!"
    echo ""
fi