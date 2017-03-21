dbset = ["common","rbs","rating","billing","accrec","mcdr","counter"]
date = "2132017"

def beginsWithAny(seq, aset):
   """ Check whether sequence seq contains ANY of the items in aset. """
   for c in seq:
      if aset.find(c) == 0: return True
   return False

# prepare database stat report file
for db in dbset:
   reportin  = "report/database_stat_" + db + "_" + date + ".txt"
   reportout = reportin[0:-4] + "_preprocessed.txt"
   fout = open(reportout,"w")
   notfirstline = False
   with open(reportin) as fin:
       for line in fin:
          if notfirstline and beginsWithAny(dbset,line):
             fout.write("\n")
	  notfirstline = True
          fout.write(line.rstrip("\n"))
fin.close()
fout.close()

# remove unused fields
for db in dbset:
   reportin = "out/database_stat_" + db + "_" + date + "_preprocessed.txt"
   reportout_usedfields   = "out/usedfields_" + db + "_" + date + ".txt"
   fout_usedfields = open(reportout_usedfields,"w")
   curline = ""
   with open(reportin) as fin:
      for line in fin:
         if line.split("|")[3] == "0" or \
	        (line.split("|")[3] == "1" and line.split("|")[5] == "0") or \
            (line.split("|")[3] == "1" and line.split("|")[5] == "?") or \
            (line.split("|")[3] == "1" and line.split("|")[5] == ""):
	        "hello"
 	     else:
	        fout_usedfields.write(",".join(line.split("|")[1:3]))
	        fout_usedfields.write("\n")
   fin.close()
   fout_usedfields.close()
