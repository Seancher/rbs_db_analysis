DEFINE INPUT PARAMETER ilDBName AS CHAR.
DEFINE INPUT PARAMETER ilDate AS CHAR.

/* list databases, tables and fields */
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
DEFINE STREAM sFile.

/* Fetch the list: database, table, field */
DEFINE VARIABLE cTextString AS CHARACTER.
DEFINE VARIABLE cDbTableField AS LONGCHAR.

INPUT FROM VALUE("report/table_field_list_" + ilDBName + "_" + ilDate + ".txt").

DO WHILE TRUE ON ENDKEY UNDO, LEAVE:
   IMPORT UNFORMATTED cTextString.
   cDbTableField = cDbTableField + cTextString + ";".
END.

INPUT CLOSE.

/* Generate database statistics */
OUTPUT STREAM sFile TO VALUE("report/database_stat_" + ilDBName + "_" +
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").
      
FOR EACH DICTDB._field, EACH DICTDB._file
   WHERE RECID (_file) = _field._file-recid BREAK BY (_file-name):

   IF SUBSTRING(_file-name, 1, 1) = "_" OR
      SUBSTRING(_file-name, 1, 3) = "SYS" OR
      INDEX(cDbTableField, _file-name + "," + _field-name) = 0
   THEN NEXT.
   
   cQuery = "FOR EACH " + ilDBName + "." + _file-name + 
            " BREAK BY " + _field-name.

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

      /* Count number of unique */
      DO WHILE TRUE:
      CREATE BUFFER bh FOR TABLE SUBSTITUTE("&1.&2",ilDBName,_file._file-name).
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
         LEAVE.
      END. /* End of Count number of unique */

      qh:QUERY-CLOSE().
      bh:BUFFER-RELEASE().
      DELETE OBJECT bh.
      DELETE OBJECT qh.

      PUT STREAM sFile UNFORMATTED ilDBName + cDelimitter.
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

      IF FIRST-OF (_file-name)
      THEN DISPLAY _file-name FORMAT "X(20)"
                   _field-name
                    iCount
                   _Extent with frame f.
      ELSE DISPLAY _field-name
                    iCount
                   _Extent with frame f.
      PAUSE 0.
   END.

END.

OUTPUT STREAM sFile CLOSE.
