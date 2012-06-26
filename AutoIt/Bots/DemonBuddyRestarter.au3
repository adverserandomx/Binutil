#include <WindowsConstants.au3>
#include <Misc.au3>
#Include <WinAPI.au3>

Global $LoginButton[2]
Global $Paused = False
HotKeySet('{=}', 'Pause')
HotKeySet('{-}', 'Terminate')



Pause()
While 1


$LoginButton[0] = 358
$LoginButton[1] = 352


MouseClick("left",$LoginButton[0], $LoginButton[1], 5, 5)

Wend

Func Pause()
   $Paused = Not $Paused
   While $Paused
      Sleep(100)
	  ToolTip('Paused... Press {=} to continue or {-} to exit...', 850, 0)
   WEnd
EndFunc

Func Terminate()
Exit   
   
EndFunc
