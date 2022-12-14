#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_Compile_Both=y
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

Example()

Func Example()
	Local $Button, $Label, $msg
	GUICreate("MessageBox", 750, 500) ; 创建一个对话框,并居中显示

	Opt("GUICoordMode")

	$Label = GUICtrlCreateLabel("", 30, 30, 690, 373, -1)
	GUICtrlSetFont (-1, 40)
	
	Select
		Case $cmdline[0] = 1
			ControlSetText("MessageBox", "", "Static1", $cmdline[1])
		Case $cmdline[0] = 2
			ControlSetText("MessageBox", "", "Static1", $cmdline[1]&@CRLF&@CRLF&$cmdline[2])
		Case $cmdline[0] = 3
			ControlSetText("MessageBox", "", "Static1", $cmdline[1]&@CRLF&@CRLF&$cmdline[2]&@CRLF&@CRLF&$cmdline[3])
		Case $cmdline[0] >= 4
			ControlSetText("MessageBox", "", "Static1", $cmdline[1]&@CRLF&@CRLF&$cmdline[2]&@CRLF&@CRLF&$cmdline[3]&@CRLF&@CRLF&$cmdline[4])
	EndSelect

	$Button = GUICtrlCreateButton("确认", 500, 430, 150, 50, $BS_DEFPUSHBUTTON)
	GUICtrlSetFont (-1, 20)

	GUISetState()      ; 显示有两个按钮的对话框

	; 运行界面,直到窗口被关闭
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Button
				ExitLoop
		EndSelect
	WEnd
EndFunc   ;==>Example
