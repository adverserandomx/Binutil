#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>
#include <GuiListBox.au3>
#include <ScrollBarConstants.au3>
#include <Array.au3>

#cs

   [Gold/Itemfarming] [AutoIt] Sarkoth Act I Dank Cellar [WD] [Stash, Sell, Repair, +++]
									by zEEneXx
								 
								  Version: 1.1c
							   
								 www.ownedcore.com
				  
#ce

OnAutoItExitRegister ('OnAutoItExit')
Opt('MouseCoordMode', 2)
Opt('PixelCoordMode', 2)

HotKeySet('{PAUSE}', 'Pause')
HotKeySet('{END}', 'Terminate')

Global $ImageFiles[8][7]
Global $SoundFiles[6]
Global $PasswordField[2]
Global $ResumeButton[2]
Global $LeaveButton[2]
Global $DisconnectButton[2]
Global $MoveToCellar1[2]
Global $MoveToCellar2[2]
Global $MoveToCellar3[2]
Global $MoveInCellar1[2]
Global $MoveInCellar2[2]
Global $MoveToGoldLoot1a[2]
Global $MoveToGoldLoot1b[2]			
Global $MoveToGoldLoot2[2]			
Global $MoveToGoldLoot3[2]	
Global $MoveToMerchant[2]
Global $MoveToStash1[2]
Global $MoveToStash2[2]
Global $CellarLocation[2]	
Global $MonsterLocation[2]
Global $MerchantLocation[2]
Global $StashLocation[2]
Global $PortalLocation[2]
Global $CharHitBox[4]
Global $LoginButtonSearchArea[4]
Global $ResumeButtonSearchArea[4]
Global $PortalIconSearchArea[4]
Global $CellarNameSearchArea[4]
Global $TownNameSearchArea[4]
Global $MerchStashSearchArea[4]
Global $MonsterSearchArea[4]
Global $LootingArea[4]
Global $FullBagSearchArea[4]
Global $SellItemsArea[4]
Global $FullStashSearchArea[4]
Global $RepairSearchArea[4]	
Global $DeathSearchArea[4]
Global $DisconnectSearchArea[4]
Global $StashBag2[2]
Global $StashBag3[2]
Global $RepairButton[2]
Global $AllItemsButton[2]
Global $CellarOffset
Global $CellarPixel
Global $Log
Global $Label
Global $LogList
Global $RuntimeTimer
Global $TimeOutTimer
Global $Paused

;///////////////////////////////////////--CONFIG--////////////////////////////////////////////////////////////////////////////////
;																																//
;										Important																				//
$ComputerLag		= 0											;Increase this in steps of 400 if you have slow loading times	//
$MoveDelay			= 0											;Increase this in steps of 100 if you have movement issues		//
$LootDelay			= 0											;Increase this in steps of 200 if you have looting issues		//
$ImgDir				= "C:\Program Files (x86)\AutoIt3\pics\"	;Location of the image folder									//
;																																//
;									    Functions																				//
$TimeOut			= 7											;How long the bot waits before timeout (in seconds)				//
$Repair				= True										;Orders the bot to repair when items are damaged				//
$Sell				= True										;Orders the bot to sell magic items when bag is full			//
$UseStash			= True										;Orders the bot to put gems and rare items into the stash		//
$HighGoldRadius		= False										;Set this to true if you have more than +18 gold radius			//
;																																//
;								   	  Miscellaneous																				//
$Sounds				= True										;Enable pickup sounds											//
$SoundsDir			= "C:\Program Files (x86)\AutoIt3\sounds\"	;Location of the sounds folder									//
$ShowLootArea		= True										;Shows lootarea													//
$ShowLog			= True										;Shows log overlay												//
$SaveStats			= True										;Saves current statistics to a *.txt file						//
$SaveLogsPath		= "C:\Program Files (x86)\AutoIt3\logs\"	;Folder to save the logs and statistics in						//
;																																//
;									   Relogging																				//									
$UseRelogging		= True										;Enable Relogging												//
$Password			= "xxxxxxxx"								;Your password													//
;																																//
;																																//
;									     Looting																				//
$LootLegendaries	= True										;Loot legendary items											//
$LootSets			= True										;Loot set items													//
$LootRares			= True										;Loot rare items												//
$LootMagics			= True										;Loot magic items (includes tomes)								//
$LootTomes			= True										;Loot tomes														//
$LootGems			= True										;Loot gems														//
;																																//
;	   <<<Changes below have an significant impact on the needed time for one run>>>											//
;																																//
$RareLootAmount		= 1											;Amount of rare items to loot									//
$MagicLootAmount	= 3											;Amount of magic items to loot (including tomes)				//
$TomeLootAmount 	= 1											;Amount of tomes to loot										//
$GemLootAmount 		= 2											;Amount of gems to loot											//
;																																//
$LootingArea[0] 	= 570										;Left	(lower -> bigger) 										//
$LootingArea[1] 	= 185										;Top	(lower -> bigger)										//
$LootingArea[2] 	= 1375										;Right	(higher -> bigger)										//
$LootingArea[3] 	= 720										;Bot	(higher -> bigger)										//
;																																//
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

