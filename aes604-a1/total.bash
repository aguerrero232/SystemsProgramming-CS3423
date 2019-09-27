#!/bin/bash

# (a) Print the total number of .crs files within the data directory:
# Total course records: total
# where total is the total .crs files.

crsCount=` ls data/*.crs | wc -l `  
echo " "
echo "Total course records: $crsCount"
echo " "