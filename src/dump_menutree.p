DEF VAR lcDelimitter AS CHAR INIT "|".
DEF VAR lcMenuText   AS CHAR.

DEF STREAM sFile.

OUTPUT STREAM sFile TO VALUE("out/menutree_dump_" + 
   STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt").

/* Write table header */
PUT STREAM sFile UNFORMATTED
   "Menu level" lcDelimitter     "Menu place" lcDelimitter
   "Menu number" lcDelimitter    "Menu label" lcDelimitter
   "Function type" lcDelimitter  "Module" lcDelimitter
   "Function code" lcDelimitter  "Function name" lcDelimitter
   "Program Class" lcDelimitter  "Deny usage" lcDelimitter
   "Token code" SKIP.

/* Fill table */
FOR EACH MenuTree:
   lcMenuText = "".
   FIND FIRST MenuText
      WHERE MenuText.MenuNum = MenuTree.MenuNum NO-LOCK NO-ERROR.
   IF AVAILABLE MenuText THEN DO:
      lcMenuText = TRIM(SUBSTRING(MenuText.MenuText,1,8)) + " " +
                   TRIM(SUBSTRING(MenuText.MenuText,9,16)).
   END.

   PUT STREAM sFile UNFORMATTED
      MenuTree.Level lcDelimitter /* label "Menu Level ....." help  "Level 1 ... 8 and 0: functions outside MenuText " */
      MenuTree.Position lcDelimitter /*  label "Menu place ....." help  "Place 1 ... 8 or  0 if Level is 0" */
      MenuTree.MenuNum lcDelimitter /*  label "MENU- number ..." format "zzz9" */
      lcMenuText lcDelimitter /*  LABEL "Label" */
      MenuTree.MenuType lcDelimitter /*   label "Function type .." */
      MenuTree.Module lcDelimitter /*  label "Module ........." help "The name of the module Called if function = 3, otherwise empty" */
      MenuTree.MenuId lcDelimitter /*   label "Function code .." */
      MenuTree.MenuTitle lcDelimitter /*  label "Function name .." help "Func. name (lowercase) or MenuText HEADER (uppercase)" */
      MenuTree.MenuClass lcDelimitter /*  label "Program Class .." */
      MenuTree.State[1] lcDelimitter /*  label "Deny usage ....." help "If YES the this MenuText can't be used !" SKIP */
      MenuTree.TokenCode SKIP. /*  label "Token code ....." help "Token code for this menu item" */
END.

OUTPUT STREAM sFile CLOSE.