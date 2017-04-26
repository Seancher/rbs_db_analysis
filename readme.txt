1. Make list of all table and fields
run: mpro -pf /apps/deployment/db/progress/store/all.pf
run main_db_metadata.p
output: all_tablefields_<DB>_<DDMMYYYY{TODAY}>.txt
        all_tableindexes_<DB>_<DDMMYYYY{TODAY}>.txt
        menutree_dump_<DDMMYYYY{TODAY}>.txt
        tmscodes_dump_<DDMMYYYY{TODAY}>.txt
        tmsparams_dump_<DDMMYYYY{TODAY}>.txt

2. Fetch database statistics
run: mpro -pf /apps/checkout/rbs/db/progress/store/all.pf
run main_db_stat.p(<DDMMYYYY{Step1Date}>)
required: all_tablefields_<DB>_<DDMMYYYY{Step1Date}>.txt
output: database_stat_<DB>_<DDMMYYYY{TODAY}>.txt

3. Preprocess database statistics
run: python preproc_database_stat.py <DDMMYYYY{Step2Date}>
required: database_stat_<DB>_<DDMMYYYY{Step2Date}>.txt
output: used_tablefields_<DB>_<DDMMYYYY{Step2Date}>.txt

NB: <DDMMYYYY{Step1Date}> - date when metadata script (step 1) was run
NB: <DDMMYYYY{Step2Date}> - date when database stat script (step 2) was run


Example run if today is "21/04/2017":
cd rbs_db_analysis
1. Staging environment. Make list of all table and fields
   mpro -pf /apps/deployment/db/progress/store/all.pf
   run main_db_metadata.p
2. Staging environment. Fetch database statistics
   mpro -pf /apps/checkout/rbs/db/progress/store/all.pf
   run main_db_stat.p("21042017")
3. Staging/local environment. Preprocess database statistics
   python preproc_database_stat.py 21042017
