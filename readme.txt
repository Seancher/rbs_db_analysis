0.
secherno@vega>> cd ~/rbs_doc/rbs_db_analysis/
secherno@vega>> export TERM=xterm

1. Make list of all table and fields
secherno@vega>> /opt/dlc/bin/mpro -pf /apps/deployment/db/progress/store/all.pf
in progress: run main_db_metadata.p
output file: all_tablefields_<DB>_<DDMMYYYY{TODAY}>.txt
             all_tableindexes_<DB>_<DDMMYYYY{TODAY}>.txt
             menutree_dump_<DDMMYYYY{TODAY}>.txt
             tmscodes_dump_<DDMMYYYY{TODAY}>.txt
             tmsparams_dump_<DDMMYYYY{TODAY}>.txt

2. Fetch database statistics
secherno@vega>> /opt/dlc/bin/mpro -pf /apps/checkout/db/progress/store/all.pf
in progress: run main_db_stat.p(<DDMMYYYY{Step1Date}>)
required file: all_tablefields_<DB>_<DDMMYYYY{Step1Date}>.txt
output file: database_stat_<DB>_<DDMMYYYY{TODAY}>.txt

3. Preprocess database statistics
secherno@vega>> python main_process_db_stat.py <FolderName> <DDMMYYYY{Step2Date}>
<FolderName> - folder where the required/output files are stored
required file: database_stat_<DB>_<DDMMYYYY{Step2Date}>.txt
output file: used_tablefields_<DB>_<DDMMYYYY{Step2Date}>.txt

NB: <DDMMYYYY{Step1Date}> - date when metadata script (step 1) was run
NB: <DDMMYYYY{Step2Date}> - date when database stat script (step 2) was run


Example run if today is "21/04/2017":
cd rbs_db_analysis
0. secherno@vega>> cd ~/rbs_doc/rbs_db_analysis/
   secherno@vega>> export TERM=xterm 
1. Staging environment. Make list of all table and fields
   secherno@vega>> /opt/dlc/bin/mpro -pf /apps/deployment/db/progress/store/all.pf
   in progress: run main_db_metadata.p
2. Staging environment. Fetch database statistics
   secherno@vega>> /opt/dlc/bin/mpro -pf /apps/checkout/rbs/db/progress/store/all.pf
   in progress: run main_db_stat.p("21042017")
3. Staging/local environment. Preprocess database statistics
   python main_preproc_database_stat.py out 21042017
