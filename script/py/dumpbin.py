# -*- coding: utf-8 -*-
import sys
import struct

def main():
	if sys.argv.__len__() < 2:
		print "usage: dumpbin.py file"
		return
	
	infile = open(sys.argv[1], "r")
	data = infile.read()

	i = 0
	addr = 0
	str = ""

	for c in range(len(data)):
		if i == 0:
			sys.stdout.write("0x%08X: " % addr)
		
		sys.stdout.write('%02X' % ord(data[c]))
		i += 1
		
		if ord(data[c]) > 32 and ord(data[c]) < 127:
			str += data[c]
		else:
			str += "."
		
		if i < 16:
			sys.stdout.write(" ")
		else:
			sys.stdout.write("  " + str + "\n")
			i = 0
			addr += 16
			str = ""
	
	if i != 0:
		sys.stdout.write("  ")
		for j in range(15-i):
			sys.stdout.write("   ")
		sys.stdout.write("  " + str + "\n")


if __name__ == '__main__':
    main()

