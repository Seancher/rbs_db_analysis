DEF VAR i AS INTEGER.
DEF VAR lDatabaseName AS CHAR.
DEF INPUT PARAMETER icDate AS CHAR.

DO i = 1 to NUM-DBS:
   lDatabaseName = LDBNAME(i).
   DISPLAY lDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(lDatabaseName).
   RUN src/gen_db_stat.p(lDatabaseName, icDate).
END.
