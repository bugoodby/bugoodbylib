
#---------------------------------------------
# �O��̋󔒂̏���
#---------------------------------------------
$str = "	   This is a test string!    	"
Write-Host "-" $str "-"
Write-Host "-" $str.Trim() "-"
Write-Host "-" $str.TrimStart() "-"
Write-Host "-" $str.TrimEnd() "-"

#---------------------------------------------
# ���s�R�[�h�̏���
#---------------------------------------------
$str = "L1: aaaaaaaaa`r`nL2: This is a test string!`n`r`n"
Write-Host $str
$str = $str.Replace("`r", "").Replace("`n", "")
Write-Host $str

