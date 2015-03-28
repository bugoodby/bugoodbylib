//------------------------------------------------
// WshShell.Popup()
// intButton = object.Popup(strText,[nSecondsToWait],[strTitle],[nType]) 
//------------------------------------------------
// nType
var MB_OK               = 0;	//[OK]のみ
var MB_OKCANCEL         = 1;	//[OK][キャンセル]
var MB_ABORTRETRYIGNORE = 2;	//[中止][再試行][無視]
var MB_YESNOCANCEL      = 3;	//[Yes][No][キャンセル]
var MB_YESNO            = 4;	//[Yes][No]
var MB_RETRYCANCEL      = 5;	//[再試行][キャンセル]

var MB_ICONERROR        = 16;	//[Stop]マーク
var MB_ICONQUESTION     = 32;	//[?]マーク
var MB_ICONWARNING      = 48;	//[!]マーク
var MB_ICONINFORMATION  = 64;	//[i]マーク

// intButton
var IDOK                = 1;	//[OK] ボタン。
var IDCANCEL            = 2;	//[キャンセル] ボタン。
var IDABORT             = 3;	//[中止] ボタン。
var IDRETRY             = 4;	//[再試行] ボタン。
var IDIGNORE            = 5;	//[無視] ボタン。
var IDYES               = 6;	//[はい] ボタン。
var IDNO                = 7;	//[いいえ] ボタン。
//------------------------------------------------


main();

function main() 
{
	var btn;
	var wshShell = new ActiveXObject("WScript.Shell");
	
	//最小構成
	wshShell.Popup("メッセージの表示");
	
	//ユーザ選択
	btn = wshShell.Popup("はい、いいえの選択", 0, "Windows Script Host", MB_YESNO);
	ShowButtonType(btn);
	
	//アイコンの変更
	btn = wshShell.Popup("エラーのアイコン", 0, "Windows Script Host", MB_ABORTRETRYIGNORE + MB_ICONERROR);
	ShowButtonType(btn);
}

function ShowButtonType( btn )
{
	switch ( btn ) {
	case IDOK:		WScript.Echo("[OK]ボタンが押されました");			break;
	case IDCANCEL:	WScript.Echo("[キャンセル]ボタンが押されました");	break;
	case IDABORT:	WScript.Echo("[中止]ボタンが押されました");			break;
	case IDRETRY:	WScript.Echo("[再試行]ボタンが押されました");		break;
	case IDIGNORE:	WScript.Echo("[無視]ボタンが押されました");			break;
	case IDYES:		WScript.Echo("[はい]ボタンが押されました");			break;
	case IDNO:		WScript.Echo("[いいえ]ボタンが押されました");		break;
	default:		WScript.Echo("エラー");								break;
	}
}
