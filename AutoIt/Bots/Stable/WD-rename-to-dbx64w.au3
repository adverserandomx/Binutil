#include <WindowsConstants.au3>
#include <Misc.au3>
#Include <WinAPI.au3>

#cs

   [Gold/Itemfarming] [AutoIt] Sarkoth Act I Dank Cellar [WD] [Stash, Sell, Repair, +++]
									by zEEneXx
								 
								  Version: 1.0e
							   
								 www.ownedcore.com
				  
#ce

Global $ImageFiles[6][5]
Global $SoundFiles[6]
Global $PasswordField[2]
Global $ResumeButton[2]
Global $LeaveButton[2]
Global $PartyLeaveButton[2]
Global $DisconnectButton[2]
Global $GameLobbyCode[3]
Global $GameScreenCode[3]
Global $MoveToCellar1[2]
Global $MoveToCellar2[2]
Global $MoveToCellar3[2]
Global $MoveInCellar1[2]
Global $MoveInCellar2[2]
Global $MoveToGoldLoot1[2]			
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
Global $Paused

Global $LocalSessionTimer ; used to measure session times
Global $SuccessfulSession = False ; set to true when we find cellar
Global $AvgCellarTime = 0
Global $AvgFailedTime = 0
Global $SessionSek = 0 ; measure this session in seconds


;///////////////////////////////////////--CONFIG--////////////////////////////////////////////////////////////////////////////////
;																																//
;										Important																				//
$ComputerLag		= 100										;Increase this in steps of 400 if you have slow loading times	//
$MoveDelay			= 100											;Increase this in steps of 100 if you have movement issues		//
$LootDelay			= 0											;Increase this in steps of 200 if you have looting issues		//
$ImgDir				= "C:\D3\AutoIt\WD\pics\"	;Location of the image folder									//
;																																//
;									    Functions																				//
$Repair				= True										;Orders the bot to repair when items are damaged				//
$Sell				= True										;Orders the bot to sell magic items when bag is full			//
$UseStash			= True										;Orders the bot to put gems and rare items into the stash		//
$HighGoldRadius		= True										;Set this to true if you have more than +18 gold radius			//
;																																//
;								   	  Miscellaneous																				//
$Sounds				= True										;Enable pickup sounds											//
$SoundsDir			= "C:\D3\AutoIt\WD\sounds\"	;Location of the sounds folder									//
$ShowLootArea		= True										;Shows lootarea													//
$ShowStatTooltip	= True										;Shows statistics from current session							//
$SaveStats			= True										;Saves current statistics to a *.txt file						//
$SaveStatsPath		= "C:\D3\AutoIt\WD\logs\"	;Folder to save the statistics in								//
;																																//
;									   Relogging																				//									
$UseRelogging		= True										;Enable Relogging												//
$Password			= "letmein68$"								;Your password													//
;																																//
;																																//
;									     Looting																				//
$LootLegendaries	= True										;Loot legendary items											//
$LootSets			= True										;Loot set items													//
$LootRares			= True										;Loot rare items												//
$LootMagics			= False										;Loot magic items (includes tomes)								//
$LootTomes			= False									;Loot tomes														//
$LootGems			= False										;Loot gems														//
;																																//
;	   <<<Changes below have an significant impact on the needed time for one run>>>											//
;																																//
$RareLootAmount		= 1											;Amount of rare items to loot									//
$MagicLootAmount	= 3											;Amount of magic items to loot (including tomes)				//
$TomeLootAmount 	= 1											;Amount of tomes to loot										//
$GemLootAmount 		= 0											;Amount of gems to loot											//
;

