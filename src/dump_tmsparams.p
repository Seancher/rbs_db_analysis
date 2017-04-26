DEF VAR lcParamType  AS CHAR.
DEF VAR lcParamVal   AS CHAR.
DEF VAR lcDelimitter AS CHAR INIT "|".

DEF STREAM sFile.

OUTPUT STREAM sFile TO VALUE("out/tmsparams_dump_" + 
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").

/* Write table header */
PUT STREAM sFile UNFORMATTED
   "Group" lcDelimitter 
   "Parameter" lcDelimitter
   "Type" lcDelimitter
   "Value" lcDelimitter
   "Description" SKIP.

/* Fill table */
FOR EACH TmsParam:
   CASE TmsParam.ParamType:
   WHEN "I"  THEN ASSIGN
      lcParamType = "Int"
      lcParamVal = STRING(TmsParam.IntVal).
   WHEN "D"  THEN ASSIGN
      lcParamType = "Dec"
      lcParamVal = STRING(TmsParam.DecVal).
   WHEN "DA" THEN ASSIGN
      lcParamType = "Date"
      lcParamVal = STRING(TmsParam.DateVal).
   WHEN "C"  THEN ASSIGN
      lcParamType = "Char"
      lcParamVal = REPLACE(TmsParam.CharVal,"~n"," ").
   END.

   PUT STREAM sFile UNFORMATTED
      TmsParam.ParamGroup lcDelimitter 
      TmsParam.ParamCode lcDelimitter
      lcParamType lcDelimitter
      lcParamVal lcDelimitter
      TmsParam.ParamName SKIP.
END.

OUTPUT STREAM sFile CLOSE.
