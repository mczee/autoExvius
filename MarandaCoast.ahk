------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

SetMouseDelay, 25
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

;================;
;================;
;=====INPUTS=====;
x0 := 626
y0 := 72
x1 := 1257
y1 := 1157
; time: 1000 = 1s, 60000 = 1 min
zone1Time := 600000 ; = 10min, 720000 = 12 min
zone2Time := 600000 ; = 10min
estimateTimeToKillBoss := 60000 ; = 1min
delayBetweenMacros := 2400000 ; = 40 min
;===END_INPUTS===;
;================;
;================;


width := x1 - x0
height := y1 - y0

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
 px := (xx - x0) / width
 py := (yy - y0) / height
 ;tooltip %px% %py%, 0, 0
 tooltip %xx% %yy%, 0, 0
 return
}

return

f12::reload ;reloads script if an error occurs

;Primary macro. Press F8 to trigger it. Press F12 to stop it.
;You can re-assign the macro by changing F8 to another valid value.
;Look at AHK help documentation to see what values to use
F8::
{
    while (true)
    {
        LongSleep()
        enterExploration() ;get to the exploration
        clearZone1() ;clear zone 1
		GoToZoneTwo()
        clearZone2()
        GoToBoss()
        KillBoss()
        GoToExit()
        exitExploration()
        global delayBetweenMacros
        sleep, delayBetweenMacros
    }
}

; Debug
F9::
{
	;KillBoss()	
}

clickOn(px, py) {
    global x0, y0, width, height
    MouseClick, left, x0 + px*width, y0 + py*height
}

MoveOneStepUp(steps:=1) {
    Loop, %steps% {
		clickOn(0.50, 0.43)
		MicroSleep()
    }
}

MoveOneStepDown(steps:=1) {
    Loop, %steps% {
		clickOn(0.50, 0.51)
		MicroSleep()
    }
}

MoveOneStepLeft(steps:=1) {
    Loop, %steps% {
		clickOn(0.45, 0.47)
		MicroSleep()
    }
}

MoveOneStepRight(steps:=1) {
    Loop, %steps% {
		clickOn(0.55, 0.47)
		MicroSleep()
    }
}

GoToZoneTwo() {
	goTopRight()
	clickOn(0.50, 0.35)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
    clickOn(0.50, 0.45)
    MicroSleep()
	MoveOneStepDown(13)
	MoveOneStepLeft(19)
	MoveOneStepUp(14)
	clickOn(0.50, 0.35)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
    clickOn(0.50, 0.45)
    MicroSleep()
	MoveOneStepDown(15)
	MoveOneStepLeft(26)
	MoveOneStepUp(13)
	MoveOneStepLeft(15)
	MoveOneStepUp(1)
    clickOn(0.50, 0.45)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
	clickOn(0.50, 0.35)
    MicroSleep()
	clickOn(0.50, 0.30)
    MicroSleep()
	clickOn(0.50, 0.25)
    MicroSleep()
	clickOn(0.50, 0.20)
    MicroSleep()
	clickOn(0.50, 0.25)
    MicroSleep()
    clickOn(0.50, 0.30)
    MicroSleep()
    clickOn(0.50, 0.35)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
    clickOn(0.50, 0.45)
    MicroSleep()
	MoveOneStepDown(1)
	MoveOneStepLeft(3)
}

GoToBoss() {
	goTopRight()
    MicroSleep()
	MoveOneStepDown(1)
	MoveOneStepLeft(23)
	MoveOneStepDown(1)
	MoveOneStepRight(15)
	MoveOneStepDown(16)
	MoveOneStepLeft(3)
	MoveOneStepDown(4)
	MoveOneStepLeft(16)
	MoveOneStepUp(6)
	MoveOneStepLeft(13)
	MoveOneStepDown(12)
	MoveOneStepLeft(4)
	MoveOneStepRight(4)
	MoveOneStepUp(13)
	MoveOneStepLeft(25)
	MoveOneStepUp(5)
}

GoToExit() {
	MoveOneStepUp(8)
	MoveOneStepRight(9)
	MoveOneStepUp(1)
    clickOn(0.50, 0.45)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
	clickOn(0.50, 0.35)
    MicroSleep()
	clickOn(0.50, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.55, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.45, 0.30)
    MicroSleep()
	clickOn(0.50, 0.35)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
    clickOn(0.50, 0.45)
    MicroSleep()
	MoveOneStepDown(1)
	MoveOneStepLeft(12)
    clickOn(0.50, 0.45)
    MicroSleep()
    clickOn(0.50, 0.40)
    MicroSleep()
	clickOn(0.50, 0.35)
    MicroSleep()
}

goTopRight() {
    clickOn(0.95, 0.05)
    QuickSleep()
}

goBottomLeft() {
    clickOn(0.05, 0.95)
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
    clickOn(0.5, 0.33) ;click on stage
    LongSleep()
    clickOn(0.5, 0.33) ;click on friend
    LongSleep()
    LongSleep()
    clickOn(0.5, 0.85) ; click on depart
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
    clickOn(0.8, 0.25)
    LongSleep()
    LongSleep()
    clickOn(0.8, 0.25)
    LongSleep()
    LongSleep()
    goBottomLeft() ; hit the auto button
    global estimateTimeToKillBoss
    sleep, estimateTimeToKillBoss
    clickOn(0.5, 0.5)
    LongSleep()
    clickOn(0.5, 0.5)
    LongSleep()
    clickOn(0.83, 0.27)
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
    clickOn(0.01, 0.3)
    ShortSleep()
    clickOn(0.01, 0.3)
    ShortSleep()
    goMaxBottom(1)
    goMaxLeft(2)
    goLeft(1)
    goMaxTop(1)
    LongSleep()
    clickOn(0.8, 0.27)

    sleep, 30000
    clickOn(0.5, 0.5)
    clickOn(0.5, 0.81) ; click next
    LongSleep()
    clickOn(0.5, 0.5) 
    sleep, 15000
    clickOn(0.5, 0.81) ; click next
    sleep, 15000
}

clearZone1()
{
    global zone1Time
    Timer("ZoneOneClearTime", zone1Time)
    while (Timer("ZoneOneClearTime") <> true)
    {
        goTopRight()
        goBottomLeft()
    }
}

clearZone2()
{
    global zone2Time
    Timer("ZoneTwoClearTime", zone2Time)
    while (Timer("ZoneTwoClearTime") <> true)
    {
        goTopRight()
        goBottomLeft()
    }
}

;Update the values in these methods to adjust timing
;across the entire macro. Time is measured in milliseconds
;1000 = 1 second
MicroSleep()
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