$LootingArea[0] 	= 570										;Left	(lower -> bigger) 										//
$LootingArea[1] 	= 185										;Top	(lower -> bigger)										//
$LootingArea[2] 	= 1375										;Right	(higher -> bigger)										//
$LootingArea[3] 	= 720										;Bot	(higher -> bigger)										//
;$LootingArea[0] 	= 500										;Left	(lower -> bigger) 										//
;$LootingArea[1] 	= 100										;Top	(lower -> bigger)										//
;$LootingArea[2] 	= 1500										;Right	(higher -> bigger)										//
;$LootingArea[3] 	= 900										;Bot	(higher -> bigger)										//
;																																//
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
$ImageFiles[0][0] 			= "legendaryA.png|70"
$ImageFiles[0][1] 			= "legendaryE.png|70"
$ImageFiles[0][2] 			= "legendaryI.png|70"
$ImageFiles[0][3] 			= "legendaryO.png|70"
$ImageFiles[0][4] 			= "legendaryU.png|70"
$ImageFiles[1][0] 			= "setA.png|90"
$ImageFiles[1][1] 			= "setE.png|90"
$ImageFiles[1][2] 			= "setU.png|90"
$ImageFiles[1][3]			= "setO.png|90"
$ImageFiles[1][4]			= "setI.png|90"
$ImageFiles[2][0] 			= "rareA.png|95"
$ImageFiles[2][1] 			= "rareE.png|95"
$ImageFiles[2][2] 			= "rareI.png|95"
$ImageFiles[2][3] 			= "rareO.png|95"
$ImageFiles[2][4] 			= "rareU.png|95"
$ImageFiles[3][0] 			= "blueA.png|70"
$ImageFiles[3][1] 			= "blueE.png|70"
$ImageFiles[3][2] 			= "blueI.png|70"
$ImageFiles[3][3] 			= "blueO.png|70"
$ImageFiles[3][4] 			= "blueU.png|70"
$ImageFiles[4][0] 			= "tome.png|140"
$ImageFiles[4][1] 			= "uare.png|110"
$ImageFiles[5][0]			= "you.png|100"
$ImageFiles[5][1]			= "sellNew.png|55"
$ImageFiles[5][2]			= "sell1x1.png|20"
$ImageFiles[5][3]			= "sell1x2.png|20"
$ImageFiles[5][4]			= "not.png|120"

$SoundFiles[0]				= "legendary.wav"
$SoundFiles[1]				= "set.wav"
$SoundFiles[2]				= "rare.wav"
$SoundFiles[3]				= "magic.wav"
$SoundFiles[4]				= "tome.wav"
$SoundFiles[5]				= "gem.wav"

$PasswordField[0]			= 820
$PasswordField[1]			= 705

$ResumeButton[0] 			= 319
$ResumeButton[1] 			= 416

$LeaveButton[0] 			= 969
$LeaveButton[1] 			= 582

$PartyLeaveButton[0]  		= 743
$PartyLeaveButton[1]		= 630

$DisconnectButton[0]		= 960
$DisconnectButton[1]		= 630

$GameLobbyCode[0] 			= 319
$GameLobbyCode[1]			= 416
$GameLobbyCode[2] 			= 4065536

$GameScreenCode[0] 			= 1119
$GameScreenCode[1] 			= 1044
$GameScreenCode[2] 			= 0xDEFDFE 

$MoveToCellar1[0]			= 500
$MoveToCellar1[1]			= 250
$MoveToCellar2[0]			= 1
$MoveToCellar2[1]			= 370
$MoveToCellar3[0]			= 365 ;400
$MoveToCellar3[1]			= 600 ;600	

$MoveInCellar1[0]			= 116
$MoveInCellar1[1]			= 986			
$MoveInCellar2[0]			= 776
$MoveInCellar2[1]			= 328

$MoveToGoldLoot1[0] 		= 577
$MoveToGoldLoot1[1] 		= 306
$MoveToGoldLoot2[0] 		= 1260
$MoveToGoldLoot2[1] 		= 351
$MoveToGoldLoot3[0] 		= 911
$MoveToGoldLoot3[1] 		= 694

$MoveToMerchant[0] 			= 1690
$MoveToMerchant[1] 			= 102

$MoveToStash1[0]			= 780
$MoveToStash1[1]			= 950
$MoveToStash2[0]			= 270
$MoveToStash2[1]			= 930

$CellarLocation[0] 			= 333; 307
$CellarLocation[1] 			= 77; 74

$MonsterLocation[0] 		= 577
$MonsterLocation[1] 		= 183

$MerchantLocation[0]		= 930
$MerchantLocation[1]		= 136

$StashLocation[0]			= 805
$StashLocation[1]			= 430

$PortalLocation[0]			= 650
$PortalLocation[1]			= 500

$CharHitBox[0] 				= 790
$CharHitBox[1] 				= 315
$CharHitBox[2] 				= 1200
$CharHitBox[3] 				= 730

