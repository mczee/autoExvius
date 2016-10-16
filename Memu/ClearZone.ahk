------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely
SetMouseDelay, 25
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
;SendMode Input


;================================================;
;================================================;
;=============== CONFIG ME ======================;
;================================================;
;================================================;


	;!!!IMPORTANT FOR MEMU!!!
	;START THIS SCRIPT AS ADMINISTRATOR
	;!!!IMPORTANT FOR MEMU!!!

	;Memu Settings: 1280x720 192 dpi
	;Maximize your Memu window
	;Activate capslock
	;Enter pixel values as accurate as possible
	;Top left corner ___WITHOUT___!!!! black android bar with wifi signal in it
	;YES, just the actual game screen where the blue starts in the top left corner
	x0 := 624
	y0 := 70
	;Bottom right corner of said game screen
	x1 := 1254
	y1 := 1154

	;Activate combat moves? You need to edit the ExecuteCombatMoves() function!
	;If false AUTO will be clicked in combat
	activateMoves := true
	
	;Click into your game screen once, press F7, suddenly a message box will appear, enter those values below
	;Go into a battle and hit F7 to get the first battle color (colorCombatDetection)
	;Hit F7 at the "Results" screen to get the second color (colorCombatFinishDetection)
	;This is the color we want to detect in our CombatScene
	colorCombatDetection := "0x18000A"
	;This is the color we want to detect in our CombatFinishedScene
	colorCombatFinishDetection := "0x002B40"
	
	;Crash detection
	;Start your game, maximize Memu, press the Android home button (bottom right circle icon)
	;Press F7 and enter the value for colorCombatFinishDetection
	colorCrashDetection := "0x12A47F"
	;Enter the X and Y values of the tooltip in here where the Exvius app button is located
	appX := 283
	appY := 383
	
	;(you probably dont want to edit this)
	combatBarX := 0.05
	combatBarY := 0.55
	;(you probably dont want to edit this)
	combatFinishX := 0.50
	combatFinishY := 0.50



;================================================;
;================================================;
;============== WELL DONE =======================;
;================================================;
;================================================;







;Stuff you dont need to worry about
width := x1 - x0
height := y1 - y0
movementSpeed := 500
combatCounter := 0
encounterCounter := 0
runsCompleted := 0
crashCounter := 0
runTimer := new SecondCounter
timeDisplay := 0
scriptRunning := 0
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

; While CapsLock is toggled On
; Script will display Mouse Position (coordinates) as a tooltip at Top-Left corner of screen.
; Also allows to copy them (to clipboard) with a PrintScreen button.
settimer start1, 1000
return
start1:
if !GetKeyState("capslock","T") ; whether capslock is on or off
{
    tooltip ; if off, don't show tooltip at all.
} else { ; if on
	UpdateTooltip()
	return
}
return

f11::Pause ; Pressing F11 once will pause the script. Pressing it again will unpause.

f12::reload ;reloads script if an error occurs



;Primary macro. Press F8 to trigger it. Press F12 to stop it.
;You can re-assign the macro by changing F8 to another valid value.
;Look at AHK help documentation to see what values to use
F8::
{
	global scriptRunning, encounterCounter, zoneEncounter, crashCounter
	scriptRunning := 1
	runTimer.count := 0
	runTimer.Start()
	QuickSleep()
	InputBox, zoneEncounter, How many Encounter to fight?
	QuickSleep()
	;Loop until encounters are maxed, then exit zone
	while (encounterCounter < zoneEncounter) {
		if (CheckIfCrashed()) {
			crashCounter++
			RestartGame()
			LongSleep()
		}
		if (DetectCombat()) {
			while (DoCombat()) {
				MicroSleep()
			}
		}
		TriggerEncounter()
	}
	runTimer.Stop()
	runseconds := runTimer.count
	MsgBox Finished %zoneOneEncounter% encounter in %runseconds% seconds.
}

