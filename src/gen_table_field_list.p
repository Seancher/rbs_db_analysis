/* generate list: database, table, field */
DEFINE INPUT PARAMETER ilDBName AS CHAR.
DEFINE VARIABLE cDelimitter AS CHAR INIT ".".
DEFINE STREAM sFile.

OUTPUT STREAM sFile TO VALUE("out/table_field_list_" + ilDBName + "_" + 
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").

FOR EACH DB._field, EACH DB._file
   WHERE RECID (DB._file) = DB._field._file-recid BREAK BY (DB._file._file-name):

   IF SUBSTRING(DB._file._file-name,1,1) = "_" OR
      SUBSTRING(DB._file._file-name,1,3) = "SYS"
   THEN NEXT.
   
   PUT STREAM sFile UNFORMATTED ";" DB._file._file-name cDelimitter
                                DB._field._field-name ";".
   PUT STREAM sFile UNFORMATTED SKIP.
END.

OUTPUT STREAM sFile CLOSE.
