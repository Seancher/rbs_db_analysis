DEF VAR i AS INTEGER.
DEF VAR lDatabaseName AS CHAR.
DEF VAR lDate AS CHAR INIT "2812017".

DO i = 1 to NUM-DBS:
   lDatabaseName = LDBNAME(i).
   DISPLAY lDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(lDatabaseName).
   RUN src/gen_database_stat.p(lDatabaseName, lDate).
END.
