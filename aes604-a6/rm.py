#!/usr/bin/env python3
import re
import shutil
import sys
import os
from os.path import expanduser
home = expanduser("~")

def check(item):
    datalist, new_path_name = [os.path.split(item)[0], os.path.split(item)[1], os.path.splitext(os.path.split(item)[1])[0], os.path.splitext(os.path.split(item)[1])[1]], item
    if os.path.exists(home + "/rm_trash/" + datalist[1]):
        count = 1
        while os.path.exists(home + "/rm_trash/" + datalist[2] + "-" + str(count) + datalist[-1]): count += 1
        new_path_name = datalist[0] + "/" + datalist[2] + "-" + str(count) + datalist[-1]
    return new_path_name

def deletestuff(path):
    path = re.sub("/+$", "", path)
    new_name = check(path)
    os.rename(path, new_name)
    shutil.move(new_name, home + "/rm_trash/")
    f = open(home + "/rm_trash/.rm_trashDB", "a+")
    f.write(os.path.split(path)[1] + "," + path + "," + home + "/rm_trash/" + os.path.split(new_name)[1] + "\n")

rFlag = False
if "-r" in sys.argv:
    sys.argv.remove("-r")
    rFlag = True
if not os.path.isdir(home + "/rm_trash"):
    os.mkdir(home + "/rm_trash")
if not os.path.isfile(home + "/rm_trash/.rm_trashDB"):
    database = open(home + "/rm_trash/.rm_trashDB", "w+")
for variables in sys.argv[1:]:
    if os.path.isdir(variables):
        if rFlag:
            deletestuff(variables)
        else:
            sys.stderr.write("rm.py: cannot remove '" + variables + "': Is a directory\n")
    elif os.path.isfile(variables):
        deletestuff(variables)
    else:
        sys.stderr.write("rm.py: cannot remove '" + variables + "': No such file or directory\n")
# Author: Ariel Guerrero
# Assignment 6: Python Scripting 2
# Description:  Takes in any amount of files and directories and deletes them
#               if you want to delete the whole directory you must pass in the -r flag as an argument
#               If a file with the same name already exists in ∼/rm_trash then -n will be appended to the name (n being
#               the occurrences of a file or directory with the same name in ∼/rm_trash)
#               also the files moved here can be restored given the path it was previously stored in
