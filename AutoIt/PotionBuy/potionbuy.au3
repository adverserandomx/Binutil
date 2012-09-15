HotKeySet('{F10}', 'Pause')
HotKeySet('{F11}', 'Terminate')


While 1
WinActivate('Diablo III')
Pause()
   for $i = 1 to 1
   MouseClick("right",414,230,2)
   ;sleep(100)
   next
WEnd


Func Pause()
   $Paused = Not $Paused
   While $Paused
      Sleep(100)
	  ToolTip('Paused... Press {=} to continue or {-} to exit...', 850, 0)
   WEnd
EndFunc

Func Terminate()
   Exit 0
EndFunc
