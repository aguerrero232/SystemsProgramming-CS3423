#!/bin/bash

#   Assignment 4: More Scripting
#   Author: Ariel Guerrero
#   Date:   10/13/2019

datadirectory=$1
templatefile=$2
originaldate=$3
outputdirectory=$4

rightbrace=0
# pretty much the whole extra-credit 
if [[ $# -eq 6 ]]; then
    leftbrace=`echo $5 | sed -r 's_(.)_\\1_g'`
    rightbrace=`echo $6 | sed -r 's_(.)_\\1_g'` # easy since we can assume we get a 6th ..
else

    if [[ $# =~ [0-35] || $# -gt 6 ]];then 
    echo "Incorrect inputs . .. .. Defaults set!"
    fi

    leftbrace="\[\["
    rightbrace="\]\]"
fi

if [[ -d $datadirectory ]]; then
    # listing off each file in the directory
    ls -f $datadirectory | while read file
    do
        date=$originaldate # handles the date so it stays constant not sure why its changing though 
        if [[ $file =~ [A-Z]{2,3}[0-9]{4}.crs ]]; then # not sure if bash uses regular or extended regular expressions
            
            curdir=$PWD # saves the current directory for reference
            # could use read but just to be cool use awk
            # stores all the data variables here because we know our data and its format.... making this really easy
            # could be more optimized but though but how? (using awk) ... or would read just be the easiest 
            deptcode=`awk  'NR == 1 { print $1 }' $datadirectory/$file`
            deptname=`awk  'NR == 1 { print substr($0,index($0,$2),length($0)) }' $datadirectory/$file`
            crsname=`awk  'NR == 2 { print $0 }' $datadirectory/$file`
            crssched=`awk  'NR == 3 { print $1 }' $datadirectory/$file`
            crsstart=`awk  'NR == 3 { print $2 }' $datadirectory/$file | sed -E 's|\/|\\\/|g'`
            crsend=`awk  'NR == 3 { print $3 }' $datadirectory/$file | sed -E 's|\/|\\\/|g'`
            date=`echo $date | sed -E 's|\/|\\\/|g'`
            credithrs=`awk  'NR == 4 { print $1 }' $datadirectory/$file`
            crsnum=`echo $file | sed -r  's/[A-Z]{2,3}([0-9]{4}).crs/\1/g'`

            # For each course with an enrollment greater than 50, your program will
            # use the provided template to generate an advisory report specifically for them..
            # ... so if [[ $currentenrollment -gt(or ge not sure yet 10/13/2019) 50 ]]; then create a .warn file?   <---------------------
            currentenrollment=`awk  'NR == 5 { print $1 }' $datadirectory/$file`
            
            if [[ $currentenrollment -gt 50 ]]; then
                
                # creates a .warn file for the current course we are going to run through our template because the current enrollment is over 
                newfile=$deptcode$crsnum.warn
                cat $templatefile > $newfile
                
                #  if the directory already exists move the new file there and then change to the directory for ease of access
                if [[ -d $curdir/$outputdirectory ]]; then
                
                    mv $newfile $curdir/$outputdirectory
                    cd $curdir/$outputdirectory

                else #  if the directory does not exist then create the directory and then move the new file there and then change to the directory for ease of access
                
                    mkdir -p $curdir/$outputdirectory
                    mv $newfile $curdir/$outputdirectory
                    cd $curdir/$outputdirectory
                
                fi
                
                #  this is where the templating happens
                sed -r -i -e "{
                    s/$leftbrace(dept_code)$rightbrace/$deptcode/g
                    s/$leftbrace(dept_name)$rightbrace/$deptname/g
                    s/$leftbrace(course_num)$rightbrace/$crsnum/g
                    s/$leftbrace(course_name)$rightbrace/$crsname/g
                    s/$leftbrace(course_start)$rightbrace/${crsstart}/g
                    s/$leftbrace(course_end)$rightbrace/${crsend}/g
                    s/$leftbrace(credit_hours)$rightbrace/$credithrs/g
                    s/$leftbrace(num_students)$rightbrace/$currentenrollment/g
                    s/$leftbrace(date)$rightbrace/"$(echo ${date})"/g
                }" $newfile
              
                # change back the where the user first used this script 
                cd $curdir
            fi
        fi
    done
else
    echo "Error: Data Directory not found!"
    exit 1
fi