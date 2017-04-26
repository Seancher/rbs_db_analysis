DEF VAR lcDelimitter AS CHAR INIT "|".

DEF STREAM sFile.

OUTPUT STREAM sFile TO VALUE("out/tmscodes_dump_" + 
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").

/* Write table header */
PUT STREAM sFile UNFORMATTED
   "Group" lcDelimitter
   "Table Name" lcDelimitter
   "Field Name" lcDelimitter
   "Description" lcDelimitter
   "Value" lcDelimitter
   "Used" lcDelimitter
   "Configuration Value" lcDelimitter
   "Memo" SKIP.

/* Fill table */
FOR EACH TmsCodes:
   PUT STREAM sFile UNFORMATTED
      TmsCodes.CodeGroup lcDelimitter
      TmsCodes.TableName lcDelimitter
      TmsCodes.FieldName lcDelimitter
      TmsCodes.CodeName lcDelimitter
      TmsCodes.CodeValue lcDelimitter
      STRING(TmsCodes.InUse EQ 1,"Yes/No") lcDelimitter
      TmsCodes.ConfigValue lcDelimitter
      TmsCodes.Memo SKIP.
END.

OUTPUT STREAM sFile CLOSE.