$ImageFiles[0][0] 			= "legendaryA.png|60"
$ImageFiles[0][1] 			= "legendaryE.png|60"
$ImageFiles[0][2] 			= "legendaryI.png|60"
$ImageFiles[0][3] 			= "legendaryO.png|60"
$ImageFiles[0][4] 			= "legendaryU.png|60"
$ImageFiles[1][0] 			= "setA.png|90"
$ImageFiles[1][1] 			= "setE.png|90"
$ImageFiles[1][2] 			= "setU.png|90"
$ImageFiles[1][3]			= "setO.png|90"
$ImageFiles[1][4]			= "setI.png|90"
$ImageFiles[2][0] 			= "rareA.png|102"
$ImageFiles[2][1] 			= "rareE.png|102"
$ImageFiles[2][2] 			= "rareI.png|102"
$ImageFiles[2][3] 			= "rareO.png|102"
$ImageFiles[2][4] 			= "rareU.png|102"
$ImageFiles[3][0] 			= "blueA.png|70"
$ImageFiles[3][1] 			= "blueE.png|70"
$ImageFiles[3][2] 			= "blueI.png|70"
$ImageFiles[3][3] 			= "blueO.png|70"
$ImageFiles[3][4] 			= "blueU.png|70"
$ImageFiles[4][0] 			= "tome.png|140"
$ImageFiles[4][1] 			= "uare.png|110"
$ImageFiles[5][0]			= "you.png|100"
$ImageFiles[5][1]			= "sellNew.png|55"
$ImageFiles[5][2]			= "sell1x1.png|40"
$ImageFiles[5][3]			= "sell1x2.png|40"
$ImageFiles[5][4]			= "not.png|120"
$ImageFiles[6][0]			= "network.png|10"
$ImageFiles[6][1]			= "lost.png|10"
$ImageFiles[7][0]			= "dank.png|120"
$ImageFiles[7][1]			= "new.png|120"
$ImageFiles[7][2]			= "game.png|20"
$ImageFiles[7][3]			= "portal.png|120"
$ImageFiles[7][4]			= "login.png|5"
$ImageFiles[7][5]			= "merchant.png|20"
$ImageFiles[7][6]			= "stash.png|20"

$SoundFiles[0]				= "legendary.wav"
$SoundFiles[1]				= "set.wav"
$SoundFiles[2]				= "rare.wav"
$SoundFiles[3]				= "magic.wav"
$SoundFiles[4]				= "tome.wav"
$SoundFiles[5]				= "gem.wav"

$CharHitBox[0] 				= 790
$CharHitBox[1] 				= 315
$CharHitBox[2] 				= 1200
$CharHitBox[3] 				= 730

$LoginButtonSearchArea[0]	= 930
$LoginButtonSearchArea[1]	= 845
$LoginButtonSearchArea[2]	= 985
$LoginButtonSearchArea[3]	= 860

$ResumeButtonSearchArea[0]	= 250
$ResumeButtonSearchArea[1]	= 410
$ResumeButtonSearchArea[2]	= 310
$ResumeButtonSearchArea[3]	= 425

$PortalIconSearchArea[0]	= 1095
$PortalIconSearchArea[1]	= 1000
$PortalIconSearchArea[2]	= 1140
$PortalIconSearchArea[3]	= 1060

$CellarNameSearchArea[0]	= 1760
$CellarNameSearchArea[1]	= 10
$CellarNameSearchArea[2]	= 1820
$CellarNameSearchArea[3]	= 30

$TownNameSearchArea[0]		= 1745
$TownNameSearchArea[1]		= 10
$TownNameSearchArea[2]		= 1795
$TownNameSearchArea[3]		= 30

$MerchStashSearchArea[0]	= 225
$MerchStashSearchArea[1]	= 30
$MerchStashSearchArea[2]	= 300
$MerchStashSearchArea[3]	= 115

$MonsterSearchArea[0] 		= 170
$MonsterSearchArea[1] 		= 65
$MonsterSearchArea[2] 		= 1270
$MonsterSearchArea[3] 		= 470

$FullBagSearchArea[0]		= 795
$FullBagSearchArea[1]		= 125
$FullBagSearchArea[2]		= 830
$FullBagSearchArea[3]		= 160

$SellItemsArea[0]			= 1460
$SellItemsArea[1]			= 585
$SellItemsArea[2]			= 1900
$SellItemsArea[3]			= 875

$FullStashSearchArea[0]		= 700
$FullStashSearchArea[1]		= 135
$FullStashSearchArea[2]		= 730
$FullStashSearchArea[3]		= 155

$RepairSearchArea[0] 		= 1507
$RepairSearchArea[1] 		= 36
$RepairSearchArea[2] 		= 1512
$RepairSearchArea[3] 		= 41

$DeathSearchArea[0] 		= 538
$DeathSearchArea[1] 		= 335
$DeathSearchArea[2] 		= 542
$DeathSearchArea[3] 		= 339

$DisconnectSearchArea[0]	= 840
$DisconnectSearchArea[1]	= 410
$DisconnectSearchArea[2]	= 950
$DisconnectSearchArea[3]	= 440

$CellarOffset 				= 33

$RareLootAttempts			= 0
$MagicLootAttempts			= 0
$TomeLootAttempts 			= 0
$GemLootAttempts 			= 0

$StartTime 					= @HOUR & ":" & @MIN
$Runs						= 0
$Closed						= 0
$Runtime					= "0h 0m 0s"
$Disconnects				= 0
$Deaths						= 0

$Legendaries				= 0
$Sets						= 0
$Rares						= 0
$Magics						= 0
$Gems						= 0
$Tomes						= 0
$Sold						= 0

$ISx						= 0
$ISy						= 0
$StashBag					= 1
$Alive						= True
$DisconnectState 			= 0
$FullBag 					= False

$LootingAreaWidth			= $LootingArea[2] - $LootingArea[0]
$LootingAreaHeight			= $LootingArea[3] - $LootingArea[1]

ScriptStarted()
Bot()

Func Bot()
   While WinActive('Diablo III')
	  Randomize()
	  ResumeGame()
	  MoveToCellar()
	  EnterCellar()
	  MoveInCellar()
	  UseSkills()
	  KillSarkoth()
	  LootGold()
	  LootItems()
	  TeleportToTown()
	  
	  If $Repair Then
		 RepairItems()
	  EndIf
	  
	  LeaveGame()
   WEnd
EndFunc


;Routine
Func ResumeGame()
   InGameLobby()
   
   ToLog("Resuming game...")
   MouseClick('LEFT', $ResumeButton[0], $ResumeButton[1], 1, 5)
   
   InGameplayScreen()
EndFunc

