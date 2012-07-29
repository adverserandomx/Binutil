;Includes gear switcher as well as 1 and 2 key spammer

#include <Misc.au3>
#Include <Array.au3>

#RequireAdmin
_Singleton("d3WizardHelper")

;---------------------------------------------------------------------
; Globals - Change values here to your preferences
;---------------------------------------------------------------------
Global $sleepTimeForCoordDetection = 2000 ;set the amount of time you want to wait during MF setup between each item coordinate
;load INI settings - DON'T MOVE THIS FUNCTION CALL
ReadSettings()

;Don't mess with values below
Global $title = "Diablo III - Wizard Combo Script"						
Global $win_title = "Diablo III"; English
Global $win_title_ch = "?????III"; Chinese
Global $Paused
Global $SelfSpam = false			; default value - set later
Global $useExplosiveBlast = false	; default value - set later
Global $ActionQueued = false		; default value - set later
Global $switchingGear = False

Global $UseAltAttack = false
Global $UseAltAttackCounter = 0
Global $MaxAltAttackCounter = 5

HotKeySet($PauseButton, "TogglePause")
HotKeySet($SetupButton, "Setup")
HotKeySet($EndButton, "RequestEnd") 

;---------------------------------------
; Window checks
;---------------------------------------
$win_exists = false
if WinExists($win_title, "") then
	$win_exists = true
elseif WinExists($win_title_ch, "") then
	$win_exists = true
endif

if not $win_exists then
   MsgBox(0, $title, $win_title & " window must be open.")
   Exit
endif


;---------------------------------------
; Main loop - for keycodes check bottom of script
;---------------------------------------
while 1
	if WinActive($win_title) or WinActive($win_title_ch) then
		if $EnableSpamKeys And NOT $Paused Then
			If _IsPressed('35') = 1 AND _IsPressed('20') = 1 Then $SelfSpam = true
			If _IsPressed('36') = 1 AND _IsPressed('20') = 1 Then 
				$SelfSpam = false
				
				;reset the alt attack info
				$UseAltAttack = false
				$UseAltAttackCounter = 0
			Endif
			If _IsPressed('31') = 1 AND _IsPressed('20') = 1 Then 
				WickedWindSpam()
				$SelfSpam = false
			endif
			If (_IsPressed('33') = 1 AND _IsPressed('20') = 1) Then 
				EBSpam()
				$SelfSpam = false
			Endif
			If $SelfSpam == true Then 
				EBSpam()
			Endif
		endif
		HotKeySet($MFButton, "SwitchMFGear")
		HotKeySet($PauseButton, "TogglePause")
		HotKeySet($SetupButton, "Setup")
		HotKeySet($EndButton, "RequestEnd") 
	else ;when window is not active, disable all hotkeys
		HotKeySet($MFButton)
		HotKeySet($PauseButton)
		HotKeySet($SetupButton)
		HotKeySet($EndButton) 
	endif
	Sleep(200)
wend

