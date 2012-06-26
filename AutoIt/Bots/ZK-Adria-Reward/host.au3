#include <ImageSearch.au3>

HotKeySet('{-}', 'Terminate')

Global $x1=0, $y1=0, $j=0, $xl=0

Opt("WinTitleMatchMode", 2)
WinActivate("Diablo III")

While 1

	;Sleep( 1000)
	Sleep(Random(5000,8000))
	MouseClick ("Left",  111,  262)
	
	Sleep(2000)
	MouseClick ("Left", 400, 375)
	Sleep(1000)
	MouseClick ("Left",  111,  262)
	
	Do
	   Sleep (100)
	   $result = _ImageSearchArea("ingame.bmp",1,0,0,500,800,$x1,$y1,30)
	   Sleep(100)
	Until $result

	Do
	   Sleep (100)
	   $result = _ImageSearchArea("stronger.bmp",1,0,0,500,800,$x1,$y1,30)
	   Sleep(100)
	Until $result

	Send ("{ESC}")
	MouseClick ("Left",  390,  348)
	Sleep(Random(100,300))
	Send("{ENTER}")

	;Do
	;   Sleep (100)
	;   $result = _ImageSearchArea("resume.png",1,0,0,500,5000,$x1,$y1,30)
	;   Sleep(100)
	;Until $result

WEnd

Func Terminate()
   Exit 0
EndFunc