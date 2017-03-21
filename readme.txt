1. Make list of all table and fields
mpro -pf /apps/deployment/rbs/db/progress/store/all.pf
run make_table_field_list.p
output: all_tablefields_<DB>_<DATE>.txt

2. Fetch database statistics
mpro -pf /apps/checkout/rbs/db/progress/store/all.pf
run make_database_stat.p
required: all_tablefields_<DB>_<DATE>.txt
output: database_stat_<DB>_<DATE>.txt

3. Preprocess database statistics
python preproc_database_stat.py
required: database_stat_<DB>_<DATE>.txt
output: used_tablefields_<DB>_<DATE>.txt