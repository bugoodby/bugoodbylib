//------------------------------------------------
// WshShell.Popup()
// intButton = object.Popup(strText,[nSecondsToWait],[strTitle],[nType]) 
//------------------------------------------------
// nType
var MB_OK               = 0;	//[OK]�̂�
var MB_OKCANCEL         = 1;	//[OK][�L�����Z��]
var MB_ABORTRETRYIGNORE = 2;	//[���~][�Ď��s][����]
var MB_YESNOCANCEL      = 3;	//[Yes][No][�L�����Z��]
var MB_YESNO            = 4;	//[Yes][No]
var MB_RETRYCANCEL      = 5;	//[�Ď��s][�L�����Z��]

var MB_ICONERROR        = 16;	//[Stop]�}�[�N
var MB_ICONQUESTION     = 32;	//[?]�}�[�N
var MB_ICONWARNING      = 48;	//[!]�}�[�N
var MB_ICONINFORMATION  = 64;	//[i]�}�[�N

// intButton
var IDOK                = 1;	//[OK] �{�^���B
var IDCANCEL            = 2;	//[�L�����Z��] �{�^���B
var IDABORT             = 3;	//[���~] �{�^���B
var IDRETRY             = 4;	//[�Ď��s] �{�^���B
var IDIGNORE            = 5;	//[����] �{�^���B
var IDYES               = 6;	//[�͂�] �{�^���B
var IDNO                = 7;	//[������] �{�^���B
//------------------------------------------------


main();

function main() 
{
	var btn;
	var wshShell = new ActiveXObject("WScript.Shell");
	
	//�ŏ��\��
	wshShell.Popup("���b�Z�[�W�̕\��");
	
	//���[�U�I��
	btn = wshShell.Popup("�͂��A�������̑I��", 0, "Windows Script Host", MB_YESNO);
	ShowButtonType(btn);
	
	//�A�C�R���̕ύX
	btn = wshShell.Popup("�G���[�̃A�C�R��", 0, "Windows Script Host", MB_ABORTRETRYIGNORE + MB_ICONERROR);
	ShowButtonType(btn);
}

function ShowButtonType( btn )
{
	switch ( btn ) {
	case IDOK:		WScript.Echo("[OK]�{�^����������܂���");			break;
	case IDCANCEL:	WScript.Echo("[�L�����Z��]�{�^����������܂���");	break;
	case IDABORT:	WScript.Echo("[���~]�{�^����������܂���");			break;
	case IDRETRY:	WScript.Echo("[�Ď��s]�{�^����������܂���");		break;
	case IDIGNORE:	WScript.Echo("[����]�{�^����������܂���");			break;
	case IDYES:		WScript.Echo("[�͂�]�{�^����������܂���");			break;
	case IDNO:		WScript.Echo("[������]�{�^����������܂���");		break;
	default:		WScript.Echo("�G���[");								break;
	}
}
