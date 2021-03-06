------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

SetMouseDelay, 25
;SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

;================;
;== CONFIG ME ===;
;================;
x0 := 626
y0 := 72
x1 := 1257
y1 := 1157
; time: 1000 = 1s, 60000 = 1 min
zone1Time := 600000 ; = 10min, 720000 = 12 min
zone2Time := 600000 ; = 10min
estimateTimeToKillBoss := 60000 ; = 1min
delayBetweenMacros := 300000 ; = 30 min, this should be enough to refresh NRG
;Activate combat moves? You need to edit the DoCombat() function!
;If false AUTO will be clicked in combat
activateMoves := false
;How long is your combat animation going to be at max? Kefka LB = 15s
animationTimeout := 15000
;How many encounter per zone are we having this wonderful day?
zoneOneEncounter := 19
zoneTwoEncounter := 14 ;+1 Boss
;================;
;== WELL DONE ===;
;================;

width := x1 - x0
height := y1 - y0

movementSpeed := 500

combatCounter := 0
encounterCounter := 0
runsCompleted := 0
crashCounter := 0

runTimer := 0
timeDisplay := 0

;Coords of the character slots and skills to swipe and click on
cLeftTopX := 0.1
cLeftTopY := 0.65
cLeftMiddleX := 0.1
cLeftMiddleY := 0.75
cLeftBottomX := 0.1
cLeftBottomY := 0.85
cRightTopX := 0.60
cRightTopY := 0.65
cRightMiddleX := 0.60
cRightMiddleY := 0.75
cRightBottomX := 0.60
cRightBottomY := 0.85

;This is the color we want to detect in our CombatScene
;Currently it's the black in the black bar with the enemy health and name in it
colorCombatDetection := "0x18000A"
;Wheres dat black pixel at yo
combatBarX := 0.05
combatBarY := 0.55

;This is the color we want to detect in our CombatScene
;Currently it's the black in the black bar with the enemy health and name in it
colorCombatFinishDetection := "0x002B40"
;Wheres dat black pixel at yo
combatFinishX := 0.50
combatFinishY := 0.50

controlID := 0

; While CapsLock is toggled On
; Script will display Mouse Position (coordinates) as a tooltip at Top-Left corner of screen.
; Also allows to copy them (to clipboard) with a PrintScreen button.

settimer start1, 1000
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
 px := (xx - x0) / width
 py := (yy - y0) / height
 ;tooltip %px% %py%, 0, 0
 global encounterCounter, combatCounter, runsCompleted, crashCounter, runTimer, timeDisplay
 timeDisplay := runTimer.count
 tooltip, %xx% %yy%`n`nEncounter: %encounterCounter%`nCombat: %combatCounter%`nRuns: %runsCompleted%`nCrashed: %crashCounter%`nTimer: %timeDisplay%, 100, 100
 return
}

return

f11::Pause ; Pressing F11 once will pause the script. Pressing it again will unpause.

f12::reload ;reloads script if an error occurs

F10::
{


	global controlID

    MouseGetPos, , , WhichWindow, WhichControl
    ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
	controlID := ahk_id WhichWindow
    MsgBox, %WhichControl% - %controlID%`nX%X%`tY%Y%`nW%W%`t%H%

	
	
	;WinGetClass, class, A
	;MsgBox, The active window's class is "%class%" 
	
	;if WinExist("ahk_class Qt5QWindowIcon")
    ;MsgBox The mouse is over Notepad.

	global controlID
	cX := GetWidth(0.5)
	cY := GetHeight(0.7)
	;ControlClick, x783 y1100, ahk_id %controlID%
	ControlClick, x%cX% y%cY%, ahk_id %controlID%
}


