/* MAIN. generate list: database, table, field, menutree, tmscodes, tmsparams */
DEF VAR i AS INTEGER.
DEF VAR cDatabaseName AS CHAR.
DEF VAR cDate AS CHAR.

cDate = STRING(DAY(TODAY),"99") +
        STRING(MONTH(TODAY),"99") +
        STRING(YEAR(TODAY),"9999").

RUN src/dump_menutree.p.
RUN src/dump_tmscodes.p.
RUN src/dump_tmsparams.p.

DO i = 1 to NUM-DBS:
   cDatabaseName = LDBNAME(i).
   DISPLAY cDatabaseName LABEL "Database name: ".
   RUN src/create_alias.p(cDatabaseName).
   RUN src/gen_db_metadata.p(cDatabaseName, cDate).
END.

