on rejectMissingValue(aList)
	set nameList to {}
	repeat with i from 1 to (count aList)
		set a to item i of aList
		if a is not missing value then
			set end of nameList to a
		end if
	end repeat
	return nameList
end rejectMissingValue

on test()
	set scriptDir to POSIX path of ((path to me as text) & "::")
	set savePath to (POSIX path of (path to desktop as text)) & "test/"
	do shell script "mkdir -p " & savePath
	set logPath to savePath & "log.txt"
	
	set pubPrinter to null
	set pubPaperSize to null
	set pubFunction to null
	set functionList to {}
	
	set fn to open for access logPath with write permission
	set eof of fn to 0
	try
		tell application "Preview"
			activate
		end tell
		
		tell application "System Events"
			tell sheet 1 of window 1 of process "Preview"
				set eleList to every UI element
				repeat with i in eleList
					write name of i & return to fn
				end repeat
			end tell
		end tell
		--choose from list eleList
		
		tell application "System Events"
			tell sheet 1 of window 1 of process "Preview"
				set pubList to every pop up button
				repeat with pub in pubList
					--set selval to value of pub
					set aList to name of every menu item of menu 1 of (click pub)
					key code 53
					if aList contains "プリンタを追加..." then set pubPrinter to pub
					if aList contains "カスタムサイズを管理..." then set pubPaperSize to pub
					if aList contains "プレビュー" then
						set pubFunction to pub
						set functionList to my rejectMissingValue(aList)
					end if
					
					write "--------------" & return to fn
					repeat with i in aList
						write i & return to fn
					end repeat
				end repeat
				
				repeat with a in functionList
					click menu item a of menu 1 of (click pubFunction)
					delay 1
					set fileName to a & ".png"
					do shell script "screencapture " & savePath & fileName
				end repeat
				
			end tell
		end tell
	end try
	close access fn
end test


on run argv
	my test()
end run
