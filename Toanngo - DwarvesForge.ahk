------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; only one instance of script can run
#Persistent ; to make it run indefinitely

SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

;=====INPUTS=====;
x0y0 := [318, 175]
x1y1 := [725, 896]
; time is in seconds
zone1Time := 900 ; = 15min, 720 = 12 min
zone2Time := 900 ; = 15min
estimateTimeToKillBoss := 60 ; = 1min
delayBetweenMacros := 300 ; = 5 min

; ADVANCED INPUTS
; 0 means default value. I'm hopeful that the defaults work for you.
; Only change these if the defaults don't work.
dpadCenter := [0, 0] ; this is the coordination of the center of the dpad
dpadRightArrowX := 0 ; this is the x-coordination ONLY of the right arrow on the dpad

explorationSelectionFirstRow := [0, 0] ; the first row on the exploration, same for first row on friends

topRightCorner := [0, 0] ; the top right corner of the screen
bottomLeftCornerAndAuto := [0. 0] ; bottom left corner, make sure it clicks the auto button as well

departButton := [0, 0]

bossYesButton := [0, 0]
bossContinueButton := [0, 0]

endScreenNextButton := [0, 0]
;===END_INPUTS===;


; Processing inputs:
origin := new Point(x0y0[1], x0y0[2])
width := x1y1[1] - origin.x
height := x1y1[2] - origin.y

if(dpadCenter[1] <> 0) {
    dpadCenter := getRelativePoint(new Point(dpadCenter[1], dpadCenter[2]))
    dpadRadius := dpadRightArrowX - dpadCenter[1]
    dpad := new Controller(dpadCenter, dpadRadius / width, dpadRadius / height)
} else {
    dpad := new Controller(new RelativePoint(0.68, 0.78), 0.2, 0.1)
}

firstRow := explorationSelectionFirstRow[1] <> 0 
    ? getRelativePoint(new Point(explorationSelectionFirstRow[1], explorationSelectionFirstRow[2])) 
    : new RelativePoint(0.5, 0.35)

topRight := topRightCorner[1] <> 0 
    ? getRelativePoint(new Point(topRightCorner[1], topRightCorner[2])) 
    : new RelativePoint(0.97, 0.05)

bottomLeft := bottomLeftCornerAndAuto[1] <> 0 
    ? getRelativePoint(new Point(bottomLeftCornerAndAuto[1], bottomLeftCornerAndAuto[2])) 
    : new RelativePoint(0.05, 0.97)

depart := departButton[1] <> 0 
    ? getRelativePoint(new Point(departButton[1], departButton[2])) 
    : new RelativePoint(0.5, 0.85)

yesButton := bossYesButton[1] <> 0
    ? getRelativePoint(new Point(bossYesButton[1], bossYesButton[2]))
    : new RelativePoint(0.8, 0.25)

continueButton := bossContinueButton[1] <> 0
    ? getRelativePoint(new Point(bossContinueButton[1], bossContinueButton[2]))
    : new RelativePoint(0.8, 0.275)

nextButton := endScreenNextButton[1] <> 0
    ? getRelativePoint(new Point(endScreenNextButton[1], endScreenNextButton[2]))
    : new RelativePoint(0.5, 0.8)

settimer showToolTip, 0 ;"0" to make it update position instantly
return

showToolTip:
CoordMode, ToolTip, Screen ; makes tooltip to appear at position, relative to screen.
CoordMode, Mouse, Screen ; makes mouse coordinates to be relative to screen.
MouseGetPos xx, yy ; get mouse x and y position, store as %xx% and %yy%
p := getRelativePoint(new Point(xx, yy)) 
px := p.px
py := p.py
tooltip (%xx% %yy%) (%px% %py%), 0, 0
return

f12::reload ;reloads script if an error occurs

F8::
{       
    global zone1Time, zone2Time, delayBetweenMacros
    while (true)
    {
        enterExploration()
        collectNode1AndMoveToZone1()
        clearZone(zone1Time)
        collectNode2()
        collectNode3()
        goToZone2()
        clearZone(zone2Time)
        collectNode4()
        goToBoss()
        killBoss()
        collectNode5AndExit()
        sleepFor(delayBetweenMacros)
    }
}

F9::
{
    global zone1Time
    clearZone(zone1Time)
}

F10::
{
    collectNode5AndExit()
}

enterExploration() {
    global firstRow, depart
    clickOn(firstRow) ; select exploration
    sleepFor(5)
    clickOn(firstRow) ; select friend
    sleepFor(5)
    clickOn(depart) ; depart
    sleepFor(20)
}

collectNode1AndMoveToZone1() {
    global dpad
    dpad.up(7)
    dpad.right(12)
    dpad.down(8)
    dpad.up(9)
    dpad.left(12)
    dpad.up(14)
    sleepFor(3)
}

collectNode2() {
    global dpad
    dpad.left(4)
    dpad.down(5)
    dpad.up(29)
}

