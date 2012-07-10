;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;




;1900x1200
Dim $ForwardMoveX = 1377, $ForwardMoveY = 836
Dim $ForwardMoveX2 = 1505, $ForwardMoveY2 = 898
Dim $MouseTrapX = 1099, $MouseTrapY = 481
Dim $ExitMoveX = 355, $ExitMoveY = 145
Dim $ExitMoveX2 = 593, $ExitMoveY2 = 295
Dim $ResumeX = 252, $ResumeY = 472
Dim $ExitGameX = 859, $ExitGameY = 644
Dim $ErrorGameX = 959, $ErrorGameY  = 544

;1440x900
Dim $ForwardMoveX = 1377/1900 * 1440, $ForwardMoveY = 836/1200 * 900
Dim $ForwardMoveX2 = 1505/1900 * 1440, $ForwardMoveY2 = 898/1200 * 900
Dim $MouseTrapX = 1099/1900 * 1440, $MouseTrapY = 481/1200 * 900
Dim $ExitMoveX = 355/1900 * 1440, $ExitMoveY = 145/1200 * 900
Dim $ExitMoveX2 = 593/1900 * 1440, $ExitMoveY2 = 295/1200 * 900
Dim $ResumeX = 252/1900 * 1440, $ResumeY = 472/1200 * 900
Dim $ExitGameX = 859/1900 * 1440, $ExitGameY = 644/1200 * 900
Dim $ErrorGameX = 959/1900 * 1440, $ErrorGameY  = 544/1200 * 900

Global $Paused = False

While (True)
HotKeySet("{UP}", "Main")
HotKeySet("{Down}", "Quit")
WEnd

Func Main()
   Do
	  Start()
   Until _IsPressed(28) ;pressing down key will exit script
   
EndFunc

Func Start()

	  ResumeGame()
	  ;must do it three times if you have the merc.. talk a lot they do
	  For $i = 0 to 3
		 Send("{BACKSPACE DOWN}") ; hits space so the guy can stop talking and move forward
		 Sleep(50)
		 Send("{BACKSPACE UP}") ; hits space so the guy can stop talking and move forward
	  Next   
	  Sleep(750)
 
	  ;Mouseclick("left",$ForwardMoveX,$ForwardMoveY,1,3) ; moves forward once;
	  MouseClick("left",$ForwardMoveX,$ForwardMoveY,1)
	  Sleep(1000)
 
	  MouseClick("left",$ForwardMoveX2,$ForwardMoveY2,1)
	  Sleep(2000)
	  MouseMove($MouseTrapX,$MouseTrapY,1);
	  send("1");
	  Sleep(300)
	  For $i = 0 to 4
		 send("2");
		 Sleep(300)
	  Next
	  ;Sleep(500);
	  MouseClick("left",$ExitMoveX,$ExitMoveY,1)
	  Sleep(2000)
	  ;Pause()
	  MouseClick("left",$ExitMoveX2,$ExitMoveY2,10)
	  ;Sleep(2000)
	  ;MouseClick("left", $ExitMoveX, $ExitMoveY,1, 3) ;moves to exit

	  Sleep(2500);
	  ExitGame();
	
	  
	  ;HandleClientError(); doesn't work because it clicks on your damn character
	 
	  
	  ;Sleep(100000) ; Gives you a bit of time so you can go back to lobby. If your computer is taking longer, make the sleep number bigger, increments of 1000

EndFunc

Func Quit()
   Exit
EndFunc

Func CheckForExit()
   if (_IsPressed(28)) Then
	  Return
   EndIf
EndFunc
   
Func Revive()
   MouseClick("left", 1069, 633) ; These first four lines are my recovery tactic I made incase I die. 
   Sleep(200) ; These first four lines are my recovery tactic I made incase I die. 
   MouseClick("left", 948, 821) ; These first four lines are my recovery tactic I made incase I die. 
   ;Sleep(200) ; These first four lines are my recovery tactic I made incase I die. 
   MouseClick("left", 335, 435) ; Hits resume game
   ;Sleep(4600)
