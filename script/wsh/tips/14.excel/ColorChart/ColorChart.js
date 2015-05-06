//------------------------------------------------
// Excel定数
//------------------------------------------------
var xlUp		= -4162;
var xlDown		= -4121;
var xlToLeft	= -4159;
var xlToRight	= -4161;
 
var xlWorkbookNormal		= -4143;
//------------------------------------------------
var fso = new ActiveXObject("Scripting.FileSystemObject");

main();

function main() 
{
	var RGB = function(red, green, blue) {
		return (parseInt(red) + (parseInt(green) * 256) + (parseInt(blue) * 65536));
	}
	
	// Excelオブジェクトの作成
	var objExcel = new ActiveXObject("Excel.Application");
	objExcel.Visible = true;
	objExcel.DisplayAlerts = false;
	
	// 出力ファイルを新規作成
	var objOutBook = objExcel.Workbooks.Add();
	var objOutSheet = objOutBook.Worksheets(1);
	objOutSheet.Select();
	
	var row = 1;
	var col = 1;
	
	for ( var r = 0; r <= 255; r+= 0x33 ) {
		for ( var g = 0; g <= 255; g += 0x33 ) {
			for ( var b = 0; b <= 255; b += 0x33 ) {
				objOutSheet.Cells(row, col).Value = "(" + r + ", " + g + ", " + b + ")";
				objOutSheet.Cells(row, col).Interior.Color = RGB(r, g, b);
				row++;
			}
		}
		row = 1;
		col++;
	}
	
	// 列の幅を自動調整
	var lastCol = objOutSheet.Cells(1, objOutSheet.Columns.Count).End(xlToLeft).Column;
	for ( var i = 1; i <= lastCol; i++ ) {
		objOutSheet.Cells(1, i).EntireColumn.AutoFit();
	}
	
	// 出力ファイルの保存
	var outXlsPath = WScript.ScriptFullName.replace(WScript.ScriptName, "output.xls");
    objOutBook.SaveAs(outXlsPath, xlWorkbookNormal);
	
	// クローズ
	objOutBook.Close();
	objExcel.Quit();
	
	// オブジェクトの破棄
	objExcel = null;
	
	return 0;
}

