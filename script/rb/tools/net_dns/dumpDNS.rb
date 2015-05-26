#!/usr/bin/ruby

def dumpbin( f, data )
	dumpLine = lambda {|d, o|
		chars = ""
		line = sprintf("0x%08X: ", o)
		d.each_byte do |bytedata|
			line << sprintf("%02X ", bytedata)
			chars << ((bytedata >= 0x20 && bytedata <= 0x7e) ? bytedata.chr : '.')
		end
		line << "   " * (16 - d.length)
		return (line + " " + chars + "\n")
	}
	offset = 0
	while d = data[offset, 16]
		f.print dumpLine.call(d, offset)
		offset += 16
	end
end

# DNS TYPE value
# http://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-4
$dns_type_tbl = {
	1 => "A (a host address)",
	2 => "NS (an authoritative name server)",
	3 => "MD (a mail destination (Obsolete - use MX))",
	4 => "MF (a mail forwarder (Obsolete - use MX))",
	5 => "CNAME (the canonical name for an alias)",
	6 => "SOA (marks the start of a zone of authority)",
	7 => "MB (a mailbox domain name (EXPERIMENTAL))",
	8 => "MG (a mail group member (EXPERIMENTAL))",
	9 => "MR (a mail rename domain name (EXPERIMENTAL))",
	10 => "NULL (a null RR (EXPERIMENTAL))",
	11 => "WKS (a well known service description)",
	12 => "PTR (a domain name pointer)",
	13 => "HINFO (host information)",
	14 => "MINFO (mailbox or mail list information)",
	15 => "MX (mail exchange)",
	16 => "TXT (text strings)",
	17 => "RP (for Responsible Person)",
	18 => "AFSDB (for AFS Data Base location)",
	19 => "X25 (for X.25 PSDN address)",
	20 => "ISDN (for ISDN address)",
	21 => "RT (for Route Through)",
	22 => "NSAP (for NSAP address, NSAP style A record)",
	23 => "NSAP-PTR (for domain name pointer, NSAP style)",
	24 => "SIG (for security signature)",
	25 => "KEY (for security key)",
	26 => "PX (X.400 mail mapping information)",
	27 => "GPOS (Geographical Position)",
	28 => "AAAA (IP6 Address)",
	29 => "LOC (Location Information)",
	30 => "NXT (Next Domain (OBSOLETE))",
	31 => "EID (Endpoint Identifier)",
	32 => "NIMLOC (Nimrod Locator)",
	33 => "SRV (Server Selection)",
	34 => "ATMA (ATM Address)",
	35 => "NAPTR (Naming Authority Pointer)",
	36 => "KX (Key Exchanger)",
	37 => "CERT",
	38 => "A6 (A6 (OBSOLETE - use AAAA))",
	39 => "DNAME",
	40 => "SINK",
	41 => "OPT",
	42 => "APL",
	43 => "DS (Delegation Signer)",
	44 => "SSHFP (SSH Key Fingerprint)",
	45 => "IPSECKEY",
	46 => "RRSIG",
	47 => "NSEC",
	#QTYPE value
	252 => "AXFR",
	253 => "MAILB",
	254 => "MAILA",
	255 => "*"
}
$dns_type_tbl.default = "???"

# DNS CLASS value
$dns_class_tbl = {
	1 => "IN",
	2 => "CS",
	3 => "CH",
	4 => "HS",
	#QCLASS value
	255 => "*"
}
$dns_class_tbl.default = "???"

def getLabel( data, offset, prefix )
#	printf("getLabel: offset=%d, prefix=%s\n", offset, prefix)
	label = prefix
	loop do
		len = data[offset, 1].unpack("C*")[0]
		if ( (len & 0xC0) == 0xC0 )
			# pointer
			ptr = ( data[offset, 2].unpack("n*")[0] & 0x3FFF )
			offset += 2
			label, ptr = getLabel(data, ptr, label)
			break
		else
			# length + label
			offset += 1
			break if ( len == 0 )
			label += "." if ( label != "" )
			label += data[offset, len]
			offset += len
		end
	end
	return [label, offset]
end

def getText( data, offset, size )
#	printf("getText: offset=%d, size=%d\n", offset, size)
	readed = 0
	label = ""
	loop do
		len = data[offset, 1].unpack("C*")[0]
		offset += 1
		readed += 1
		break if ( len == 0 )
		
		label += data[offset, len] + "\n"
		offset += len
		readed += len
		break if ( readed >= size )
	end
	return label
end

