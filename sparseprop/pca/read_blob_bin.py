import struct

def read_bin():
    f = open("000001.fc7-1","rb")
    s = struct.unpack("i"*5,f.read(4*5))
    print s
    m = s[0]*s[1]*s[2]*s[3]*s[4]
    data = struct.unpack("f"*m, f.read(4*m))
    print data
    f.close()





def main():
    read_bin()



###
main()