;---------------------------------------
; Values read from the Settings.ini file
;---------------------------------------
func ReadSettings()
   
   Global $PauseButton = IniRead("Settings.ini", "Button", "PauseButton", "{F3}")
   Global $SetupButton = IniRead("Settings.ini", "Button", "SetupButton", "{F4}")
   Global $EndButton = IniRead("Settings.ini", "Button", "EndButton", "{F5}")
   Global $SelfSpamButton = IniRead("Settings.ini", "Button", "EndButton", "{5}")
   
   Global $EnableSpamKeys = IniRead("Settings.ini", "Button", "EnableSpamKeys", true)

   Global $MFButton = IniRead("Settings.ini", "Button", "SwitchMFButton", "{F1}"); alt+0 by default
   Global $NovaButton = IniRead("Settings.ini", "Button", "NovaButton", "{1}")
   Global $DiamondSkinButton = IniRead("Settings.ini", "Button", "DiamondSkinButton", "{2}")
   Global $ExplosiveBlastButton = IniRead("Settings.ini", "Button", "ExplosiveBlastButton", "{3}")
   Global $MiscButton = IniRead("Settings.ini", "Button", "MiscButton", "{4}")   
   Global $UseMiscButton = IniRead("Settings.ini", "Button", "UseMiscButton", false)
   Global $EnableAltPrimaryAttack = IniRead("Settings.ini", "Button", "EnableAltPrimaryAttack", false)   

   Global $CloseAllButton = IniRead("Settings.ini", "CloseAllButton", "CloseAllButton", "{SPACE}")
   Global $Inventory = IniRead("Settings.ini", "Inventory", "Inventory", "{i}")
   Global $NumOfItems = IniRead("Settings.ini", "NumOfItems", "NumOfItems", "0")
   Global $SwitchBothRings = IniRead("Settings.ini", "SwitchBothRings", "SwitchBothRings", true)

   Global $upperBound = $NumOfItems
   if $SwitchBothRings == "False" then
    Else
		$upperBound = $upperBound - 1
		Global $SecRingCoords = IniReadSection("Settings.ini", "SecRingCoords")
	endif
	Global $Coords = IniReadSection("Settings.ini", "Coords")
 endfunc

;---------------------------------------
; Wiz Tank functions 
;---------------------------------------
func PrimaryAttack()
	if ($EnableAltPrimaryAttack == true) then		
		if ($UseAltAttackCounter >= $MaxAltAttackCounter) then
			$UseAltAttackCounter = 0
			$UseAltAttack = Not $UseAltAttack
		endif

		if ($UseAltAttack) then
			Send($MiscButton) ;misc
		else
			MouseClick("Left") ;ww		
		endif
	else
		MouseClick("Left") ;ww
	endif
endfunc

func SpamKeys()
	; this version tries to get more nova/diamond skin into the rotation
	if $ActionQueued == false then
		$ActionQueue = true
		
		$UseAltAttackCounter = $UseAltAttackCounter + 1

		Send("{SHIFTDOWN}")
		
		PrimaryAttack()		
		Send($NovaButton)
		Send($DiamondSkinButton)
		PrimaryAttack()
		
		if $useExplosiveBlast == True Then
			Send($NovaButton)	;nova
			Send($DiamondSkinButton) ;shell
			Send($ExplosiveBlastButton) ;eb	
		EndIf
		
		if $UseMiscButton == True And $EnableAltPrimaryAttack == false Then
			MouseClick("Left") ;ww
			Send($NovaButton)	;nova
			Send($MiscButton) ;misc
	    EndIf
		
		PrimaryAttack()		
		Send($NovaButton)	;nova
		Send($DiamondSkinButton) ;shell
		
		Send("{SHIFTUP}")		
		
		$ActionQueued = False
	EndIf  
EndFunc


func WickedWindSpam()
	$useExplosiveBlast = false
	SpamKeys()
EndFunc

func EBSpam()
	$useExplosiveBlast = true
	SpamKeys()     
EndFunc


;---------------------------------------
; SwitchMFGear
;---------------------------------------
func SwitchMFGear()
	if WinActive($win_title) or WinActive($win_title_ch) then
	  $SelfSpam = false
	  If $switchingGear == True Then ;prevent spamming switch inventory key because of user panic
		 Return
	  EndIf
	  $switchingGear = True  
	  BlockInput(1)
	  $StartPos = MouseGetPos()
	  Send($CloseAllButton)
	  Sleep(100)
	  Send($Inventory)
	  Sleep(100)
	  For $i = 1 To $upperBound
		 MouseClick ("right", $Coords[$i][0], $Coords[$i][1], 1, 1 )
		 Sleep(10)
		 ;ToolTip("i = " & $i)
		 ;TogglePause()
	  Next

	  if $SwitchBothRings  Then
		 Send("{ALT DOWN}");
		 MouseClick ( "right", $SecRingCoords[1][0], $SecRingCoords[1][1], 1, 0 )
		 Send("{ALT UP}")
	  endif

	  Send($Inventory)

	  MouseMove($StartPos[0], $StartPos[1], 0)
	  BlockInput(0)
	  $switchingGear = False
	endif
