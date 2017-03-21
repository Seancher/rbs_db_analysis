/* MAIN. generate list: database, table, field */
DEF VAR i AS INTEGER.
DEF VAR cDatabaseName AS CHAR.
DEF VAR cDate AS CHAR.

cDate = STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)).

DO i = 1 to NUM-DBS:
   cDatabaseName = LDBNAME(i).
   DISPLAY cDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(cDatabaseName).
   RUN src/gen_table_field_list.p(cDatabaseName, cDate).
END.