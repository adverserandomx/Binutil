---------------------------------------
Window checks
---------------------------------------
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