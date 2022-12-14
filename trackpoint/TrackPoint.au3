#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <GDIPlus.au3>
#include <ScreenCapture.au3>

If FileExists('TrackPointLog.txt') Then FileDelete('TrackPointLog.txt')

$hGUI = GUICreate('TrackPoint', @DesktopWidth, @DesktopHeight, 0, 0, 0x80000000)
GUISetState()

_GDIPlus_Startup()
Local $hGr = _GDIPlus_GraphicsCreateFromHWND($hGUI)
Local $hPen = _GDIPlus_PenCreate(0xFFFF0000)
For $i=20 To 1 Step -1
	_GDIPlus_GraphicsDrawEllipse($hGr, @DesktopWidth/2-$i, @DesktopHeight/2-$i, $i*2, $i*2, $hPen)
Next
_GDIPlus_PenSetColor($hPen, 0xFF00A000)
_GDIPlus_PenSetWidth($hPen, 3)

Global $x0 = @DesktopWidth/2
Global $y0 = @DesktopHeight/2
Global $aPos[2]
Global $bIsStarted = False

Global $iTO = IniRead('TrackPoint.ini', 'Settings', 'Timeout', 30)
Global $iLen = IniRead('TrackPoint.ini', 'Settings', 'MinSpan', 300)
Global $ivLen = IniRead('TrackPoint.ini', 'Settings', 'Deviate', 30)
Global $StopChkTime = IniRead('TrackPoint.ini', 'Settings', 'StopChkTime', 0.3)

Global $iDir = 1	;	 1 up / 2 left / 3 down / 4 right
Global $iDvtChk = 0x0F
Global $iLenChk = 0

MouseMove($x0, $y0, 0)

Global $aPos = MouseGetPos()
$x0 = $aPos[0]
$y0 = $aPos[1]

Global $ts = TimerInit()
While 1
	If TimerDiff($ts)>$iTO*1000 Then
		FileWrite('TrackPointLog.txt', 'FAIL'&@CRLF&'Test Timeout!')
		_GDIPlus_GraphicsDispose($hGr)
		_GDIPlus_Shutdown()
		Exit
	EndIf

	$msg = GUIGetMsg()
	Switch $msg
		Case -3
			FileWrite('TrackPointLog.txt', 'FAIL'&@CRLF&'Test is cancelled manually')
			_GDIPlus_GraphicsDispose($hGr)
			_GDIPlus_Shutdown()

			Exit
	EndSwitch

	$aPos = MouseGetPos()

	ConsoleWrite($aPos[0]&','&$aPos[1]&@LF)

	If $aPos[0]<>$x0 Or $aPos[1]<>$y0 Then
		Switch $iDir
			Case 1			; up
				If $y0=0 Then
					ResetCursor()
					ContinueLoop
				EndIf
				If Abs($aPos[0]-@DesktopWidth/2)>$ivLen Then
					$iDvtChk = BitAND($iDvtChk, 0x0E)
					_GDIPlus_PenSetColor($hPen, 0xFFC00000)
				EndIf
				If @DesktopHeight/2-$aPos[1]>$iLen Then $iLenChk = BitOR($iLenChk, 1)
			Case 2			; left
				If $x0=0 Then
					ResetCursor()
					ContinueLoop
				EndIf
				If Abs($aPos[1]-@DesktopHeight/2)>$ivLen Then
					$iDvtChk = BitAND($iDvtChk, 0x0D)
					_GDIPlus_PenSetColor($hPen, 0xFFC00000)
				EndIf
				If @DesktopWidth/2-$aPos[0]>$iLen Then $iLenChk = BitOR($iLenChk, 2)
			Case 3
				If $y0 >= @DesktopHeight-1 Then
					ResetCursor()
					ContinueLoop
				EndIf
				If Abs($aPos[0]-@DesktopWidth/2)>$ivLen Then
					$iDvtChk = BitAND($iDvtChk, 0x0B)
					_GDIPlus_PenSetColor($hPen, 0xFFC00000)
				EndIf
				If $aPos[1]-@DesktopHeight/2>$iLen Then $iLenChk = BitOR($iLenChk, 4)
			Case 4
				If $y0 >= @DesktopHeight-1 Then
					ResetCursor()
					ContinueLoop
				EndIf
				If Abs($aPos[1]-@DesktopHeight/2)>$ivLen Then
					$iDvtChk = BitAND($iDvtChk, 0x07)
					_GDIPlus_PenSetColor($hPen, 0xFFC00000)
				EndIf
				If $aPos[0]-@DesktopWidth/2>$iLen Then $iLenChk = BitOR($iLenChk, 8)
		EndSwitch

		$bIsStarted = True
		$tsChkStop = TimerInit()


		_GDIPlus_GraphicsDrawLine($hGr, $x0, $y0, $aPos[0], $aPos[1], $hPen)
		$x0 = $aPos[0]
		$y0 = $aPos[1]
	ElseIf $bIsStarted Then
		If TimerDiff($tsChkStop)>$StopChkTime*1000 Then
			ResetCursor()
			$bIsStarted = False
			If $iDir = 4 Then ExitLoop
			$iDir += 1
			_GDIPlus_PenSetColor($hPen, 0xFF00A000)
		EndIf
	EndIf
WEnd

_GDIPlus_GraphicsDispose($hGr)
_GDIPlus_Shutdown()

_ScreenCapture_CaptureWnd('TrackPoint.jpg', $hGUI)

GUIDelete()

If $iDvtChk=0x0F And $iLenChk=0x0F Then
	FileWrite('TrackPointLog.txt', 'PASS'&@CRLF&'TrackPoint Test PASS! - ' & Hex($iDvtChk,1)&Hex($iLenChk,1))
Else
	FileWrite('TrackPointLog.txt', 'FAIL'&@CRLF&'TrackPoint Test FAIL! - ' & Hex($iDvtChk,1)&Hex($iLenChk,1))
EndIf


Func ResetCursor()
	$x0 = @DesktopWidth/2
	$y0 = @DesktopHeight/2
	MouseMove($x0, $y0, 0)
	$aPos = MouseGetPos()
	$x0 = $aPos[0]
	$y0 = $aPos[1]
EndFunc