/* MAIN. generate list: database, table, field */
DEF VAR i AS INTEGER.
DEF VAR cDatabaseName AS CHAR.
DEF VAR cDate AS CHAR.

cDate = STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)).

RUN src/dump_menutree.p
RUN src/dump_tmscodes.p
RUN src/dump_tmsparams.p

DO i = 1 to NUM-DBS:
   cDatabaseName = LDBNAME(i).
   DISPLAY cDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(cDatabaseName).
   RUN src/gen_db_metadata.p(cDatabaseName, cDate).
END.