$MonsterSearchArea[0] 		= 150
$MonsterSearchArea[1] 		= 20
$MonsterSearchArea[2] 		= 1248
$MonsterSearchArea[3] 		= 446

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

$StashBag2[0]				= 510
$StashBag2[1]				= 360

$StashBag3[0]				= 510
$StashBag3[1]				= 490

$RepairButton[0] 			= 517
$RepairButton[1] 			= 483

$AllItemsButton[0] 			= 223
$AllItemsButton[1] 			= 592

$CellarOffset 				= 33

$RareLootAttempts			= 0
$MagicLootAttempts			= 0
$TomeLootAttempts 			= 0
$GemLootAttempts 			= 0

$StartTime 					= @HOUR & ":" & @MIN & " Uhr"
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
$DisconnectState 			= 0
$FullBag 					= False

$LootingAreaWidth			= $LootingArea[2] - $LootingArea[0]
$LootingAreaHeight			= $LootingArea[3] - $LootingArea[1]

If $ShowLootArea = True Then
   DrawLootArea()	
EndIf	 

Opt('MouseCoordMode', 2)
Opt('PixelCoordMode', 2)

HotKeySet('{=}', 'Pause')
HotKeySet('{-}', 'Terminate')

Pause()
$Timer = TimerInit()



If $ShowStatTooltip = True Then
   PrintToolTip()
   ;ToolTip("Start: " & $StartTime & "  |  Runs: " & $Runs & "  |  Closed:  " & $Closed & "  |  Deaths: " & $Deaths & "  |  Disconnects: " & $Disconnects & "  |  Runtime: " & $Runtime & "  |  Legendaries: " & $Legendaries & "  |  Sets: " & $Sets & "  |  Rares: " & $Rares & "  |  Magics: " & $Magics & "  |  Tomes: " & $Tomes & "  |  Gems: " & $Gems & "  |  Sold: " & $Sold, 530, 0)
EndIf

