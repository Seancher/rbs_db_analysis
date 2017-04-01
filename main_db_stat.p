DEF VAR i AS INTEGER.
DEF VAR lDatabaseName AS CHAR.
DEF VAR cDate AS CHAR.

cDate = STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)).

DO i = 1 to NUM-DBS:
   lDatabaseName = LDBNAME(i).
   DISPLAY lDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(lDatabaseName).
   RUN src/gen_db_stat.p(lDatabaseName, cDate).
END.
