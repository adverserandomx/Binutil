
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
	  Sleep(250)
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

	$inGameInstructions = "F7 to suspend keypress detection" & @CRLF & _
	"F8 to exit the program"

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
	& @CRLF & $bindingInstructions, "{F1}", 251, 250)
	If $LButton <> "" then
		IniWrite($SettingsFile, "Button", "SwitchMFButton", " " & $LButton)
		$MFButton = $LButton
	Else
		$MFButton = "{F1}"
		ErrorMsg()
		IniWrite($SettingsFile, "Button", "SwitchMFButton",$MFButton)
	endif

	$LInventory = InputBox($title, "In game keybinding used to open your inventory (i by default)." _
	& @CRLF & $bindingInstructions, "" & $Inventory, "", 251, 250)
	If $LInventory <> "" then
		IniWrite($SettingsFile, "Inventory", "Inventory", " " & $LInventory)
		$Inventory = $LInventory
	Else
		$Inventory = "i"
		ErrorMsg()
		IniWrite($SettingsFile, "Inventory", "Inventory", " i")
	endif

	$LCloseAllButton = InputBox($title, "Enter which hotkey closes all windows in game (SPACE by default)(If you didn't change it in game, you can just press OK here)." _
	& @CRLF & $bindingInstructions, "" & $CloseAllButton, "", 251, 250)
	If $LCloseAllButton <> "" then
		IniWrite($SettingsFile, "CloseAllButton", "CloseAllButton", " " & $LCloseAllButton)
		$CloseAllButton = $LCloseAllButton
	Else
		$CloseAllButton = 1
		ErrorMsg()
		IniWrite($SettingsFile, "CloseAllButton", "CloseAllButton", " 1")
	endif

	; how many items do you want to switch?
	$LNumOfItems = InputBox($title, "How many items slots will you change?")
	If $LNumOfItems <> "" then
		IniWrite($SettingsFile, "NumOfItems", "NumOfItems", " " & $LNumOfItems)
		$NumOfItems = $LNumOfItems
	Else
		$NumOfItems = 2
		ErrorMsg()
		IniWrite($SettingsFile, "NumOfItems", "NumOfItems", " 2")
	endif

	; do you want to switch both rings?

	if MsgBox($MB_YESNO, $title, "Do you want to switch both rings?") == $MB_YES then
		$SwitchBothRings = true
		IniWrite($SettingsFile, "SwitchBothRings", "SwitchBothRings", $SwitchBothRings)
	Else
		$SwitchBothRings = false
		IniWrite($SettingsFile, "SwitchBothRings", "SwitchBothRings", $SwitchBothRings)
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
	IniWriteSection($SettingsFile, "Coords", $Coords, 0)

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
		IniWriteSection($SettingsFile, "SecRingCoords", $sData)
	endif

	ReadSettings()
	MsgBox(0, "", "Setup complete, you can now start swapping gear")

endfunc

Func WriteDefaultIni()
   Global $MFButton = IniWrite($SettingsFile, "Button", "SwitchMFButton", "{F1}")   
   Global $PauseButton = IniWrite($SettingsFile, "Button", "PauseButton", "{F7}")
   Global $EndButton = IniWrite($SettingsFile, "Button", "EndButton", "{F8}")
   Global $SetupButton = IniWrite($SettingsFile, "Button", "SetupButton", "{F9}")

   Global $SelfSpamButton = IniWrite($SettingsFile, "Button", "SelfSpamButton", "{5}")
   
   Global $EnableSpamKeys = IniWrite($SettingsFile, "Button", "EnableSpamKeys", true)
   Global $NovaButton = IniWrite($SettingsFile, "Button", "NovaButton", "{1}")
   Global $DiamondSkinButton = IniWrite($SettingsFile, "Button", "DiamondSkinButton", "{2}")
   Global $ExplosiveBlastButton = IniWrite($SettingsFile, "Button", "ExplosiveBlastButton", "{3}")
   Global $MiscButton = IniWrite($SettingsFile, "Button", "MiscButton", "{4}")   
   Global $UseMiscButton = IniWrite($SettingsFile, "Button", "UseMiscButton", false)
   Global $EnableAltPrimaryAttack = IniWrite($SettingsFile, "Button", "EnableAltPrimaryAttack", false)
   Global $EnableMeteor = IniWrite($SettingsFile, "Button", "EnableMeteor", false)
      
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
