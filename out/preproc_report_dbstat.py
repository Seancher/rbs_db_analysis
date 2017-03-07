db = 'common,rbs,rating,billing,accrec,mcdr,counter'
reportin  = "db_report.txt"
reportout = reportin[0:-4] + "_preprocessed.txt"

def beginsWithAny(seq, aset):
   """ Check whether sequence seq contains ANY of the items in aset. """
   for c in seq:
      if aset.find(c) == 0: return True
   return False

# main
fout = open(reportout,"w")
with open(reportin) as fin:
   for line in fin:
      if beginsWithAny(db,line):
         fout.write("\n")
      fout.write(line.rstrip("\n"))
