//------------------------------------------------
// Excel�萔
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
 
var xlWorkbookNormal		= -4143;
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");


WScript.Quit(main( WScript.Arguments.Count(), WScript.Arguments ));
function main( argc, argv ) 
{
	if ( argc != 1 ) {
		WScript.Echo("�������s���ł�");
		return 1;
	}
	
	if ( WScript.FullName.substr(WScript.FullName.length - 11, 11).toUpperCase() == "WSCRIPT.EXE" ) {
		var wshShell = new ActiveXObject("WScript.Shell");
		var cmd = "cmd.exe /c cscript.exe //NOLOGO \"" + WScript.ScriptFullName + "\"";
		for ( var i = 0; i < argc; i++ ) {
			cmd += " \"" + argv(i) + "\"";
		}
		cmd += " & pause"
		return wshShell.Run(cmd, 1, true);
	}
	
	return ExecScript(argv(0));
}

function ExecScript( folder )
{
	var collector = new ExcelDataCollector();
	collector.init();
	collector.enumerate(folder);
	collector.exec();
	collector.term();
	
	return 0;
}

function ExcelDataCollector()
{
	var m_oExcel = null;
	var m_oOutBook = null;
	var m_oOutSheet = null;
	var m_fileList = [];
	var m_row = 0;
	
	var HEADER_ROW = 1;			// �w�b�_�̍s�ԍ�
	var PATH_COL = 1;			// �p�X�̗�ԍ�
	var VALUE_START_COL = 2;	// �擾�l�Z���̊J�n��ԍ�
	
	var m_tInfo = [
		{ "sheet": "target", "range": "A4" },
		{ "sheet": "target", "range": "E4" },
	];
	
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	}
	
	this.init = function()
	{
		// Excel�I�u�W�F�N�g�̍쐬
		m_oExcel = new ActiveXObject("Excel.Application");
		m_oExcel.Visible = true;			// �E�B���h�E�\���ݒ�
		m_oExcel.DisplayAlerts = false;		// �A���[�g�ݒ�
		
		// �o�̓t�@�C����V�K�쐬
		m_oOutBook = m_oExcel.Workbooks.Add();
		m_oOutSheet = m_oOutBook.Worksheets(1);
		m_oOutSheet.Select();
		
		// �w�b�_�̍쐬
		m_oOutSheet.Cells(HEADER_ROW, PATH_COL).Value = "Path";
		m_oOutSheet.Cells(HEADER_ROW, PATH_COL).Interior.Color = RGB(192,192,192);
		for ( var i in m_tInfo ) {
			m_oOutSheet.Cells(HEADER_ROW, VALUE_START_COL + parseInt(i)).Value = m_tInfo[i].sheet + "/" + m_tInfo[i].range;
			m_oOutSheet.Cells(HEADER_ROW, VALUE_START_COL + parseInt(i)).Interior.Color = RGB(192,192,192);
		}
		
		m_fileList.length = 0;
		m_row = HEADER_ROW + 1;
		
		return true;
	};
	
	this.term = function()
	{
		// ��̕�����������
		var lastCol = m_oOutSheet.Cells(HEADER_ROW, m_oOutSheet.Columns.Count).End(xlToLeft).Column;
		for ( var i = 1; i <= lastCol; i++ ) {
			m_oOutSheet.Cells(1, i).EntireColumn.AutoFit();
		}
		
		// �I�[�g�t�B���^�̐ݒ�
		m_oOutSheet.UsedRange.AutoFilter();
		
		// �o�̓t�@�C���̕ۑ�
		var outXlsPath = WScript.ScriptFullName.replace(WScript.ScriptName, "result.xls");
	    m_oOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
		
		m_oOutBook.Close();
		m_oExcel.Quit();
		m_oExcel = null;
	};
	
	this.enumerate = function( folder )
	{
		var filter = "\.xls$";
		
		var enumerate_sub = function( folder ) {
			var d = fso.GetFolder(folder);
			var subdirs = new Enumerator(d.SubFolders);
			var files = new Enumerator(d.files);
			
			for ( ; !files.atEnd(); files.moveNext() ) {
				if ( files.item().Path.match(filter) ) {
					m_fileList.push(files.item().Path);
				}
			}
			for ( ; !subdirs.atEnd(); subdirs.moveNext() ) {
				enumerate_sub(subdirs.item().Path);
			}
		};
		
		LOG("Enumerate start: " + folder);
		m_fileList.length = 0;
		enumerate_sub(folder);
		LOG("Enumerate end: " + m_fileList.length);
	};
	
	this.exec = function()
	{
		for ( var i in m_fileList ) {
			collectData(m_fileList[i]);
		}
	};
	
	var collectData = function( f )
	{
		LOG("[target] " + f);
		try {
			var oBook = m_oExcel.Workbooks.Open(f);
			
			for ( var i in m_tInfo ) {
				var oSheet = oBook.WorkSheets( m_tInfo[i].sheet );
				var text = oSheet.Range( m_tInfo[i].range ).Text;
				m_oOutSheet.Cells( m_row, VALUE_START_COL + parseInt(i) ).Value = text;
			}
			
			m_oOutSheet.Cells( m_row, PATH_COL ).Value = f;
			m_row++;
			oBook.Close();
		}
		catch (e) {
			LOG("[ERROR] " + e.description);
			return false;
		}
		return true;
	};
}

function LOG( str )
{
	WScript.Echo(str);
}