collectNode3() {
    global dpad
    dpad.down(13)
    dpad.left(17)
    sleepFor(3)
    dpad.left(10)
    dpad.up(1)
    dpad.left(7)
    dpad.down(19)
    sleepFor(3)
    dpad.down(2)
    dpad.right(19)
    dpad.down(9)
    dpad.left(6)
    dpad.down(1)
    dpad.left(5)
    dpad.top(2)
    dpad.left(5)
    dpad.top(4)
    sleepFor(3)
    dpad.left(11)
    dpad.top(2)
}

goToZone2() {
    global dpad
    dpad.right(22)
    dpad.top(2)
    dpad.right(1)
    sleepFor(3)
    dpad.right(12)
    sleepFor(3)
    dpad.right(32)
    sleepFor(3)
    dpad.right(12)
    sleepFor(3)
    dpad.right(9)
    dpad.down(5)
    sleepFor(3)
    dpad.left(17)
    dpad.up(6)
    dpad.right(19)
    dpad.up(6)
    sleepFor(3)
    dpad.up(28)
    dpad.right(1)
    dpad.up(13)
    sleepFor(3)
    dpad.left(2)
}

collectNode4() {
    global dpad
    dpad.left(4)
    dpad.down(5)
    dpad.right(4)
    dpad.up(18)
    dpad.left(2)
    dpad.up(10)
    sleepFor(3)
    dpad.up(9)
    dpad.right(7)
}

goToBoss() {
    global dpad
    dpad.left(7)
    dpad.down(11)
    sleepFor(3)
    dpad.down(6)
    dpad.left(5)
    sleepFor(3)
    dpad.left(18)
    dpad.up(9)
    sleepFor(3)
    dpad.up(7)
    sleepFor(3)
}

killBoss() {
    global yesButton, topRight, bottomLeft, estimateTimeToKillBoss, continueButton
    clickOn(yesButton)
    sleepFor(10)
    clickOn(topRight)
    sleepFor(10)
    clickOn(bottomLeft)
    sleepFor(estimateTimeToKillBoss)
    clickOn(bottomLeft)
    sleepFor(5)
    clickOn(bottomLeft)
    sleepFor(5)
    clickOn(continueButton)
    sleepFor(10)
}

collectNode5AndExit() {
    global dpad, continueButton, topRight, nextButton
    dpad.up(1)
    dpad.left(14)
    sleepFor(3)
    dpad.left(5)
    dpad.up(8)
    dpad.right(6)
    dpad.up(3)
    dpad.down(3)
    dpad.left(6)
    dpad.down(6)
    dpad.right(7)
    sleepFor(3)
    dpad.right(12)
    dpad.top(7)
    sleepFor(5)
    clickOn(continueButton) ;nclick yes
    sleepFor(30)
    clickOn(topRight)
    sleepFor(2)
    clickOn(nextButton) ; click next
    sleepFor(5)
    clickOn(topRight) 
    sleepFor(30)
    clickOn(nextButton) ; click next
}

clearZone(time) {
    global topRight, bottomLeft
    Timer("ZoneClearTime", time * 1000)
    while (Timer("ZoneClearTime") <> true)
    {
        clickOn(topRight)
        sleepFor(1)
        clickOn(bottomLeft)
        sleepFor(1)
    }
}

Timer(Timer_Name := "", Timer_Opt := "D") {
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

class Point {
    __New(x, y) {
        this.x := x
        this.y := y
    }
}

class RelativePoint {
    __New(px, py) {
        this.px := px
        this.py := py
    }
}

class Controller {  
    static controllerDelay = 0.5
    __New(relativeCenterPoint, xRelativeOffset, yRelativeOffset) {
        this.relativeCenter := relativeCenterPoint
        this.offSet := new RelativePoint(xRelativeOffset, yRelativeOffset)
    }

    go(dir, steps) {
        px := this.relativeCenter.px
        py := this.relativeCenter.py
        if(dir = "top" or dir = "up") {
            py := py - this.offset.py
        } else if(dir = "bottom" or dir = "down") {
            py := py + this.offset.py
        } else if(dir = "left") {
            px := px - this.offset.px
        } else if(dir = "right") {
            px := px + this.offset.px
        } 
        Loop, %steps% {
            dragRelative(this.relativeCenter, new RelativePoint(px, py))
            sleepFor(this.controllerDelay)
        }
    }

    up(steps) {
        this.go("up", steps)
    }
    top(steps) {
        this.go("up", steps)
    }
    down(steps) {
        this.go("down", steps)
    }
    bottom(steps) {
        this.go("down", steps)
    }
    left(steps) {
        this.go("left", steps)
    }
    right(steps) {
        this.go("right", steps)
    }
}

getRelativePoint(point) {
    global width, height, origin
    return new RelativePoint((point.x - origin.x) / width, (point.y - origin.y) / height)
}

dragRelative(from, to) {
    global origin, width, height
    MouseClickDrag, Left, origin.x + from.px * width, origin.y + from.py * height, origin.x + to.px * width, origin.y + to.py * height  
}

clickOn(p) {
    global origin, width, height
    MouseClick, left, origin.x + p.px * width, origin.y + p.py * height, 1, 0
}

sleepFor(seconds) {
    sleep, seconds * 1000
}