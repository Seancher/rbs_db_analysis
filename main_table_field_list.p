/* MAIN. generate list: database, table, field */
DEF VAR i AS INTEGER.
DEF VAR lDatabaseName AS CHAR.

DO i = 1 to NUM-DBS:
   lDatabaseName = LDBNAME(i).
   DISPLAY lDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(lDatabaseName).
   RUN src/gen_table_field_list.p(lDatabaseName).
END.