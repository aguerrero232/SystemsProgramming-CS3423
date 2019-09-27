#!/bin/bash

function readVars() {
    read dept_code dept_name # first line reads
    read course_name # second line reads
    read course_sched course_start course_end # third line reads
    read course_hours # fourth line reads
    read initial_enrollment # fith line reads
}

#(a) Prompt the user for a string representing the course department and number (e.g.,
#“cs3423”):
read -p "Enter a course department code and number:" dept_code course_num
fileName=${dept_code^^}${course_num}.crs

if [  -e "data/$fileName" ] ; then  # file exists
    # get the data for before the file is delted to print into the log
    readVars < data/$fileName ## why is this happeneing here ?!?!?!  <--------------
    
    #(b) Delete the specified course’s file.
    rm  data/$fileName
    
    #(c) Update data/queries.log by adding the following line:
    #[date] DELETED: dept_code course_num course_name
    #where date is the output from the date command and dept_code, course_num, and
    #course_name are the corresponding values.
    echo `date`" DELETED: $dept_code $course_num $course_name" >> data/queries.log
    
    #(d) Print the following message to stdout with the course’s number:
    #course number was successfully deleted.
    echo "$course_num was successfully deleted."
    echo ""
    
else # file not found
    #(e) If the course is not found, print the following error instead and continue with the
    #script.
    echo "ERROR: course not found"
fi