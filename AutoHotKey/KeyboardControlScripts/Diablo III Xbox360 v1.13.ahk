/* 
													Diablo III Xbox360 Script
													by Jared Sigley aka Yelgis
													uses code from AutoHotkey.com
															
															
															
															Description:

This script enables you to control your character in game using a Xbox360 controller on PC. 

															Instructions:
1) Dowload the Joystick Test from AutoHotkey  http://www.autohotkey.com/docs/scripts/JoystickTest.htm
2) Run Joystick Test script to determine the number for your Xbox360 controller
3) Change the JoystickNumber variable below to whatever number corresponds with your controller
4) Run Diablo III Xbox360 script with autohotkey (or as standalone .exe after compiling)
5) Start Diablo III
6) Bind the following commands in game:
	- Move key to F12 
	- Town Portal to Up Arrow
	- Inventory to Left Arrow
	- Skills Menu to Down Arrow
	- Map to Right Arrow
7) If you change resolutions ingame at any point while the script is running, you must exit and restart the script
	for the new resolution values to be recognized.

*Note: The D-pad controls (Up, Down, Left and Right) are configurable to any of those menu options. The above is just what I suggest. If you want to arrange them differently that is up to you. Just be sure to only set Town Portal, Inventory, Skills Menu and Map to the d-pad because that portion of the script can't handle combat action keystrokes properly. 

See the config section below for how to change the key layout (A list of the button number layout for the controller is provided). 
	
	
Default Controls:

Move = Left Analog Stick
Mouse Control = Right Analog Stick3
Left Mouse/Skill = RT
Right Mouse/Skill = LT
1st Skill Slot = RB
2nd Skill Slot = LB
3rd Skill Slot = Y
4th Skill Slot = B
Potion = X
Town Portal = D-pad Up
Inventory = D-pad Left
Map = D-pad Right
Skills Menu = D-pad Down
Game Menu (Esc) = Back
Banner = Start
Stand Still = Press Left stick
Show Items on Ground = Press Right stick

*/


; BEGIN CONFIG SECTION

; Increase the following value to make the mouse cursor move faster:
JoyMulti = 1.0

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 10

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; Change these values to use joystick reassign the buttons on your controller to different actions
; Use the Joystick Test Script to find out your joystick's button numbers more easily.
; The default buttons for the 360 controller are:
; A = 1
; B = 2
; X = 3
; Y = 4
; LB = 5
; RB = 6
; back = 7
; start = 8
; left analog stick pushed in = 9
; right analog stick pushed in = 10
; To change a button just change the number below
SkillOne = 6
SkillTwo = 5
SkillThree = 4 
SkillFour = 2
Potion = 3
GameMenu = 7
StandStill = 9
Banner = 8
ShowItems = 10

; Mkey is the key set in game to the Move Action
mkey = F12						; change this to the key you have bound to the Move action in your game client

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.




#NoEnv							; Prevents bugs caused by environmental variables matching those in the script
#SingleInstance	                ; Makes it so only one copy can be ran at a time
SendMode Input		            ; Avoids the possible limitations of SendMode Play, increases reliability.
SetWorkingDir %A_ScriptDir%     ; Sets the script's working directory
SetDefaultMouseSpeed, 0         ; For character movement without moving the cursor
SetTitleMatchMode, 3            ; Window title must exactly match Winactive("Diablo III")
SetFormat, float, 03  			; Omits decimal point from axis position percentages.

left_flag = 0
right_flag = 0

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
    YAxisMultiplier = -1
else
    YAxisMultiplier = 1

	
; This section creates Hotkeys for Joystick Buttons that repeat the Key being used in subroutines below the auto-execute section
JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%SkillOne%, SkillOne
Hotkey, %JoystickPrefix%%SkillTwo%, SkillTwo
Hotkey, %JoystickPrefix%%SkillThree%, SkillThree
Hotkey, %JoystickPrefix%%SkillFour%, SkillFour
Hotkey, %JoystickPrefix%%Potion%, Potion
Hotkey, %JoystickPrefix%%GameMenu%, GameMenu
Hotkey, %JoystickPrefix%%ShowItems%, ShowItems
Hotkey, %JoystickPrefix%%StandStill%, StandStill
Hotkey, %JoystickPrefix%%Banner%, Banner

	
	
OnExit, Agent_Kill
	
