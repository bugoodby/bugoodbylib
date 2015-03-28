
Dim d : d = Now

WScript.Echo "object:           " & d

Dim tomorrow : tomorrow = DateAdd("d", 1, Now)
WScript.Echo "tomorrow:         " & tomorrow

Dim yesterday : yesterday = DateAdd("d", -1, Now)
WScript.Echo "yesterday:        " & yesterday

Dim lastweek : lastweek = DateAdd("d", -7, Now)
WScript.Echo "last week:        " & lastweek



WScript.Echo "getDate1():       " & getDate1() & vbCrLf & _
			 "getDate2():       " & getDate2() & vbCrLf



' YYYYMMDD_HHMMSS
Function getDate1()
	Dim n : n = Now
	getDate1 = Year(n) & Right("00" & Month(n), 2) & Right("00" & Day(n), 2) & "_" & _
					Right("00" & Hour(n), 2) & Right("00" & Minute(n), 2) & Right("00" & Second(n), 2)
End Function

' YYYY/MM/DD HH:MM:SS
Function getDate2()
	Dim n : n = Now
	getDate2 = Year(n) & Right("00" & Month(n), 2) & Right("00" & Day(n), 2) & " " & _
					Right("00" & Hour(n), 2) & ":" & Right("00" & Minute(n), 2) & ":" & Right("00" & Second(n), 2)
End Function


