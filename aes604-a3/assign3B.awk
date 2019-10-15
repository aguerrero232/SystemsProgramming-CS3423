BEGIN{
    months["Jan"]=01; months["Feb"]=02; months["Mar"]=03; months["Apr"]=04; months["May"]=05; months["Jun"]=06;  # this is how i compare the months 
    months["Jul"]=07; months["Aug"]=08; months["Sep"]=09; months["Oct"]=10; months["Nov"]=11; months["Dec"]=12;  # by using an associative array to access the months     
    monthdayformat ="[A-Z][a-z][a-z][0-9][0-9]"; hourminformat ="[0-9][0-9]:[0-9][0-9]";                         # numerical order to compare with each other 
    counter=0;                                                                                                                              
}

{
    if( $1 in process){
        printf("%-12s%s%s"," ",substr($0,index($0,$8),length($0)),"\n");
    }else {
        process[$1] = $0;
        print "User: ",$1;
        printf("%-12s%s%s"," " ,substr($0,index($0,$8),length($0)),"\n" );
    }    
}

{ 
    if (counter == 0){ # only enters this loop at the start to store the beginning data to start comparing times with 
        counter = 1; latetime=earlytime=$5; earlyline=lateline=$0; # sets counter to 1 so we dont enter again, latetime and early time to the starting $5  
    }                                                              # earlyline and lateline also both get set to the starting $0 jic they are the earliest or latest 
    else{    
        currtime = $5; curruser=$1; # storing the current time and the current user id 
        comparason = compTime(currtime,latetime);# checking to see if the current time is later than the latest time found up till now 
        if( (comparason == -1) || (comparason == 0 && curruser < lateusr) ){ # if the time comes back as later than the last or a tie with a user name that starts before the other
            latetime=currtime; lateusr=curruser; lateline=$0; # then set the data
        }
        comparason = compTime(currtime,earlytime); # checking to see if the current time is earlier than the earliest time found up till now
        if( (comparason == 1) || (comparason == 0 && curruser < earlyusr) ){ # if the time comes back as earlier than the last or a tie with a user name that starts before the other
            earlytime=currtime; earlyusr=curruser; earlyline=$0; # then set the data
        }
    }
}

END{ # this is where the final sorted times get printed out 
    print (" ");
    print "\nEarliest Start Time: " ;
    print earlyline;
    print "\nLatest Start Time: " ; 
    print lateline;
    print (" ");
}

function compTime(curTime,lastTime){
    if( curTime ~ monthdayformat && lastTime ~ hourminformat ){ # the current time came before the last time because monthday is always > hourmin  
        return 1;
    }
    else if(curTime ~ hourminformat && lastTime ~ monthdayformat){  # the current time came after the last time becuase monthday is always beofre hour min
        return -1;
    }
    else if (curTime ~ monthdayformat && lastTime ~ monthdayformat ){ # both times came in as monthday format 
        currentMonth = months[substr(curTime,1,3)]; currentDay = substr(curTime,4,2); # storing the current times data
        lastMonth = months[substr(lastTime,1,3)]; lastDay = substr(lastTime,4,2); # storing the last times data
        if(currentMonth < lastMonth){
            return 1;       # this month is before the last month 
        }
        else if (currentMonth > lastMonth){
            return -1; # this month is after the last one 
        }
        else{
            if(currentDay < lastDay){ # the times have the same month but the current day comes before the last times day  
                return 1;
            }
            else{
                return 0; # they are equal times 
            }
        }
    }
    else { # both times came in as hourmin format  ex.) 01:00 or 12:59 
        if(curTime < lastTime){ # the current time is less than than the last time 
            return 1;
        }
        else if(curTime > lastTime){ # the current time is greater than the last time 
            return -1;
        }
        else{ # the times are equal 
            return 0;
        }
    }   
}