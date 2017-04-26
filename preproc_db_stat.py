import sys

dbset = ["common","rbs","rating","billing","accrec","mcdr","counter"]
date = sys.argv[1]

def beginsWithAny(seq, aset):
   """ Check whether sequence seq contains ANY of the items in aset. """
   for c in seq:
      if aset.find(c) == 0: return True
   return False

# prepare database stat report file
for db in dbset:
   reportIn  = "out/database_stat_" + db + "_" + date + ".txt"
   reportOut = reportIn[0:-4] + "_preprocessed.txt"
   fOut = open(reportOut,"w")
   notFirstLine = False
   with open(reportIn) as fIn:
      for line in fIn:
         if notFirstLine and beginsWithAny(dbset,line):
            fOut.write("\n")
         notFirstLine = True
         fOut.write(line.rstrip("\n"))
   fOut.write("\n")
   fIn.close()
   fOut.close()

# remove unused fields
for db in dbset:
   reportIn = "out/database_stat_" + db + "_" + date + "_preprocessed.txt"
   reportOut_usedFields = "out/used_tablefields_" + db + "_" + date + ".txt"
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
