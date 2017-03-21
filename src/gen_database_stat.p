DEFINE INPUT PARAMETER icDBName AS CHAR.
DEFINE INPUT PARAMETER icDate AS CHAR.

/* list databases, tables and fields */
DEF VAR i AS INTEGER.
DEF VAR j AS INTEGER.
DEF VAR arUniqueVal AS CHAR EXTENT 40.
DEF VAR iNumOfUniqueVals AS INTEGER INIT 40.

DEF VAR cQuery AS CHAR.
DEF VAR cQueryExt AS CHAR.
   
DEFINE VARIABLE bh AS HANDLE  NO-UNDO.
DEFINE VARIABLE qh AS HANDLE  NO-UNDO.
DEFINE VARIABLE cTableName AS CHAR.
DEFINE VARIABLE cFieldName AS CHAR.
DEFINE VARIABLE iCount AS INTEGER.
DEFINE VARIABLE cDelimitter AS CHAR INIT "|".
DEFINE STREAM sFile.

/* Fetch the list: database, table, field */
DEFINE VARIABLE cTextString AS CHARACTER.
DEFINE VARIABLE cDbTableField AS LONGCHAR.

INPUT FROM VALUE("out/table_field_list_" + icDBName + "_" + icDate + ".txt").

DO WHILE TRUE ON ENDKEY UNDO, LEAVE:
   IMPORT UNFORMATTED cTextString.
   cDbTableField = cDbTableField + cTextString + ";".
END.

INPUT CLOSE.

/* Generate database statistics */
OUTPUT STREAM sFile TO VALUE("out/database_stat_" + icDBName + "_" + 
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").
      
FOR EACH DB._field, EACH DB._file
   WHERE RECID (DB._file) = DB._field._file-recid BREAK BY (DB._file._file-name):

   IF SUBSTRING(DB._file._file-name, 1, 1) = "_" OR
      SUBSTRING(DB._file._file-name, 1, 3) = "SYS" OR
      INDEX(cDbTableField, ";" + DB._file._file-name + "." + DB._field._field-name + ";") = 0
   THEN NEXT.
   
   cQuery = "FOR EACH " + icDBName + "." + DB._file._file-name + 
            " BREAK BY " + DB._field._field-name.

   REPEAT j = 0 TO DB._field._extent:
      /* If the field is an array then go thought its values */
      IF DB._field._extent > 0 AND j = 0
      THEN NEXT.

      ASSIGN
         cQueryExt = ""
         iCount = 0
         arUniqueVal = "".

      IF DB._field._extent > 0
      THEN cQueryExt = "[" + STRING(j) + "]".

      /* Count number of unique */
      DO WHILE TRUE:
      CREATE BUFFER bh FOR TABLE SUBSTITUTE("&1.&2",icDBName,DB._file._file-name).
         CREATE QUERY qh.
         qh:SET-BUFFERS(bh).
         qh:QUERY-PREPARE(cQuery + cQueryExt) NO-ERROR.
         qh:QUERY-OPEN() NO-ERROR.

         /* cannot calculate number of unique values */
         IF NOT qh:IS-OPEN
         THEN DO:
            iCount = -1.
            LEAVE.
         END.

         REPEAT:
            IF iCount EQ 100
            THEN LEAVE.
            
            qh:GET-NEXT().
            IF NOT bh:AVAILABLE
            THEN LEAVE.

            IF qh:FIRST-OF(1)
            THEN DO:
               iCount = iCount + 1.
               IF iCount <= iNumOfUniqueVals
               THEN arUniqueVal[iCount] = STRING(bh:BUFFER-FIELD(DB._field._field-name):BUFFER-VALUE()).
            END.
         END.
         LEAVE.
      END. /* End of Count number of unique */

      qh:QUERY-CLOSE().
      bh:BUFFER-RELEASE().
      DELETE OBJECT bh.
      DELETE OBJECT qh.

      PUT STREAM sFile UNFORMATTED icDBName cDelimitter.
      PUT STREAM sFile UNFORMATTED DB._file._file-name cDelimitter.
      PUT STREAM sFile UNFORMATTED DB._field._field-name cQueryExt cDelimitter.
      IF iCount EQ 100
      THEN PUT STREAM sFile UNFORMATTED ">" STRING(iCount) cDelimitter.
      ELSE PUT STREAM sFile UNFORMATTED STRING(iCount) cDelimitter.
      PUT STREAM sFile UNFORMATTED STRING(DB._field._extent) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[1]) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[2]) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[3]) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[4]) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[5]) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[6]) cDelimitter.
      PUT STREAM sFile UNFORMATTED TRIM(arUniqueVal[7]).
      PUT STREAM sFile UNFORMATTED SKIP.

      IF FIRST-OF (DB._file._file-name)
      THEN DISPLAY DB._file._file-name FORMAT "X(20)"
                   DB._field._field-name
                   iCount
                   DB._field._extent with frame f.
      ELSE DISPLAY DB._field._field-name
                   iCount
                   DB._field._extent with frame f.
      PAUSE 0.
   END.

END.

OUTPUT STREAM sFile CLOSE.