;Pixel color detection
F7::
{
	global combatBarX, combatBarY, combatFinishX, combatFinishY
	
	PixelGetColor, colorCombat, GetWidth(combatBarX), GetHeight(combatBarY), RGB
	PixelGetColor, colorCombatFinish, GetWidth(combatFinishX), GetHeight(combatFinishY), RGB
	
	MsgBox colorCombatDetection = %colorCombat%`ncolorCombatFinishDetection = %colorCombatFinish%
	return
}

;Debug
F9::
{
	PlayerSixActivate()
	QuickSleep()
	PlayerScrollDown()
	MicroSleep()
	PlayerSixClick(3)
}



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
	
	;Syntax:
	;	Player<#>Activate() = Swipes over that player to enter skill menu
	;	Player<#>Click(<SKILL#>,<TARGET#>) = Click on that skill, chose a target to click for heals or buffs
	;	PlayerScrollDown = Scroll down 1 compelte set of skills
	
	;Examples
	;PlayerOne(2) = Swipe over top left unit (1), click middle left skill (2)
	;PlayerFive(3,5) = Swipe right middle unit (5), click bottom left skill (3), click on player 5 with skill
	
	;Every second encounter tell your friend to scroll down 1 complete set and click a skill
	global encounterCounter, combatCounter
	if ((encounterCounter > 0) AND (Mod(encounterCounter, 2) = 0) AND (combatCounter = 1)) {
		;Swipe right over player six
		PlayerSixActivate()
		QuickSleep()
		;Scroll down 1 complete set of skills
		PlayerScrollDown()
		MicroSleep()
		;Click skill
		PlayerSixClick(3)
	}

	;Click on AUTO to execute the moves at once
	clickAuto()
	;Click twice to deactivate so we can do the next set of moves, deactivate to just let AUTO finish the job
	;clickAuto()
}

;=== YOU MIGHT NOT WANT TO EDIT THIS, MAYBE, JUST MAYBE ===
DoCombat() {
	global combatCounter, activateMoves
	
	combatCounter++
	
	if (DetectCombatFinished()) {
		;Check if finish screen is up and click once to exit
		combatCounter := 0
		QuickSleep()
		clickOn(0.5, 0.5)
		LongSleep()
		;Lets tell the previous function we are done here
		return false
	} else if (activateMoves = true) {
		;Check if moves are active and we are in the first round
		ExecuteCombatMoves()
		return true
	} else {
		clickAuto()
		MicroSleep()
		return true
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

PlayerSixActivate() {
	global cRightBottomX, cRightBottomY
	x := GetWidth(cRightBottomX)
	y := GetHeight(cRightBottomY)
	xmove := GetWidth(cRightBottomX+0.2)
	MouseClickDrag, left, x, y, xmove, y
}

PlayerSixClick(skill,target:=0) {
	ClickSkill(skill)
	QuickSleep()
	if (target > 0) {
		ClickSkill(target)
		QuickSleep()
	}
}

PlayerScrollDown() {
	MouseClickDrag, left, GetWidth(0.49), GetHeight(0.9), GetWidth(0.49), GetHeight(0.61)
	ShortSleep()
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

;Update the Tooltip
UpdateTooltip() {
	CoordMode, ToolTip, Screen ; makes tooltip to appear at position, relative to screen.
	CoordMode, Mouse, Screen ; makes mouse coordinates to be relative to screen.
	MouseGetPos xx, yy ; get mouse x and y position, store as %xx% and %yy%
	px := (xx - x0) / width
	py := (yy - y0) / height
	xRel := GetWidthRel(xx)
	yRel := GetHeightRel(yy)
	global scriptRunning, encounterCounter, crashCounter, runTimer
	if (runTimer.count > 0) {
		timeDisplay := runTimer.count
	} else {
		timeDisplay := 0
	}
	if (delayBetweenMacros > 0) {
		timeDelayDisplay := Round(delayBetweenMacros/1000,0)
	} else {
		timeDelayDisplay := 0
	}
	tooltip, X %xx%`nY %yy%`n`nXrel %xRel%`nYrel %yRel%`n`nRunning: %scriptRunning%`nEncounter: %encounterCounter%`nCrashed: %crashCounter%`nTimer (s): %timeDisplay%, 100, 100 ;offset x, y from top left
}

;Pixel color detection
PixelColorDetection()
{
	global combatBarX, combatBarY, combatFinishX, combatFinishY
	
	PixelGetColor, colorCombat, GetWidth(combatBarX), GetHeight(combatBarY), RGB
	PixelGetColor, colorCombatFinish, GetWidth(combatFinishX), GetHeight(combatFinishY), RGB
	
	MsgBox colorCombatDetection = %colorCombat%`ncolorCombatFinishDetection = %colorCombatFinish%
	return
}

;Just move to trigger an encounter
TriggerEncounter() {
	clickOn(0.05, 0.47)
	MicroSleep()
	clickOn(0.95, 0.47)
	MicroSleep()
}

;Check if crashed
CheckIfCrashed() {
	global colorCrashDetection
	PixelGetColor, color, GetWidth(0.5), GetHeight(0.5), RGB
	if (color = colorCrashDetection) {
		return true
	} else {
		return false
	}	
}

;Restart game
RestartGame() {
	global appX, appY
	MouseClick, left, appX, appY
	Sleep, 30000
	clickOn(0.5, 0.5)
	Sleep, 30000
}

;Check specified pixel if combat scene is active
DetectCombat() {
	global encounterCounter, combatBarX, combatBarY, colorCombatDetection, combatCounter
	PixelGetColor, color, GetWidth(combatBarX), GetHeight(combatBarY), RGB
	if (color = colorCombatDetection) {
		encounterCounter++
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

;He does all the clicking so you dont have to!
clickOn(px, py) {
	MouseClick, left, GetWidth(px), GetHeight(py)
	MoveSleep()
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

GetWidthRel(pixel) {
	global x0, width
	realWidth := pixel-x0
	relX := Round(realWidth/width, 2)
	return relX
}

GetHeightRel(pixel) {
	global y0, height
	realHeight := pixel-y0
	relY := Round(realHeight/height, 2)
	return relY
}

clickAuto() {
    clickOn(0.05, 0.95)
    QuickSleep()
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