WinActivate('Diablo III')
While 1
   If WinActive('Diablo III') Then 
    
	  While $DisconnectState < 2
	  For $i = 18 To 0 step -1
		 If InGameLobby() Then
			ExitLoop
		 EndIf
		 
		 Sleep(600)
		 If $i == 1 Then
			CheckForDisconnectState()
			Sleep(2000 + $Computerlag)
		 EndIf
	  Next
	  
	  if $SaveStats = True Then
		 SaveStats()
	  EndIf
	  
	  MouseClick('LEFT', $ResumeButton[0], $ResumeButton[1], 1, 5)
	  Sleep(1250 + $Computerlag)
      
	  
	  For $i = 20 To 0 step -1
		 If InGameplayScreen() Then
			$DisconnectState = 0
			ExitLoop
		 EndIf
		 
		 Sleep(500)
		 If $i == 1 Then
			;ConsoleWrite("In 2nd loop")
			CheckForDisconnectState()
			Sleep(2000 + $Computerlag)
		 EndIf
	  Next
	  
	 
	  If $DisconnectState = 2 Then
		 If $UseRelogging = True Then
			Relog()
		 Else
			Terminate()
		 EndIf
	  Else
		 If $DisconnectState = 0 Then
			ExitLoop
		 EndIf
	  EndIf
	  
	  WEnd
	  
	  $LocalSessionTimer = TimerInit()
	  Sleep(200 + $Computerlag)
	  Send("{2}")
	  Sleep(200 + $Computerlag)
	  
	  Move($MoveToCellar1[0], $MoveToCellar1[1])
	  Sleep(150 + $MoveDelay)
	  Send("{4}") ;spirit walkf
	  Sleep(500)
	  Move($MoveToCellar2[0], $MoveToCellar2[1]) 
	  Sleep(550 + $MoveDelay)
	  ;Pause()
	  Move($MoveToCellar3[0], $MoveToCellar3[1])
	  
	  MouseMove($CellarLocation[0], $CellarLocation[1], 1)
	  Sleep(800 + $MoveDelay)
	  
      $CellarPixel = PixelSearch($CellarLocation[0]-$CellarOffset, $CellarLocation[1]-$CellarOffset, $CellarLocation[0]+4, $CellarLocation[1]+4, 0x334FB7, 6)
	  If @error Then
		 Sleep(200 + $Computerlag)
		 MouseClick('RIGHT')
		 Sleep(400 + $Computerlag)
		 $Closed+=1
		 $SuccessfulSession = False
		 Send("{t}")
		 Sleep(6500 + $Computerlag)
		 LeaveGame()
		 ContinueLoop
	  EndIf
	  
	  MouseClick('LEFT', $CellarLocation[0], $CellarLocation[1], 1, 5)
      Sleep(4000 + $Computerlag)
	  
	  If CheckForDeath() Then
		 ContinueLoop
	  EndIf
	   
	  Move($MoveInCellar1[0], $MoveInCellar1[1])
	  Sleep(1000 + $MoveDelay)
	  Move($MoveInCellar2[0], $MoveInCellar2[1])
	  Sleep(10 + $MoveDelay)
	  MouseMove($MonsterLocation[0],$MonsterLocation[1], 5)
	  Sleep(150 + $Computerlag)

	  Send("{1}")
	  Sleep(200 + $Computerlag)
	  MouseClick('RIGHT')
	  Sleep(400 + $Computerlag)
	  Send("{3}")
	  Sleep(150 + $Computerlag)
	  
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
		 
	
		 For $i = 7 To 0 step -1
			Attack($MonsterBar[0], $MonsterBar[1])
			Sleep(100)
			   
		  Next
	  WEnd
	  
	  If $HighGoldRadius = True Then
		 Move($MoveToGoldLoot1[0], $MoveToGoldLoot1[1])
		 Sleep(250 + $MoveDelay)
		 AttackNearbyMonsters()
	  Else
		 Move(402, 306)
		 Sleep(250 + $MoveDelay)
		 AttackNearbyMonsters()
		 Move($MoveToGoldLoot2[0], $MoveToGoldLoot2[1])
		 Sleep(250 + $MoveDelay)
		 AttackNearbyMonsters()
		 Move($MoveToGoldLoot3[0], $MoveToGoldLoot3[1])
		 Sleep(250 + $MoveDelay)
		 AttackNearbyMonsters()
	  EndIf
	  
	  MouseMove(120, 120, 3)
	  Sleep(100)
	  
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
	  
	  If CheckForDeath() Then
		 ContinueLoop
	  EndIf
	  ;HACK: Final quick move just to loot an extra crap Hack just for my character
	  Move($MoveToGoldLoot3[0], $MoveToGoldLoot3[1])
	  $SuccessfulSession = True
	  
	  Sleep(500)
	  Send("{t}")
	  Sleep(7000 + $Computerlag)
	  
	  If $Repair Then
		 RepairItems()
	  EndIf
	  
	  LeaveGame()
	  Sleep(1000 + $Computerlag)
   EndIf
WEnd


;Loot
Func LootLegendaries()
   For $gI = 0 to 4
	  $array = StringSplit($ImageFiles[0][$gI],"|")
	  $file = $array[1]
	  $accuracy = $array[2]
   
	  $target = _ImageSearchArea($ImgDir & $file, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $accuracy)
	  If $target = 1 Then
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[0], 0)
		 EndIf
		 $Legendaries+=1
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(800 + $LootDelay)
		 MouseMove(120, 120, 3)
		 Sleep(100)
		 If $Sell = True Then
			CheckBagFull()
			If $FullBag = True Then
			$FullBag = False
			Sleep(300)
			LootLegendaries()
			EndIf
		 EndIf
	  EndIf
   Next
EndFunc

Func LootSets()
   For $gI = 0 to 4
	  $array = StringSplit($ImageFiles[1][$gI],"|")
	  $file = $array[1]
	  $accuracy = $array[2]
   
	  $target = _ImageSearchArea($ImgDir & $file, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $accuracy)
	  If $target = 1 Then
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[1], 0)
		 EndIf
		 $Sets+=1
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(800 + $LootDelay)
		 MouseMove(120, 120, 3)
		 Sleep(100)
		 If $Sell = True Then
			CheckBagFull()
			If $FullBag = True Then
			   $FullBag = False
			   Sleep(300)
			   LootSets()
			EndIf
		 EndIf
	  EndIf
   Next	 
EndFunc

