#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_Compile_Both=y
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

Example()

Func Example()
	Local $Button, $Label, $msg
	GUICreate("提示信息", 750, 500) ; 创建一个对话框,并居中显示

	Opt("GUICoordMode")
	
	$Label = GUICtrlCreateLabel("这台机器是 GSKU 的"&@CRLF&@CRLF&"请点击 确认按钮 关机"&@CRLF&@CRLF&"请把它放在 E、F、M 线上架"&@CRLF&@CRLF&"辛苦了", 30, 30, 990, 400, -1)
	GUICtrlSetFont (-1, 40)
	$Button = GUICtrlCreateButton("确认", 500, 400, 150, 50, $BS_DEFPUSHBUTTON)
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