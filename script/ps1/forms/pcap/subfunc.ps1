
$PCAPNG_SHB = [uint32]0x0A0D0D0A # Section Header Block
$PCAPNG_IDB = [uint32]0x00000001 # Interface Description Block
$PCAPNG_PB  = [uint32]0x00000002 # Packet Block
$PCAPNG_SPB = [uint32]0x00000003 # Simple Packet Block
$PCAPNG_NRB = [uint32]0x00000004 # Name Resolusion Block
$PCAPNG_ISB = [uint32]0x00000005 # Interface Statistic Block 
$PCAPNG_EPB = [uint32]0x00000006 # Enhanced Packet Block

$PCAPNG_ORDER_MAGIC = [uint32]0x1A2B3C4D


function Get-BlockName( [uint32]$type )
{
	switch ($type)
	{
	$PCAPNG_SHB { "SHB" }
	$PCAPNG_IDB { "IDB" }
	$PCAPNG_PB { "PB" }
	$PCAPNG_SPB { "SPB" }
	$PCAPNG_NRB { "NRB" }
	$PCAPNG_ISB { "ISB" }
	$PCAPNG_EPB { "EPB" }
	default { "???" }
	}
}

function Get-LinkTypeName( [uint16]$type )
{
	switch ($type)
	{
	0 { "NULL" }
	1 { "ETHERNET" }
	default { "???" }
	}
}

function Refresh-TreeView( $path )
{
	$treeView.Nodes.Clear()

	$netorder = $true
	$stream = [System.IO.File]::OpenRead($path)
	
	$buf = New-Object byte[] 4
	
	# Magic Number
	[void]$stream.Read($buf, 0, 4)
	if ( $PCAPNG_SHB -ne [System.BitConverter]::ToUint32($buf, 0) ) {
		"invalid magic number"
		$stream.Close()
		return
	}
	
	# Block Total Length
	[void]$stream.Read($buf, 0, 4)
	
	# Byte-Order Magic
	[void]$stream.Read($buf, 0, 4)
	if ( $PCAPNG_ORDER_MAGIC -eq [System.BitConverter]::ToUint32($buf, 0) ) {
		$netorder = $false
	}
	
	$stream.Seek(0, [System.IO.SeekOrigin]::Begin)
	
	do {
		$block = @{ netorder = $netorder; header = @{}; trailer = @{}; }
		
		# Block Type
		[void]$stream.Read($buf, 0, 4)
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$block.header["BlockType"] = [System.BitConverter]::ToUint32($buf, 0)
		
		# Block Total Length
		[void]$stream.Read($buf, 0, 4)
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$block.header["TotalLength"] = [System.BitConverter]::ToUint32($buf, 0)
		
		# Block Body
		$bodyLen = $block.header.TotalLength - 12
		$bodybuf = New-Object byte[] $bodyLen
		[void]$stream.Read($bodybuf, 0, $bodyLen)
		$block.body = $bodybuf
		
		# Block Total Length
		[void]$stream.Read($buf, 0, 4)
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$block.trailer["TotalLength"] = [System.BitConverter]::ToUint32($buf, 0)
		
		$name = Get-BlockName $block.header.BlockType
		$n = $treeView.Nodes.Add($name)
		$n.Tag = $block
	} while ( $stream.Position -lt $stream.Length )
	
	$stream.Close()
}

function Dump-Block( [Hashtable]$block )
{
	$str = ""
	$str += "BlockType: {0:X8}`r`n" -f $block.header.BlockType
	$str += "TotalLength: {0}`r`n" -f $block.header.TotalLength
	$str += "`r`n"
	
	if ( $block.header.BlockType -eq $PCAPNG_EPB )
	{
		$buf = $block.body[0..3]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "InterfaceID: {0}`r`n" -f [System.BitConverter]::ToUint32($buf, 0)

		$buf = $block.body[4..7]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "Timestamp(High): {0}`r`n" -f [System.BitConverter]::ToUint32($buf, 0)

		$buf = $block.body[8..11]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "Timestamp(Low): {0}`r`n" -f [System.BitConverter]::ToUint32($buf, 0)

		$buf = $block.body[12..15]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "Captured Len: {0}`r`n" -f [System.BitConverter]::ToUint32($buf, 0)

		$buf = $block.body[16..19]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "Packet Len: {0}`r`n" -f [System.BitConverter]::ToUint32($buf, 0)

		$str += "`r`n"
		$str += Dump-EtherHeader $block 20
	}
	elseif ( $block.header.BlockType -eq $PCAPNG_IDB ) 
	{
		$buf = $block.body[0..1]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$linktype = [System.BitConverter]::ToUint16($buf, 0)
		$str += ("LinkType: {0} ({1})`r`n" -f $linktype, (Get-LinkTypeName $linktype))

		$buf = $block.body[2..3]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "Reserved: {0}`r`n" -f [System.BitConverter]::ToUint16($buf, 0)

		$buf = $block.body[4..7]
		if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
		$str += "SnapLen: {0}`r`n" -f [System.BitConverter]::ToUint32($buf, 0)
	}
	
	$str += "`r`n"
	$str += Dump-HexData $block.body
	return $str
}