endfunc

;---------------------------------------
; Setup
;---------------------------------------

func Setup()
	$MB_YESNO = 4
	$MB_YES = 6

	if MsgBox($MB_YESNO, $title, "Do you want to Run Setup?") == $MB_Yes then
		RunMFSetup()
	endif
endfunc


;---------------------------------------
; MF Setup 
;---------------------------------------
func RunMFSetup()

	$MB_YESNO = 4
	$MB_YES = 6

	$inGameInstructions = "= to suspend keypress detection" & @CRLF & _
	"SHIFT+= to exit the program"

	$bindingInstructions = "Instead of ALT use: !" & @CRLF & _
	"Instead of SHIFT use: +" & @CRLF & _
	"Instead of CTRL use: ^" & @CRLF & _
	"Examples:" & @CRLF & _
	"SHIFT+CTRL+K = +^K"& @CRLF & _
	"ALT+4 = !4"& @CRLF & _
	"K = K"& @CRLF & _
	"Please check your settings.ini to change other button defaults"

   
	MsgBox(0, $title, $inGameInstructions)
	
	WriteDefaultIni()

	$LButton = InputBox($title, "Enter which hotkey you want to use that'll toggle the gear swap." _
	& @CRLF & $bindingInstructions, "" & $MFButton, "", 251, 250)
	If $LButton <> "" then
		IniWrite("Settings.ini", "Button", "SwitchMFButton", " " & $LButton)
		$MFButton = $LButton
	Else
		$MFButton = "{F1}"
		ErrorMsg()
		IniWrite("Settings.ini", "Button", "SwitchMFButton",$MFButton)
	endif

	$LInventory = InputBox($title, "In game keybinding used to open your inventory (i by default)." _
	& @CRLF & $bindingInstructions, "" & $Inventory, "", 251, 250)
	If $LInventory <> "" then
		IniWrite("Settings.ini", "Inventory", "Inventory", " " & $LInventory)
		$Inventory = $LInventory
	Else
		$Inventory = "i"
		ErrorMsg()
		IniWrite("Settings.ini", "Inventory", "Inventory", " i")
	endif

	$LCloseAllButton = InputBox($title, "Enter which hotkey closes all windows in game (SPACE by default)(If you didn't change it in game, you can just press OK here)." _
	& @CRLF & $bindingInstructions, "" & $CloseAllButton, "", 251, 250)
	If $LCloseAllButton <> "" then
		IniWrite("Settings.ini", "CloseAllButton", "CloseAllButton", " " & $LCloseAllButton)
		$CloseAllButton = $LCloseAllButton
	Else
		$CloseAllButton = 1
		ErrorMsg()
		IniWrite("Settings.ini", "CloseAllButton", "CloseAllButton", " 1")
	endif

	; how many items do you want to switch?
	$LNumOfItems = InputBox($title, "How many items slots will you change?")
	If $LNumOfItems <> "" then
		IniWrite("Settings.ini", "NumOfItems", "NumOfItems", " " & $LNumOfItems)
		$NumOfItems = $LNumOfItems
	Else
		$NumOfItems = 2
		ErrorMsg()
		IniWrite("Settings.ini", "NumOfItems", "NumOfItems", " 2")
	endif

	; do you want to switch both rings?

	if MsgBox($MB_YESNO, $title, "Do you want to switch both rings?") == $MB_YES then
		$SwitchBothRings = true
		IniWrite("Settings.ini", "SwitchBothRings", "SwitchBothRings", $SwitchBothRings)
	Else
		$SwitchBothRings = false
		IniWrite("Settings.ini", "SwitchBothRings", "SwitchBothRings", $SwitchBothRings)
	endif

	; input item locations
	; 	loop for items - 1 if we change 2nd ring too
	$upperBound = $NumOfItems
	if $SwitchBothRings then
		$upperBound = $upperBound - 1
	endif

	Dim $LCoords[$upperBound][2]

	For $i = 0 To $upperBound - 1
		MsgBox(0, "", "Move the mouse into the position of the " & $i + 1 & " (st/nd/rd/th) item in your inventory." & @CRLF & _
		"Coordinate recognition will happen " & $sleepTimeForCoordDetection/1000 & " sec after pressing 'OK'")
		sleep($sleepTimeForCoordDetection)
		$pos = MouseGetPos()
		$LCoords[$i][0] = $pos[0]
		$LCoords[$i][1] = $pos[1]
	Next
	$Coords = $LCoords
	IniWriteSection("Settings.ini", "Coords", $Coords, 0)

	; input 2nd ring location

	if $SwitchBothRings then
		MsgBox(0, "", "Move the mouse into the position of the 2nd ring in your inventory." & @CRLF & _
		"Coordinate recognition will happen 2 sec after pressing 'OK'")
		sleep($sleepTimeForCoordDetection)
		$pos = MouseGetPos()
		Global $SecRingCoords[2][2]
		$SecRingCoords[1][0] = $pos[0]
		$SecRingCoords[1][1] = $pos[1]
		$sData = $SecRingCoords[1][0]&"="&$SecRingCoords[1][1]
		IniWriteSection("Settings.ini", "SecRingCoords", $sData)
	endif

	ReadSettings()
	MsgBox(0, "", "Setup complete, you can now start swapping gear")