Func MoveToCellar()
   ToLog("Starting run...")
   $Runs+=1
   RefreshStats()
   
   Sleep(200 + $Computerlag)
   Send("{2}")
   Sleep(200 + $Computerlag)
   
   ToLog("Moving to cellar - 1")
   Move($MoveToCellar1[0], $MoveToCellar1[1])
   Sleep(1400 + $MoveDelay)
   
   Send("{4}")
   Sleep(500)
   
   ToLog("Moving to cellar - 2")
   Move($MoveToCellar2[0], $MoveToCellar2[1]) 
   Sleep(2150 + $MoveDelay)
   
   ToLog("Moving to cellar - 3")
   Move($MoveToCellar3[0], $MoveToCellar3[1])
   Sleep(1250 + $MoveDelay)
EndFunc

Func EnterCellar()
   MouseMove($CellarLocation[0], $CellarLocation[1], 5)
   Sleep(400 + $ComputerLag)
   
   $CellarPixel = PixelSearch($CellarLocation[0]-$CellarOffset, $CellarLocation[1]-$CellarOffset, $CellarLocation[0]+4, $CellarLocation[1]+4, 0x334FB7, 6)
   If @error Then
	  ToLog("Cellar is closed")
	  $Closed+=1
	  RefreshStats()
	  TeleportToTown()
	  LeaveGame()
   EndIf
   
   ToLog("Entering cellar...")
   MouseClick('LEFT', $CellarLocation[0], $CellarLocation[1], 1, 5)
   InCellar()
EndFunc

Func MoveInCellar()
   ToLog("Moving in cellar - 1")
   Move($MoveInCellar1[0], $MoveInCellar1[1])
   Sleep(2250 + $MoveDelay)
   
   ToLog("Moving in cellar - 2")
   Move($MoveInCellar2[0], $MoveInCellar2[1])
   Sleep(1260 + $MoveDelay)
   
   MouseMove($MonsterLocation[0],$MonsterLocation[1], 5)
   Sleep(150 + $Computerlag)
EndFunc
   
Func UseSkills()
   ToLog("Using skills...")
   Send("{1}")
   Sleep(400 + $Computerlag)
   
   Send("{3}")
   Sleep(400 + $Computerlag)
   
   MouseClick('RIGHT')
   Sleep(250 + $Computerlag)
EndFunc
   
Func KillSarkoth()
   ToLog("Kill Sarkoth...")
   While 1
	  $MonsterBar = PixelSearch($MonsterSearchArea[0], $MonsterSearchArea[1], $MonsterSearchArea[2], $MonsterSearchArea[3], 0xEE0000, 10)
	  If @error Then
		 Attack($MonsterLocation[0],$MonsterLocation[1])
		 Sleep(850)
		 
		 $MonsterBar =  PixelSearch($MonsterSearchArea[0], $MonsterSearchArea[1], $MonsterSearchArea[2], $MonsterSearchArea[3], 0xEE0000, 10)
		 If @error Then
			ExitLoop
		 EndIf
	  EndIf
	  
	  Attack($MonsterBar[0], $MonsterBar[1])
	  Sleep(100)
   WEnd
   ToLog("All monsters are dead")
EndFunc

Func LootGold()
   ToLog("Looting gold...")
   If $HighGoldRadius = False Then
	  Move($MoveToGoldLoot1a[0], $MoveToGoldLoot1a[1])
	  Sleep(1500 + $MoveDelay)
	  AttackNearbyMonsters()
	  
	  Move($MoveToGoldLoot2[0], $MoveToGoldLoot2[1])
	  Sleep(1500 + $MoveDelay)
	  AttackNearbyMonsters()
	  
	  Move($MoveToGoldLoot3[0], $MoveToGoldLoot3[1])
	  Sleep(1500 + $MoveDelay)
	  AttackNearbyMonsters()
   Else
	  Move($MoveToGoldLoot1b[0], $MoveToGoldLoot1b[1])
	  Sleep(1500 + $MoveDelay)
	  AttackNearbyMonsters()
   EndIf
   
   MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
   Sleep(100)
EndFunc

Func LootItems()
   If $LootSets Then
	  LootSets()
   EndIf
   
   If $LootLegendaries Then
	  LootLegendaries()
   EndIf
   
   If $LootRares Then
	  LootRares()
	  $RareLootAttempts = 0
   EndIf
   
   If $LootMagics Then
	  LootMagics()
	  $MagicLootAttempts = 0
   Else
	  If $LootTomes Then
		 LootTomes()
		 $TomesLootAttempts = 0
	  EndIf
   EndIf
   
   If $LootGems Then
	  LootGems()
	  $GemLootAttempts = 0
   EndIf
   
   CheckForDeath()
EndFunc
   
Func TeleportToTown()
   ToLog("Teleporting to town...")
   Sleep(500)
   Send("{t}")
   InTown()
EndFunc


;Loot
Func LootLegendaries() 
   ToLog("Searching for legendaries...")
   For $gI = 0 to 4
	  $Array = StringSplit($ImageFiles[0][$gI],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
	  
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ToLog("Legendary found")
		 $Legendaries+=1
		 RefreshStats()
		 
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[0], 0)
		 EndIf
		 
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(800 + $LootDelay)
		 
		 MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
		 Sleep(100)
		 
		 If $Sell = True Then
			CheckBagFull()
			If $FullBag = True Then
			   $FullBag = False
			   Sleep(300)
			   LootLegendaries()
			EndIf
		 EndIf
		 ExitLoop
	  EndIf
   Next
EndFunc

Func LootSets()
   ToLog("Searching for sets...")
   For $gI = 0 to 4
	  $Array = StringSplit($ImageFiles[1][$gI],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
	  
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ToLog("Set found")
		 $Sets+=1
		 RefreshStats()
		 
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[1], 0)
		 EndIf
		 
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(800 + $LootDelay)
		 
		 MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
		 Sleep(100)
		 
		 If $Sell = True Then
			CheckBagFull()
			If $FullBag = True Then
			   $FullBag = False
			   Sleep(300)
			   LootSets()
			EndIf
		 EndIf
		 ExitLoop
	  EndIf
   Next	 