Func LootRares()
   For $gI = 0 to 4
	  $array = StringSplit($ImageFiles[2][$gI],"|")
	  $file = $array[1]
	  $accuracy = $array[2]
   
	  $target = _ImageSearchArea($ImgDir & $file, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $accuracy)
	  If $target = 1 Then
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[2], 0)
		 EndIf
		 $Rares+=1
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(700 + $LootDelay)
		 MouseMove(120, 120, 3)
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
   For $gI = 0 to 4
	  $array = StringSplit($ImageFiles[3][$gI],"|")
	  $file = $array[1]
	  $accuracy = $array[2]
   
	  $target = _ImageSearchArea($ImgDir & $file, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $accuracy)
	  If $target = 1 Then
		 ConsoleWrite("Found Magic item!")
		 If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[3], 0)
		 EndIf
		 $Magics+=1
		 MouseClick("LEFT", $ISx, $ISy, 1, 4)
		 Sleep(700 + $LootDelay)
		 MouseMove(120, 120, 3)
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
   $array = StringSplit($ImageFiles[4][0],"|")
   $file = $array[1]
   $accuracy = $array[2]
   
   $target = _ImageSearchArea($ImgDir & $file, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $accuracy)
   If $target = 1 Then
	  If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[4], 0)
		 EndIf
	  $Tomes+=1
	  MouseClick("LEFT", $ISx, $ISy, 1, 4)
	  Sleep(700 + $LootDelay)
	  MouseMove(120, 120, 3)
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
   $array = StringSplit($ImageFiles[4][1],"|")
   $file = $array[1]
   $accuracy = $array[2]
   
   $target = _ImageSearchArea($ImgDir & $file, 1, $LootingArea[0], $LootingArea[1], $LootingArea[2], $LootingArea[3], $ISx, $ISy, $accuracy)
   If $target = 1 Then
	  If $Sounds = True Then
			SoundPlay($SoundsDir & $SoundFiles[5], 0)
		 EndIf
	  $Gems+=1
	  MouseClick("LEFT", $ISx, $ISy, 1, 4)
	  Sleep(700 + $LootDelay)
	  MouseMove(120, 120, 3)
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
   $array = StringSplit($ImageFiles[5][0],"|")
   $file = $array[1]
   $accuracy = $array[2]
   
   $target = _ImageSearchArea($ImgDir & $file, 1, $FullBagSearchArea[0], $FullBagSearchArea[1], $FullBagSearchArea[2], $FullBagSearchArea[3], $ISx, $ISy, $accuracy)
   If $target = 1 Then
	  $FullBag = True
	  SellItems()
   EndIf
EndFunc

Func SellItems()
   Sleep(750)
   Send("{t}")
   Sleep(7000 + $Computerlag)
   Move($MoveToMerchant[0] , $MoveToMerchant[1])
   Sleep(2500 + $MoveDelay)
   MouseClick('LEFT', $MerchantLocation[0], $MerchantLocation[1], 1, 10)
   Sleep(2250 + $MoveDelay)
   
   For $gI = 1 to 3
	  $array = StringSplit($ImageFiles[5][$gI],"|")
	  $file = $array[1]
	  $accuracy = $array[2]

	  For $i = 40 To 0 step -1
		 $target = _ImageSearchArea($ImgDir & $file, 1, $SellItemsArea[0], $SellItemsArea[1], $SellItemsArea[2], $SellItemsArea[3], $ISx, $ISy, $accuracy)
		 If $target = 1 Then
			$Sold+=1
			MouseClick("RIGHT", $ISx, $ISy, 1, 0)
			Sleep(250)
		 EndIf
	  Next
   Next
   
   $RareLootAttempts	= 0
   $MagicLootAttempts	= 0
   $TomeLootAttempts 	= 0
   $GemLootAttempts 	= 0
   
   Move($MoveToStash1[0] , $MoveToStash1[1])
   Sleep(800 + $MoveDelay)
   Move($MoveToStash2[0] , $MoveToStash2[1])
   Sleep(1200 + $MoveDelay)
   If $UseStash = True Then
	  $StashBag = 1
	  ToStash()
	  Sleep(200)
	  Send("{ESC}")
   EndIf
   Sleep(700)
   MouseClick("LEFT", $PortalLocation[0], $PortalLocation[1], 1, 10)
   Sleep(3000 + $Computerlag)
EndFunc