def dumpQuestionRecord( f, data, offset )
#	printf("dumpResourceRecord: offset=%d\n", offset)
#	dumpbin(f, data[offset..-1])
	
	name = ""
	name, offset = getLabel(data, offset, "")
	type = data[offset, 2].unpack("n*")[0]
	offset += 2
	cls = data[offset, 2].unpack("n*")[0]
	offset += 2
	
	if ( (cls & 0x8000) > 0 )
		clsflg = "(QU)"
	else
		clsflg = "(QM)"
	end
	
	f.printf("Name   = %s\n", name)
	f.printf("Qtype  = 0x%x - %s\n", type, $dns_type_tbl[type])
	f.printf("Qclass = 0x%x - %s %s\n", cls, $dns_class_tbl[(cls & 0x7FFF)], clsflg)
	
	return offset
end

def dumpResourceRecord( f, data, offset )
#	printf("dumpResourceRecord: offset=%d\n", offset)
#	dumpbin(f, data[offset..-1])
	
	name = ""
	name, offset = getLabel(data, offset, "")
	type = data[offset, 2].unpack("n*")[0]
	offset += 2
	cls = data[offset, 2].unpack("n*")[0]
	offset += 2
	ttl = data[offset, 4].unpack("N*")[0]
	offset += 4
	rdlen =  data[offset, 2].unpack("n*")[0]
	offset += 2
	
	if ( (cls & 0x8000) > 0 )
		clsflg = "(with cache flush)"
	else
		clsflg = ""
	end
	
	f.printf("Name   = %s\n", name)
	f.printf("Type   = 0x%x - %s\n", type, $dns_type_tbl[type])
	f.printf("Class  = 0x%x - %s %s\n", cls, $dns_class_tbl[(cls & 0x7FFF)], clsflg)
	f.printf("TTL    = %d\n", ttl)
	f.printf("RDLen  = %u\n", rdlen)
	
	if ( rdlen > 0 )
		f.print "** RDATA **\n"
		case type
		when 12 #PTR
			label, tmpval = getLabel(data, offset, "")
			f.printf("%s\n", label)
		when 16 #TXT
			text = getText(data, offset, rdlen)
			f.printf("%s\n", text)
		else
			dumpbin(f, data[offset, rdlen])
		end
		offset += rdlen
	end
	return offset
end

def dumpDNS( f, data )
	#--------------------
	# header
	#--------------------
	id = data[0, 2].unpack("n*")[0]
	flag = data[2, 2].unpack("n*")[0]
	qd_cnt = data[4, 2].unpack("n*")[0]
	an_cnt = data[6, 2].unpack("n*")[0]
	ns_cnt = data[8, 2].unpack("n*")[0]
	ar_cnt = data[10, 2].unpack("n*")[0]
	
	f.print "----------------------------------------------\n"
	f.print "<header>\n"
	f.printf("ID       = 0x%x\n", id)
	f.printf("Flag     = 0x%x\n", flag)
	f.printf("           QR=%d OPcode=%d AA=%d TC=%d\n", (flag >> 15), ((flag >> 11) & 0xF), ((flag >> 10) & 0x1), ((flag >> 9) & 0x1))
	f.printf("           RD=%d RA=%d Z=%d RCODE=%d\n", ((flag >> 8) & 0x1), ((flag >> 7) & 0x1), ((flag >> 4) & 0x7), (flag & 0xF))
	f.printf("QD Count = %d\n", qd_cnt)
	f.printf("AN Count = %d\n", an_cnt)
	f.printf("NS Count = %d\n", ns_cnt)
	f.printf("AR Count = %d\n", ar_cnt)
	f.print "\n"
	
	offset = 12
	
	#--------------------
	# QD
	#--------------------
	for cnt in 1..qd_cnt
		f.print "<QD" + cnt.to_s + ">\n"
		offset = dumpQuestionRecord(f, data, offset)
		f.print "\n"
	end
	
	#--------------------
	# AN
	#--------------------
	for cnt in 1..an_cnt
		f.print "<AN" + cnt.to_s + ">\n"
		offset = dumpResourceRecord(f, data, offset)
		f.print "\n"
	end

	#--------------------
	# NS
	#--------------------
	for cnt in 1..ns_cnt
		f.print "<NS" + cnt.to_s + ">\n"
		offset = dumpResourceRecord(f, data, offset)
		f.print "\n"
	end
	
	#--------------------
	# AR
	#--------------------
	for cnt in 1..ar_cnt
		f.print "<AR" + cnt.to_s + ">\n"
		offset = dumpResourceRecord(f, data, offset)
		f.print "\n"
	end
end



def usage
	prog = __FILE__
	puts "Usage: #{prog} file"
end

if ARGV.length == 0
	usage()
	exit
end

infile = ARGV[0]
File.open(infile, "rb") {|f|
	data = f.read
	dumpbin(STDOUT, data)
	dumpDNS(STDOUT, data)
}


