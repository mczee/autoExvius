#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
 
SendMode Event  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
 
NORESULT = 0
HOMESCREEN = 10
STAGESELECTSCREEN = 11
FRIENDSELECTSCREEN = 12
DEPARTSCREEN = 13
EXPLORATIONSCREEN = 14
BATTLEINITSCREEN = 15 ;The battle screen where Auto isn't clicked
BATTLEAUTOSCREEN = 16 ;The battle screen where Auto is clicked
BATTLEOVERSCREEN = 17 ;The "Results" popup over the main battle screen
VICTORYSCREEN = 18 ;There are a few of these but you can get through all of them the same so who cares
EXPLORATIONPROMPTSCREEN = 19 ;this is the prompt that comes up for bosses, boss results, and leaving, they all have the yes/continue in the same spot
CHARACTERINFOSCREEN = 20
;There's a gap here for other stuff to fill in later, but I wanted to group all the interrupt screens together
FRIENDREQUESTSCREEN = 30
ENERGYREFILLSCREEN = 31
CONNECTIONERRORSCREEN = 32
ITEMSFULLSCREEN = 33
QUESTPOPUPSCREEN = 34
 
;GRINDER CONSTS
EARTHSHRINEGRIND = 50
MARANDAGRIND = 51
 
ENERGYFACTOR = 300000
;ENERGYFACTOR = 300
 
myGrind = nothing
 
;List of location functions for whereAmI
;isConnectionError should always be evaluated first since it'll superimpose on normal screens
locationFuncList = isConnectionError.isHomeScreen.isStageSelectScreen.isFriendSelectScreen.isDepartScreen.isBattleOverScreen
locationFuncList = %locationFuncList%.isExplorationScreen.isBattleInitScreen.isBattleAutoScreen.isVictoryScreen.isQuestPopupScreen
locationFuncList = %locationFuncList%.isExplorationPromptScreen.isFriendRequestScreen.isEnergyRefillScreen.isConnectionErrorScreen.isItemsFullScreen
StringSplit, locationFuncArray, locationFuncList,.,
 
#Include Gdip.ahk
WINDOWNAME = Nox App Player
SetDefaultMouseSpeed, 5
SetKeyDelay, 10, 10
#MaxThreadsPerHotkey 2
CoordMode, Mouse, Relative
Token := Gdip_Startup()
looping = 1
 
DEC2HEX(DEC, RARGB="false") {
    RGB += DEC ;Converts the decimal to hexidecimal
    if(RARGB=="true")
        RGB := RGB & 0x00ffffff
    return RGB
}
findColorInBox(windowBmp,colorcode,tlx,tly){
;Searches a <boxsize> box with tlx,tly being the top left coords
    global WINDOWNAME
    boxsize := 16
    tlx -= %boxsize% // 2
    Loop, %boxsize%{
        Loop, %boxsize%{
            ;Convert the ARGB code from GDIP to RGB hex
            ARGB := GDIP_GetPixel(windowBmp, tlx, tly)
            RGB := DEC2HEX(ARGB, "true")
            if(RGB = colorcode){
                return true
                break 2
            }
            tly += 1
        }
        tly-=boxsize
        tlx+=1
    }
    return false
}
 
