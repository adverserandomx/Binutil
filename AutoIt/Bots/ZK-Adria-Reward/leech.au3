#include <ImageSearch.au3>
Global $x0=0, $y0=0


	Opt("WinTitleMatchMode", 2)
	WinActivate("Diablo III")

While 1
	
	$Ari = PixelSearch(0, 20, 137, 110, 0x1E2034, 25)
	If Not @error Then
		   MouseClick ('left', $Ari[0]-20, $Ari[1])
	EndIf
	Sleep(6000)
	Send("{ESC}")
	Sleep(1000)
	Send("{ESC}")
	Sleep(1000)

	$result =_ImageSearchArea("leavegame.png", 1, 0, 0, 900, 900, $x0, $y0, 50)
	While $result<>1
		Send ("{ESC}")
		Sleep(650+Random(0,250))
		$result=_ImageSearchArea("leavegame.png", 1, 0, 0, 900, 900, $x0, $y0, 50)
	WEnd

	MouseClick ("Left", $x0, $y0)

	$result =_ImageSearchArea("resume.png", 1, 0, 0, 900, 900, $x0, $y0, 50)
	While $result<>1
		Sleep(50+Random(0,50))
		$result=_ImageSearchArea("resume.png", 1, 0, 0, 900, 900, $x0, $y0, 50)
	WEnd

	Sleep(Random(500,800))

	Send ("o")
	Sleep(Random(500,800))
	MouseClick ("Right", 590, 222)
	Sleep(Random(500,800))
	MouseClick ("Left", 619, 301)
	Sleep(Random(500,800))

	$result =_ImageSearchArea("ingame.bmp", 1, 0, 0, 900, 900, $x0, $y0, 50)
	While $result<>1
	  Sleep(50+Random(0,50))
	  $result=_ImageSearchArea("ingame.bmp", 1, 0, 0, 900, 900, $x0, $y0, 50)
	WEnd
	Sleep(Random(500,800))

WEnd