Func ToStash() 
   Sleep(300)
   MouseClick("LEFT", $StashLocation[0], $StashLocation[1], 1, 10)
   Sleep(500)
   
   For $x = 0 to 5 step + 1
	  $xC = 1527
	  For $i = -1 To 8 step + 1
		 MouseClick("RIGHT", $xC + ($i*47), 610 + ($x*50), 1, 0)
		 Sleep(25)
		 If CheckStashFull() = 1 Then
			if($i>0) Then
			   $xC-=47
			EndIf
			$i-=1
		 EndIf
		 If $UseStash = False Then
			ExitLoop (2)
		 EndIf
	  Next
   Next
EndFunc

Func CheckStashFull()
   $array = StringSplit($ImageFiles[5][4],"|")
   $file = $array[1]
   $accuracy = $array[2]
   
   $target = _ImageSearchArea($ImgDir & $file, 1, $FullStashSearchArea[0], $FullStashSearchArea[1], $FullStashSearchArea[2], $FullStashSearchArea[3], $ISx, $ISy, $accuracy)
   If $target = 1 Then
	  Switch $StashBag
	  Case 1
		 Sleep(200)
		 MouseClick("LEFT", $StashBag2[0], $StashBag2[1], 1, 5)
		 $StashBag = 2
		 Sleep(5000)
	  Case 2
		 Sleep(200)
		 MouseClick("LEFT", $StashBag3[0], $StashBag3[1], 1, 5)
		 $StashBag = 3
		 Sleep(5000)
	  Case 3
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
   Move($MoveToMerchant[0] , $MoveToMerchant[1])
   Sleep(2500 + $MoveDelay)
   MouseClick('LEFT', $MerchantLocation[0], $MerchantLocation[1], 1, 10)
   Sleep(2500 + $MoveDelay)
   MouseClick('LEFT', $RepairButton[0], $RepairButton[1], 1, 5)
   Sleep(500)
   MouseClick('LEFT', $AllItemsButton[0], $AllItemsButton[1], 1, 5)
   Sleep(500)
   Send("{ESC}")
EndFunc

Func CheckForRepair()
   $RepairNeeded = PixelSearch($RepairSearchArea[0], $RepairSearchArea[1], $RepairSearchArea[2], $RepairSearchArea[3], 0xFFE801,10)
   If Not @error Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc


;Check gamestate, death and disconnect 
Func InGameLobby()
	PixelSearch($GameLobbyCode[0], $GameLobbyCode[1], $GameLobbyCode[0]+10, $GameLobbyCode[1]+10, $GameLobbyCode[2], 10)
    If Not @error Then
	   Return True
	Else
	   Return False
   EndIf
EndFunc

Func InGameplayScreen()
	PixelSearch($GameScreenCode[0], $GameScreenCode[1], $GameScreenCode[0]+4, $GameScreenCode[1]+3, $GameScreenCode[2], 10)
	If Not @error Then
	   Return True
	Else
	   Return False
   EndIf
EndFunc

Func CheckForDeath()
   $Death = PixelSearch($DeathSearchArea[0], $DeathSearchArea[1], $DeathSearchArea[2], $DeathSearchArea[3], 0xFFFFFF) 
   If Not @error Then
	  $Deaths+=1
	  LeaveGame()
	  Sleep(12000 + $Computerlag)
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func CheckForDisconnectState()
   $target = _ImageSearchArea($ImgDir & "network.png", 1, $DisconnectSearchArea[0], $DisconnectSearchArea[1], $DisconnectSearchArea[2], $DisconnectSearchArea[3], $ISx, $ISy, 10)
   If $target = 1 Then
	  $Disconnects+=1
	  $DisconnectState = 1
	  MouseClick("LEFT", $DisconnectButton[0], $DisconnectButton[1], 1, 5)
	  Sleep(3000 + $Computerlag)
   EndIf
   
   $target = _ImageSearchArea($ImgDir & "lost.png", 1, $DisconnectSearchArea[0], $DisconnectSearchArea[1], $DisconnectSearchArea[2], $DisconnectSearchArea[3], $ISx, $ISy, 10)
   If $target = 1 Then
	  If $DisconnectState = 0 Then
		 $Disconnects+=1
	  EndIf
	  $DisconnectState = 2
	  MouseClick("LEFT", $DisconnectButton[0], $DisconnectButton[1], 1, 5)
	  Sleep(3000 + $Computerlag)	
   EndIf
