       IDENTIFICATION DIVISION.
       PROGRAM-ID. EMPLOYEE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
	   SELECT EMPLOYEEFILE ASSIGN TO "EMPFILE.DAT"
	    FILE STATUS IS FILE-CHECK-KEY
		ORGANIZATION IS LINE SEQUENTIAL.
          
               
       DATA DIVISION.
       FILE SECTION.
	   FD EMPLOYEEFILE.
	   01 EMPDETAILS.
			88 ENDOFFILE VALUE HIGH-VALUES.
			02 EMPLOYEEID  	 PIC 9(7).
			02 EMPLOYEENAME.
				03 LASTNAME	 PIC X(10).
				03 FIRSTNAME PIC X(10).
			02 STARTDATE.
				03 START-YEAR	PIC 9(4).
				03 START-MONTH	PIC 9(2).
				03 START-DAY	PIC 9(2).
			02 SALARY    	PIC 9(9).
			02 GENDER       PIC X.

   
       WORKING-STORAGE SECTION.
       01  WS-MONTHS-DATA.
           05 FILLER      PIC X(05) VALUE '01JAN'.
           05 FILLER      PIC X(05) VALUE '02FEB'.
           05 FILLER      PIC X(05) VALUE '03MAR'.
           05 FILLER      PIC X(05) VALUE '04APR'.
           05 FILLER      PIC X(05) VALUE '05MAY'.
           05 FILLER      PIC X(05) VALUE '06JUN'.
           05 FILLER      PIC X(05) VALUE '07JUL'.
           05 FILLER      PIC X(05) VALUE '08AUG'.
           05 FILLER      PIC X(05) VALUE '09SEP'.
           05 FILLER      PIC X(05) VALUE '10OCT'.
           05 FILLER      PIC X(05) VALUE '11NOV'.
           05 FILLER      PIC X(05) VALUE '12DEC'.
            
       01  WS-MONTH-MAP         REDEFINES WS-MONTHS-DATA.
           05 WS-MONTH-ITEM     OCCURS 12 TIMES. 
           10 WS-MONTH-NUM      PIC 9(02).
           10 WS-MONTH-NAME     PIC X(03).
		   
  	   
       01  WS-DATE.
           05  WS-YEAR PIC 99.
           05  WS-MONTH PIC 99.
           05  WS-DAY   PIC 99.
		   
	   01  WS-WORK-AREAS.
	       05  WS-SALARY-TOTAL  PIC 9(12) VALUE ZERO. 
		   05  FILE-CHECK-KEY   PIC X(2).

       01  HEADING-LINE.

            05 FILLER	        PIC X(11)  VALUE 'EMPLOYEE ID'.
            05 FILLER	        PIC X(2)   VALUE SPACES.
            05 FILLER	        PIC X(16)  VALUE 'EMPLOYEE NAME'.
            05 FILLER	        PIC X(4)   VALUE SPACES.
            05 FILLER	        PIC X(10)  VALUE 'START DATE'.
            05 FILLER	        PIC X(7)   VALUE SPACES.
            05 FILLER	        PIC X(11)  VALUE 'SALARY'.
			05 FILLER           PIC X(71)  VALUE SPACES.

			
		01  DETAIL-LINE.
			05 DET-EMP-ID       PIC 9(7).
			05 FILLER           PIC X(6) VALUE SPACES.
			05 DET-FNAME        PIC X(10).
			05 DET-LNAME        PIC X(10).
			05 DET-START-DATE.
			   07 DET-START-MON PIC X(3).
			   07 FILLER        PIC X VALUE '-'.
			   07 DET-START-DAY PIC XX.
			   07 FILLER        PIC X VALUE '-'.
			   07 DET-START-YEAR PIC X(4).
			05 DET-SALARY       PIC $$$$,$$$,$$9.
			05 FILLER           PIC X(76).
			
        01  TOTAL-LINE1.
			05 FILLER           PIC X(41) VALUE SPACES.
			05 FILLER           PIC X(15) VALUE 
			      "===============".
			05 FILLER           PIC X(75).
			
	    01  TOTAL-LINE2.
			05 FILLER           PIC X(29) VALUE SPACES.
			05 FILLER           PIC X(10) VALUE "TOTAL".
			05 TOT-SALARY       PIC $,$$$,$$$,$$$,$$9.
			05 FILLER           PIC X(76).

       PROCEDURE DIVISION.
       0100-READ-EMPLOYEES.

		   OPEN INPUT EMPLOYEEFILE
		   IF FILE-CHECK-KEY NOT = "00" 
		      DISPLAY "Non-zero file status returned from OPEN", 
			     FILE-CHECK-KEY
			  GO TO 9000-END-PROGRAM
		   END-IF.
				 
		   READ EMPLOYEEFILE
			AT END SET ENDOFFILE TO TRUE
			END-READ.
		   DISPLAY HEADING-LINE.
		   PERFORM 0200-PROCESS-EMPLOYEES UNTIL ENDOFFILE.
		   CLOSE EMPLOYEEFILE.
		   
		   MOVE WS-SALARY-TOTAL TO TOT-SALARY.
		   DISPLAY TOTAL-LINE1.
		   DISPLAY TOTAL-LINE2.
		   PERFORM 9000-END-PROGRAM.
	   0100-END.
	   
	   0200-PROCESS-EMPLOYEES.
	        MOVE EMPLOYEEID TO DET-EMP-ID.
	        MOVE LASTNAME TO DET-LNAME.
			MOVE FIRSTNAME TO DET-FNAME.
			MOVE WS-MONTH-NAME(START-MONTH) TO 
			   DET-START-MON.
			MOVE START-DAY TO DET-START-DAY.
			MOVE START-YEAR TO DET-START-YEAR.
			MOVE SALARY TO DET-SALARY.
			ADD SALARY TO WS-SALARY-TOTAL.
			DISPLAY DETAIL-LINE.
			READ EMPLOYEEFILE 
			  AT END SET ENDOFFILE TO TRUE
			END-READ.
		  
	   0200-END. 
	   
	   
	   9000-END-PROGRAM.		
           STOP RUN.
           
          END PROGRAM EMPLOYEE.