WinWaitActive, Diablo III, , 60   	; this command waits 60 seconds for Diablo III to be the active window before continuing
if ErrorLevel
{
    MsgBox, Diablo III not started within the allotted time. Please run the script again then start Diablo III
    ExitApp
}
else
{
		Sleep 500												; waits this long before initializing: this solves getting incorrect info
		WinGetPos, win_x, win_y, width, height, A				; being retrieved by the WinGetPos command due to the window not being fully
		x_center := win_x + width / 2							; active
		compensation := (width / height) == (16 / 10) ? 1.063829 : 1.063711
		y_center := win_y + height / 2 / compensation	
		x_anchor := x_center - 50					; sets the upper left x-plane coord in pixels
		y_anchor := y_center - 50					; sets the upper left y-plane coord in pixels
}	


SetTimer, DIII_Move, -1
SetTimer, DIII_Mouse, -1
SetTimer, WatchPOV, -1

return  ; End of auto-execute section.




;This OnExit subroutine will terminate the Agent.exe if it doesn't close after Diablo III shuts down
Agent_Kill:		; kills Agent.exe if it is still running after Diablo and the script close
	if !WinExist("Diablo III")
	{
		Process, Close, Agent.exe 		
	}
	ExitApp
return




; This section contains the subroutines for Hotkeys that need to send repeated keys while held down
SkillOne:
Send {1 down}  
SetTimer, WaitForOneUp, 10
return

WaitForOneUp:
if GetKeyState(JoystickPrefix . SkillOne)  
    return
Send {1 up}  
SetTimer, WaitForOneUp, off
return


SkillTwo:
Send {2 down}  
SetTimer, WaitForTwoUp, 10
return

WaitForTwoUp:
if GetKeyState(JoystickPrefix . SkillTwo)  
    return
Send {2 up}  
SetTimer, WaitForTwoUp, off
return


SkillThree:
Send {3 down}  
SetTimer, WaitForThreeUp, 10
return

WaitForThreeUp:
if GetKeyState(JoystickPrefix . SkillThree)  
    return
Send {3 up}  
SetTimer, WaitForThreeUp, off
return


SkillFour:
	Send {4 down}  
	SetTimer, WaitForFourUp, 10
return

WaitForFourUp:
if GetKeyState(JoystickPrefix . SkillFour)  
    return
Send {4 up}  
SetTimer, WaitForFourUp, off
return


ShowItems:
	Send {Cntrl down}  
	SetTimer, WaitForItemUp, 10
return

WaitForItemUp:
if GetKeyState(JoystickPrefix . ShowItems)  
    return
Send {Cntrl up}  
SetTimer, WaitForItemUp, off
return


StandStill:
	Send {Shift down}  
	SetTimer, WaitForShiftUp, 10
return

WaitForShiftUp:
if GetKeyState(JoystickPrefix . StandStill)  
    return
Send {Shift up}  
SetTimer, WaitForShiftUp, off
return

Potion:
	Send {q down}  
	SetTimer, WaitForPotionUp, 10
return

WaitForPotionUp:
if GetKeyState(JoystickPrefix . Potion)  
    return
Send {q up}  
SetTimer, WaitForPotionUp, off
return

GameMenu:
	Send {ESC down}  
	SetTimer, WaitForESCUp, 10
return

WaitForESCUp:
if GetKeyState(JoystickPrefix . GameMenu)  
    return
Send {Esc up}  
SetTimer, WaitForESCUp, off
return

Banner:
	Send {g down}  
	SetTimer, WaitForBannerUp, 10
return

WaitForBannerUp:
if GetKeyState(JoystickPrefix . Banner)  
    return
Send {g up}  
SetTimer, WaitForBannerUp, off
return


; This timer watches for the triggers to be pressed and converts them into mouse clicks
WaitForLeftTriggerUp:
GetKeyState, joyZ, %JoystickNumber%JoyZ 
if joyZ > 60
    return		
SetTimer, WaitForLeftTriggerUp, off
Click right up
return	


WaitForRightTriggerUp:
GetKeyState, joyZ, %JoystickNumber%JoyZ 
if joyZ < 40
    return		
SetTimer, WaitForRightTriggerUp, off
Click left up
return




