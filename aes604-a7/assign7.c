#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include "assign7.h"

    void printMenu();
    void create(COURSE course);
    void read(COURSE course);
    void update(COURSE course);
    void delete(COURSE course);
    void printCourses();

    int main() {
        COURSE course;
        char inputbuffer[100];
        FILE *tmpFile;
        tmpFile = fopen("courses.dat", "ab");
        fclose(tmpFile);
        printMenu();
        while (fgets(inputbuffer,sizeof(inputbuffer),stdin) != NULL ){
            if(strlen(inputbuffer) > 2) inputbuffer[0] = 'X';
            switch (toupper(inputbuffer[0])){
                case 'C':
                    create(course);
                    break;
                case 'R': 
                    read(course);
                    break;
                case 'U':
                    update(course);
                    break;
                case 'D': 
                    delete(course);
                    break;
                case 'P':
                    printCourses();
                    break;
                default:
                    printf("%s","ERROR: invalid option\n");
                    break;
            }
            printMenu();
        }
    } 
    
    //  • C: a course is created
    void create(COURSE course){

        FILE *tmpFile;
        int courseNum;
        // (a) From the terminal, read the following one line at a time:
        // i. Course number (zero-indexed integer)
        printf("Enter a CS course number: ");
        scanf("%d", &courseNum);
        getchar();      

        tmpFile = fopen("courses.dat","rb+");
        // find where the course is if it already exists
        fseek(tmpFile, ((courseNum)*sizeof(COURSE)), SEEK_SET);
        fread(&course, sizeof(course), 1L, tmpFile);
        // (c) If the course already exists, print the following error and continue with the program.
        // The program should detect this and respond immediately after reading the
        // course number.
        // ERROR: course already exists
        if(course.courseSize > 0 ) printf("ERROR: course already exists\n");
        else{         
            // ii. Course name (string possibly containing whitespace)
            printf("Course name: ");
            scanf("%[^\n]", course.courseName);
            getchar();
            // iii. Course schedule (string ∈ {MWF,TR})
            printf("Course schedule: ");
            scanf("%s", course.courseSched);
            getchar();
            // iv. Course credit hours (unsigned integer)
            printf("Credit hours: ");
            scanf("%d", &course.courseHours);
            getchar();
            // v. Course enrollment (unsigned integer)
            printf("Course enrollment: ");
            scanf("%d", &course.courseSize);
            getchar();
            // (b) Using the values entered by the user, create a new file in the data folder based on
            // the instructions above. 
            fseek(tmpFile, ((courseNum)*sizeof(COURSE)), SEEK_SET);
            fwrite(&course, sizeof(course), 1L, tmpFile);
        }
        fclose(tmpFile);     
    }
    
    // • R: read an existing course’s information
    void read(COURSE course) {
        FILE *tmpFile;
        int courseNum, read;

        // (a) Prompt the user for a course number: (e.g., “3423”)
        // Enter a CS course number:
        printf("Enter a CS course number: ");
        scanf("%d", &courseNum);
        getchar();
        tmpFile = fopen("courses.dat", "rb+");
        // (b) Search for the specified course using the provided course number (e.g., “3423”).
        fseek(tmpFile, ((courseNum)*sizeof(COURSE)), SEEK_SET); 
        read = fread(&course, sizeof(course), 1L, tmpFile);
    
        if(read == 0) printf("ERROR: item not found\n");
        else if(course.courseSize > 0) {
            // (c) Print the course information in the following format:
            // Course number: course number
            printf("\nCourse number: %d\n",courseNum );
            // Course name: courseName
            printf("Course name: %s\n",course.courseName );
            // Scheduled days: courseShed
            printf("Scheduled days: %s\n", course.courseSched);
            // Credit hours: courseHours
            printf("Credit hours: %d\n", course.courseHours);
            // Enrolled Students: courseSize
            printf("Enrolled Students: %d\n\n", course.courseSize);
        } else {    
            // (d) If the course is not found, print the following error instead and continue with the
            // program.
            printf("ERROR: course not found\n");
        }   
        fclose(tmpFile);
    }

    //     • U: update an existing course record
    void update(COURSE course) {
        FILE *tmpFile;
        COURSE course2;
        char tmpCreditHours[11], tmpCourseEnroll[11];
        int CourseNum;

        // (a) Prompt the user for the following one at a time:
        // i. Course number (zero-indexed integer)
        printf("Enter a course number:");
        scanf("%d", &CourseNum);
        getchar();
        tmpFile = fopen("courses.dat", "rb+"); 
        fseek(tmpFile, ((CourseNum)*sizeof(COURSE)), SEEK_SET); 
        fread(&course, sizeof(course), 1L, tmpFile); 

        // (c) If the course record is not found, print the following error and continue with the
        // program. You should detect this and respond immediately after reading the course number.
        if(course.courseSize == 0) printf("ERROR: course not found\n");
        else {
            // ii. Course name (string possibly containing whitespace)
            printf("Course name: ");
            fgets(course2.courseName, 63, stdin);
            // iii. Course schedule (string ∈ {MWF,TR})
            printf("Course schedule: ");
            fgets(course2.courseSched, 5, stdin);
            // iv. Course credit hours (unsigned integer)
            printf("Course credit hours: ");
            fgets(tmpCreditHours, 10, stdin);
            // v. Course enrollment (unsigned integer)
            printf("Course enrollment: ");
            fgets(tmpCourseEnroll, 10, stdin);
            // (b) Update each of the corresponding fields for the course based on the user’s input. If
            // the user input is blank for a particular field (except course number), maintain the original value from the file.
            if(strlen(tmpCreditHours) != 0) sscanf(tmpCreditHours, "%d", &course.courseHours);

            if(strlen(tmpCourseEnroll) != 0) sscanf(tmpCourseEnroll, "%d", &course.courseSize);
           
            if(strlen(course2.courseName) != 0) sscanf(course2.courseName, "%[^\n]", course.courseName);
            
            if(strlen(course2.courseSched) != 0) sscanf(course2.courseSched, "%s", course.courseSched);
            
            fseek(tmpFile, ((CourseNum)*sizeof(COURSE)), SEEK_SET);
            fwrite(&course, sizeof(course), 1L, tmpFile);
            fclose(tmpFile);
        }
    }

    // • D: delete an existing course
    void delete(COURSE course){
        FILE *tmpFile; 
        int courseNum, read;
        // (a) Prompt the user for a course number (e.g., “3423”):
        // Enter a course number:
        printf("Enter a course number: ");
        scanf("%d", &courseNum);
        getchar();
        tmpFile = fopen("courses.dat", "rb+"); 
        fseek(tmpFile, ((courseNum)*sizeof(COURSE)), SEEK_SET); 
        read = fread(&course, sizeof(course), 1L, tmpFile); 
        // (d) If the course is not found, print the following error instead and continue with the
        // program.
        if(read == 0) printf("ERROR: course not found\n");
        else if(course.courseSize > 0) {
            // (b) Delete the specified course’s record.
            // Hint: You may assume thecreditHours field will never be zero for a valid course.
            course.courseSize  = 0;
            course.courseHours = 0;
            memset(course.courseName,'\0',sizeof(course.courseName));
            memset(course.courseSched,'\0',sizeof(course.courseSched));
            fseek(tmpFile, (-1)*sizeof(COURSE), SEEK_CUR);
            fwrite(&course, sizeof(course), 1L, tmpFile);
            // (c) Print the following message to standard output with the course’s number:
            // course number was successfully deleted.
            printf("%d was successfully deleted.\n",courseNum);
        }
        fclose(tmpFile);
    }

    // • P: print all courses
    void printCourses(){
        FILE *tmpFile;
        COURSE course;
       
        tmpFile = fopen("courses.dat", "rb+");
    
        while(fread(&course, sizeof(course), 1L, tmpFile) == 1){
            if(course.courseSize > 0) {
                // (c) Print the course information in the following format:
                // Course name: courseName
                printf("Course name: %s\n",course.courseName );
                // Scheduled days: courseShed
                printf("Scheduled days: %s\n", course.courseSched);
                // Credit hours: courseHours
                printf("Credit hours: %d\n", course.courseHours);
                // Enrolled Students: courseSize
                printf("Enrolled Students: %d\n\n", course.courseSize);
            }
        }
        fclose(tmpFile);
    }

    void printMenu(){ printf("\nEnter one of the following actions or press CTRL-D to exit.\nC - create a new course record\nR - read an existing course record\nU - update an existing course record\nD - delete an existing course record\nP - print all course records\n");}