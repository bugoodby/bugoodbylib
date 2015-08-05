var fso = new ActiveXObject("Scripting.FileSystemObject");

main( WScript.Arguments.Count(), WScript.Arguments );

function main( argc, argv ) 
{
	// WScript�Ȃ�CScript�ŋN��������
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript();
}

function ExecScript()
{
	var file = WScript.ScriptFullName.replace(WScript.ScriptName, "database.csv");
	
	var reader = new ExcelTableReader();
	if ( ! reader.Open(file, 1, 7, 1) ) {
		return false;
	}
	
	var count = reader.GetRowCount();
	for ( var r = 1; r <= count; r++ )
	{
		LOG("--------");
		LOG( reader.GetText(r, "����") );
		
		var color = reader.GetColor(r, "�區��");
		LOG("color = " + color + "  " + ( color == RGB(255, 255, 255) ) ? "while" : "others");
	}
	
	reader.CopyItems("���v");
	
	reader.Close();
}


// Excel�̃e�[�u���������N���X
function ExcelTableReader()
{
	var m_sheetName = "";
	var m_headerRow = 1;
	var m_startCol = 1;		// ��ƂȂ��ԍ�
	var m_oExcel = null;
	var m_oSheet = null;
	var m_lastRow = 0;
	var m_lastCol = 0;
	var m_hdr = {};
	
	var xlUp		= -4162;
	var xlDown		= -4121;
	var xlToLeft	= -4159;
	var xlToRight	= -4161;
	
	// xls�t�@�C�����J���e�[�u������͂���
	this.Open = function( filespec, opt_sheet_name, opt_header_row, opt_start_col )
	{
		m_sheetName = opt_sheet_name || "Sheet1";
		m_headerRow = opt_header_row || 1;
		m_startCol = opt_start_col || 1;
		
		// Excel�I�u�W�F�N�g�̍쐬
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// �E�B���h�E�\���ݒ�
		m_oExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
		
		// Excel�t�@�C����ǂݎ���p�ŊJ��
		var oBook = m_oExcel.Workbooks.Open(filespec, null, true);
		m_oSheet = oBook.WorkSheets(m_sheetName);
		
		// �e�[�u���̍s���A�񐔂��擾
		m_lastRow = m_oSheet.Cells(m_oSheet.Rows.Count, m_startCol).End(xlUp).Row;
		m_lastCol = m_oSheet.Cells(m_headerRow, m_oSheet.Columns.Count).End(xlToLeft).Column;
		
//		for ( var r = m_headerRow+1; r <= 65536; r++ ) {
//			if ( m_oSheet.Cells(r, m_startCol).Value == "���v" ) {
//				m_lastRow = r - 1;
//				break;
//			}
//		}
		
		
		LOG("+-[ExcelTableReader]----------------");
		LOG("| " + filespec);
		LOG("| TABLE RANGE: start: (" + (m_headerRow+1) + "," + m_startCol + ") = " + m_oSheet.Cells((m_headerRow+1),m_startCol).Address);
		LOG("|              end  : (" + m_lastRow + "," + m_lastCol + ") = " + m_oSheet.Cells((m_lastRow),m_lastCol).Address);
		// �w�b�_�[���
		LOG("| HEADER ITEMS:");
		for ( var c = m_startCol; c <= m_lastCol; c++ )
		{
			var txt = m_oSheet.Cells(m_headerRow, c).Text;
			m_hdr[txt] = c;
			LOG("|   " + txt);
		}
		LOG("------------------------------------");
		
		return true;
	}
	
	// xls�t�@�C�������
	this.Close = function()
	{
		m_oExcel.Quit();
		m_oExcel = null;
	}
	
	// �e�[�u���̍s����Ԃ�
	this.GetRowCount = function()
	{
		return m_lastRow - m_headerRow;
	}
	
	// �e�[�u����
	//  - rowNumber�s��
	//  - ���ږ���itemName
	// �ł���Z���̒l��Ԃ�
	this.GetText = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetText: invalid itemName " + itemName);
			return "";
		}
		return m_oSheet.Cells(m_headerRow + rowNumber, c).Text;
	}
	
	// �e�[�u����
	//  - rowNumber�s��
	//  - ���ږ���itemName
	// �ł���Z���̒l���A�P�s�e�L�X�g�̔z��Ƃ��ĕԂ�
	this.GetTextArray = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetTextArray: invalid itemName " + itemName);
			return [];
		}
		var a = m_oSheet.Cells(m_headerRow + rowNumber, c).Text.split("\n");
		var b = [];
		for ( var i in a ) {
			if ( a[i] != "" ) b.push(a[i]);
		}
		return b;
	}
	
	// �e�[�u����
	//  - rowNumber�s��
	//  - ���ږ���itemName
	// �ł���Z���̔w�i�F��Ԃ�
	this.GetColor = function( rowNumber, itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] GetColor: invalid itemName " + itemName);
			return 0;
		}
		return m_oSheet.Cells(m_headerRow + rowNumber, c).Interior.Color;
	}
	
	// �e�[�u����
	//  - ���ږ���itemName
	// �ł���͈͂��R�s�[����
	this.CopyItems = function( itemName )
	{
		var c = m_hdr[itemName];
		if ( !c ) {
			LOG("[ERROR] CopyItems: invalid itemName " + itemName);
			return;
		}
		var startRange = m_oSheet.Cells((m_headerRow+1), c).Address;
		var endRange = m_oSheet.Cells(m_lastRow, c).Address;
		var copyRange = startRange + ":" + endRange;
		LOG(copyRange);
		m_oSheet.Range(copyRange).Copy();
	}
}

function RGB(red, green, blue)
{
	return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
}

function LOG( str )
{
	WScript.Echo(str);
}