;;;;;;values for moving single spaces
;up   : 200,335
;down : 200,405
;left : 180,380
;right: 230,380
;Center: 200,370
moveUp(){
    clickBetter(200,335)
    sleep 300
}
moveLeft(){
    clickBetter(180,380)
    sleep 300
}
moveRight(){
    clickBetter(230,380)
    sleep 300
}
moveDown(){
    clickBetter(200,405)
    sleep 300
}
;moveFull functions press at the edges of the screen for faster distance moving
;They need a longer sleep internally to prevent commands from stacking and ruining
;whatever they were trying to do
moveFullUp(){
    clickBetter(200,65)
    sleep 1500
}
moveFullLeft(){
    clickBetter(5,370)
    sleep 1500
}
moveFullRight(){
    clickBetter(400,370)
    sleep 1500
}
moveFullDown(){
    clickBetter(200,745)
    sleep 1500
}
;Oscillate functions are for exploration grinding
;3 is probably a good number for any, but numberOfRepetitions can be changed if needed
oscillateSideways(numberOfRepetitions:=2){
    Loop %numberOfRepetitions%{
        moveFullRight()
    }
    Loop %numberOfRepetitions%{
        moveFullLeft()
    }
}
oscillateUpDown(numberOfRepetitions:=2){
    Loop %numberOfRepetitions%{
        moveFullUp()
    }
    Loop %numberOfRepetitions%{
        moveFullDown()
    }
}
multiMove(direction,numberOfTimes){
    ;Wrapper for move functions so you don't need to call them 10 times in a row or whatever
    moveFunc = clickCenter ;
    if(direction = "L"){
        moveFunc = moveLeft
    }else if (direction = "R"){
        moveFunc = moveRight
    }else if (direction = "U"){
        moveFunc = moveUp
    }else if (direction = "D"){
        moveFunc = moveDown
    }else if (direction = "FL"){
        moveFunc = moveFullLeft
    }else if (direction = "FR"){
        moveFunc = moveFullRight
    }else if (direction = "FU"){
        moveFunc = moveFullUp
    }else if (direction = "FD"){
        moveFunc = moveFullDown
    }else{
        msgbox there's an error here
        return
    }
    Loop %numberOfTimes%{
        %moveFunc%()
    }
}
pressAuto(){
    ;Presses the auto button on the battle screen, it just reads better like this
    clickBetter(50,730)
}
clickCenter(){
    ;Clicks the center of the screen
    clickBetter(205,390)
}
clickBetter(x, y){ ;Click mouse in target window location
    global WINDOWNAME
    ControlClick , x%x% y%y%, %WINDOWNAME%,,,,NA Pos
    return
}
 
 
;BEGIN THE SCREENSEARCH FUNCTIONS
isConnectionError(windowBmp){
    global
    if(findColorInBox(windowBmp,0x00418E,156,443)){
        if(findColorInBox(windowBmp,0xC7C8C9,344,309)){
            ;;Searches for the OK button and part of the top right corner of the box
            return CONNECTIONERRORSCREEN
        }
    }
    return NORESULT
}
isHomeScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0xDEF5E2,176,711)){
        if(findColorInBox(windowBmp,0x009CD7,127,407)){
            return HOMESCREEN
        }
    }
    return NORESULT
}
;;TODO
isStageSelectScreen(windowBmp){
    ;;This function doesn't work if there's an esper stage in the second slot, oh well who cares
    global
    if(findColorInBox(windowBmp,0xF3F3F3,32,387)){
        if(findColorInBox(windowBmp,0x846C01,42,428)){
            ;; middle of the crossed sword on the second level, part of its bottom gold border
            return STAGESELECTSCREEN
        }
    }
    return NORESULT
}
;;TODO
isFriendSelectScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x001454,295,195)){
        ;;Searches for the sort filter button
        return FRIENDSELECTSCREEN
    }
    return NORESULT
}
;;TODO
isDepartScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x003391,370,155)){
        return DEPARTSCREEN
    }
    return NORESULT
}
isExplorationScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x877048,384,718)){
        ;;Searches for the exploration screen's menu button
        return EXPLORATIONSCREEN
    }
    return NORESULT
}
isExplorationPromptScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x000D30,350,218)){
        if(findColorInBox(windowBmp,0x001242 ,270,165)){
            ;;Searches for the blue of an exploration prompt
            return EXPLORATIONPROMPTSCREEN
        }
    }
    return NORESULT
}
isQuestPopupScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x023C45,200,505)){
        if(findColorInBox(windowBmp,0x0580A12,265,490)){
            ;Middle teal part of quest complete box, part of red Go button
            return QUESTPOPUPSCREEN
        }
    }
    return NORESULT
}
isBattleInitScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x00637F,50,720)){
        if(findColorInBox(windowBmp,0x005E7E,145,720)){
            ;;Searches for unpressed auto and regular colored repeat button
            return BATTLEINITSCREEN
        }
    }
    return NORESULT
}
isBattleAutoScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x002733,150,720)){
        if(findColorInBox(windowBmp,0x0046AF,335,715)){
            ;;Auto changes colors while it's on so search for darkened repeat and the MENU button
            return BATTLEAUTOSCREEN
        }
    }
    return NORESULT
}
isBattleOverScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x001F2E,191,439)){
        if(findColorInBox(windowBmp,0x010608,145,700)){
            ;; Teal in the results loot window, top of the darkened repeat button
            return BATTLEOVERSCREEN
        }
    }
    return NORESULT
}
isFriendRequestScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x005698,130,545)){
        if(findColorInBox(windowBmp,0x7C828A,180,530)){
            ;;Searches for two spots on the "Don't Request" button
            return FRIENDREQUESTSCREEN
        }
    }
    return NORESULT
}
isEnergyRefillScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x002670,160,445)){
        if(findColorInBox(windowBmp,0x570000,240,435)){
            ;;Searches for the NO and YES buttons
            return ENERGYREFILLSCREEN
        }
    }
    return NORESULT
}
;;TODO
isConnectionErrorScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x0F0A0A,375,705)){
        return CONNECTIONERRORSCREEN
    }
    return NORESULT
}
;;TODO
isItemsFullScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x0F0A0A,375,705)){
        return ITEMSFULLSCREEN
    }
    return NORESULT
}
isVictoryScreen(windowBmp){
    global
    if(findColorInBox(windowBmp,0x001144,106,678)){
        if(findColorInBox(windowBmp,0x00104C,306,681)){
            if(findColorInBox(windowBmp, 0x7AE2BB,329,174)){
                ;;The character info screen has some green here, it otherwise hits the qualifiers for victory screen
                return CHARACTERINFOSCREEN
                }
            ;;check for two points on the blue gradient background
            return VICTORYSCREEN
        }
    }
    return NORESULT
}
;END OF SCREENSEARCH FUNCTIONS
 
