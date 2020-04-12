       IDENTIFICATION DIVISION.
       PROGRAM-ID. WIKIIDX.
      * CREATE AN INDEXED FILE FROM A SEQUENTIAL FILE
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

	   SELECT WIKIFILESEQ ASSIGN TO "wikipedia.dat"	  
	     ORGANIZATION IS LINE SEQUENTIAL.
       
       SELECT WIKIFILEIDX ASSIGN TO "WIKIIDX.DAT"
        FILE STATUS IS FILE-CHECK-KEY
		ORGANIZATION IS INDEXED
		ACCESS MODE IS RANDOM
		RECORD KEY IS WIKI-ID-IDX
		ALTERNATE RECORD KEY IS WIKI-TOPIC-IDX
		   WITH DUPLICATES.

       DATA DIVISION.
       FILE SECTION.
	   FD WIKIFILEIDX.
	   01 WIKIRECORDIDX.
	      05 WIKI-TOPIC-IDX         PIC X(50).
		  05 WIKI-ID-IDX            PIC 9(8).
		  05 WIKI-COMMENT-IDX       PIC X(100).
	
       FD WIKIFILESEQ.
	   01 WIKIRECORDSEQ.
	      88 ENDOFFILE      VALUE   HIGH-VALUES.
	      05 WIKI-TOPIC-SEQ         PIC X(50).
		  05 WIKI-ID-SEQ            PIC 9(8).
		  05 WIKI-COMMENT-SEQ       PIC X(100).
	
		
       WORKING-STORAGE SECTION.
       01  WS-WORKING-STORAGE.
           05 FILLER      PIC X(27) VALUE 
		      'WORKING STORAGE STARTS HERE'.
     
   
	   01  WS-WORK-AREAS.
	       05  FILE-CHECK-KEY     PIC X(2).

		 

       PROCEDURE DIVISION.
       0100-READ-MOVIES.

		   OPEN INPUT WIKIFILESEQ.
		   OPEN OUTPUT WIKIFILEIDX.
		   				
           READ WIKIFILESEQ 
		     AT END SET ENDOFFILE TO TRUE
		   END-READ.
		   PERFORM 0200-PROCESS-FILE UNTIL
		      ENDOFFILE.
		 
		   PERFORM 9000-END-PROGRAM.
		   
	   0100-END.
	   
	   0200-PROCESS-FILE.
	  
		   WRITE WIKIRECORDIDX FROM WIKIRECORDSEQ
		      INVALID KEY DISPLAY 
			     "WIKI STATUS = " FILE-CHECK-KEY
		   END-WRITE.
		   READ WIKIFILESEQ
		      AT END SET ENDOFFILE TO TRUE.
		0200-END.
		   
	   9000-END-PROGRAM.
           CLOSE WIKIFILESEQ, WIKIFILEIDX. 
      	   
		 
                
           STOP RUN.
           
          END PROGRAM WIKIIDX.