;Primary macro. Press F8 to trigger it. Press F12 to stop it.
;You can re-assign the macro by changing F8 to another valid value.
;Look at AHK help documentation to see what values to use
F8::
{
    while (true)
    {
		runTimer := new SecondCounter
		runTimer.Start()
		LongSleep()
        enterExploration()
		GoToZoneTwo()
        GoToBoss()
        KillBoss()
        exitExploration()
		runTimer.Stop()
        global delayBetweenMacros
        sleep, delayBetweenMacros
    }
	

}

; Debug
F9::
{
        GoToBoss()
        KillBoss()
        exitExploration()
		runTimer.Stop()
}



;^!z::  ; Control+Alt+Z hotkey.
;MouseGetPos, MouseX, MouseY
;PixelGetColor, color, GetWidth(0.5), GetHeight(0.5), RGB
;MsgBox The color at the current cursor position is %color%.
;return


;====================================================================
;= DOCOMBAT ROUTINE - EDIT THIS IF YOU WANT TO EXECUTE COMBAT MOVES =
;====================================================================
ExecuteCombatMoves() {
	;Call the Player function for each of your characters
	;In the brackets goes the skill, ordered like the party
	;left top 1, left middle 2, left bottom 3, right top 4, right middle 5, right bottom 6
	;DO NOT USE SKILL 1 (LIMIT)
	;This does NOT have limit detection yet, don't use click on skill 1, it will break the run
	;Does not feature enemy detection, you can't cast on a specific enemy for now
	;Just mainly for AOE skills/heals/buffs or boss runs
	
	;Syntax: Player<UNIT>(<SKILL>,<TARGET>)
	
	;Examples
	;PlayerOne(2) = Swipe over top left unit (1), click middle left skill (2)
	;PlayerFive(3,5) = Swipe right middle unit (5), click bottom left skill (3), click on player 5 with skill
	
	;Every third encounter tell Lenna to cast Cura
	;if (Mod(encounterCounter, 3) = 0) {
	;	PlayerThree(3,3)
	;}

	;PlayerFour(2)
	;PlayerFive(3)
	;PlayerSix(5,1)

	;Click on AUTO to execute the moves at once
	goBottomLeft()
	;Click twice to deactivate so we can do the next set of moves, deactivate to just let AUTO finish the job
	;goBottomLeft()
}

;=== YOU MIGHT NOT WANT TO EDIT THIS, MAYBE, JUST MAYBE ===
DoCombat() {
	global encounterCounter, combatCounter, activateMoves
	
	if (DetectCombatFinished()) {
		;Check if finish screen is up and click once to exit
		combatCounter := 0
		QuickSleep()
		ClickMouse(0.5, 0.5)
		LongSleep()
		;Lets tell the previous function we are done here
		return true
	} else if (activateMoves = true AND combatCounter = 0) {
		;Check if moves are active and we are in the first round
		combatCounter++
		encounterCounter++
		ExecuteCombatMoves()
		;Lets wait for the animations to finish
		sleep, global animationTimeout
		return false
	} else if (combatCounter = 0) {
		combatCounter++
		encounterCounter++
		;Click AUTO derp
		goBottomLeft()
		LongSleep()
		return false
	}
}
;===================
;= GOOD JOB, BUDDY =
;===================

