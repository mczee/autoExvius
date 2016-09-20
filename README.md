# autoExvius
FFExvius AHK macro collection

---

Files:

- MarandaCoast.ahk > Runs solid
- DwarvesCoast.ahk > Runs solid
- Toanngo* > Should work, configure and go

---

Instructions:

- Be able to auto the exploration, if you have problems take 2 healers with LB heals
- Set auto LB to on in options
- Nox
- Game in DPAD, small, right
- AutoHotkey
- Get MarandaCoast.ahk from git
- Run the ahk
- Press CAPSLOCK to open the coord box on the top left
- Edit the file, marked with INPUTS, and change the coord (x0, y0) to your top left corner of the game screen (not including the black bar with battery and wifi), and (x1, y1) to bottom right corner of you game screen
- Edit the timers to your parties kill speed
- Save and F12 to reload the script
- Go to the exploration selection screen -> F8 -> Full run

---

Aralan Instructions:

You need to download GDIP.ahk from here and put it in the same directory as the script, which is here. I'm pretty sure you need to have Nox set to DirectX rendering in order for it to work (with the other option I just got blank screen results), and I'm completely certain it needs to be set to Tablet 1280x720 before you start Exvius. The bot works by checking for pixel colors in certain areas, so if you use a different resolution it will 1) click the wrong spots and 2) probably not click anywhere because it can't figure out what screen it's on.
it uses the default window name for Nox, so on the off chance you changed yours, you'll need to change the WINDOWNAME definition around line 41

Anyway, if you download it and use it:
Start from the screen showing the different stages of whatever area you want to grind
If you're Earth Shrine grinding press F6
if you're Maranda grinding press F7
if you want to restart the script press F9
if you want to close it and can't figure out how to work your mouse press F12
if you want to change these hotkeys look the syntax up on google
That's it! Go do something else!

The preset values will efficiently grind whichever stage until you press F12 or die, connection errors, friend requests, and daily quest popups should all be dealt with automatically. If you want to burn energy initially, set the ENERGYFACTOR to 1, then reload the script with its normal value later. The bot will also grab all the collection points on Maranda after it's done grinding out fights in an area. Also, right now the bot doesn't do anything but click auto during a fight, so you might need a beefy team/Lenna to effectively auto Maranda, I don't know I have both so

It shouldn't be hard to add more stages to this if you're particularly industrious. You should be able to add new areas with just movement parameters for zone entry, grinding oscillation, and collection point hitting 

---

Toanngo Instruction:

Credit: https://www.reddit.com/user/toanngo

- install autohotkey
- save the macro as .ahk file
- double click and run it
- the coordinate will always be shown at top left corner of your screen. You should only care about the first pair (the second pair is relative positioning)
- get the top left (x0, y0) + bottom right (x1, y1) coordinates (DO NOT INCLUDE THE NOX MENUs, JUST INCLUDE THE SCREEN ONLY)
- edit the file and put the coordinate on to the INPUT section
- In the game, select DPAD mode, LARGE, RIGHT
- go to the dwarf's forge selection screen
- F8
- take a break.
- F8 : start macro
- F12: reload + stop

EOF