EndFunc
   
Func ResumeGame()
   MouseClick("left", $ResumeX, $ResumeY, 1, 3)
   Sleep(4000);
EndFunc
   
Func ExitGame()
   Send("{ESC}")
   Sleep(750)
   
   ; Hits the Leave game button so you can leave game
   MouseClick("left", $ExitGameX, $ExitGameY)
   Sleep(5000);
EndFunc

Func HandleClientError()
   MouseClick("left", $ErrorGameX, $ErrorGameY, 1, 3)
EndFunc

Func Pause()
   $Paused = Not $Paused
   While $Paused
      Sleep(100)
      ToolTip('Paused...', 0, 0)
   WEnd
   ToolTip("")
EndFunc   ;==>Pause


Exit
Func _IsPressed($hexKey)
; $hexKey must be the value of one of the keys.
; _IsPressed will return 0 if the key is not pressed, 1 if it is.
; $hexKey should entered as a string, don't forget the quotes!
; (yeah, layer. This is for you)
  
  Local $aR, $bO
  
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
     $bO = 1
  Else
     $bO = 0
  EndIf
  
  Return $bO
EndFunc ;==>_IsPressed

#cs
  01 Left mouse button
  02 Right mouse button;does not works in my system...
  04 Middle mouse button (three-button mouse)
  05 Windows 2000/XP: X1 mouse button
  06 Windows 2000/XP: X2 mouse button
  08 BACKSPACE key
  09 TAB key
  0C CLEAR key
  0D ENTER key
  10 SHIFT key
  11 CTRL key
  12 ALT key
  13 PAUSE key
  14 CAPS LOCK key
  1B ESC key
  20 SPACEBAR
  21 PAGE UP key
  22 PAGE DOWN key
  23 END key
  24 HOME key
  25 LEFT ARROW key
  26 UP ARROW key
  27 RIGHT ARROW key
  28 DOWN ARROW key
  29 SELECT key
  2A PRINT key
  2B EXECUTE key
  2C PRINT SCREEN key
  2D INS key
  2E DEL key
  30 0 key
  31 1 key
  32 2 key
  33 3 key
  34 4 key
  35 5 key
  36 6 key
  37 7 key
  38 8 key
  39 9 key
  41 A key
  42 B key
  43 C key
  44 D key
  45 E key
  46 F key
  47 G key
  48 H key
  49 I key
  4A J key
  4B K key
  4C L key
  4D M key
  4E N key
  4F O key
  50 P key
  51 Q key
  52 R key
  53 S key
  54 T key
  55 U key
  56 V key
  57 W key
  58 X key
  59 Y key
  5A Z key
  5B Left Windows key
  5C Right Windows key
  60 Numeric keypad 0 key
  61 Numeric keypad 1 key
  62 Numeric keypad 2 key
  63 Numeric keypad 3 key
  64 Numeric keypad 4 key
  65 Numeric keypad 5 key
  66 Numeric keypad 6 key
  67 Numeric keypad 7 key
  68 Numeric keypad 8 key
  69 Numeric keypad 9 key
  6A Multiply key
  6B Add key
  6C Separator key
  6D Subtract key
  6E Decimal key
  6F Divide key
  70 F1 key
  71 F2 key
  72 F3 key
  73 F4 key
  74 F5 key
  75 F6 key
  76 F7 key
  77 F8 key
  78 F9 key
  79 F10 key
  7A F11 key
  7B F12 key
  7C-7F F13 key - F16 key
  80H-87H F17 key - F24 key
  90 NUM LOCK key
  91 SCROLL LOCK key
  A0 Left SHIFT key
  A1 Right SHIFT key
  A2 Left CONTROL key
  A3 Right CONTROL key
  A4 Left MENU key
  A5 Right MENU key
#ce