; The most beautiful function maybe ever?
whereAmI()
{
    global
    local result := NORESULT
    ;Take a snapshot and figure out where the hell we are
    hwnd := WinExist(WINDOWNAME)
    if(hwnd = 0){
        WinGetTitle, winTitle, A
        msgbox Couldn't acquire window handle, check WINDOWNAME and restart script.  The current active window's name is %winTitle%
        exit
    }
    windowBmp := Gdip_BitmapFromHWND(hwnd)
    Loop %locationFuncArray0%
    { ;Loops over all the screens
        thisFunc := locationFuncArray%A_Index%
        result := %thisFunc%(windowBmp)
        ifNotEqual result, %NORESULT%
        {
            Gdip_DisposeImage(windowBmp) ;Make sure this disposes the image on success or failure
            return result
        }
    }
    Gdip_DisposeImage(windowBmp) ;Make sure this disposes the image on success or failure
    return NORESULT
}
 
grindWrapper(){
    ;Here's where we do the stuff like pick a stage, pick a friend, depart, deal with victory etc
    global
    targetLoopTime = 0
    grindFunction = what
    stageY = 280
   
    if(myGrind = EARTHSHRINEGRIND){
        targetLoopTime := 1*ENERGYFACTOR ; 1 energy takes 5 minutes
        grindFunction = earthShrineGrinder
        stageY = 380 ;Select the second stage on the list
    }else if (myGrind = MARANDAGRIND){
        targetLoopTime := 12*ENERGYFACTOR ; 12 energy takes an hour
        grindFunction = marandaGrinder
        stageY = 280 ;Select the first stage on the list
    }
    startTime := A_TickCount
    iWon := false
    while (looping){
        location := whereAmI()
        if(location = STAGESELECTSCREEN){
            if(iWon = true){
                ;Reset iWon, sleep for remainingTime, reset startTime
                iWon := false
                endTime := A_TickCount
                remainingTime := (targetLoopTime - (endTime - startTime))
                if(remainingTime < 5000){
                    remainingTime = 5000
                }
                sleep remainingTime
                startTime := A_TickCount
            }
            clickBetter(200,stageY)
        }else if(location = FRIENDSELECTSCREEN){
            ;Nothing to do here but click
            clickBetter(200,280)
        }else if(location = DEPARTSCREEN){
            ;Click depart and start grinding
            clickBetter(200,640)
            sleep 5000
            %grindFunction%()
        }else if(location = VICTORYSCREEN){
            iWon := true
            ;Two clicks in rapid succession to autodecline friend requests without accidentally clicking through to the wrong stage
            clickBetter(90,550) ;;Don't Request
            clickBetter(205,635) ;;Next
        }else if(location = CONNECTIONERRORSCREEN){
            clickBetter(200,450)
            sleep 5000
        }else if(location = BATTLEINITSCREEN){
            ;I don't know how this happened, maybe there was a connection error?
            ;Call your grind function and hope for the best
            %grindFunction%()
        }else if(location = QUESTPOPUPSCREEN){
            clickBetter(105,480)
        }else if(location = CHARACTERINFOSCREEN){
            ;;I don't know why but sometimes we end up here, just back out
            clickBetter(47,165)
        }else{
            debugline = I don't know where I am oh god: %location%
            sleep 500
        }
        sleep 1000
    }
}
 
explorationFightGrinder(maxFights, oscillationFunction){
    ;In case I forget, I'm reminding myself that if a battle happens while there's still
    ;more oscillation queued, going fulldown just hits the repeat button and doesn't mess anything up
    global
    fightCount := 0
    while (fightCount < maxFights){
        location := whereAmI()
        if(location = BATTLEINITSCREEN){
            ;Increment fightcount, press auto, wait a second
            fightCount+=1
            pressAuto()
            sleep 1000
        }else if (location = BATTLEAUTOSCREEN){
            ;Just hang out
            sleep 1000 
        }else if (location = EXPLORATIONSCREEN){
            %oscillationFunction%()
        }else if (location = BATTLEOVERSCREEN){
            clickCenter()
        }
    }
    location := whereAmI()
    while(location != EXPLORATIONSCREEN){
        sleep 1000
        location := whereAmI()
        clickCenter() ;maybe this'll help
    }
}
 