endfunc

Func WriteDefaultIni()
   Global $PauseButton = IniWrite("Settings.ini", "Button", "SwitchMFButton", "{F1}")   
   Global $PauseButton = IniWrite("Settings.ini", "Button", "PauseButton", "{F3}")
   Global $SetupButton = IniWrite("Settings.ini", "Button", "SetupButton", "{F4}")
   Global $EndButton = IniWrite("Settings.ini", "Button", "EndButton", "{F5}")
   Global $SelfSpamButton = IniWrite("Settings.ini", "Button", "EndButton", "{5}")
   
   Global $EnableSpamKeys = IniWrite("Settings.ini", "Button", "EnableSpamKeys", true)
   Global $NovaButton = IniWrite("Settings.ini", "Button", "NovaButton", "{1}")
   Global $DiamondSkinButton = IniWrite("Settings.ini", "Button", "DiamondSkinButton", "{2}")
   Global $ExplosiveBlastButton = IniWrite("Settings.ini", "Button", "ExplosiveBlastButton", "{3}")
   Global $MiscButton = IniWrite("Settings.ini", "Button", "MiscButton", "{4}")   
   Global $UseMiscButton = IniWrite("Settings.ini", "Button", "UseMiscButton", false)
   
EndFunc


;---------------------------------------
; Helper functions
;---------------------------------------
func RequestEnd()
	$MB_YESNO = 4
	$MB_YES = 6

	if MsgBox($MB_YESNO, $title, "End script?") == $MB_YES then
		Exit
	endif
endfunc

func TogglePause()
	$Paused = NOT $Paused
	while $Paused
		sleep(100)
		;disable switch MF gear button and setup keys
		HotKeySet($MFButton) 
		HotKeySet($SetupButton)
		ToolTip($title & ' is Paused. Hit ' & $PauseButton & ' to resume.',0,0)
	wend
	HotKeySet($MFButton, "SwitchMFGear")
	HotKeySet($SetupButton, "Setup")
	ToolTip("")
 endfunc
 
func ErrorMsg()
   MsgBox(0, $title, "Incorrect value entered or the user pressed cancel. Default value will be used!")
endfunc
 
#cs
KeyPressed key codes
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