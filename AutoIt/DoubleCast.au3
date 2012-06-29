#include <Misc.au3>
#Include <Array.au3>

#RequireAdmin
_Singleton("d3gearswitcher")

;---------------------------------------
; Set up a Hot key to end the script
;---------------------------------------
Global $Paused
Global $Toggle
HotKeySet("{5}", "DoubleCast")
HotKeySet("{F4}", "RequestEnd")
HotKeySet("{F3}", "TogglePause")

Global $ActionQueued = false

func DoubleCast()
   if $ActionQueued == false then
	  $ActionQueued = true
	  MouseClick("left")
	  Sleep(100)
	  Mouseclick("right")
	  Sleep(100)
	  
	  $ActionQueued = False
   EndIf
   
EndFunc


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


while 1
	Sleep(1)

wend