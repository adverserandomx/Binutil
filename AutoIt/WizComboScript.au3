;Includes gear switcher as well as 1 and 2 key spammer

#include <Misc.au3>
#Include <Array.au3>

#RequireAdmin
_Singleton("d3WizardHelper")

;---------------------------------------------------------------------
; Globals - Change values here to your preferences
;---------------------------------------------------------------------
Global $SettingsFile = IniRead("LocalSetup.ini", "FileConfig", "SettingsFile", "Settings.ini")
Global $EnableF3HotKey = IniRead($SettingsFile, "HotKeyConfig", "EnableF3HotKey", false)
Global $EnableF4HotKey = IniRead($SettingsFile, "HotKeyConfig", "EnableF4HotKey", false)

Global $sleepTimeForCoordDetection = 2000 ;set the amount of time you want to wait during MF setup between each item coordinate
;load INI settings - DON'T MOVE THIS FUNCTION CALL

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


Global $AntiIdle = False
Global $IdleBeingCalled = False
Func AntiIdle()
   if $IdleBeingCalled == False then
	  $IdleBeingCalled = True
	  $AntiIdle = True
	  Do
		 Send("{i}")
		 ToolTip("Idling")
		 Sleep(60000)
	  Until $AntiIdle
	  ToolTip("")
	  $IdleBeingCalled = False
   Endif
   $AntiIdle = False
EndFunc	

#include "WizIncludes/ReadSettings.au3"
ReadSettings()

; assign hot keys after reading the settings
HotKeySet("{F6}", "AntiIdle")
HotKeySet($PauseButton, "TogglePause")
HotKeySet($SetupButton, "Setup")
HotKeySet($EndButton, "RequestEnd") 
If $EnableF3HotKey Then HotKeySet("{F3}", "EnableAutoAttack")
If $EnableF3HotKey Then HotKeySet("{F4}", "DisableAutoAttack")

;#include ".../WizIncludes/WindowChecks.au3"

;---------------------------------------
; Main loop - for keycodes check bottom of script
;---------------------------------------
while 1
	if WinActive($win_title) or WinActive($win_title_ch) then
		if $EnableSpamKeys And NOT $Paused Then
			WizLoop()
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
; CM Wiz Functions 
;---------------------------------------
func WizLoop()
	If _IsPressed('35') = 1 AND _IsPressed('20') = 1 Then $SelfSpam = true
	If _IsPressed('36') = 1 AND _IsPressed('20') = 1 Then 
		DisableAutoAttack()
	Endif
	;If _IsPressed('31') = 1 AND _IsPressed('20') = 1 Then 
	;	WickedWindSpam()
	;	$SelfSpam = false
	;endif
	If _IsPressed('20') = 1 AND (_IsPressed('33') = 1 OR _IsPressed('34') = 1 OR _IsPressed('31') = 1) Then 
		EBSpam()
		$SelfSpam = false
	Endif
	If $SelfSpam == true Then 
		EBSpam()
	Endif
endfunc

func DisableAutoAttack()
	$SelfSpam = false
	
	;reset the alt attack info
	$UseAltAttack = false
	$UseAltAttackCounter = 0
endfunc

func EnableAutoAttack()
	$SelfSpam = true
endfunc

func PrimaryAttack()
	;we really want to spam more nova...
	Send($NovaButton)
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
	Send($NovaButton)
endfunc

func SpamKeys()
	; this version tries to get more nova/diamond skin into the rotation
	if $ActionQueued == false then
		$ActionQueue = true
		
		$UseAltAttackCounter = $UseAltAttackCounter + 1

		Send("{SHIFTDOWN}")
		
		PrimaryAttack()
		
		If $EnableMeteor == True Then ; add slight delay for Meteor
		 Sleep(175)
		EndIf
		
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

#include "WizIncludes/EndingIncludes.au3"