EndFunc 

Func Relog()
   MouseClick("LEFT", $PasswordField[0], $PasswordField[1], 1, 5)
   Send($Password)
   Sleep(1000 + $Computerlag)
   Send("{ENTER}")
   Sleep(8000 + $Computerlag)
   $DisconnectState = 0
EndFunc


;Miscellaneous
Func AttackNearbyMonsters()
   While 1
	  $MonsterData =  PixelSearch($CharHitBox[0], $CharHitBox[1], $CharHitBox[2], $CharHitBox[3], 0xEE0000, 10)
	  If @error Then
		 ExitLoop
	  EndIf
	  Send("{4}")
	  Sleep(300)
	  For $i = 10 To 0 step -1
		 Attack($MonsterData[0], $MonsterData[1])
		 Sleep(150)
	  Next
   WEnd
EndFunc

Func Attack($x, $y)
   Send("{SHIFTDOWN}")
   MouseClick('LEFT', Random($x - 3, $x + 3), Random($y - 3, $y + 3), 1, 0)
   Send("{SHIFTUP}")
EndFunc	

Func Move($x, $y)
   MouseClick('MIDDLE', $x, $y, 1, 5)
   Sleep(1250)
EndFunc

Func SaveStats()
   DirGetSize($SaveStatsPath)
   If @error= 1 Then
	  DirCreate($SaveStatsPath)
   EndIf
   $File = FileOpen($SaveStatsPath & "statistics.txt", 2)
   FileWriteLine($File, "=========" & @HOUR & ":" & @MIN & ":" & @SEC & "=========")
   FileWriteLine($File, "Startime: " & @TAB & @TAB & $StartTime & @LF & "Runs: " & @TAB & @TAB & $Runs & @LF & "Closed: " & @TAB & @TAB & $Closed & @LF & "Deaths: " & @TAB & @TAB & $Deaths & @LF & "Disconnects: " & @TAB & $Disconnects & @LF & "Runtime: " & @TAB & @TAB & $Runtime & @LF & @LF & "Legendaries: " & @TAB & $Legendaries & @LF & "Sets: " & @TAB & @TAB & $Sets & @LF & "Rares: " & @TAB & @TAB & $Rares & @LF & "Magics: " & @TAB & @TAB & $Magics & @LF & "Tomes: " & @TAB & @TAB & $Tomes & @LF & "Gems: " & @TAB & @TAB & $Gems & @LF & "Sold: " & @TAB & @TAB & $Sold)
   FileClose($File)
EndFunc

Func DrawLootArea()
   $hFullScreen = WinGetHandle("Program Manager")
   $hGUI = GUICreate("", $LootingAreaWidth + 2, $LootingAreaHeight + 2, $LootingArea[0], $LootingArea[1], $WS_POPUP, BitOR($WS_EX_LAYERED,$WS_EX_TRANSPARENT))
   GuiSetBkColor(0xABCDEF)
   _WinAPI_SetLayeredWindowAttributes($hGUI, 0xABCDEF, 0xA0)
   WinSetOnTop($hGUI, "", 1)
   GuiSetState()
   $hDC = _WinAPI_GetWindowDC($hGUI)
   $hPen = _WinAPI_CreatePen($PS_SOLID, 2, 0x0000FF)
   $obj_orig = _WinAPI_SelectObject($hDC, $hPen)
   $user32_dll = DllOpen("user32.dll")
   _WinAPI_DrawLine($hDC, 0, 1, $LootingAreaWidth, 0)
   _WinAPI_DrawLine($hDC, 1, 0, 0, $LootingAreaHeight)
   _WinAPI_DrawLine($hDC, $LootingAreaWidth, $LootingAreaHeight, $LootingAreaWidth, 0)
   _WinAPI_DrawLine($hDC, $LootingAreaWidth, $LootingAreaHeight, 0, $LootingAreaHeight)
EndFunc



