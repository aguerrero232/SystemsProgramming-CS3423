#!/usr/bin/env python3
import shutil
import sys
import os
from os.path import expanduser
home = expanduser("~")
database = list()
if os.path.isfile(home + "/rm_trash/.rm_trashDB"):
    with open(home + "/rm_trash/.rm_trashDB", "r") as infile:
        for line in infile:
            datalist = line.split()
            datalist = datalist[0].split(",")
            database.append(dict({"BaseName": datalist[0], "Original": datalist[1], "RMTRASH": datalist[2], "SortThis": os.path.splitext(datalist[2])[0]}))
database.sort(key=lambda i: i["SortThis"], reverse=True)
with open(home + "/rm_trash/.rm_trashDB", "w+") as outfile:
    for contents in database:
        outfile.write(contents.get("BaseName")+","+contents.get("Original")+","+contents.get("RMTRASH"))
        outfile.write("\n")
for args in sys.argv[1:]:
    count = 0
    for items in database:
        if items.get("Original") == args:
            shutil.move(items.get("RMTRASH"), args), database.remove(items)
            infile = open(home + "/rm_trash/.rm_trashDB", 'r').readlines()
            with open(home + "/rm_trash/.rm_trashDB", 'w') as outfile:
                for index, line in enumerate(infile):
                    if index != count:
                        outfile.write(line)
            break
        count += 1
# Author: Ariel Guerrero
# Assignment 6: Python Scripting 2
# Description:  Takes in any amount of files and directories and deletes them
#               if you want to delete the whole directory you must pass in the -r flag as an argument
#               If a file with the same name already exists in ∼/rm_trash then -n will be appended to the name (n being
#               the occurrences of a file or directory with the same name in ∼/rm_trash)
#               also the files moved here can be restored given the path it was previously stored in
