#include <Misc.au3>
#Include <Array.au3>

#RequireAdmin
_Singleton("d3gearswitcher")

;---------------------------------------
; Set up a Hot key to end the script
;---------------------------------------
Global $Paused
Global $Toggle
HotKeySet("{F4}", "RequestEnd")
HotKeySet("{F3}", "TogglePause")

;---------------------------------------
; Values read from the Settings.ini file
;---------------------------------------
func ReadSettings()
	Global $Button = IniRead("Settings.ini", "Button", "Button", "!{0}"); alt+0 by default
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

ReadSettings()

;---------------------------------------
; Globals
;---------------------------------------
$title = "Diablo III - Gear Switcher"
$win_title = "Diablo III"; English
$win_title_ch = "?????III"; Chinese
$sleepTimeForCoordDetection = 2000


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
; Start
;---------------------------------------

func Start()
	$MB_YESNO = 4
	$MB_YES = 6

	if MsgBox($MB_YESNO, $title, "Do you want to Run Setup?") == $MB_Yes then
		RunSetup()
	endif
endfunc

Start()

;---------------------------------------
; ButtonPress
;---------------------------------------
Global $switchingGear = False
func ButtonPress()
	if WinActive($win_title) or WinActive($win_title_ch) then
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
		 ;Sleep(100)
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
		HotKeySet($Button)
		ToolTip($title & ' is "Paused"',0,0)
	wend
	HotKeySet($Button, "ButtonPress")
	ToolTip("")
endfunc

;---------------------------------------

func RunSetup()

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
	"K = K"

	MsgBox(0, $title, $inGameInstructions)
	$LButton = InputBox($title, "Enter which hotkey you want to use that'll toggle the gear swap." _
	& @CRLF & $bindingInstructions, "" & $Button, "", 251, 250)
	If $LButton <> "" then
		IniWrite("Settings.ini", "Button", "Button", " " & $LButton)
		$Button = $LButton
	Else
		$Button = 1
		ErrorMsg()
		IniWrite("Settings.ini", "Button", "Button", " 1")
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
		"Coordinate recognition will happen 2 sec after pressing 'OK'")
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

;---------------------------------------
func ErrorMsg()
	MsgBox(0, $title, "Incorrect value entered or the user pressed cancel. Default value will be used!")
endfunc

while 1
	Sleep(1)
	if WinActive($win_title) or WinActive($win_title_ch) then
		HotKeySet($Button, "ButtonPress")
	else
		HotKeySet($Button)
	endif
wend