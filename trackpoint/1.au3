#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

While 1
	$apos = MouseGetPos()
	ToolTip($apos[0]&','&$apos[1])
	Sleep(10)
WEnd