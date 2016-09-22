------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely
SetMouseDelay, 25
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen



;================================================;
;================================================;
;=============== CONFIG ME ======================;
;================================================;
;================================================;


	;Nox settings: 1280x720 Tablet OpenGL
	;Maximize your Nox window
	;Activate capslock
	;Enter pixel values as accurate as possible
	
	;Top left corner ___WITHOUT___!!!! black android bar with wifi signal in it
	;YES, just the actual game screen where the blue starts in the top left corner
	x0 := 626
	y0 := 72
	;Bottom right corner of said game screen
	x1 := 1257
	y1 := 1157


	;We wont use lapis, this is to subtract runtime for less cooldown
	;t(NRG)*60000, 15NRG=900000
	energyRefillTime := 900000
	
	;How many encounter per zone are we having this wonderful day?
	zoneOneEncounter := 14

	;Click into your game screen once, press F7, suddenly a message box will appear, enter those values below
	
	;Go into a battle and hit F7 to get the first battle color
	;Hit F7 at the "battle complete" screen to get the second color
	
	;This is the color we want to detect in our CombatScene
	colorCombatDetection := "0x18000A"

	;This is the color we want to detect in our CombatFinishedScene
	colorCombatFinishDetection := "0x002B40"
	
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
delayBetweenMacros := 0
movementSpeed := 500
combatCounter := 0
encounterCounter := 0
runsCompleted := 0
crashCounter := 0
runTimer := 0
timeDisplay := 0
;Activate combat moves? You need to edit the DoCombat() function!
;If false AUTO will be clicked in combat
activateMoves := false
;If above is true: How long is your combat animation going to be at max? Kefka LB = 15s
animationTimeout := 15000
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
	CoordMode, ToolTip, Screen ; makes tooltip to appear at position, relative to screen.
	CoordMode, Mouse, Screen ; makes mouse coordinates to be relative to screen.
	MouseGetPos xx, yy ; get mouse x and y position, store as %xx% and %yy%
	px := (xx - x0) / width
	py := (yy - y0) / height
	global encounterCounter, combatCounter, runsCompleted, crashCounter, runTimer, timeDisplay, delayBetweenMacros
	if (runTimer.count > 0) {
		timeDisplay := runTimer.count
	} else {
		timeDisplay := 0
	}
	if (delayBetweenMacros > 0) {
		timeDelayDisplay := delayBetweenMacros/1000
	} else {
		timeDelayDisplay := 0
	}
	tooltip, %xx% %yy%`n`nEncounter: %encounterCounter%`nCombat: %combatCounter%`nRuns: %runsCompleted%`nCrashed: %crashCounter%`nTimer (s): %timeDisplay%`nDelay (s): %timeDelayDisplay%, 100, 100 ;offset x, y from top left
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
    while (true)
    {
		runTimer := new SecondCounter
		runTimer.Start()
		LongSleep()
        enterExploration()
        GoToBoss()
        KillBoss()
		GoToExit()
        exitExploration()
		runTimer.Stop()
        global energyRefillTime, delayBetweenMacros := 0
		runtimeMicro := runTimer.count * 1000
		delayBetweenMacros := energyRefillTime - runtimeMicro
        sleep, delayBetweenMacros
    }
}

;Debug
F9::
{
    GoToExit()
}

;Pixel color detection
F7::
{
	global combatBarX, combatBarY, combatFinishX, combatFinishY
	
	PixelGetColor, colorCombat, GetWidth(combatBarX), GetHeight(combatBarY), RGB
	PixelGetColor, colorCombatFinish, GetWidth(combatFinishX), GetHeight(combatFinishY), RGB
	
	MsgBox colorCombatDetection = %colorCombat%`ncolorCombatFinishDetection = %colorCombatFinish%
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

goBottomLeft() {
    ClickMouse(0.05, 0.95)
    QuickSleep()
}

GoToBoss() {
	global encounterCounter := 0

	clickOn(0.1, 0.3)
	MicroSleep()
		
	;Loop until encounters are maxed, then exit zone
	global encounterCounter, zoneOneEncounter
	while (encounterCounter < zoneOneEncounter) {
		while(DetectCombat()) {
			DoCombat()
			LongSleep()
		}
		clickOn(0.01, 0.45)
		sleep, 300
		clickOn(0.99, 0.45)
		sleep, 300
	}
	clickOn(0.01, 0.45)
	QuickSleep()

	clickOn(0.7, 0.15)
	QuickSleep()
	clickOn(0.01, 0.4)
	QuickSleep()
	clickOn(0.01, 0.45)
	QuickSleep()
	clickOn(0.01, 0.45)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.99, 0.45)
	QuickSleep()
	clickOn(0.99, 0.45)
	QuickSleep()
	clickOn(0.99, 0.40)
	QuickSleep()
	clickOn(0.99, 0.45)
	QuickSleep()
	clickOn(0.99, 0.45)
	QuickSleep()
	clickOn(0.99, 0.45)
	QuickSleep()
	clickOn(0.5, 0.99)
	QuickSleep()
	clickOn(0.5, 0.99)
	QuickSleep()
	clickOn(0.55, 0.5)
	QuickSleep()
	clickOn(0.75, 0.45)
	QuickSleep()
	MoveOneStepDown(1)
	MoveOneStepUp(1)
	MoveOneStepLeft(3)
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	MoveOneStepRight(3)
	MoveOneStepUp(4)
	MoveOneStepLeft(2)
	MoveOneStepUp(2)
	MoveOneStepLeft(1)
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.99)
	QuickSleep()
	clickOn(0.5, 0.99)
	QuickSleep()
	MoveOneStepRight(3)
	MoveOneStepDown(5)
	clickOn(0.01, 0.45)
	QuickSleep()
	clickOn(0.01, 0.45)
	QuickSleep()
	clickOn(0.01, 0.45)
	QuickSleep()
	clickOn(0.01, 0.45)
	QuickSleep()
	clickOn(0.5, 0.01)
	QuickSleep()
	clickOn(0.5, 0.01)
	LongSleep()
}

GoToExit() {
	MoveOneStepLeft(2)
	MoveOneStepDown(2)
	MoveOneStepUp(2)
	MoveOneStepRight(3)
	clickOn(0.5, 0.01)
	LongSleep()	
}

enterExploration() {
    ClickMouse(0.5, 0.33) ;click on stage
    LongSleep()
    ClickMouse(0.5, 0.33) ;click on friend
    LongSleep()
    ClickMouse(0.5, 0.85) ; click on depart
    sleep, 10000
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
    ClickMouse(0.83, 0.27)
    LongSleep()
}

exitExploration() {
    ;Click exit
	ClickMouse(0.83, 0.27)
    LongSleep()
	
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
