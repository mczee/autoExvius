------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

;================;
;================;
;=====INPUTS=====;
x0 := 208
y0 := 128
x1 := 612
y1 := 845
; time: 1000 = 1s, 60000 = 1 min
zone1Time := 900000 ; = 15min, 720000 = 12 min
zone2Time := 900000 ; = 15min
estimateTimeToKillBoss := 60000 ; = 1min
delayBetweenMacros := 300000 ; = 5 min

; 0 means default value. Change this if needed
dpadCenterX := 0 ; the x value of the center of the dpad
dpadCenterY := 0 ; the y value of the center of the dpad
dpadRightArrowX := 0 ; the x value of the right arrow of the dpad

;===END_INPUTS===;
;================;
;================;


width := x1 - x0
height := y1 - y0

if(dpadCenterX <> 0 & dpadCenterY <> 0 & dpadRightArrowX <> 0) {
    dpadPx := (dpadCenterX - x0) / width
    dpadPy := (dpadCenterY - y0) / height
    dpadR :=  dpadRightArrowX - dpadCenterX
    dpadRPx := dpadR / width
    dpadRPy := dpadR / height
} else {
    dpadPx := 0.68
    dpadPy := 0.78
    dpadRPx := 0.2 
    dpadRPy := 0.1
}



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
        enterExploration() ;get to the exploration
        clearZone1() ;clear zone 1
        collectFirstPoint()
        collectSecondPointAndGoToZone2()
        clearZone2() ;clear zone 2
        collectThirdPoint()
        collectFourthPoint()
        goToBoss()
        killBoss()
        collectFifthPointAndExit()
        global delayBetweenMacros
        sleep, delayBetweenMacros
    }
}

F6:: ; clear zone 1 and continue
{
    while (true)
    {
        clearZone1() ;clear zone 1
        collectFirstPoint()
        collectSecondPointAndGoToZone2()
        clearZone2() ;clear zone 2
        collectThirdPoint()
        collectFourthPoint()
        goToBoss()
        killBoss()
        collectFifthPointAndExit()
        global delayBetweenMacros
        sleep, delayBetweenMacros
        enterExploration() ;get to the exploration
    }
}

F7:: ; clear zone 2 and continue
{
    while (true)
    {
        collectSecondPointAndGoToZone2()
        clearZone2() ;clear zone 2
        collectThirdPoint()
        collectFourthPoint()
        goToBoss()
        killBoss()
        collectFifthPointAndExit()
        global delayBetweenMacros
        sleep, delayBetweenMacros
        enterExploration() ;get to the exploration
        clearZone1() ;clear zone 1
        collectFirstPoint()
    }
}


F9::
{
    clearZone1()
}

F10::
{

}

clickOn(px, py) {
    global x0, y0, width, height
    MouseClick, left, x0 + px*width, y0 + py*height, 1, 0
}

dragOn(px1, py1) {
    global x0, y0, width, height, dpadPx, dpadPy
    MouseClickDrag, Left, x0 + dpadPx*width, y0 + dpadPy*height, x0 + px1*width, y0 + py1*height    
}

goTop(steps) {
    global dpadPx, dpadPy, dpadRPy
    Loop, %steps% {
        dragOn(dpadPx, dpadPy - dpadRPy)
        FastSleep()
    }   
}
goBottom(steps) {
    global dpadPx, dpadPy, dpadRPy
    Loop, %steps% {
        dragOn(dpadPx, dpadPy + dpadRPy)
        FastSleep()
    }   
}
goLeft(steps) {
    global dpadPx, dpadPy, dpadRPx
    Loop, %steps% {
        dragOn(dpadPx - dpadRPx, dpadPy)
        FastSleep()
    }   
}
goRight(steps) {
    global dpadPx, dpadPy, dpadRPx
    Loop, %steps% {
        dragOn(dpadPx + dpadRPx, dpadPy)
        FastSleep()
    }   
}
goTopRight() {
    clickOn(0.95, 0.05)
    QuickSleep()
}
goBottomLeft() {
    clickOn(0.05, 0.95)
    QuickSleep()
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
    ;readjusting position
    goTop(5)
    goRight(5)
    ;start collecting
    goBottom(13)
    goLeft(19)
    goTop(11)
}
collectSecondPointAndGoToZone2() {
    goBottom(15)
    goLeft(26)
    goTop(12)
    goLeft(15)
    goTop(6)
    goBottom(5)
    goLeft(3)
}
collectThirdPoint() {
    ;readjusting position:
    goRight(7)
    goTop(8)
    ;start collecting node
    goBottom(3)
    goLeft(18)
}
collectFourthPoint() {
    goRight(15)
    goBottom(16)
    goLeft(3)
    goBottom(4)
    goLeft(16)
    goTop(5)
    goLeft(13)
    goBottom(11)
    goLeft(4)
}
goToBoss() {
    goRight(3)
    goTop(11)
    goLeft(23)
    goTop(10)
}
killBoss() {
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

collectFifthPointAndExit() {
    goRight(4)
    goTop(10)
    goRight(8)
    goTop(3)
    goRight(8)
    goLeft(8)
    goBottom(3)
    goLeft(11)
    goTop(2)
    LongSleep()
    clickOn(0.8, 0.27) ;nclick yes

    sleep, 30000
    clickOn(0.5, 0.5)
    clickOn(0.5, 0.81) ; click next
    LongSleep()
    clickOn(0.5, 0.5) 
    sleep, 30000
    clickOn(0.5, 0.81) ; click next
    sleep, 30000
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


FastSleep() {
    sleep, 500
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