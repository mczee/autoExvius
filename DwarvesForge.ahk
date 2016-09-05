------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

;SetMouseDelay, 25
;SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen


; While CapsLock is toggled On
; Script will display Mouse Position (coordinates) as a tooltip at Top-Left corner of screen.
; Also allows to copy them (to clipboard) with a PrintScreen button.

settimer start1, 0 ;"0" to make it update position instantly
return

start1:
if !GetKeyState("capslock","T") ; whether capslock is on or off
{
    tooltip ; if off, don't show tooltip at all.
}
else
{ ; if on

 CoordMode, ToolTip, Screen ; makes tooltip to appear at position, relative to screen.
 CoordMode, Mouse, Screen ; makes mouse coordinates to be relative to screen.
 MouseGetPos xx, yy ; get mouse x and y position, store as %xx% and %yy%
 tooltip %xx% %yy%, 0, 0 ; display tooltip of %xx% %yy% at coordinates x0 y0.
 PrintScreen:: ; assign new function to PrintScreen. If pressed...
 clipboard == %xx% %yy% ; ...store %xx% %yy% to clipboard.
 return
}

return

f12::reload ;reloads script if an error occurs

;Primary macro. Press F8 to trigger it. Press F12 to stop it.
;You can re-assign the macro by changing F8 to another valid value.
;Look at AHK help documentation to see what values to use
F8::
{

    ;720000 = 12 minutes.
    ;This assume it will take you 12 minutes to clear
    ;Adjust as needed, but ensure full clear or could break macro
    Timer("ZoneOneClearTime", 720000)
    while (Timer("ZoneOneClearTime") <> true)
    {
		castHealing := false
		combatCycleDone := false
		while (CheckCombatScene())
		{
			
			;limitActive := false
			;Timer("CheckForLimit", 3000)
			;while (Timer("CheckForLimit") <> true)
			;{
				;limitActive := CheckIfLimitIsActive()
				;sleep, 100
			;}
			;if (limitActive = true) {
			;	MsgBox Limit detected!
			;}
			;combatCycleDone := true
			
			if (combatCycleDone = false) {
				QuickSleep()
				;Zidane Steal
					MouseClickDrag, left, 750, 900, 850, 900
					ShortSleep()
					MouseClick, left, 1111, 885
					QuickSleep()
				;Kefka Blizzara
					MouseClickDrag, left, 1050, 785, 1150, 785
					LongSleep()
					MouseClick, left, 800, 880
					QuickSleep()
				;Shantotto Blizzara
					MouseClickDrag, left, 1050, 900, 1150, 900
					LongSleep()
					MouseClickDrag, left, 900, 1000, 900, 800
					QuickSleep()
					MouseClickDrag, left, 900, 1000, 900, 800
					QuickSleep()
					MouseClick, left, 900, 900
					QuickSleep()
				;Krile Cura
				if (castHealing = true) {
					MouseClickDrag, left, 750, 1000, 850, 1000
					ShortSleep()
					MouseClickDrag, left, 900, 1000, 900, 800
					QuickSleep()
					MouseClick, left, 990, 900
					QuickSleep()
					MouseClick, left, 750, 1000
					QuickSleep()
				}
				combatCycleDone := true
				castHealing := true
				MoveDownLeftAndClickAuto() 
			}
			AnimationSleep()
		}
		;MsgBox Combat ended!
		;MoveUpRight()
        ;QuickSleep()
        ;MoveDownLeftAndClickAuto()
        ;QuickSleep()
    }



    ;Timer("Energy", 0)
    ;while (true)
    ;{
    ;    if Timer("Energy")
        {
            ;Set "3900000" to how long you want it to delay in milliseconds
            ;13 energy = 65 minutes = 3900000
            ;Setting the number to zero will drain your energy as fast as it can
            ;Setting the number to 3900000 will preserve your existing energy
    ;        Timer("Energy", 3900000)
    ;        LongSleep()
    ;        EnterExploration()
    ;        CompleteDungeon()
    ;    }
    ;}

}
}


;The following methods are common pixel coordinates used
;Update the values based on your screen resolution
;Inside the MouseClick method update the X and Y coordinates to match the description.

;This coordinate is difficult to get but very important
;Setting this properly will handle the quest complete pop-up
;Value is found by locating the following area:
; **Point over the third banner in the instance selection screen
; **Point slightly above and to the right of your "friends" unit in the depart screen still within the third banners area
; **Point within the cancel box that meets the above criteria
ClickRightSideOfCancelOnQuestScreen()
{
    MouseClick, left, 825, 675
}

;Position of the back button on the instance select screen
ClickBackButton()
{
    MouseClick, left, 687, 257
}

;Position within the exploration banner on the instance select screen
;NOTE: This will also cause your first friend to be select when entering
ClickExplortationInstance()
{
    MouseClick, left, 900, 413
}

;Position inside the depart button
ClickDepartAndNext()
{
    MouseClick, left, 950, 980
}

;Position inside "Ok" box on the cannot connect screen
ClickOkOnCannotConnect()
{
    MouseClick, left, 950, 670
}

