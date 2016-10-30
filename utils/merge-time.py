import sys

def main(argv):
    #print argv[0], argv[1]
    fin = open(argv[0],"r")
    fout = open(argv[1],"w")
    lines = fin.readlines()
    tot_fir = 0.0
    tot_sec = 0.0
    for i in range(len(lines)/2):
        tot_fir += float(lines[2*i])
        tot_sec += float(lines[2*i+1])
    fout.write(str(tot_fir)+"\n")
    fout.write(str(tot_sec)+"\n")

    fin.close()
    fout.close()



if __name__ == "__main__":
    main(sys.argv[1:])