Func LeaveGame()
   $Runs+=1
   $Sek 	= Floor(TimerDIff($Timer) / 1000)
   $Min 	= Floor($Sek / 60)
   $Hour 	= Floor($Min / 60)
   $Runtime = $Hour & "h " & ($Min-$Hour*60) & "m " & ($Sek-$Min*60) & "s"
   
   $SessionSek = Floor(TimerDiff($LocalSessionTimer) / 1000)
   if $SuccessfulSession Then
	  $CellarCount = $Runs - $Closed
	  $AvgCellarTime = Floor((($AvgCellarTime * ($CellarCount - 1)) + $SessionSek) / $CellarCount)
   Else
	  $AvgFailedTime = Floor((($AvgFailedTime * ($Closed - 1)) + $SessionSek) / $Closed)
   EndIf
   
   If $ShowStatTooltip = True Then
	  PrintToolTip()
	  ;ToolTip("Start: " & $StartTime & "  |  Runs: " & $Runs & "(" & $AverageSuccessfulSessionTime & ")  |  Closed:  " & $Closed & " (" & $AverageFailedSessionTime & ")  |  Deaths: " & $Deaths & "  |  Disconnects: " & $Disconnects & "  |  Runtime: " & $Runtime & "  |  Legendaries: " & $Legendaries & "  |  Sets: " & $Sets & "  |  Rares: " & $Rares & "  |  Magics: " & $Magics & "  |  Tomes: " & $Tomes & "  |  Gems: " & $Gems & "  |  Sold: " & $Sold, 530, 0)
   EndIf
   Send("{ESC}")
   Sleep(200)
   MouseClick('LEFT', $LeaveButton[0], $LeaveButton[1], 1, 5)
   Sleep(100) ;add in case we are leeching
   MouseClick('LEFT', $PartyLeaveButton[0], $PartyLeaveButton[1], 1, 1)
   Sleep(1250 + $Computerlag)
EndFunc	
 
Func Pause()
   $Paused = Not $Paused
   While $Paused
      Sleep(100)
	  ToolTip('Paused... Press {=} to continue or {-} to exit...', 850, 0)
   WEnd
   If $ShowStatTooltip = True Then
	  PrintToolTip()
	  ;ToolTip("Start: " & $StartTime & "  |  Runs: " & $Runs & "  |  Closed:  " & $Closed & "  |  Deaths: " & $Deaths & "  |  Disconnects: " & $Disconnects & "  |  Runtime: " & $Runtime & "  |  Legendaries: " & $Legendaries & "  |  Sets: " & $Sets & "  |  Rares: " & $Rares & "  |  Magics: " & $Magics & "  |  Tomes: " & $Tomes & "  |  Gems: " & $Gems & "  |  Sold: " & $Sold, 530, 0)
   Else
	  ToolTip("")
   EndIf
EndFunc

Func PrintToolTip()
   ToolTip("Start: " & $StartTime & " (" & $SessionSek & ")  |  Runs: " & $Runs & " (" & $AvgCellarTime & ")  |  Closed:  " & $Closed & " (" & $AvgFailedTime & ")  |  Deaths: " & $Deaths & "  |  Disconnects: " & $Disconnects & "  |  Runtime: " & $Runtime & "  |  Legendaries: " & $Legendaries & "  |  Sets: " & $Sets & "  |  Rares: " & $Rares & "  |  Magics: " & $Magics & "  |  Tomes: " & $Tomes & "  |  Gems: " & $Gems & "  |  Sold: " & $Sold, 530, 0)
EndFunc

Func Terminate()
   SaveStats()
   Exit 0
EndFunc

Func _ImageSearchArea($findImage,$resultPosition,$x1,$y1,$right,$bottom,ByRef $x, ByRef $y, $tolerance)
	If $tolerance>0 Then $findImage = "*" & $tolerance & " " & $findImage
	
	If @AutoItX64 Then
		 $result = DllCall("ImageSearchDLL_x64.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$findImage)
	  Else
		 $result = DllCall("ImageSearchDLL.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$findImage)
   EndIf
	
    If $result = "0" Then Return 0

   $array = StringSplit($result[0],"|")
   If(UBound($array) >= 4) Then
	  $x=Int(Number($array[2]))
	  $y=Int(Number($array[3]))
	  If $resultPosition=1 Then
		 $x=$x + Int(Number($array[4])/2)
		 $y=$y + Int(Number($array[5])/2)
	  Endif
	  Return 1
   EndIf
EndFunc