; This timer allows the D-pad (POV hat) to sent keypresses to be used for hotkeys
WatchPOV:
	if !WinActive("Diablo III") 
	{
		SetTimer, DIII_Mouse, -500				; runs the timer less frequently if Diablo isn't the active window
		return
	}

	GetKeyState, POV, JoyPOV  ; Get position of the POV control.
	KeyToHoldDownPrev = %KeyToHoldDown%  ; Prev now holds the key that was down before (if any).

	; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
	; To support them all, use a range:
	if POV < 0   ; No angle to report
		KeyToHoldDown =
	else if POV > 31500                 ; 315 to 360 degrees: Forward
		KeyToHoldDown = Up
	else if POV between 0 and 4500      ; 0 to 45 degrees: Forward
		KeyToHoldDown = Up
	else if POV between 4501 and 13500  ; 45 to 135 degrees: Right
		KeyToHoldDown = Right
	else if POV between 13501 and 22500 ; 135 to 225 degrees: Down
		KeyToHoldDown = Down
	else                                ; 225 to 315 degrees: Left
		KeyToHoldDown = Left
	
	GetKeyState, joyZ, %JoystickNumber%JoyZ 
	
	; Watch for Left Trigger
	if joyZ > 60
	{	
		SetMouseDelay, -1  									
		Click right down  						
		SetTimer, WaitForLeftTriggerUp, 10
	}
	
	; Watch for Right Trigger
	if joyZ < 40
	{
		SetMouseDelay, -1  									
		Click left down 						
		SetTimer, WaitForRightTriggerUp, 10
	}	
	
	if KeyToHoldDown = %KeyToHoldDownPrev%  ; The correct key is already down (or no key is needed).
	{	
		SetTimer, WatchPOV, -10
		return  ; Do nothing.
	}	

	; Otherwise, release the previous key and press down the new key:
	SetKeyDelay -1  ; Avoid delays between keystrokes.
	if KeyToHoldDownPrev   ; There is a previous key to release.
		Send, {%KeyToHoldDownPrev% up}  ; Release it.
	if KeyToHoldDown   ; There is a key to press down.
		Send, {%KeyToHoldDown% down}  ; Press it down.
		
		
	
	SetTimer, WatchPOV, -10
return	



; This timer of the timer controls right stick mouse movements	
DIII_Mouse:
	if !WinActive("Diablo III") 
	{
		SetTimer, DIII_Mouse, -500				; runs the timer less frequently if Diablo isn't the active window
		return
	}

	MouseNeedsToBeMoved := false  ; Set default.	
	GetKeyState, joyR, %JoystickNumber%JoyR
    GetKeyState, joyU, %JoystickNumber%JoyU
		
	if joyU > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaU := joyU - JoyThresholdUpper
	}
	else if joyU < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaU:= joyU - JoyThresholdLower
	}
	else
		DeltaU = 0
	
	if joyR > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaR := joyR - JoyThresholdUpper
	}
	else if joyR < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaR := joyR - JoyThresholdLower
	}
	else
		DeltaR = 0

	if MouseNeedsToBeMoved
	{
		SetMouseDelay, -1  ; Makes movement smoother.
		MouseMove, DeltaU * JoyMulti, DeltaR * JoyMulti * YAxisMultiplier, 0, R
	}

	SetTimer, DIII_Mouse, -10
return	
	
	
	
	
	
; This timer watches for left stick input then moves the character 
DIII_Move:
	if !WinActive("Diablo III") 
	{
		if !WinExist("Diablo III")					; closes the script down if Diablo is no longer running
		{	
			ExitApp
		}
		
		SetTimer, DIII_Move, -500				; runs the timer less frequently if Diablo isn't the active window
		return
	}
	
	MouseGetPos, x_initial, y_initial
	GetKeyState, joyX, %JoystickNumber%JoyX
	GetKeyState, joyY, %JoystickNumber%JoyY
	
	if GetKeyState("Shift", "P") ; this if/loop lets Shift still function as stand a stand still key
	{
		Loop
		{
			GetKeyState, state, Shift, P
			if state = U  
			break				
		}
	}
	else if (joyX < JoyThresholdLower) OR (joyX > JoyThresholdUpper) OR (joyY < JoyThresholdLower) OR (joyY > JoyThresholdUpper)
	{
	
		x_final := x_anchor + joyX
		y_final := y_anchor + joyY
		MouseMove, %x_final%, %y_final%, 0			; Move cursor to direction to be moved towards without clicking
		Send {F12} 									; sends Move command, you must set your Move keybind to match in game
		MouseMove, %x_initial%, %y_initial%, 0  	; returns cursor to where it was before you issued joystick movement
	}
													
SetTimer, DIII_Move, -10	
return	


; Copyright (c) 2012, Jared Sigley 
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
; THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
; CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
; PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.