;Position near the top of the screen in the middle
MoveUp()
{
    MouseClick, left, 950, 80
}

;Position not quite as close to the top of the screen
;This value is used in the move to second zone function
;If this value is off the transition between zone 1 and 2 can fail.
MoveUpHalfWay()
{
    MouseClick, left, 950, 200
}

;Position just above Rain that causes him to move only one unit forward
MoveUpOneUnit()
{
    MouseClick, left, 950, 500
}


;Position near the bottom of the screen in the middle
MoveDown()
{
    MouseClick, left, 950, 1150
}

;Position near the left of the screen level of Rain
MoveLeft()
{
    MouseClick, left, 650, 550
}

;Position near the right of the screen level with Rain
MoveRight()
{
    MouseClick, left, 1250, 550
}

;Position near the upper right of the screen
MoveUpRight()
{
    MouseClick, left, 1250, 80
}

;Position near the top left of the screen
MoveUpLeft()
{
    MouseClick, left, 650, 80
}

;Position near the lower left that is also over the auto attack on the battle screen
MoveDownLeftAndClickAuto()
{
    MouseClick, left, 650, 1130
}

;Position inside the "yes" to fight, and "leave" instance
ClickFightAndLeave()
{
    MouseClick, left, 1130, 350
}

;Check specified pixels if combat scene is active
CheckCombatScene() {
	;Bar: 670, 670 140008
	;Menu: 1240, 1140 003E9B
    PixelGetColor, checkBar, 670, 670, RGB
	PixelGetColor, checkMenu, 1240, 1140, RGB
	if (checkBar = "0x140008" AND checkMenu = "0x003E9B") {
		return true
	} else {
		return false
	}
}

;Check if Limit pixel is active
CheckIfLimitIsActive() {
	;Kefka: 1227, 790 BB2301
	;Shant: 1230, 903 C72A02
    PixelGetColor, checkKefka, 1227, 790, RGB
	PixelGetColor, checkShant, 1230, 903, RGB
	
	;MsgBox K %checkKefka% S %checkShant%
	
	if (checkKefka = "0xBB2301" AND checkShant = "0xC72A02") {
		return true
	} else {
		return false
	}
}

;Function that selects the exploration and enters it
EnterExploration()
{
    AccountForQuest()
    ClickExplortationInstance()
    LongSleep()
    LongSleep()
    ClickExplortationInstance()
    LongSleep()
    LongSleep()
    ClickDepartAndNext()
    LongSleep()
    LongSleep()
    ClickOkOnCannotConnect()
    LongSleep()
    LongSleep()
}

;Function to account for the completed quest pop up
AccountForQuest()
{
    ClickRightSideOfCancelOnQuestScreen()
    LongSleep()
    LongSleep()
    ClickRightSideOfCancelOnQuestScreen()
    LongSleep()
    LongSleep()
    ClickRightSideOfCancelOnQuestScreen()
    LongSleep()
    LongSleep()
    ClickBackButton()
    LongSleep()
    LongSleep()
    ClickBackButton()
    LongSleep()
    LongSleep()
}

;Function that calls the different "stages" of completing the dungeon
CompleteDungeon()
{
    ;MoveToZoneOne()
    MoveToZoneOneAndGetFirstNode()
    ClearZone()
    MoveToZoneTwo()
    ClearZone()
    MoveToBossRoom()
    FightBoss()
    CollectRewards()
}

;Moves from entrance to zone one
MoveToZoneOne()
{
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    ShortSleep()
}

;Moves to the first node and then to zone one
MoveToZoneOneAndGetFirstNode()
{
    MoveUpRight()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveRight()
    ShortSleep()
    MoveRight()
    ShortSleep()
    MoveDown()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveLeft()
    ShortSleep()
    MoveLeft()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUpLeft()
    ShortSleep()
    ShortSleep()
}

;Moves to zone two once zone once is clear. Picks up node on the way.
MoveToZoneTwo()
{
    MoveDownLeftAndClickAuto()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveRight()
    ShortSleep()
    MoveUpLeft()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    ShortSleep()
    MoveUpOneUnit()
    ShortSleep()
    ShortSleep()
}

;Moves from zone two to the boss room
MoveToBossRoom()
{
    MoveDownLeftAndClickAuto()
    ShortSleep()
    MoveUpRight()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveLeft()
    ShortSleep()
    ;Slightly shortened forward move
    MoveUpHalfWay()
    ShortSleep()
    MoveRight()
    ShortSleep()
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    ShortSleep()
}

;Moves to the boss, engages the fight, completes the fight, and leaves dungeon
FightBoss()
{
    MoveUp()
    ShortSleep()
    MoveUp()
    ShortSleep()
    ClickFightAndLeave()
    ShortSleep()
    LongSleep()
    ClickFightAndLeave()
    LongSleep()
    LongSleep()
    MoveDownLeftAndClickAuto()
    Sleep, 90000
    MoveRight()
    LongSleep()
    LongSleep()
    MoveRight()
    LongSleep()
    LongSleep()
    MoveRight()
    LongSleep()
    LongSleep()

}

