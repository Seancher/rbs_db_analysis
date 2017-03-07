/* generate list: database, table, field */
DEFINE INPUT PARAMETER ilDBName AS CHAR.
DEFINE VARIABLE cDelimitter AS CHAR INIT ",".
DEFINE STREAM sFile.

OUTPUT STREAM sFile TO VALUE("report/table_field_list_" + ilDBName + "_" + 
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").

FOR EACH DICTDB._field, EACH DICTDB._file
   WHERE RECID (_file) = _field._file-recid BREAK BY (_file-name):

   IF SUBSTRING(_file-name,1,1) = "_" OR
      SUBSTRING(_file-name,1,3) = "SYS"
   THEN NEXT.
   
   PUT STREAM sFile UNFORMATTED _file._file-name + cDelimitter +
                                _field._field-name.
   PUT STREAM sFile UNFORMATTED SKIP.
END.

OUTPUT STREAM sFile CLOSE.