explorationBossLoop(){
    global
    sleep 6000
    clickBetter(320,230) ;  Click yes at 320,230
    sleep 6000
    clickCenter()
    sleep 6000
    location := whereAmI()
    while (location <> EXPLORATIONPROMPTSCREEN){
        if(location = BATTLEINITSCREEN){
            pressAuto()
           
        }else{
            ; click the center because whatever I guess
            clickCenter()
        }
        sleep 5000
        location := whereAmI()
    }
    clickBetter(345,230) ;click Continue
    sleep 5000
}
 
earthShrineGrinder(){
    global ;Needed for screen constants
    ;This one's easy
    missCount = 0
    Loop{
        location := whereAmI()
        if(location = BATTLEINITSCREEN){
            ;press auto, wait a second
            pressAuto()
        }else if (location = BATTLEAUTOSCREEN){
            sleep 1000
        }else{
            if(missCount > 3){
                break ;Just as soon as it's not a battle screen anymore, back to the wrapper
            }
            missCount+=1
        }
        sleep 1500
    }
}
 
marandaGrinder(){
    global ;Needed for screen constants
    multiMove("D",5) ;Enter Zone 1
    explorationFightGrinder(15, "oscillateSideways")
    sleep 5000
    ;Path to start point
    multiMove("FL",3)
    multiMove("FU",1)
    ;Z1 top right to Collection 1:
    multiMove("FL",3)
    multiMove("D",8)
    multiMove("L",13)
    multiMove("FU",3) ; Character should be offcenter toward the top of the screen here
    clickBetter(5,340) ; Full left of where the character should be, hit the collection point
    sleep 1000
    ;Collection 1 to Collection 2:
    clickBetter(200,420) ; Moves down, view recenters
    sleep 1000
    multiMove("D",9)
    multiMove("FL",2)
    multiMove("FD",1)
    multiMove("FL",4)
    multiMove("FU",2)
    multiMove("FL",3)
    moveFullUp() ; Collection point 2 hit
    ;Collection 2 to Zone 2
    moveFullDown()
    multiMove("U",3)
    moveFullLeft()
    sleep 3000
    multiMove("L",3) ; move into position for Zone 2 grinder
    explorationFightGrinder(14, "oscillateUpDown")
    sleep 5000
    multiMove("FU",4) ; Move into starting position for pathing
    ;Zone2 to Collection 1
    multiMove("FL",4)
    moveFullDown() ; Collection point three hit
    ;Collection 3 to 4
    multiMove("R",15)
    multiMove("FD",3)
    moveFullLeft()
    multiMove("D",4)
    multiMove("FL",4)
    multiMove("U",6)
    multiMove("L",13)
    multiMove("D",12)
    moveFullLeft() ; Collection point four hit
    ;Collection 4 to boss
    moveFullRight()
    multiMove("FU",2)
    multiMove("FL",7)
    multiMove("U",5)
    ;React to boss prompt:
    explorationBossLoop()
    ;Boss to collection 5
    multiMove("FR",2)
    multiMove("FU",2)
    multiMove("FR",2)
    moveFullUp() ; Should be offcentered to the top
    clickBetter(400,215) ; Special case full right move
    sleep 1250
    clickBetter(400,215) ; Special case full right move
    sleep 1250
    moveFullDown() ; Collection point five hit
    ;Collection 5 to exit
    clickBetter(10,260) ; special case full left move
    sleep 1250
    clickBetter(10,260) ; special case full left move
    sleep 1250
    moveFullDown()
    multiMove("FL",2)
    multiMove("L",2)
    multiMove("FU",2)
    ;React to exit:
    sleep 1000
    clickBetter(320,230) ; click yes at 320,230
}
 
F11::
whereAmI()
return
F6:: ;EARTH SHRINE INITIALIZER
myGrind := EARTHSHRINEGRIND
grindWrapper()
return
 
F7:: ;MARANDA GRIND INITIALIZER
myGrind := MARANDAGRIND
grindWrapper()
return
 
F9:: ;;Reload, breaks everything
Gdip_shutdown(Token)
Reload
Sleep 3000 ; If successful, the reload will happen during this sleep, else the msgbox will pop up
MsgBox, Whoops the script didn't reload, careful it's still running
return
 
F12::
Gdip_shutdown(Token)
exit