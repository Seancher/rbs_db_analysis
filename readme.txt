1. Make list of all table and fields
mpro -pf /apps/deployment/db/progress/store/all.pf
run main_db_metadata.p
output: all_tablefields_<DB>_<DATE>.txt
        all_tableindexes_<DB>_<DATE>.txt
        menutree_dump_<DATE>.txt
        tmscodes_dump_<DATE>.txt
        tmsparams_dump_<DATE>.txt

2. Fetch database statistics
mpro -pf /apps/checkout/rbs/db/progress/store/all.pf
run main_db_stat.p(<DATE_DDMMYYYY>)
required: all_tablefields_<DB>_<DATE>.txt
output: database_stat_<DB>_<DATE>.txt

3. Preprocess database statistics
python preproc_database_stat.py
required: database_stat_<DB>_<DATE>.txt
output: used_tablefields_<DB>_<DATE>.txt