EndFunc

Func LootRares()
   ToLog("Searching for rares... " & $RareLootAttempts+1)
   For $gI = 0 to 4
	  $Array = StringSplit($ImageFiles[2][$gI],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
	  
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ToLog("Rare found")
		 $Rares+=1
		 RefreshStats()
		 
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[2], 0)
		 EndIf
		 
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(700 + $LootDelay)
		 
		 MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
		 Sleep(100)
		 
		 If $Sell = True Then
			CheckBagFull()
			If $FullBag = True Then
			   $FullBag = False
			   Sleep(300)
			   LootRares()
			EndIf
		 EndIf
		 ExitLoop
	  EndIf
   Next
   
   $RareLootAttempts+=1		
   
   If($RareLootAttempts >= $RareLootAmount) Then 
	  Return
   Else
	  LootRares()
   EndIf
EndFunc

Func LootMagics()
   ToLog("Searching for magics... " & $MagicLootAttempts+1)
   For $gI = 0 to 4
	  $Array = StringSplit($ImageFiles[3][$gI],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
	  
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ToLog("Magic found")
		 $Magics+=1
		 RefreshStats()
		 
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[3], 0)
		 EndIf
		 
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(700 + $LootDelay)
		 
		 MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
		 Sleep(100)
		 
		 If $Sell = True Then
			CheckBagFull()
			If $FullBag = True Then
			   $FullBag = False
			   Sleep(300)
			   LootMagics()
			EndIf
		 EndIf
		 ExitLoop
	  EndIf
   Next
   
   $MagicLootAttempts+=1
   
   If($MagicLootAttempts >= $MagicLootAmount) Then 
	  Return
   Else
	  LootMagics()
   EndIf
EndFunc

Func LootTomes()
   ToLog("Searching for Tomes of Secrets... " & $TomeLootAttempts+1)
   $Array = StringSplit($ImageFiles[4][0],"|")
   $File = $Array[1]
   $Accuracy = $Array[2]
   
   $Target = _ImageSearchArea($ImgDir & $File, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $Accuracy)
   If $Target = 1 Then
	  ToLog("Tome of Secrets found")
	  $Tomes+=1
	  RefreshStats()
	  
	  If $Sounds = True Then
		 SoundPlay($SoundsDir & $SoundFiles[4], 0)
	  EndIf
	  
	  MouseClick("LEFT", $ISx, $ISy, 1, 4)
	  Sleep(700 + $LootDelay)
	  
	  MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
	  Sleep(100)
	  
	  If $Sell = True Then
		 CheckBagFull()
		 If $FullBag = True Then
			$FullBag = False
			Sleep(300)
			LootTomes()
		 EndIf
	  EndIf
   EndIf
   
   $TomeLootAttempts+=1
   
   If($TomeLootAttempts >= $TomeLootAmount) Then 
	  Return
   Else
	  LootTomes()
   EndIf
EndFunc
   
Func LootGems()
   ToLog("Searching for gems... " & $GemLootAttempts+1)
   $Array = StringSplit($ImageFiles[4][1],"|")
   $File = $Array[1]
   $Accuracy = $Array[2]
   
   $Target = _ImageSearchArea($ImgDir & $File, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $Accuracy)
   If $Target = 1 Then
	  ToLog("Gem found")
	  $Gems+=1
	  RefreshStats()
	  
	  If $Sounds = True Then
		 SoundPlay($SoundsDir & $SoundFiles[5], 0)
	  EndIf
	  
	  MouseClick("LEFT", $ISx, $ISy, 1, 4)
	  Sleep(700 + $LootDelay)
	  
	  MouseMove(Random(100, 140, 1), Random(100, 140, 1), 3)
	  Sleep(100)
	  
	  If $Sell = True Then
		 CheckBagFull()
		 If $FullBag = True Then
			$FullBag = False
			Sleep(300)
			LootGems()
		 EndIf
	  EndIf
   EndIf
   
   $GemLootAttempts+=1
   
   If($GemLootAttempts >= $GemLootAmount) Then 
	  Return
   Else
	  LootGems()
   EndIf
EndFunc


;Sell, store and repair
Func CheckBagFull()
   $Array = StringSplit($ImageFiles[5][0],"|")
   $File = $Array[1]
   $Accuracy = $Array[2]
   
   $Target = _ImageSearchArea($ImgDir & $File, 1, $FullBagSearchArea[0], $FullBagSearchArea[1], $FullBagSearchArea[2], $FullBagSearchArea[3], $ISx, $ISy, $Accuracy)
   If $Target = 1 Then
	  ToLog("Our bag is full")
	  $FullBag = True
	  SellItems()
   EndIf
EndFunc

