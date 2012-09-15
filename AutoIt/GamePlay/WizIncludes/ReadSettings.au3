;---------------------------------------
; Values read from the Settings.ini file
;---------------------------------------
func ReadSettings()
   
   Global $PauseButton = IniRead($SettingsFile, "Button", "PauseButton", "{F7}")
   Global $EndButton = IniRead($SettingsFile, "Button", "EndButton", "{F8}")
   Global $SetupButton = IniRead($SettingsFile, "Button", "SetupButton", "{F9}")
   
   Global $SelfSpamButton = IniRead($SettingsFile, "Button", "EndButton", "{5}")
   
   Global $EnableSpamKeys = IniRead($SettingsFile, "Button", "EnableSpamKeys", true)

   Global $MFButton = IniRead($SettingsFile, "Button", "SwitchMFButton", "{F1}"); alt+0 by default
   Global $NovaButton = IniRead($SettingsFile, "Button", "NovaButton", "{3}")
   Global $DiamondSkinButton = IniRead($SettingsFile, "Button", "DiamondSkinButton", "{2}")
   Global $ExplosiveBlastButton = IniRead($SettingsFile, "Button", "ExplosiveBlastButton", "{1}")
   Global $MiscButton = IniRead($SettingsFile, "Button", "MiscButton", "{4}")   
   Global $UseMiscButton = IniRead($SettingsFile, "Button", "UseMiscButton", false)
   Global $EnableAltPrimaryAttack = IniRead($SettingsFile, "Button", "EnableAltPrimaryAttack", false)
   Global $EnableMeteor = IniRead($SettingsFile, "Button", "EnableMeteor", false)   

   Global $CloseAllButton = IniRead($SettingsFile, "CloseAllButton", "CloseAllButton", "{SPACE}")
   Global $Inventory = IniRead($SettingsFile, "Inventory", "Inventory", "{i}")
   Global $NumOfItems = IniRead($SettingsFile, "NumOfItems", "NumOfItems", "0")
   Global $SwitchBothRings = IniRead($SettingsFile, "SwitchBothRings", "SwitchBothRings", true)

   Global $upperBound = $NumOfItems
   if $SwitchBothRings == "False" then
    Else
		$upperBound = $upperBound - 1
		Global $SecRingCoords = IniReadSection($SettingsFile, "SecRingCoords")
	endif
	Global $Coords = IniReadSection($SettingsFile, "Coords")
 endfunc