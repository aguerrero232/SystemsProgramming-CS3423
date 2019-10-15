#!/bin/bash
for var in $@
do 
chmod 700 ./assign3B.awk 
sed -r -e '1d' -e '/^[^A-Z]{3}[^0-9]{3}/d' $var | sort | awk -f ./assign3B.awk 
done


# ------------------------------------------------------------------------- OLD LOGIC -----------------------------------------------------------------------------------
#     #          Jan01                          Jan                       months[Jan]  <= last month we got      01      then compare to last day we got    
#     #( $5 ~ /[A-Z][a-z]{2}[0-9]{2}/ && substr($5, 0, 3) in months && months[substr($5, 0, 3)] <= lastmonth && substr($5, 3, 2) < lastday) {
#    {
#         if ( $5 ~ /[A-Z][a-z][a-z][0-9][0-9]/ ){  # only enter if $5 matches the expression [A-Z][a-z]{2}[0-9]{2} ## turns out i dont need an if outside of this block        
#             if(counter ==0){
#                 counter=1;
#                 lastName = $1; # this current $1 will now be the last abc123 userid 
#                 type1wholeL = $0;
#                 lastmonth = months[substr($5, 1, 3)];
#                 lastday = substr($5, 4, 2);
#             }  
#             else if(months[substr($5,1,3)] < lastmonth){
#                 lastName = $1; # this current $1 will now be the last abc123 userid 
#                 type1wholeL = $0;
#                 lastmonth = months[substr($5, 1, 3)];
#                 lastday = substr($5, 4, 2);
#             }
#             else if(months[substr($5,1,3)] == lastmonth){
#                     if(substr($5, 4, 2) < lastday){
#                         lastName = $1; # this current $1 will now be the last abc123 userid 
#                         type1wholeL = $0;
#                         lastmonth = months[substr($5, 1, 3)];
#                         lastday = substr($5, 4, 2);
#                     }
#                     else if(substr($5, 4, 2) == lastday){
#                         if($1 < lastName){
#                             lastName = $1; # this current $1 will now be the last abc123 userid 
#                             type1wholeL = $0;
#                             lastmonth = months[substr($5, 1, 3)];
#                             lastday = substr($5, 4, 2);
#                         }
#                     }
#             }
#         }
#         else if( $5 ~ /[0-2][0-9]:[0-6][0-9]/ ){
#             if ($5 > type2timeE  ){ 
#                 lastName = $1; # this current $1 will now be the last abc123 userid    
#                 usrname = $1; 
#                 type2wholeE = $0;
#                 type2timeE = $5;      
#             }
#             if( type1wholeL == 0){ # if none in the Jan01 format 
#                 if(type2timeL > $5 ){
#                     lastName = $1; # this current $1 will now be the last abc123 userid 
#                     type2wholeL = $0;
#                     type2timeL = $5;
#                 }
#             }
#         }
#    }
        # # if( type2wholeE == 0 ){ # if none in the 00:00 format
        #     if(substr($5, 0, 3) in months &&  months[substr($5, 0, 3)] >= firstmonth && substr($5, 3, 2) > lastday){       
        #         type1wholeE = $0;
        #         lastName = $1; # this current $1 will now be the last abc123 userid 
        #         firstmonth = months[substr($5, 0, 3)];
        #         firstday = substr($5, 3, 2);
        #     }
        # }
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------