;Handles the collection process after the instance is complete
CollectRewards()
{
    LongSleep()
    LongSleep()
    LongSleep()
    LongSleep()
    ;Clicks near next, but not over it. Anywhere on screen is fine
    MouseClick, left, 850, 950
    LongSleep()
    LongSleep()
    ClickDepartAndNext()
    LongSleep()
    LongSleep()
    ClickDepartAndNext()
    LongSleep()
    LongSleep()
    ;Clicks near next, but not over it. Anywhere on screen is fine
    MouseClick, left, 850, 950
    LongSleep()
    LongSleep()
    ClickDepartAndNext()
    LongSleep()
    LongSleep()
}

;Handles clearing a zone once entered. Process is identical for each zone.
;Causes Rain to move in a diagonal pattern which prevents re-zoning
;This function accounts for 24 minutes of the macro run time.
;Assumes that you can clear all fights with just auto attack
ClearZone()
{
    ;720000 = 12 minutes.
    ;This assume it will take you 12 minutes to clear
    ;Adjust as needed, but ensure full clear or could break macro
    Timer("ZoneOneClearTime", 720000)
    while (Timer("ZoneOneClearTime") <> true)
    {
		;Bar: 670, 670 140008
		;Menu: 1240, 1140 003E9B
        CheckBar := PixelGetColor, color, 670, 670, RGB
		CheckMenu := PixelGetColor, color, 1240, 1140, RGB
		while (CheckBar = "0x140008" AND CheckMenu = "0x003E9B")
		{
			QuickSleep()
			MouseClick, left, 750, 770, 0, D
			MouseMove, 850, 770, 50
			MouseClick, left, 850, 770, 0, U
			
		}
		;MoveUpRight()
        ;QuickSleep()
        ;MoveDownLeftAndClickAuto()
        ;QuickSleep()
    }
}

^!z::  ; Control+Alt+Z hotkey.
;MouseGetPos, MouseX, MouseY
PixelGetColor, color, 670, 670, RGB
MsgBox The color at the current cursor position is %color%.
return

;Update the values in these methods to adjust timing
;across the entire macro. Time is measured in milliseconds
;1000 = 1 second
QuickSleep()
{
    sleep, 1000
}

ShortSleep()
{
    sleep, 2000
}

LongSleep()
{
    sleep, 3000
}

AnimationSleep()
{
	sleep, 15000
}

;Code to support arbitrary timers.
;Not my code, but can be used as shown above for other purposes
Timer(Timer_Name := "", Timer_Opt := "D")
{
    static
    global Timer, Timer_Count
    if !Timer
        Timer := {}
    if (Timer_Opt = "U" or Timer_Opt = "Unset")
        if IsObject(Timer[Timer_Name])
        {
            Timer.Remove(Timer_Name)
            Timer_Count --=
            return true
        }
        else
            return false
    if RegExMatch(Timer_Opt,"(\d+)",Timer_Match)
    {
        if !(Timer[Timer_Name,"Start"])
            Timer_Count += 1
        Timer[Timer_Name,"Start"] := A_TickCount
        Timer[Timer_Name,"Finish"] := A_TickCount + Timer_Match1
        Timer[Timer_Name,"Period"] := Timer_Match1
    }
    if RegExMatch(Timer_Opt,"(\D+)",Timer_Match)
        Timer_Opt := Timer_Match1
    else
        Timer_Opt := "D"
    if (Timer_Name = "")
    {
        for index, element in Timer
            Timer(index)
        return
    }
    if (Timer_Opt = "R" or Timer_Opt = "Reset")
    {
        Timer[Timer_Name,"Start"] := A_TickCount
        Timer[Timer_Name,"Finish"] := A_TickCount + Timer[Timer_Name,"Period"]
    }
    Timer[Timer_Name,"Now"] := A_TickCount
    Timer[Timer_Name,"Left"] := Timer[Timer_Name,"Finish"] - Timer[Timer_Name,"Now"]
    Timer[Timer_Name,"Elapse"] := Timer[Timer_Name,"Now"] - Timer[Timer_Name,"Start"]
    Timer[Timer_Name,"Done"] := true
    if (Timer[Timer_Name,"Left"] > 0)
        Timer[Timer_Name,"Done"] := false
    if (Timer_Opt = "D" or Timer_Opt = "Done")
        return Timer[Timer_Name,"Done"]
    if (Timer_Opt = "S" or Timer_Opt = "Start")
        return Timer[Timer_Name,"Start"]
    if (Timer_Opt = "F" or Timer_Opt = "Finish")
        return Timer[Timer_Name,"Finish"]
    if (Timer_Opt = "L" or Timer_Opt = "Left")
        return Timer[Timer_Name,"Left"]
    if (Timer_Opt = "N" or Timer_Opt = "Now")
        return Timer[Timer_Name,"Now"]
    if (Timer_Opt = "P" or Timer_Opt = "Period")
        return Timer[Timer_Name,"Period"]
    if (Timer_Opt = "E" or Timer_Opt = "Elapse")
        return Timer[Timer_Name,"Elapse"]
}