Func SellItems()   
   TeleportToTown()
   MoveToMerchant()
   
   ToLog("Selling...")
   
   $Count = 0
   
   For $gI = 1 to 3
	  $Array = StringSplit($ImageFiles[5][$gI],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
	  
	  For $i = 30 To 0 step -1
		 $Target = _ImageSearchArea($ImgDir & $File, 1, $SellItemsArea[0], $SellItemsArea[1], $SellItemsArea[2], $SellItemsArea[3], $ISx, $ISy, $Accuracy)
		 If $Target = 1 Then
			$Count+=1
			$Sold+=1
			RefreshStats()
			
			MouseClick("RIGHT", $ISx, $ISy, 1, 2)
			Sleep(150)
		 EndIf
	  Next
   Next
   
   ToLog("Selling... done - Sold " & $Count & " items!")
   
   $RareLootAttempts	= 0
   $MagicLootAttempts	= 0
   $TomeLootAttempts 	= 0
   $GemLootAttempts 	= 0
   
   MoveToStash()
      
   Sleep(300 & $ComputerLag)
   
   MouseClick("LEFT", $PortalLocation[0], $PortalLocation[1], 1, 10)
   InCellar()
EndFunc

Func PutInStash()   
   ToLog("Storing items in the stash...")
  
   While UBOUND($Stash) > 0
	  $r = Random(0, UBOUND($Stash)-1, 1)
		 
	  MouseClick("RIGHT", $Stash[$r][0], $Stash[$r][1], 1, 0)
		 
	  Sleep(75)
	  If Not CheckStashFull() = 1 Then
		 _ArrayDelete($Stash, $r)
	  EndIf
		 
	  If $UseStash = False Then
		 ExitLoop
	  EndIf
	  $r+=1		 
   WEnd
   
   ToLog("Storing items in the stash... done")
EndFunc

Func CheckStashFull()
   $Array = StringSplit($ImageFiles[5][4],"|")
   $File = $Array[1]
   $Accuracy = $Array[2]
   
   $Target = _ImageSearchArea($ImgDir & $File, 1, $FullStashSearchArea[0], $FullStashSearchArea[1], $FullStashSearchArea[2], $FullStashSearchArea[3], $ISx, $ISy, $Accuracy)
   If $Target = 1 Then
	  Switch $StashBag
		 Case 1
			ToLog("First stashbag is full - changing...")
			Sleep(200)
			MouseClick("LEFT", $StashBag2[0], $StashBag2[1], 1, 5)
			$StashBag = 2
			Sleep(5000)
		 Case 2
			ToLog("Second stashbag is full - changing...")
			Sleep(200)
			MouseClick("LEFT", $StashBag3[0], $StashBag3[1], 1, 5)
			$StashBag = 3
			Sleep(5000)
		 Case 3
			ToLog("Third stashbag is full - aborting...")
			$UseStash = False
	  EndSwitch
	  Return 1
   EndIf
   Return 0
EndFunc

Func RepairItems()
   If Not CheckForRepair() Then
	  Return
   EndIf
   
   MoveToMerchant()
   
   ToLog("Repairing...")
   MouseClick('LEFT', $RepairButton[0], $RepairButton[1], 1, 5)
   Sleep(500)
   
   MouseClick('LEFT', $AllItemsButton[0], $AllItemsButton[1], 1, 5)
   Sleep(500)
   
   Send("{ESC}")
   ToLog("Repairing... done")
EndFunc

Func CheckForRepair()
   $RepairNeeded = PixelSearch($RepairSearchArea[0], $RepairSearchArea[1], $RepairSearchArea[2], $RepairSearchArea[3], 0xFFE801, 10)
   If Not @error Then
	  ToLog("We need to repair")
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func MoveToMerchant()
   Sleep(500)
   ToLog("Waiting to get to the merchant...")
   
   ToLog("Moving to merchant - 1")
   Move($MoveToMerchant[0] , $MoveToMerchant[1])
   Sleep(3500 + $MoveDelay)
   
   ToLog("Moving to merchant - 2")
   MouseClick('LEFT', $MerchantLocation[0], $MerchantLocation[1], 1, 10)
   
   AtMerchant()
EndFunc

Func MoveToStash()
   ToLog("Waiting to get to the stash...")
   
   ToLog("Moving to stash - 1")
   Move($MoveToStash1[0] , $MoveToStash1[1])
   Sleep(2050 + $MoveDelay)
   
   ToLog("Moving to stash - 2")
   Move($MoveToStash2[0] , $MoveToStash2[1])
   Sleep(2650 + $MoveDelay)
   
   If $UseStash = True Then
	  $StashBag = 1
	  MouseClick("LEFT", $StashLocation[0], $StashLocation[1], 1, 10)
	  AtStash()
	  PutInStash()
	  Sleep(200)
	  Send("{ESC}")
   EndIf
EndFunc


;Check gamestate, disconnect and death
Func InLoginScreen()
   ToLog("Waiting to get into the login screen...")
   
   While 1
	  $Array = StringSplit($ImageFiles[7][4],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $LoginButtonSearchArea[0], $LoginButtonSearchArea[1], $LoginButtonSearchArea[2], $LoginButtonSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ExitLoop
	  Else
		 Sleep(350)
	  EndIf
   WEnd  
EndFunc

Func InGameLobby()
   ToLog("Waiting to get into the game lobby...")
   
   While 1
	  $Array = StringSplit($ImageFiles[7][2],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $ResumeButtonSearchArea[0], $ResumeButtonSearchArea[1], $ResumeButtonSearchArea[2], $ResumeButtonSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ExitLoop
	  Else
		 CheckForDeath()
		 Sleep(200)
		 CheckForDisconnect()
		 Sleep(350)
	  EndIf
   WEnd  
EndFunc

Func InGameplayScreen()
   ToLog("Waiting to get into the game...")
   
   While 1
	  $Array = StringSplit($ImageFiles[7][3],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $PortalIconSearchArea[0], $PortalIconSearchArea[1], $PortalIconSearchArea[2], $PortalIconSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 $Alive = True
		 $DisconnectState = 0
		 ExitLoop
	  Else
		 CheckForDeath()
		 Sleep(200)
		 CheckForDisconnect()
		 Sleep(200)
	  EndIf
   WEnd  
EndFunc

Func InCellar()
   ToLog("Waiting to get into the cellar...")
   $TimeOutTimer = TimerInit()
   
   While 1
	  $Array = StringSplit($ImageFiles[7][0],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $CellarNameSearchArea[0], $CellarNameSearchArea[1], $CellarNameSearchArea[2], $CellarNameSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ExitLoop
	  Else
		 If Floor(TimerDiff($TimeOutTimer) / 1000) >= $TimeOut Then
			ToLog("TimeOut - Leaving")
			LeaveGame()
		 EndIf
		 CheckForDeath()
		 Sleep(200)
		 CheckForDisconnect()
		 Sleep(200)
	  EndIf
   WEnd
EndFunc

Func InTown()
   ToLog("Waiting to get into the town...")
   $TimeOutTimer = TimerInit()
   
   While 1
	  $Array = StringSplit($ImageFiles[7][1],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $TownNameSearchArea[0], $TownNameSearchArea[1], $TownNameSearchArea[2], $TownNameSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ExitLoop
	  Else
		 If Floor(TimerDiff($TimeOutTimer) / 1000) >= $TimeOut Then
			ToLog("TimeOut - Trying to teleport again")
			TeleportToTown()
		 EndIf
		 CheckForDeath()
		 Sleep(200)
		 CheckForDisconnect()
		 Sleep(200)
	  EndIf
   WEnd   
EndFunc

Func AtMerchant()
   $TimeOutTimer = TimerInit()
   
   While 1
	  $Array = StringSplit($ImageFiles[7][5],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $MerchStashSearchArea[0], $MerchStashSearchArea[1], $MerchStashSearchArea[2], $MerchStashSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ExitLoop
	  Else
		 If Floor(TimerDiff($TimeOutTimer) / 1000) >= $TimeOut Then
			ToLog("TimeOut - Leaving")
			LeaveGame()
		 EndIf
		 CheckForDeath()
		 Sleep(200)
		 CheckForDisconnect()
		 Sleep(200)
	  EndIf
   WEnd   
EndFunc

Func AtStash()
   $TimeOutTimer = TimerInit()
   
   While 1
	  $Array = StringSplit($ImageFiles[7][6],"|")
	  $File = $Array[1]
	  $Accuracy = $Array[2]
   
	  $Target = _ImageSearchArea($ImgDir & $File, 1, $MerchStashSearchArea[0], $MerchStashSearchArea[1], $MerchStashSearchArea[2], $MerchStashSearchArea[3], $ISx, $ISy, $Accuracy)
	  If $Target = 1 Then
		 ExitLoop
	  Else
		 If Floor(TimerDiff($TimeOutTimer) / 1000) >= $TimeOut Then
			ToLog("TimeOut - Leaving")
			LeaveGame()
		 EndIf
		 CheckForDeath()
		 Sleep(200)
		 CheckForDisconnect()
		 Sleep(200)
	  EndIf
   WEnd   
EndFunc

Func CheckForDisconnect()
   $Array = StringSplit($ImageFiles[6][0],"|")
   $File = $Array[1]
   $Accuracy = $Array[2]
   
   $Target = _ImageSearchArea($ImgDir & $File, 1, $DisconnectSearchArea[0], $DisconnectSearchArea[1], $DisconnectSearchArea[2], $DisconnectSearchArea[3], $ISx, $ISy, $Accuracy)
   If $Target = 1 Then
	  ToLog("We got disconnected")
	  $Disconnects+=1
	  RefreshStats()
	  $DisconnectState = 1
	  
	  MouseClick("LEFT", $DisconnectButton[0], $DisconnectButton[1], 1, 5)
	  InGameLobby()
   EndIf
   
   $Array = StringSplit($ImageFiles[6][1],"|")
   $File = $Array[1]
   $Accuracy = $Array[2]
   
   $Target = _ImageSearchArea($ImgDir & $File, 1, $DisconnectSearchArea[0], $DisconnectSearchArea[1], $DisconnectSearchArea[2], $DisconnectSearchArea[3], $ISx, $ISy, 10)
   If $Target = 1 Then
	  ToLog("We got... totally disconnected")
	  If $DisconnectState = 0 Then
		 $Disconnects+=1
		 RefreshStats()
	  EndIf
	  $DisconnectState = 2
	  
	  MouseClick("LEFT", $DisconnectButton[0], $DisconnectButton[1], 1, 5)
	  InLoginScreen()	
   EndIf
   
   If $DisconnectState = 2 Then
	  If $UseRelogging = True Then
		 Relog()
	  Else
		 Terminate()
	  EndIf
   EndIf
EndFunc 

Func CheckForDeath()
   If $Alive = True Then
	  $Death = PixelSearch($DeathSearchArea[0], $DeathSearchArea[1], $DeathSearchArea[2], $DeathSearchArea[3], 0xFFFFFF) 
	  If Not @error Then
		 $Alive = False
		 ToLog("We are dead... :(")
		 $Deaths+=1
		 RefreshStats()
		 LeaveGame()
	  EndIf
   EndIf
EndFunc


;Miscellaneous
Func ScriptStarted()
   Pause()
   
   $RuntimeTimer = TimerInit()
   
   If $ShowLootArea = True Then
	  DrawLootArea()	
   EndIf
   
   If $ShowLog = True Then
	  $Log = FileOpen($SaveLogsPath & "log.txt", 1)
	  DrawLog()
   EndIf
   
   If $ShowLog = True Or $SaveStats = True Then
	  DirGetSize($SaveLogsPath)
	  If @error= 1 Then
		 DirCreate($SaveLogsPath)
	  EndIf	  
   EndIf
   
   ToLog("Bot started")
   
   WinActivate('Diablo III')   
EndFunc

Func Pause()
   ToLog("Paused...")
   $Paused = Not $Paused
   
   While $Paused
      Sleep(100)
	  ToolTip('Paused... Press {PAUSE} to continue...', 850, 0)
   WEnd
   
   ToolTip("")
EndFunc

Func Randomize()
   Global $Stash[54][2]
   $c = 0
   $d = -2
   For $a = 0 to 53
	  $d+=1
	  If $a = 9 or $a = 18 or $a = 27 or $a = 36 or $a = 45 Then
		 $c+=1
		 $d=-1
	  EndIf
	  For $b = 0 to 1
		 If $b = 0 Then
			$Stash[$a][$b] = Random(1522, 1532, 1) + (49 * $d)
		 Else
			$Stash[$a][$b] = Random(606, 614, 1) + (49 * $c)
		 EndIf
	  Next
   Next
   
   $MoveToCellar1[0]		= Random(498, 503, 1)
   $MoveToCellar1[1]		= Random(248, 253, 1)
   $MoveToCellar2[0]		= Random(1, 4, 1)
   $MoveToCellar2[1]		= Random(368, 373, 1)
   $MoveToCellar3[0]		= Random(398, 403, 1)
   $MoveToCellar3[1]		= Random(598, 603, 1)	

   $MoveInCellar1[0]		= Random(114, 119, 1)
   $MoveInCellar1[1]		= Random(984, 989, 1)			
   $MoveInCellar2[0]		= Random(774, 779, 1)
   $MoveInCellar2[1]		= Random(326, 331, 1)

   $MoveToGoldLoot1a[0] 	= Random(400, 405, 1)
   $MoveToGoldLoot1a[1] 	= Random(304, 309, 1)
   $MoveToGoldLoot1b[0] 	= Random(575, 580, 1)
   $MoveToGoldLoot1b[1] 	= Random(304, 309, 1)
   $MoveToGoldLoot2[0] 		= Random(1258, 1263, 1)
   $MoveToGoldLoot2[1] 		= Random(349, 354, 1)
   $MoveToGoldLoot3[0] 		= Random(909, 914, 1)
   $MoveToGoldLoot3[1] 		= Random(692, 697, 1)

   $MoveToMerchant[0] 		= Random(1688, 1693, 1)
   $MoveToMerchant[1] 		= Random(100, 105, 1)

   $MoveToStash1[0]			= Random(778, 783, 1)
   $MoveToStash1[1]			= Random(948, 953, 1)
   $MoveToStash2[0]			= Random(268, 273, 1)
   $MoveToStash2[1]			= Random(928, 933, 1)

   $CellarLocation[0] 		= Random(305, 309, 1)
   $CellarLocation[1] 		= Random(72, 76, 1)

   $MonsterLocation[0] 		= Random(575, 580, 1)
   $MonsterLocation[1] 		= Random(181, 186, 1)

   $MerchantLocation[0]		= Random(928, 933, 1)
   $MerchantLocation[1]		= Random(134, 139, 1)

   $StashLocation[0]		= Random(803, 808, 1)
   $StashLocation[1]		= Random(428, 433, 1)

   $PortalLocation[0]		= Random(648, 653, 1)
   $PortalLocation[1]		= Random(498, 503, 1)

   $StashBag2[0]			= Random(508, 513, 1)
   $StashBag2[1]			= Random(358, 363, 1)

   $StashBag3[0]			= Random(508, 513, 1)
   $StashBag3[1]			= Random(488, 493, 1)

   $RepairButton[0] 		= Random(515, 520, 1)
   $RepairButton[1] 		= Random(481, 486, 1)

   $AllItemsButton[0] 		= Random(221, 226, 1)
   $AllItemsButton[1] 		= Random(590, 595, 1)
   
   $PasswordField[0]		= Random(818, 823, 1)
   $PasswordField[1]		= Random(703, 708, 1)

   $ResumeButton[0] 		= Random(317, 322, 1)
   $ResumeButton[1] 		= Random(414, 419, 1)

   $LeaveButton[0] 			= Random(967, 972, 1)
   $LeaveButton[1] 			= Random(580, 584, 1)

   $DisconnectButton[0]		= Random(958, 963, 1)
   $DisconnectButton[1]		= Random(628, 633, 1)
EndFunc

Func DrawLootArea()
   $LootAreaGUI = GUICreate("", $LootingAreaWidth + 2, $LootingAreaHeight + 2, $LootingArea[0], $LootingArea[1], $WS_POPUP, BitOR($WS_EX_LAYERED, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TRANSPARENT)))
   GuiSetBkColor(0xABCDEF)
   _WinAPI_SetLayeredWindowAttributes($LootAreaGUI, 0xABCDEF, 0xA0)
   WinSetOnTop($LootAreaGUI, "", 1)
   GuiSetState()
   $hDC = _WinAPI_GetWindowDC($LootAreaGUI)
   $hPen = _WinAPI_CreatePen($PS_SOLID, 2, 0x0000FF)
   $obj_orig = _WinAPI_SelectObject($hDC, $hPen)
   $user32_dll = DllOpen("user32.dll")
   _WinAPI_DrawLine($hDC, 0, 1, $LootingAreaWidth, 0)
   _WinAPI_DrawLine($hDC, 1, 0, 0, $LootingAreaHeight)
   _WinAPI_DrawLine($hDC, $LootingAreaWidth, $LootingAreaHeight, $LootingAreaWidth, 0)
   _WinAPI_DrawLine($hDC, $LootingAreaWidth, $LootingAreaHeight, 0, $LootingAreaHeight)
   
   _WinAPI_SetTextColor($hDC, 0x0000FF)
   _WinAPI_SetBkMode($hDC, $TRANSPARENT)
   
   $tRECT = DllStructCreate($tagRect)
   DllStructSetData($tRECT, "Left", 5)
   DllStructSetData($tRECT, "Top", 5)
   DllStructSetData($tRECT, "Right", 250)
   DllStructSetData($tRECT, "Bottom", 50)
   
   _WinAPI_DrawText($hDC, "Loot Area", $tRect, 0)
EndFunc

Func DrawLog()
   $Width = 475
   $Height = 200
   $LogGUI = GUICreate("", $Width, $Height, 1920 - $Width - 5, 1080 - $Height - 5, $WS_POPUPWINDOW, BitOR($WS_EX_LAYERED, BitOr($WS_EX_TOOLWINDOW, $WS_EX_TRANSPARENT)))
   GuiSetBkColor(0x000000)
   _WinAPI_SetLayeredWindowAttributes($LogGUI, 0xEEEEEF, 0xEE) ;0xA0
   WinSetOnTop($LogGUI, "", 1)
   GuiSetState()
   
   $Label = GUICtrlCreateLabel("", 0, 10, $Width, 100, $SS_CENTER)
   GUICtrlSetFont($Label, 8, 500, 0, "")
   GuiCtrlSetColor($Label, 0xFFFFFF)
   
   $LogList = GUICtrlCreateList("", 5, 60, $Width - 10, $Height - 60, $LBS_NOSEL)
   GUICtrlSetColor($LogList, 0x000000)
   GUICtrlSetFont($LogList, 8)
   
   RefreshStats()
EndFunc

Func RefreshStats()
   If $ShowLog = True Then
	  GUICtrlSetData($Label, "Start: " & $StartTime & "  |  Runs: " & $Runs & "  |  Closed:  " & $Closed & "  |  Deaths: " & $Deaths & "  |  Disconnects: " & $Disconnects & @LF & @LF & "Legendaries: " & $Legendaries & "  |  Sets: " & $Sets & "  |  Rares: " & $Rares & "  |  Magics: " & $Magics & "  |  Tomes: " & $Tomes & "  |  Gems: " & $Gems & "  |  Sold: " & $Sold)
   EndIf
EndFunc

Func ToLog($Text)
   If $ShowLog = True Then
	  GUICtrlSetData($LogList, "<" & @Hour & ":" & @MIN & ":" & @SEC & "> " & $Text)
	  GUICtrlSendMsg($LogList, $WM_VSCROLL, $SB_LINEDOWN, 0)
   
	  FileWriteLine($Log, "<" & @Hour & ":" & @MIN & ":" & @SEC & "> " & $Text)
	  If $Text = "Bot closed" Then
		 FileWriteLine($Log, @LF)  
	  EndIf
   EndIf
EndFunc

Func Relog()
   ToLog("Relogging...")
   MouseClick("LEFT", $PasswordField[0], $PasswordField[1], 1, 5)
   Send($Password)
   
   Sleep(1000 + $Computerlag)
   Send("{ENTER}")
   
   $DisconnectState = 0
   Bot()
EndFunc

Func SaveStats()
   $File = FileOpen($SaveLogsPath & "statistics.txt", 1)
   FileWriteLine($File, "=========" & @HOUR & ":" & @MIN & ":" & @SEC & "=========")
   FileWriteLine($File, "Startime: " & @TAB & @TAB & $StartTime & @LF & "Runs: " & @TAB & @TAB & $Runs & @LF & "Closed: " & @TAB & @TAB & $Closed & @LF & "Deaths: " & @TAB & @TAB & $Deaths & @LF & "Disconnects: " & @TAB & $Disconnects & @LF & "Runtime: " & @TAB & @TAB & $Runtime & @LF & @LF & "Legendaries: " & @TAB & $Legendaries & @LF & "Sets: " & @TAB & @TAB & $Sets & @LF & "Rares: " & @TAB & @TAB & $Rares & @LF & "Magics: " & @TAB & @TAB & $Magics & @LF & "Tomes: " & @TAB & @TAB & $Tomes & @LF & "Gems: " & @TAB & @TAB & $Gems & @LF & "Sold: " & @TAB & @TAB & $Sold)
   FileWriteLine($File, @LF)
   FileClose($File)
EndFunc

Func Move($x, $y)
   MouseClick('MIDDLE', $x, $y, 1, 5)
EndFunc

Func Attack($x, $y)
   Send("{SHIFTDOWN}")
   MouseClick('LEFT', $x, $y, 1, 2)
   Send("{SHIFTUP}")
EndFunc	

Func AttackNearbyMonsters()
   While 1
	  $MonsterData =  PixelSearch($CharHitBox[0], $CharHitBox[1], $CharHitBox[2], $CharHitBox[3], 0xEE0000, 10)
	  If @error Then
		 ExitLoop
	  EndIf
	  ToLog("Maybe not all monsters are dead...")
	  Send("{4}")
	  Sleep(300)
	  
	  For $i = 10 To 0 step -1
		 Attack($MonsterData[0], $MonsterData[1])
		 Sleep(150)
	  Next
	  ToLog("Hopefully now...")
   WEnd
EndFunc

Func LeaveGame()
   If $SaveStats = True Then
	  SaveStats()
   EndIf
   ToLog("Leaving the game")
   $Sek 	= Floor(TimerDiff($RuntimeTimer) / 1000)
   $Min 	= Floor($Sek / 60)
   $Hour 	= Floor($Min / 60)
   $Runtime = $Hour & "h " & ($Min - $Hour * 60) & "m " & ($Sek - $Min * 60) & "s"
      
   Sleep(1000 + $ComputerLag)
   
   Send("{ESC}")
   Sleep(200)
   
   MouseClick('LEFT', $LeaveButton[0], $LeaveButton[1], 1, 5)
   Sleep(1250 + $Computerlag)
   
   Bot()
EndFunc	

Func Terminate()
   ToLog("Terminating... Good bye :)")
   SaveStats()
   Exit 0
EndFunc

Func _ImageSearchArea($FindImage,$ResultPosition,$x1,$y1,$right,$bottom,ByRef $x, ByRef $y, $Tolerance)
	If $Tolerance > 0 Then $FindImage = "*" & $Tolerance & " " & $FindImage
	   
	If @AutoItX64 Then
		 $Result = DllCall("ImageSearchDLL_x64.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$FindImage)
	  Else
		 $Result = DllCall("ImageSearchDLL.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$FindImage)
	  EndIf
	  
   If $Result = "0" Then Return 0
	  
   $Array = StringSplit($Result[0],"|")
   
   If(UBound($Array) >= 4) Then
	  $x=Int(Number($Array[2]))
	  $y=Int(Number($Array[3]))
	  
	  If $ResultPosition=1 Then
		 $x=$x + Int(Number($Array[4])/2)
		 $y=$y + Int(Number($Array[5])/2)
	  Endif
	  Return 1
   EndIf
EndFunc

Func OnAutoItExit()
   ToLog("Bot closed")
EndFunc