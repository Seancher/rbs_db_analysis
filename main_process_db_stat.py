import os
import sys

foldername = sys.argv[1] + "/"
date = sys.argv[2]

dbset = ["common","rbs","rating","billing","accrec","mcdr","counter","fraudcdr","mcdrdtl","mobile","ordercanal","prepcdr","prepedr","reratelog","roamcdr","star"]

for db in dbset:
    os.system('python src/preproc_db_stat.py ' + foldername + ' ' + db + ' ' + date)