import sys
import os.path

foldername = sys.argv[1]
dbname = sys.argv[2]
date = sys.argv[3]

if not os.path.isfile(foldername + "database_stat_" + dbname + "_" + date + ".txt"):
    print ("No file: " + foldername + "database_stat_" + dbname + "_" + date + ".txt")
    quit()
else: 
    print("Processing: " + foldername + "database_stat_" + dbname + "_" + date + ".txt") 

# prepare database stat report file
reportIn  = foldername + "database_stat_" + dbname + "_" + date + ".txt"
reportOut = reportIn[0:-4] + "_preprocessed.txt"
fOut = open(reportOut,"w")
notFirstLine = False
with open(reportIn) as fIn:
  for line in fIn:
     if notFirstLine and line.find(dbname) == 0:
        fOut.write("\n")
     notFirstLine = True
     fOut.write(line.rstrip("\n"))
fOut.write("\n")
fIn.close()
fOut.close()

# remove unused fields
reportIn = foldername + "database_stat_" + dbname + "_" + date + "_preprocessed.txt"
reportOut_usedFields = foldername + "used_tablefields_" + dbname + "_" + date + ".txt"
fOut_usedFields = open(reportOut_usedFields,"w")
curline = ""
with open(reportIn) as fIn:
  for line in fIn:
     if line.split("|")[3] == "0" or \
        (line.split("|")[3] == "1" and line.split("|")[5] == "0") or \
        (line.split("|")[3] == "1" and line.split("|")[5] == "?") or \
        (line.split("|")[3] == "1" and line.split("|")[5] == ""):
        "skip this field"
     else:
        fOut_usedFields.write(".".join(line.split("|")[1:3]))
        fOut_usedFields.write("\n")
fOut_usedFields.write("\n")
fIn.close()
fOut_usedFields.close()