function Dump-NullHeader( [Hashtable]$block, $offset )
{
	$str = "[Null]`r`n"
	
	$buf = $block.body[$offset..($offset+3)]
	if ( $block.netorder -eq $true ) { [array]::Reverse($buf) }
	$family = [System.BitConverter]::ToUint32($buf, 0)
	$str += ("Family: 0x{0:x8}`r`n" -f $family)
	
	$str += "`r`n"
	$str += Dump-IPHeader $block ($offset+4)
	return $str
}

function Dump-EtherHeader( [Hashtable]$block, $offset )
{
	$str = "[Ethernet]`r`n"
	
	$mac = $block.body[($offset)..($offset+5)]
	$str += ("DST: {0:x2}:{1:x2}:{2:x2}:{3:x2}:{4:x2}:{5:x2}`r`n" -f $mac[0], $mac[1], $mac[2], $mac[3], $mac[4], $mac[5])
	
	$mac = $block.body[($offset+6)..($offset+11)]
	$str += ("SRC: {0:x2}:{1:x2}:{2:x2}:{3:x2}:{4:x2}:{5:x2}`r`n" -f $mac[0], $mac[1], $mac[2], $mac[3], $mac[4], $mac[5])

	$buf = $block.body[($offset+12)..($offset+13)]
	[array]::Reverse($buf)
	$type = [System.BitConverter]::ToUint16($buf, 0)
	$str += "Type: 0x{0:x4}`r`n" -f $type

	$str += "`r`n"
	
	if ( $type -eq 0x0800 ) {
		$str += Dump-IPHeader $block ($offset+14)
	}
	return $str
}

function Dump-IPHeader( [Hashtable]$block, $offset )
{
	$str = "[IP]`r`n"
	
	$buf = $block.body[$offset]
	$header_size = (($buf -band 0xf) * 4)
	
	$buf = $block.body[($offset+12)..($offset+15)]
	$str += ("SRC: {0}.{1}.{2}.{3}  =>  " -f $buf[0], $buf[1], $buf[2], $buf[3])

	$buf = $block.body[($offset+16)..($offset+19)]
	$str += ("DST: {0}.{1}.{2}.{3}`r`n" -f $buf[0], $buf[1], $buf[2], $buf[3])

	$protocol = $block.body[($offset+9)]
	$str += ("Protocol: {0}`r`n" -f $protocol)

	$str += "`r`n"
	
	if ( $protocol -eq 6 ) {
		$str += Dump-TCPHeader $block ($offset+$header_size)
	} 
	elseif ( $protocol -eq 17 ) {
		$str += Dump-UDPHeader $block ($offset+$header_size)
	}
	
	return $str
}

function Dump-TCPHeader( [Hashtable]$block, $offset )
{
	$str = "[TCP]`r`n"
	
	$buf = $block.body[$offset+12]
	$header_size = ((($buf -band 0xf0) / 16) * 4)
	
	$buf = $block.body[$offset..($offset+1)]
	[array]::Reverse($buf)
	$str += ("Src Port: {0}`r`n" -f [System.BitConverter]::ToUint16($buf, 0))

	$buf = $block.body[($offset+2)..($offset+3)]
	[array]::Reverse($buf)
	$str += ("Dst Port: {0}`r`n" -f [System.BitConverter]::ToUint16($buf, 0))

	$str += "`r`n"
	
	return $str
}

function Dump-UDPHeader( [Hashtable]$block, $offset )
{
	$str = "[UDP]`r`n"
	
	$buf = $block.body[$offset..($offset+1)]
	[array]::Reverse($buf)
	$str += ("Src Port: {0}`r`n" -f [System.BitConverter]::ToUint16($buf, 0))

	$buf = $block.body[($offset+2)..($offset+3)]
	[array]::Reverse($buf)
	$str += ("Dst Port: {0}`r`n" -f [System.BitConverter]::ToUint16($buf, 0))

	$str += "`r`n"

	return $str
}

function Dump-HexData( [byte[]]$obj )
{
	$dumpLine = {
		PARAM([byte[]]$data)
		$line = ("{0:X8}: " -f $offset)
		$chars = ""
		foreach ($b in $data) {
			$line += ("{0:x2} " -f $b)
			if ($b -ge 0x20 -and $b -le 0x7e) {
				$chars += [char]$b
			} else {
				$chars += "."
			}
		}
		$line += "   " * (16 - $data.length)
		return "$line $chars`r`n"
	}
	$str = ""
	$offset = 0
	do {
		[byte[]]$ldata = $obj[$offset..($offset+15)]
		if ( $ldata.length -gt 0 ) {
			$str += $dumpLine.Invoke($ldata)
		}
		$offset += 16
	} while ($ldata.length -gt 0)
	return $str
}
