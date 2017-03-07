FOR EACH EventLog BREAK BY EventLogStatus
FOR EACH EventLog BREAK BY eventdate
FOR EACH EventLog BREAK BY datavalues
** Index value is too long. (141)
Cannot Get on query  which is not opened. (3159)

skip eventlog datavalues

/* list databases, tables and fields */
DEF VAR x AS CHAR.
DEF VAR i AS INTEGER.
DEF STREAM sFile.

OUTPUT STREAM sFile TO VALUE("/home/secherno/report/all_db_list.txt").

DO i = 1 TO NUM-DBS:
   x = LDBNAME (i).
   CREATE ALIAS "DICTDB" FOR DATABASE VALUE (x).
   DISPLAY x LABEL "Database name: ".
      FOR EACH DICTDB._field, EACH DICTDB._file
      WHERE RECID (_file) = _field._fil BREAK BY (_file-name):
         IF SUBSTRING (_file-name,1,1) = "_" OR
            SUBSTRING (_file-name,1,3) = "SYS"
         THEN NEXT.
         ELSE DO:
            IF FIRST-OF (_file-name) THEN
            DISPLAY _file-name FORMAT "X(20)" _field-name.
            ELSE DISPLAY _field-name.
            PUT STREAM sFile UNFORMATTED _file-name + "|" + _field-name.
            PUT STREAM sFile UNFORMATTED SKIP.
         END.
      END.
END.


/* Find number of unique values */
DEFINE VARIABLE i AS INTEGER NO-UNDO.

FOR EACH dpmember BREAK BY dpmember.hosttable:
    IF LAST-OF(dpmember.hosttable) THEN DO:
            i = i + 1.
    END.
END.



/* Find number of unique values */
DEFINE VARIABLE bh AS HANDLE  NO-UNDO.
DEFINE VARIABLE qh AS HANDLE  NO-UNDO.
DEFINE VARIABLE cTableName AS CHAR INIT "Customer".
DEFINE VARIABLE cFieldName AS CHAR INIT "SmsNumber".
DEFINE VARIABLE iCount AS INTEGER.

CREATE BUFFER bh FOR TABLE cTableName.
CREATE QUERY qh.

qh:SET-BUFFERS(bh).
qh:QUERY-PREPARE("FOR EACH " + cTableName + " BREAK BY " + cFieldName).
qh:QUERY-OPEN().
REPEAT:
   qh:GET-NEXT().
   IF NOT bh:AVAILABLE
   THEN LEAVE.

   IF qh:FIRST-OF(1)
   THEN iCount = iCount + 1.
END.

qh:QUERY-CLOSE().
bh:BUFFER-RELEASE().
DELETE OBJECT bh.
DELETE OBJECT qh.




/* list databases, tables and fields */
DEF VAR x AS CHAR.
DEF VAR i AS INTEGER.
DEF VAR j AS INTEGER.
DEF VAR arUniqueVal AS CHAR EXTENT 7.

DEF VAR cQuery AS CHAR.
DEF VAR cQueryExt AS CHAR.

DEFINE VARIABLE bh AS HANDLE  NO-UNDO.
DEFINE VARIABLE qh AS HANDLE  NO-UNDO.
DEFINE VARIABLE cTableName AS CHAR.
DEFINE VARIABLE cFieldName AS CHAR.
DEFINE VARIABLE iCount AS INTEGER.
DEFINE VARIABLE cDelimitter AS CHAR INIT "|".
DEF STREAM sFile.

OUTPUT STREAM sFile TO VALUE("/home/schernov/report/all_db.txt").

DO i = 1 TO NUM-DBS:
   x = LDBNAME (i).
   CREATE ALIAS "DICTDB" FOR DATABASE VALUE (x).
   DISPLAY x LABEL "Database name: ".
      FOR EACH DICTDB._field, EACH DICTDB._file
      WHERE RECID (_file) = _field._fil BREAK BY (_file-name):

         IF SUBSTRING(_file-name,1,1) = "_" THEN NEXT.
         
         /* The variable is too long to unique search */
         IF _file-name = "EventLog" AND /* THE FIELD IS USED. MANY UNIQUE */
           _field-name = "DataValues" THEN NEXT.
         IF _file-name = "MsRequestParam" AND /* THE FIELD IS USED. MANY UNIQUE */
         _field-name = "CharValue" THEN NEXT.
         IF _file-name EQ "SYSSEQUENCES" THEN NEXT.

         cQuery = "FOR EACH " + _file-name + " BREAK BY " + _field-name.
      
         REPEAT j = 0 TO _Extent:
            /* If the field is an array then go thought its values */
            IF _Extent > 0 AND j = 0
            THEN NEXT.
            
            ASSIGN
               cQueryExt = ""
               iCount = 0
               arUniqueVal = "".
               
            IF _Extent > 0
            THEN cQueryExt = "[" + STRING(j) + "]".
            
            CREATE BUFFER bh FOR TABLE _file-name.
            CREATE QUERY qh.
            qh:SET-BUFFERS(bh).
            qh:QUERY-PREPARE(cQuery + cQueryExt).
            
            qh:QUERY-OPEN().
            REPEAT:
               qh:GET-NEXT().
               IF NOT bh:AVAILABLE
               THEN LEAVE.

               IF qh:FIRST-OF(1)
               THEN DO:
                  iCount = iCount + 1.
                  IF iCount < 8
                  THEN arUniqueVal[iCount] = STRING(bh:BUFFER-FIELD(_field-name):BUFFER-VALUE()).
               END.
            END.
            
            qh:QUERY-CLOSE().
            bh:BUFFER-RELEASE().
            DELETE OBJECT bh.
            DELETE OBJECT qh.
            
            PUT STREAM sFile UNFORMATTED x + cDelimitter.
            PUT STREAM sFile UNFORMATTED _file-name + cDelimitter.
            PUT STREAM sFile UNFORMATTED _field-name + cQueryExt + cDelimitter.
            PUT STREAM sFile UNFORMATTED STRING(iCount) + cDelimitter.
            PUT STREAM sFile UNFORMATTED STRING(_Extent) + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[1] + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[2] + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[3] + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[4] + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[5] + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[6] + cDelimitter.
            PUT STREAM sFile UNFORMATTED arUniqueVal[7].
            PUT STREAM sFile UNFORMATTED SKIP.
         END.
         
         PAUSE 0.
         IF FIRST-OF (_file-name)
         THEN DISPLAY _file-name FORMAT "X(20)"
                      _field-name
                      iCount
                      _Extent.
         ELSE DISPLAY _field-name
                      iCount
                      _Extent.

      END.
   PUT STREAM sFile UNFORMATTED SKIP.
END.

OUTPUT STREAM sFile CLOSE.



