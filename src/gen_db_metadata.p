/* generate list: database, table, field */
DEFINE INPUT PARAMETER ilDBName AS CHAR.
DEFINE INPUT PARAMETER icDate AS CHAR.

DEFINE VARIABLE cDelimitter AS CHAR INIT ".".
DEFINE STREAM sTableField.
DEFINE STREAM sTableIndex.

OUTPUT STREAM sTableField TO VALUE("out/all_tablefields_" + ilDBName + "_" + 
   icDate + ".txt").
OUTPUT STREAM sTableIndex TO VALUE("out/all_tableindexes_" + ilDBName + "_" + 
   icDate + ".txt").

FOR EACH DB._file BY DB._file._file-name:
   /* Skip historical ("X") and system ("_","SYS") fields */
   IF SUBSTRING(DB._file._file-name,1,1) = "X" OR
      SUBSTRING(DB._file._file-name,1,1) = "_" OR
      SUBSTRING(DB._file._file-name,1,3) = "SYS"
   THEN NEXT.
   
   /* Store the list of table-field-isIndexed */
   FOR EACH DB._field OF DB._file:
      FIND FIRST DB._index-field
         WHERE DB._index-field._field-recid = RECID(DB._field) NO-ERROR.
   
      PUT STREAM sTableField UNFORMATTED
         DB._file._file-name cDelimitter
         DB._field._field-name cDelimitter
         AVAILABLE DB._index-field SKIP.
   END.
   
   /* Store the list of table-indexes */
   FOR EACH DB._index OF DB._file:
      IF DB._index._index-name NE "default"
      THEN PUT STREAM sTableIndex UNFORMATTED
            DB._file._file-name cDelimitter
            DB._index._index-name cDelimitter
            RECID(DB._index) = DB._file._prime-index SKIP.
   END.
END.
OUTPUT STREAM sTableIndex CLOSE.
OUTPUT STREAM sTableField CLOSE.