PlayerOne(skill,target:=0) {
	global cLeftTopX, cLeftTopY
	x := GetWidth(cLeftTopX)
	y := GetHeight(cLeftTopY)
	xmove := GetWidth(cLeftTopX+0.2)
	MouseClickDrag, left, x, y, xmove, y
	ShortSleep()
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

PlayerTwo(skill,target:=0) {
	global cLeftMiddleX, cLeftMiddleY
	x := GetWidth(cLeftMiddleX)
	y := GetHeight(cLeftMiddleY)
	xmove := GetWidth(cLeftMiddleX+0.2)
	MouseClickDrag, left, x, y, xmove, y
	ShortSleep()
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

PlayerThree(skill,target:=0) {
	global cLeftBottomX, cLeftBottomY
	x := GetWidth(cLeftBottomX)
	y := GetHeight(cLeftBottomY)
	xmove := GetWidth(cLeftBottomX+0.2)
	MouseClickDrag, left, x, y, xmove, y
	ShortSleep()
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

PlayerFour(skill,target:=0) {
	global cRightTopX, cRightTopY
	x := GetWidth(cRightTopX)
	y := GetHeight(cRightTopY)
	xmove := GetWidth(cRightTopX+0.2)
	MouseClickDrag, left, x, y, xmove, y
	ShortSleep()
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

PlayerFive(skill,target:=0) {
	global cRightMiddleX, cRightMiddleY
	x := GetWidth(cRightMiddleX)
	y := GetHeight(cRightMiddleY)
	xmove := GetWidth(cRightMiddleX+0.2)
	MouseClickDrag, left, x, y, xmove, y
	ShortSleep()
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

PlayerSix(skill,target:=0) {
	global cRightBottomX, cRightBottomY
	x := GetWidth(cRightBottomX)
	y := GetHeight(cRightBottomY)
	xmove := GetWidth(cRightBottomX+0.2)
	MouseClickDrag, left, x, y, xmove, y
	ShortSleep()
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

ClickSkill(skill) {
	global cLeftTopX, cLeftTopY, cLeftMiddleX, cLeftMiddleY, cLeftBottomX, cLeftBottomY, cRightTopX, cRightTopY, cRightMiddleX, cRightMiddleY, cRightBottomX, cRightBottomY
	;No switch case in AHK apparently, well lets do this the dirty way
	if (skill = 1) {
		MouseClick, left, GetWidth(cLeftTopX), GetHeight(cLeftTopY)
	}
	if (skill = 2) {
		MouseClick, left, GetWidth(cLeftMiddleX), GetHeight(cLeftMiddleY)
	}
	if (skill = 3) {
		MouseClick, left, GetWidth(cLeftBottomX), GetHeight(cLeftBottomY)
	}
	if (skill = 4) {
		MouseClick, left, GetWidth(cRightTopX), GetHeight(cRightTopY)
	}
	if (skill = 5) {
		MouseClick, left, GetWidth(cRightMiddleX), GetHeight(cRightMiddleY)
	}
	if (skill = 6) {
		MouseClick, left, GetWidth(cRightBottomX), GetHeight(cRightBottomY)
	}
}

;Check if crashed
CheckIfCrashed() {
	crashColor := "0x0E1F39"
	PixelGetColor, color, GetWidth(0.5), GetHeight(0.5), RGB
	if (color = crashColor) {
		return true
	} else {
		return false
	}	
}

;Restart game
RestartGame() {
	clickOn(0.85, 0.25)
	Sleep, 30000
	clickOn(0.5, 0.5)
	Sleep, 30000
}

;Check specified pixel if combat scene is active
DetectCombat() {
	global combatBarX, combatBarY, colorCombatDetection, combatCounter
	PixelGetColor, color, GetWidth(combatBarX), GetHeight(combatBarY), RGB
	if (color = colorCombatDetection) {
		return true
	} else {
		combatCounter := 0
		return false
	}
}

;Check if combat finish screen is up
DetectCombatFinished() {
	global combatFinishX, combatFinishY, colorCombatFinishDetection
	PixelGetColor, color, GetWidth(combatFinishX), GetHeight(combatFinishY), RGB
	if (color = colorCombatFinishDetection) {
		return true
	} else {
		return false
	}
}

clickOn(px, py) {
    MouseClick, left, GetWidth(px), GetHeight(py)
	MoveSleep()
	;while(DetectCombat()) {
	;	if (DoCombat()) {
	;		clickOn(px, py)			
	;	}
	;}
}

ClickMouse(px, py) {
    MouseClick, left, GetWidth(px), GetHeight(py)
}

GetWidth(px) {
    global x0, width
	return x0+px*width
}

GetHeight(py) {
    global y0, height
	return y0+py*height
}

MoveOneStepUp(steps:=1) {
    Loop, %steps% {
		clickOn(0.50, 0.43)
		;MicroSleep()
		;while(DetectCombat()) {
		;	if (DoCombat()) {
		;		clickOn(0.50, 0.43)
		;		MicroSleep()			
		;	}
		;}
    }
}

MoveOneStepDown(steps:=1) {
    Loop, %steps% {
		clickOn(0.50, 0.51)
		;MicroSleep()
		;while(DetectCombat()) {
		;	if (DoCombat()) {
		;		clickOn(0.50, 0.51)
		;		MicroSleep()			
		;	}
		;}
    }
}

MoveOneStepLeft(steps:=1) {
    Loop, %steps% {
		clickOn(0.45, 0.47)
		;MicroSleep()
		;while(DetectCombat()) {
		;	if (DoCombat()) {
		;		clickOn(0.45, 0.47)
		;		MicroSleep()			
		;	}
		;}
    }
}

MoveOneStepRight(steps:=1) {
    Loop, %steps% {
		clickOn(0.55, 0.47)
		;MicroSleep()
		;while(DetectCombat()) {
		;	if (DoCombat()) {
		;		clickOn(0.55, 0.47)
		;		MicroSleep()			
		;	}
		;}
    }
}

GoToZoneTwo() {
	global encounterCounter := 0

	;Loop until encounters are maxed, then exit zone
	global encounterCounter, zoneOneEncounter
	while (encounterCounter < zoneOneEncounter) {
		while(DetectCombat()) {
			DoCombat()
			LongSleep()
		}
		clickOn(0.1, 0.45)
		MicroSleep()
		clickOn(0.9, 0.45)
		MicroSleep()
	}
	clickOn(0.1, 0.45)
	QuickSleep()


	;p1 down
	MoveOneStepDown(8)
	MoveOneStepLeft(7)
	MoveOneStepDown(10)
	MoveOneStepLeft(6)
	MoveOneStepDown(5)
	MoveOneStepLeft(4)
	MoveOneStepDown(11)
	MoveOneStepUp(1)
	MoveOneStepLeft(6)
	MoveOneStepDown(20)
	MoveOneStepLeft(5)
	MoveOneStepDown(10)
	
	;p2 to node1
	MoveOneStepRight(5)
	MoveOneStepDown(2)
	MoveOneStepRight(6)
	MoveOneStepUp(3)
	MoveOneStepRight(10)
	MoveOneStepDown(3)
	MoveOneStepRight(7)
	MoveOneStepUp(6)
	MoveOneStepRight(3)
	MoveOneStepUp(5)
	MoveOneStepRight(3)
	MoveOneStepUp(5)
	MoveOneStepRight(1)
	MoveOneStepUp(5)
	
	;p3 to zone2
	MoveOneStepDown(9)
	MoveOneStepLeft(3)
	MoveOneStepDown(5)
	MoveOneStepLeft(3)
	MoveOneStepDown(3)
	MoveOneStepLeft(3)
	MoveOneStepDown(4)
	MoveOneStepLeft(9)
	MoveOneStepUp(1)
	MoveOneStepLeft(5)
	MoveOneStepDown(3)
	MoveOneStepLeft(6)
	MoveOneStepDown(6)
	MoveOneStepLeft(6)
	MoveOneStepDown(4)
	MoveOneStepLeft(5)
	MoveOneStepDown(11)
	MoveOneStepLeft(11)
	MoveOneStepDown(4)
	MoveOneStepLeft(7)
	
	;to enter zone2
	MoveOneStepDown(5)
	MoveOneStepLeft(7)
	MoveOneStepDown(7)
	
	LongSleep()
}

GoToBoss() {
	;to node3
	MoveOneStepDown(3)
	MoveOneStepRight(5)
	MoveOneStepDown(2)
	MoveOneStepRight(6)
	MoveOneStepUp(4)
	MoveOneStepRight(3)
	MoveOneStepUp(4)
	MoveOneStepRight(11)
	MoveOneStepDown(9)
	MoveOneStepRight(5)
	MoveOneStepDown(13)
	MoveOneStepLeft(8)
	MoveOneStepDown(2)
	
	;to boss
	MoveOneStepUp(2)
	MoveOneStepRight(9)
	MoveOneStepUp(14)
	MoveOneStepLeft(8)
	MoveOneStepUp(6)
	MoveOneStepLeft(11)
	MoveOneStepDown(5)
	MoveOneStepLeft(3)
	MoveOneStepDown(5)
	MoveOneStepLeft(7)
	
	;Trigger Boss
	MoveOneStepDown(9)
	LongSleep()
}

GoToExit() {
	;Enter Node 4 room
	MoveOneStepLeft(11)
	clickOn(0.1, 0.4)
	LongSleep()
	
	;Collect Node 4 and exit room
	MoveOneStepLeft(5)
	MoveOneStepUp(9)
	MoveOneStepRight(6)
	MoveOneStepUp(2)
	MoveOneStepDown(2)
	MoveOneStepLeft(6)
	MoveOneStepDown(9)
	MoveOneStepRight(7)
	LongSleep()
	
	;Exit dungeon
	MoveOneStepRight(11)
	MoveOneStepUp(3)
	clickOn(0.5, 0.1)
	LongSleep()	
}

goTopRight() {
    ClickMouse(0.95, 0.05)
    QuickSleep()
}

goBottomLeft() {
    ClickMouse(0.05, 0.95)
    QuickSleep()
}

goMaxTop(steps){
    Loop, %steps% {
        clickOn(0.5, 0.01)
        LongSleep()
    }
}

goMaxBottom(steps) {
    Loop, %steps% {
        clickOn(0.5, 0.99)
        LongSleep()
    }
}

goMaxLeft(steps) {
    Loop, %steps% {
        clickOn(0.01, 0.47)
        ShortSleep()
    }
}

goMaxRight(steps) {
    Loop, %steps% {
        clickOn(0.99, 0.47)
        ShortSleep()
    }
}

goRight(steps) {
    Loop, %steps% {
        clickOn(0.55, 0.47)
        QuickSleep()
    }
}
goLeft(steps) {
    Loop, %steps% {
        clickOn(0.45 , 0.47)
        QuickSleep()
    }
}

goTop(steps) {
    Loop, %steps% {
        clickOn(0.5, 0.40)
        QuickSleep()
    }

}

goBottom(steps) {
    Loop, %steps% {
        clickOn(0.5, 0.51)
        QuickSleep()
    }
}

enterExploration() {
    ClickMouse(0.5, 0.33) ;click on stage
    LongSleep()
    ClickMouse(0.5, 0.33) ;click on friend
    LongSleep()
    ClickMouse(0.5, 0.85) ; click on depart
    sleep, 10000
}


collectFirstPoint() {
    goMaxBottom(2)
    goMaxLeft(3)
    goLeft(4)
    goMaxTop(3)
}

collectSecondPointAndGoToZone2() {
    goMaxBottom(1)
    goBottom(5)
    goMaxLeft(5)
    goMaxTop(1)
    goLeft(2)
    goMaxTop(1)
    goMaxLeft(3)
    goMaxTop(1)
    goMaxBottom(1)
    goTop(2)
    goMaxLeft(1)
}
collectThirdPoint() {
    goTopRight() 
    goMaxTop(1)
    goMaxLeft(4)
    goMaxBottom(1)
}
collectFourthPoint() {
    goMaxRight(3)
    goMaxBottom(2)
    goMaxLeft(1)
    goMaxBottom(1)
    goTop(3)
    goMaxLeft(3)
    goMaxTop(1)
    goBottom(3)
    goMaxLeft(3)
    goMaxBottom(1)
    goBottom(2)
    goMaxLeft(1)
}

goToBossOld() {
    goMaxRight(1)
    goMaxTop(2)
    goMaxLeft(6)
    goMaxTop(1)
    LongSleep()
}

KillBoss() {
	LongSleep()
    ClickMouse(0.8, 0.25)
    LongSleep()
    LongSleep()
    ClickMouse(0.8, 0.25)
    LongSleep()
    LongSleep()
    goBottomLeft() ; hit the auto button
    while (DetectCombatFinished() = false) {
		if (CheckIfCrashed()) {
			global crashCounter
			crashCounter++
			LongSleep()
			RestartGame()
		}
		sleep, 1000
	}
    ClickMouse(0.5, 0.5)
    LongSleep()
    ClickMouse(0.5, 0.5)
    LongSleep()
    ClickMouse(0.83, 0.37)
    LongSleep()
}

collectFifthPoint() {
    goMaxRight(1)
    goMaxTop(1)
    gomaxRight(2)
    gomaxTop(1)
    clickOn(0.99, 0.26)
    ShortSleep()
    clickOn(0.99, 0.26)
    ShortSleep()
    goMaxBottom(1)
}

exitExploration() {
	;Wait for rewards and stuff
    sleep, 15000
    clickOn(0.5, 0.5)
    QuickSleep()
	clickOn(0.5, 0.5)
    QuickSleep()
    clickOn(0.5, 0.5)
	QuickSleep()
    clickOn(0.5, 0.81) ; click next
    LongSleep()
    clickOn(0.5, 0.5)
    QuickSleep()
    clickOn(0.5, 0.5)
    QuickSleep()
    clickOn(0.5, 0.5)
	LongSleep()
    clickOn(0.5, 0.5)
    QuickSleep()
    clickOn(0.5, 0.5)
    QuickSleep()
    clickOn(0.5, 0.5)
    LongSleep()
    clickOn(0.5, 0.81) ; click next
    LongSleep()
	
	;We did it
	global runsCompleted
	runsCompleted++
}

ClearZoneOne()
{
    ;global zone1Time
    ;Timer("ZoneOneClearTime", zone1Time)
    ;while (Timer("ZoneOneClearTime") <> true)
    
	global encounterCounter, zoneOneEncounter
	
	while (encounterCounter < zoneOneEncounter) {
        goTopRight()
        goBottomLeft()
		while(DetectCombat()) {
			if (DoCombat()) {
				goTopRight()
			}
		}
    }
	
	encounterCounter := 0
}

ClearZoneTwo()
{
    ;global zone2Time
    ;Timer("ZoneTwoClearTime", zone2Time)
    ;while (Timer("ZoneTwoClearTime") <> true)

	global encounterCounter, zoneTwoEncounter
	
	while (encounterCounter < zoneTwoEncounter) {
        goTopRight()
        goBottomLeft()
		while(DetectCombat()) {
			if (DoCombat()) {
				goTopRight()
			}
		}
    }
	
	;encounterCounter := 0
}

;Update the values in these methods to adjust timing
;across the entire macro. Time is measured in milliseconds
;1000 = 1 second
MicroSleep()
{
    sleep, 500
}

MoveSleep()
{
    sleep, 300
}


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
    sleep, 4000
}

; An example class for counting the seconds...
class SecondCounter {
    __New() {
        this.interval := 1000
        this.count := 0
        ; Tick() has an implicit parameter "this" which is a reference to
        ; the object, so we need to create a function which encapsulates
        ; "this" and the method to call:
        this.timer := ObjBindMethod(this, "Tick")
    }
    Start() {
        ; Known limitation: SetTimer requires a plain variable reference.
        timer := this.timer
        SetTimer % timer, % this.interval
        ;ToolTip % "Counter started"
    }
    Stop() {
        ; To turn off the timer, we must pass the same object as before:
        timer := this.timer
        SetTimer % timer, Off
        ;ToolTip % "Counter stopped at " this.count
    }
    ; In this example, the timer calls this method:
    Tick() {
        ++this.count
    }
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