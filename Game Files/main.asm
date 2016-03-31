;Simon Final 12/1/2015
;Chris Potter, Maya Bloom, Jonathan Keys
;Assembly, Professor Suresh

TITLE Simon

.386 
.MODEL FLAT, STDCALL
OPTION CASEMAP:none 

;-------LIBRARIES USED--------------------------------------------
INCLUDELIB winmm.lib
INCLUDELIB user32.lib 
INCLUDELIB kernel32.lib 
INCLUDELIB gdi32.lib  
INCLUDE macros.inc
INCLUDE \masm32\INCLUDE\Irvine32_NOWIN.inc
INCLUDE \masm32\INCLUDE\windows.inc 
INCLUDE \masm32\INCLUDE\user32.inc 
INCLUDE \masm32\INCLUDE\kernel32.inc 
 
.data

;--------------SOUND VARIABLE FILES-----------------------------------
BeepGreen1 BYTE "GreenBeep1.wav",0			;File location and variable for Green beep 1
BeepGreen2 BYTE "GreenBeep2.wav",0			;File location and variable for Green beep 2
BeepGreen3 BYTE "GreenBeep3.wav",0			;File location and variable for Green beep 3
BeepRed1 BYTE "RedBeep1.wav",0				;File location and variable for Red beep 1
BeepRed2 BYTE "RedBeep2.wav",0				;File location and variable for Red beep 2
BeepRed3 BYTE "RedBeep3.wav",0				;File location and variable for Red beep 3
BeepBlue1 BYTE "BlueBeep1.wav",0			;File location and variable for Blue beep 1
BeepBlue2 BYTE "BlueBeep2.wav",0			;File location and variable for Blue beep 2
BeepBlue3 BYTE "BlueBeep3.wav",0			;File location and variable for Blue beep 3
BeepYellow1 BYTE "YellowBeep1.wav",0		;File location and variable for Yellow beep 1
BeepYellow2 BYTE "YellowBeep2.wav",0		;File location and variable for Yellow beep 2
BeepYellow3 BYTE "YellowBeep3.wav",0		;File location and variable for Yellow beep 3
BeepGameOver BYTE "GameOverSound.wav",0		;File location and variable for Game Over beep
BeepSplash BYTE "SpashScreen.wav",0			;File location and variable for Splash Screen beep

NULL equ 0
SND_ASYNC equ 1h
SND_FILENAME equ 20000h
PlaySound PROTO STDCALL :dword, :dword, :dword
ExitProcess PROTO STDCALL :DWORD


;--------------MOUSE CLICK VARIABLES AND STRINGS-------------- THANKS TO JAY RUSSO FOR ALL INFORMATION AND SNIPPETS/LIBRARIES FOR MOUSE CLICKS
rHnd HANDLE ?				;Jays Code
numEventsRead DWORD ?		;Jays Code
numEventsOccurred DWORD ?	;Jays Code
eventBuffer INPUT_RECORD 128 DUP(<>)	;Jays Code

;--------------MOUSE CLICK COORDINATE VARIABLES-------------------
XCord DWORD ?				;Variable holder for X Coordinate
YCord DWORD ?				;Variable holder for Y Coordinate

;--------------MOUSE CLICK COORDINATE VARIABLES COLORS-------------
XGreen DWORD 33				;Right hand X Coordinate of Green button
YGreen DWORD 16				;Bottom Y Coordinate of Green button

XRed DWORD 34				;Left hand X Coordinate of Red button
YRed DWORD 16				;Bottom Y Coordinate of Red button

XYellow DWORD 33			;Right hand X Coordinate of Blue button
YYellow DWORD 17			;Top Y Coordinate of Blue button

XBlue DWORD 34				;Left hand Y Coordinate of Yellow button
YBlue DWORD 17				;Top Y Coordinate of Yellow button

;--------------MOUSE CLICK COORDINATE VARIABLES START SCREEN-------
YStartBoardT DWORD 8		;Top Y Coordinate of all buttons
YStartBoardB DWORD 12		;Bottom Y Coordinate of all buttons

XStartL DWORD 3				;Left hand X Coordinate of Start button
XStartR DWORD 20			;Right hand X Coordinate of Start button

XHelpL DWORD 25				;Left hand X Coordinate of Help button
XHelpR DWORD 42				;Right hand X Coordinate of Help button

XExitL DWORD 47				;Left hand X Coordinate of Exit button
XExitR DWORD 64				;Right hand X Coordinate of Exit button

;--------------START SCREEN TEXT-----------------------------------
playStr db "PLAY",0			;Text for start screen of play button
helpStr db "HELP",0			;Text for start screen of help button
exitStr db "EXIT",0			;Text for start screen of exit button

;--------------START SCREEN VARIABLES FOR TEXT---------------------
StartGamePlay DWORD 1		;Value of Start button is equal to 1
StartGameHelp DWORD 2		;Value of Help button is equal to 2
StartGameExit DWORD 3		;Value of Exit button is equal to 3
UserInputValue DWORD ?		;Variable which is passed either 1,2, or 3 and calls the correct procedure with it

;--------------DIRECTION SCREEN STRINGS----------------------------
helpStr1_1 db "WELCOME TO SIMON!",0
helpStr2_1 db "A game that tests your wits, your Strength",0
helpStr2_2 db "and most importantly your MEMORY!",0
helpStr3_1 db "When you hit PLAY a circular board of awesomenss",0
helpStr3_2 db "will show on your screen.",0
helpStr4_1 db "Simon will light up one color. Remember it. Then tell Simon, by",0
helpStr4_2 db "clicking on the color, what color was just lit.",0
helpStr4_3 db "Congratulations you have now completed round 1.",0
helpStr5_1 db "Round 2 will show you the same color from round 1,",0
helpStr5_2 db "then add another color to remember.",0
helpStr6_1 db "Remember the colors and the order presented. Then by clicking",0
helpStr6_2 db "the colors, in order, tell Simon what colors it just told you.",0
helpStr7_1 db "Each round will progress the same way.",0

;--------------START SCREEN BOARD VARIABLES--------------
sTotalSize = 884		;total size of board
sW db 68				;total width of board
sWTracker db 0			;to keep track of width posistion
sH db 13				;total height of board
sHTracker db 0			;to keep track of heigh posistion

StartScreen	BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,9,9,9,0,0,9,9,9,9,9,9,0,9,9,9,9
			BYTE 9,9,0,0,9,9,9,9,9,9,9,9,9,9,0,0,9,9,9,9,0,0,0,9,9,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,0,0,9,9,9,0,0,9,9,9,0,9,9,0,9,9,0,9
			BYTE 9,9,0,0,9,9,9,0,0,0,0,9,9,9,0,0,9,9,0,9,9,0,0,9,9,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,0,0,9,9,9,0,0,9,9,9,0,9,9,9,9,9,0,9
			BYTE 9,9,0,0,9,9,9,0,0,0,0,9,9,9,0,0,9,9,0,0,9,9,0,9,9,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,0,0,9,9,9,0,0,9,9,9,0,0,9,9,9,0,0,9
			BYTE 9,9,0,0,9,9,9,9,9,9,9,9,9,9,0,0,9,9,0,0,0,9,9,9,9,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,9,9,9,9,9,9,9,9,9
			BYTE 9,9,9,9,9,9,9,9,9,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0
			BYTE 0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0,0,9,9,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,9,9,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0
			BYTE 0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0,0,9,9,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,9,9,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0
			BYTE 0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0,0,9,9,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,9,9,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0
			BYTE 0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,9,9,9,9,9,9,9,9,9
			BYTE 9,9,9,9,9,9,9,9,9,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0

;--------------BOARD SCREEN VARIABLES---------------------
w db 68				;total width of board
wTracker db 0		;width tracker val
h db 36				;total height of board
hTracker db 0		;height tracker val
totalSize = 2378	;total size of board
TestBoard	BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0
			BYTE 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0
			BYTE 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0
			BYTE 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
			BYTE 0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0
			BYTE 0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0
			BYTE 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0
			BYTE 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,9,9,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0
			BYTE 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,9,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
			BYTE 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,9,9,0,9,0,9,9,0
			BYTE 9,9,0,9,9,9,0,9,9,9,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
			BYTE 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,9,0,9,0,9,0,9
			BYTE 0,9,0,9,0,9,0,9,0,9,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,9,0,9,0,0
			BYTE 0,9,0,9,9,9,0,9,0,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
			BYTE 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
			BYTE 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
			BYTE 0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0
			BYTE 0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0
			BYTE 0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0
			BYTE 0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0
			BYTE 0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0
			BYTE 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0
			BYTE 0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,5,0,0
			BYTE 0,0,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;--------------VARIABLES FOR BUTTONS----------------------------------------
GreenButton EQU 0			;Green Button is equal to value 0
RedButton EQU 1				;Red Button is equal to value 1
YellowButton EQU 2			;Yellow Button is equal to value 2
BlueButton EQU 3			;Green Button is equal to value 3

;--------------ARRAYS FOR USER AND AI INPUT---------------------------------
AIInputs DWORD 50 DUP(0)	;AI input array
UserInputs DWORD 50 DUP(0)	;User input array

;--------------VARIABLES GAME LOGIC AND TRACKING----------------------------
Turn DWORD 0				;Used to hold the array location value for each run
Again DWORD 1				;Used (never changed) to check against 'ReRun' to decided whether to run game logic again
ReRun DWORD ?				;Used to aginst 'Again' to check wether to loop or not
Run DWORD 1					;Used to keep track of how many iterations the game has gone through
Score DWORD -1				;Score tracker, starts at -1 but at first start of game it bumps up to 0 and then keeps track from there
HighScore DWORD 0			;High Score Tracker, starts at 0 and stacks the user score if it is greater than current highest score
HighScoreStr BYTE "High Score: ",0

;--------------VARIABLES FOR WHETHER USER OR AI IS PRESSING BUTTONS----------
AIPress DWORD 0				;AI press of button is equal to 0
UserPress DWORD 1			;User press of button is equal to 1
ButtonPressVal DWORD ?		;Is passed either AIPress or UserPress to track which use is pressing buttons

;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;-------------------------------START OF CODE-------------------------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
.code
main PROC
	Call Randomize
			;--------------Start Of Game----------------------------;
			;Calls and prints the start screen, and then calls to	;
			;receive the users input, executing which ever option	;
			;they chose.											;
			;--------------Start Of Game----------------------------;
	
	StartOfGame:
		Call PrintStartScreen
		Call StartScreenInput
			;--------------Simon------------------------------------;
			;Calls AI to receive it's input as well as color		;
			;clicks, then calls the user which does the same, as	;
			;well as checks the values aginst AI to make sure		;
			;they are correct. After it checks wether it was passed	;
			;a wether it was correct or not and then either jumps	;
			;to redo Simon (pass) or jumps to Fail (fail).			;
			;--------------Simon------------------------------------;
	Simon:
		Call AI
		Call User
		Call CheckRedo

		cmp eax, Again
		je Simon
		jne Fail
			;--------------Fail-------------------------------------;
			;When user fails it will execute and call GameIsOver	;
			;and then jumps back to the StartOfGame to get back to	;
			;the home screen where the user can exit or play again.	;
			;--------------Fail-------------------------------------;
	Fail:
		Call GameIsOver
		jmp StartOfGame
exit
main ENDP
			;--------------CheckRedo--------------------------------;
			;Checks redo calls a delay to make the AI not run right	;
			;after the user is done clicking and then adds 1 to Run	;
			;as a tracker for the game, as well as turn which is a	;
			;tracker for all arrays.								;
			;--------------CheckRedo--------------------------------;
CheckRedo PROC
	;	mov eax, 1000
	;	call Delay
		add Run, 1
		add Turn, 4
		mov eax, ReRun
		ret
CheckRedo ENDP
			;--------------GameIsOver-------------------------------;
			;Flashes the board quickly 10 times when the user fails	;
			;and then plays a fail sound and calls ClearHouse to	;
			;clear all variables to how they were at first run.		;
			;--------------GameIsOver-------------------------------;
GameIsOver PROC
	mov ecx, 4	;MUST BE EVEN
	FlashBoard:
		push ecx
		call changeGreen
		call changeYellow
		call changeRed
		call changeBlue
		call printColoredBoard
		invoke PlaySound, OFFSET BeepGameOver, NULL, SND_FILENAME
		pop ecx
	loop FlashBoard
	mov eax, 300
	Call ClearHouse
	ret
GameIsOver ENDP
			;--------------ClearHouse-------------------------------;
			;Restores all varaibles to how they would be when the	;
			;program is first exectuted, as well as clearing all	;
			;the arrays used.										;
			;--------------ClearHouse-------------------------------;
ClearHouse PROC
	mov Turn, 0
	mov Again, 1
	mov ReRun, 0
	mov eax, Score
	cmp eax, HighScore
	jle NotNewHigh
	mov HighScore, eax
	NotNewHigh:
	mov Score, -1
	mov Run, 1
	mov ecx, lengthof UserInputs
	mov edi, 0
	L2:
		mov UserInputs[edi], 0
		mov AIInputs[edi], 0
		add edi, 4
	loop L2
	ret
ClearHouse ENDP
			;--------------StartScreenInput-------------------------;
			;Run when input is desired on the Start Screen. It will	;
			;receive a users mouse click and use the coordinate		;
			;values of each button to determine which button the	;
			;user clicked. Then it will jump to the correct label	;
			;which holds the procedure which needs to be executed.	;
			;--------------StartScreenInput-------------------------;
StartScreenInput PROC
	StartOfClick:
		Call GetButtonClick
	YValChecks1:
		mov eax, YStartBoardT
		cmp YCord, eax
		jge YValChecks2
		jl StartOfClick
		YValChecks2:
			mov eax, YStartBoardB
			cmp YCord, eax
			jle StartButton1
			jg StartOfClick
	StartButton1:
		mov eax, XStartL
		cmp XCord, eax
		jge StartButton2
		jl StartOfClick
		StartButton2:
			mov eax, XStartR
			cmp XCord, eax
			jle StartButtonPress
			jg HelpButton1
			StartButtonPress:
				mov UserInputValue, 1
				jmp ContinueStartScreen
		HelpButton1:
			mov eax, XHelpL
			cmp XCord, eax
			jge HelpButton2
			jl StartOfClick
			HelpButton2:
				mov eax, XHelpR
				cmp XCord, eax
				jle HelpButtonPress
				jg ExitButton1
				HelpButtonPress:
					mov UserInputValue, 2
					jmp ContinueStartScreen
		ExitButton1:
			mov eax, XExitL
			cmp XCord, eax
			jge ExitButton2
			jl StartOfClick
			ExitButton2:
				mov eax, XExitR
				cmp XCord, eax
				jle ExitButtonPress
				jg StartOfClick
				ExitButtonPress:
					mov UserInputValue, 3
					jmp ContinueStartScreen
		ContinueStartScreen:
		mov eax, UserInputValue
		cmp StartGamePlay, eax
		je GamePlay
		cmp StartGameHelp, eax
		je Directions
		cmp StartGameExit, eax
		je ExitGame
	GamePlay:
		ret
	Directions:
		call DisplayHelp
		jmp StartOfClick
	ExitGame:
		mov dh, 1
		mov dl, 1
		call Gotoxy
		mov eax, black
		call SetTextColor
		INVOKE ExitProcess, 0
		ret
StartScreenInput ENDP
			;--------------ScorePrint-------------------------------;
			;Outputs the score to the simon baord in the middle		;
			;using gotoxy.											;
			;--------------ScorePrint-------------------------------;
ScorePrint PROC
	mov eax, white
	call SetTextColor
	mov dh,18
	mov dl, 28
	call Gotoxy
	mov edx, offset HighScoreStr
	call WriteString
	mov eax, HighScore
	Call WriteDec
	mov dh,	19		;row
	mov dl,	34		;col
	call Gotoxy
	mov eax, Score
	Call WriteDec
	mov eax, black
	call SetTextColor
	ret
ScorePrint ENDP
			;--------------AI---------------------------------------;
			;First increments Score by 1, as it runs each time the	;
			;user passes their turn. Then calls RandomRange to find	;
			;the random button it will choose and puts it in the	;
			;array. Loop Simon runs which presses the button and	;
			;highlights them for each value which the AI has ever	;
			;picked. It loops for the variable run which keeps		;
			;track of how many values the AI has picked so far.		;
			;--------------AI---------------------------------------;
AI PROC
	mov eax, 500
	Call Delay
	add Score, 1
	mov esi, Turn
	mov eax, 4
	Call RandomRange
	mov AIInputs[esi], eax
	mov edi, 0
	mov ecx, Run
	Simon:
		push ecx
		mov ebx, AIPress
		mov ButtonPressVal, ebx
		Call ButtonPress
		add edi, 4
		pop ecx
	loop Simon
	ret
AI ENDP
			;--------------User-------------------------------------;
			;User starts with a loop for however many variables the	;
			;user will need to input. It calls UserMouseClick to	;
			;check which buttont he user clicks and then highlights	;
			;it. It then checks the values from ValuesCheck and		;
			;depending on the return of that is wether the loop		;
			;loops again for next input, or skips the loop to jump	;
			;to the GameOver procedure.								;
			;--------------User-------------------------------------;
User PROC
	mov edi, 0
	mov ecx, Run
	L2:
		push ecx
		push edi
		Call UserMouseClick
		pop edi
		mov ebx, UserPress
		mov ButtonPressVal, ebx
		Call ButtonPress
		Call ValuesCheck
		add edi, 4
		pop ecx
		mov eax, ReRun
		cmp eax, Again
		jne Endloop
	loop L2
	Endloop:
	ret
User ENDP

UserMouseClick PROC
	Call GetButtonClick
		mov eax, XGreen
		cmp XCord, eax
		jle NextGreen
		jg NextRed
			NextGreen:
				mov eax, YGreen
				cmp YCord, eax
				jle GreenClick
				jg BlueClick
					GreenClick:
						mov UserInputs[edi], 0
						jmp ContinueUser
					BlueClick:
						mov UserInputs[edi], 2
						jmp ContinueUser
			NextRed:
				mov eax, YRed
				cmp YCord, eax
				jle RedClick
				jg YellowClick
				RedClick:
					mov UserInputs[edi], 1
					jmp ContinueUser
				YellowClick:
					mov UserInputs[edi], 3
					jmp ContinueUser
		ContinueUser:
	ret
UserMouseClick ENDP
			;--------------ValuesCheck------------------------------;
			;Values check will take in AIInput array and the User	;
			;Input arrya. it will then compare them and depending	;
			;whether it fails or not it will either exit with a		;
			;fail escape variable or a pass variable to let the		;
			;previous procedure which called it decide what to do	;
			;with it.												;
			;--------------ValuesCheck------------------------------;
ValuesCheck PROC
	mov eax, AIInputs[edi]
	mov ebx, UserInputs[edi]
	cmp eax, ebx
	je Pass
	jne Fail
	Pass:
		mov ReRun, 1
		jmp Continueloop
	Fail:
		mov ReRun, 0
		mov ecx, 0
		jmp Continueloop
	Continueloop:
		add esi, 4
	CheckComplete:
	ret
ValuesCheck ENDP
			;--------------ButtonPress------------------------------;
			;Receives a ButtonPressVal to figure wether the AI or	;
			;the User called the procedure. Then it take the value	;
			;from the array (user or AI's array) and has a couple	;
			;conditional functions to decide which button was		;
			;pressed. Then it calls to highlight the color as well	;
			;as output a sound with it.								;
			;--------------ButtonPress------------------------------;
ButtonPress PROC	
	mov eax, ButtonPressVal
	cmp eax, AIPress
	je AIButtonPress
	cmp eax, UserPress
	je UserButtonPress
	UserButtonPress:
		mov eax, UserInputs[edi]
		jmp ContinueButtonPress
	AIButtonPress:
		mov eax, AIInputs[edi]
		jmp ContinueButtonPress
	ContinueButtonPress:
		cmp eax, 4
		jge ButtonFinish
		cmp eax, -1
		jle ButtonFinish
	GreenCheck:
		cmp eax, GreenButton
		je GreenChoice
		jne BlueCheck
			BlueCheck:
				cmp eax, BlueButton
				je BlueChoice
				jne RedCheck
					RedCheck:
						cmp eax, RedButton
						je RedChoice
						jne YellowCheck
							YellowCheck:
								cmp eax, YellowButton
								je YellowChoice
								Jne Impossible
	GreenChoice:
		call changeGreen
		call printColoredBoard
		mov eax, Score
		cmp eax, 14
		jge OverFourteenG
		cmp eax, 6
		jge OverSixG
		invoke PlaySound, OFFSET BeepGreen1, NULL, SND_FILENAME
		jmp SoundPlayedG
		OverSixG:
		invoke PlaySound, OFFSET BeepGreen2, NULL, SND_FILENAME
		jmp SoundPlayedG
		OverFourteenG:
		invoke PlaySound, OFFSET BeepGreen3, NULL, SND_FILENAME
		SoundPlayedG:
		call changeGreen
		call printColoredBoard
		jmp ButtonFinish
			YellowChoice:
				call changeYellow
				call printColoredBoard
				mov eax, Score
				cmp eax, 14
				jge OverFourteenY
				cmp eax, 6
				jge OverSixY
				invoke PlaySound, OFFSET BeepYellow1, NULL, SND_FILENAME
				jmp SoundPlayedY
				OverSixY:
				invoke PlaySound, OFFSET BeepYellow2, NULL, SND_FILENAME
				jmp SoundPlayedY
				OverFourteenY:
				invoke PlaySound, OFFSET BeepYellow3, NULL, SND_FILENAME
				SoundPlayedY:
				call changeYellow
				call printColoredBoard
				jmp ButtonFinish
					RedChoice:
						call changeRed
						call printColoredBoard
						mov eax, Score
						cmp eax, 14
						jge OverFourteenR
						cmp eax, 6
						jge OverSixR
						invoke PlaySound, OFFSET BeepRed1, NULL, SND_FILENAME
						jmp SoundPlayedR
						OverSixR:
						invoke PlaySound, OFFSET BeepRed2, NULL, SND_FILENAME
						jmp SoundPlayedR
						OverFourteenR:
						invoke PlaySound, OFFSET BeepRed3, NULL, SND_FILENAME
						SoundPlayedR:
						call changeRed
						call printColoredBoard
						jmp ButtonFinish
							BlueChoice:
								call changeBlue
								call printColoredBoard
								mov eax, Score
								cmp eax, 14
								jge OverFourteenB
								cmp eax, 6
								jge OverSixB
								invoke PlaySound, OFFSET BeepBlue1, NULL, SND_FILENAME
								jmp SoundPlayedB
								OverSixB:
								invoke PlaySound, OFFSET BeepBlue2, NULL, SND_FILENAME
								jmp SoundPlayedB
								OverFourteenB:
								invoke PlaySound, OFFSET BeepBlue3, NULL, SND_FILENAME
								SoundPlayedB:
								call changeBlue
								call printColoredBoard
								jmp ButtonFinish
	Impossible:
		jmp ButtonFinish
	ButtonFinish:
	ret
ButtonPress ENDP
			;--------------PrintColoredBoard------------------------;
			;Will take the values which may have been changed by	;
			;previous procedures and outputs the new board. When	;
			;called it will reprint the board and have a change in	;
			;one of the buttons colors to simulate a button press.	;
			;--------------PrintColoredBoard------------------------;
printColoredBoard PROC
	mov esi, 0
	mov ecx, totalSize
	mov eax,0
	printColors:
		push ecx
		call moveToPosition
		call selectCurrentColor
		inc esi
		pop ecx
	loop printColors
	Call ScorePrint
	mov wTracker, 0
	mov hTracker, 0
ret
printColoredBoard ENDP
			;--------------selectCurrentColor----------------------;
			;Checks to see what the current board position's color ;
			;is and changes the color of the cursor to output      ;
			;--------------selectCurrentColor----------------------;
selectCurrentColor PROC uses ecx
	mov al, TestBoard[esi]
	cmp al, 9
	jge whiteC
	cmp al, 7
	jge blueC
	cmp al, 5
	jge yellowC
	cmp al, 3
	jge redC
	cmp al, 1
	jge greenC
	call isBlack
	ret
	whiteC:
		call isWhite
		ret
	yellowC:
		call isYellow
		ret
	blueC:
		call isBlue
		ret
	redC:
		call isRed
		ret
	greenC:
		call isGreen
		ret
selectCurrentColor ENDP
			;--------------MoveToPosistion--------------------------;
			;Will take in the height and width trackers of the		;
			;board and then uses Gotoxy to move to the posistion	;
			;and then increments it to get to the next posistion.	;
			;--------------MoveToPosistion--------------------------;
moveToPosition PROC uses eax
	mov dh,	hTracker		;row
	mov dl,	wTracker		;col
	call Gotoxy
	inc wTracker
	movzx eax, wTracker
	cmp al, w
	je moveDown
	ret
	moveDown:
		mov wTracker, 0
		inc hTracker
	ret
moveToPosition ENDP
			;--------------ChangeGreen------------------------------;
			;Change green will change the green section of the		;
			;board and then waits for PrintColoredBoard to output	;
			;the changes to it.										;
			;--------------ChangeGreen------------------------------;
changeGreen PROC
	mov esi, 0
	mov ecx, totalSize
	mov eax,0
	ChangeGreenL:
		mov al,  TestBoard[esi]
		cmp al, 1
		je makeLightG
		cmp eax, 2
		je makeDarkG
		inc esi
	loop ChangeGreenL
	ret
	makeLightG:
		mov TestBoard[esi], 2
		inc esi
	loop ChangeGreenL
	makeDarkG:
		mov TestBoard[esi], 1
		inc esi
	loop ChangeGreenL
	ret
changeGreen ENDP
			;--------------ChangeRed--------------------------------;
			;Change green will change the red section of the		;
			;board and then waits for PrintColoredBoard to output	;
			;the changes to it.										;
			;--------------ChangeRed--------------------------------;
changeRed PROC
	mov esi, 0
	mov ecx, totalSize
	mov eax,0
	ChangeRedL:
		mov al, TestBoard[esi]
		cmp al, 3
		je makeLightR
		cmp eax, 4
		je makeDarkR
		inc esi
	loop ChangeRedL
	ret
	makeLightR:
		mov TestBoard[esi], 4
		inc esi
	loop ChangeRedL
	makeDarkR:
		mov TestBoard[esi], 3
		inc esi
	loop ChangeRedL
	ret
changeRed ENDP
			;--------------ChangeBlue-------------------------------;
			;Change green will change the blue section of the		;
			;board and then waits for PrintColoredBoard to output	;
			;the changes to it.										;
			;--------------ChangeBlue-------------------------------;
changeBlue PROC
	mov esi, 0
	mov ecx, totalSize
	mov eax,0
	ChangeBlueL:
		mov al, TestBoard[esi]
		cmp al, 7
		je makeLightB
		cmp eax, 8
		je makeDarkB
		inc esi
	loop ChangeBlueL
	ret
	makeLightB:
		mov TestBoard[esi], 8
		inc esi
	loop ChangeBlueL
	makeDarkB:
		mov TestBoard[esi], 7
		inc esi
	loop ChangeBlueL
	ret
changeBlue ENDP
			;--------------ChangeYellow-----------------------------;
			;Change green will change the yellow section of the		;
			;board and then waits for PrintColoredBoard to output	;
			;the changes to it.										;
			;--------------ChangeYellow-----------------------------;
changeYellow PROC
	mov esi, 0
	mov ecx, totalSize
	mov eax,0
	ChangeYellowL:
		mov al,  TestBoard[esi]
		cmp al, 5
		je makeLightY
		cmp eax, 6
		je makeDarkY
		inc esi
	loop ChangeYellowL
	ret
	makeLightY:
		mov TestBoard[esi], 6
		inc esi

	loop ChangeYellowL
	makeDarkY:
		mov TestBoard[esi], 5
		inc esi
	loop ChangeYellowL
	ret
changeYellow ENDP
			;--------------isGreen----------------------------------;
			;Checks the array and flips the value depending on the	;
			;color which it is for. This will in turn flip the bit	;
			;used to check which color to output. Makes Green go to	;
			;light green.											;
			;--------------isGreen----------------------------------;
isGreen PROC uses eax
	movzx eax, TestBoard[esi]
	cmp eax, 1
	jne lightG
	mov eax, 32
	call printWhiteSpace
	ret
	lightG:
	mov eax, 160
	call printWhiteSpace
	ret
isGreen ENDP
			;--------------isRed------------------------------------;
			;Checks the array and flips the value depending on the	;
			;color which it is for. This will in turn flip the bit	;
			;used to check which color to output. Makes Red go to	;
			;light red.												;
			;--------------isRed------------------------------------;
isRed PROC uses eax
	movzx eax, TestBoard[esi]
	cmp eax, 3
	jne lightR
	mov eax, 64
	call printWhiteSpace
	ret
	lightR:
	mov eax, 192
	call printWhiteSpace
	ret
isRed ENDP
			;--------------isBlue-----------------------------------;
			;Checks the array and flips the value depending on the	;
			;color which it is for. This will in turn flip the bit	;
			;used to check which color to output. Makes Blue go to	;
			;light Blue.											;
			;--------------isBlue-----------------------------------;
isBlue PROC uses eax
	movzx eax, TestBoard[esi]
	cmp eax, 7
	jne lightG
	mov eax, 16
	call printWhiteSpace
	ret
	lightG:
	mov eax, 144
	call printWhiteSpace
	ret
isBlue ENDP
			;--------------isYellow---------------------------------;
			;Checks the array and flips the value depending on the	;
			;color which it is for. This will in turn flip the bit	;
			;used to check which color to output. Make Yellow go to	;
			;light Yellow.											;
			;--------------isYellow---------------------------------;
isYellow PROC uses eax
	movzx eax, TestBoard[esi]
	cmp eax, 5
	jne lightG
	mov eax, 96
	call printWhiteSpace
	ret
	lightG:
	mov eax, 224
	call printWhiteSpace
	ret
isYellow ENDP
			;--------------isBlack----------------------------------;
			;Sets the background to black.							;
			;--------------isBlack----------------------------------;
isBlack PROC uses eax
	mov ah, 0
	call SetTextColor
	call printWhiteSpace
	ret
isBlack ENDP
			;--------------isWhite----------------------------------;
			;Sets the text color to white after isBlack for when	;
			;text needs to be outputted.							;
			;--------------isWhite----------------------------------;
isWhite PROC uses eax
	mov eax, 240
	call SetTextColor
	call printWhiteSpace
	ret
isWhite ENDP
			;--------------PrintWhiteSpace--------------------------;
			;Prints a blank character for whitespace				;
			;--------------PrintWhiteSpace--------------------------;
printWhiteSpace PROC uses eax
	call SetTextColor
	mov al, " "
	call WriteChar
ret
printWhiteSpace ENDP
			;--------------PrintStartScreen-------------------------;
			;Prints the start screen array from the values which	;
			;passed to it.											;
			;--------------PrintStartScreen-------------------------;
PrintStartScreen PROC
	call Clrscr
	mov esi, 0
	mov ecx, sTotalSize
	mov eax,0
	sPrintColors:
		push ecx
		call sMoveToPosition
		mov bl, StartScreen[esi]
		call sSelectCurrentColor
		inc esi
		pop ecx
	loop sPrintColors
	mov sWTracker, 0
	mov sHTracker, 0
	call placeStartText
	invoke PlaySound, OFFSET BeepSplash, NULL, SND_ASYNC
ret
PrintStartScreen ENDP
			;--------------sSelectCurrentColor----------------------;
			;Handles coloring for the Splash Screen board			;
			;--------------sSelectCurrentColor----------------------;
sSelectCurrentColor PROC uses ecx
		mov al, StartScreen[esi]
		cmp bl, 9
		jge whiteC
		cmp bl, 7
		jge yellowC
		cmp bl, 5
		jge blueC
		cmp bl, 3
		jge redC
		cmp bl, 1
		jge greenC
		call isBlack
		ret
		whiteC:
		call isWhite
		ret
		yellowC:
		call isYellow
		ret
		blueC:
		call isBlue
		ret
		redC:
		call isRed
		ret
		greenC:
		call isGreen
		ret
sSelectCurrentColor ENDP
			;--------------sMoveToPosistion-------------------------;
			;Use the trackers for the height and width of the start	;
			;screen to output the screen.							;
			;--------------sMoveToPosistion-------------------------;
sMoveToPosition PROC uses eax
	mov dh,	sHTracker		;row
	mov dl,	sWTracker		;col
	call Gotoxy
	inc sWTracker
	movzx eax, sWTracker
	cmp al, w
	je moveDown
	ret
	moveDown:
		mov sWTracker, 0
		inc sHTracker
	ret
sMoveToPosition ENDP
			;--------------DisplayHelp------------------------------;
			;Displays the help screen under the StartScreen and		;
			;outputs all the strings that are needed for the		;
			;directions.											;
			;--------------DisplayHelp------------------------------;
DisplayHelp PROC
	mov dh, 15
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr1_1
	call WriteString
	mov dh, 16
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr2_1
	call WriteString
	mov dh, 17
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr2_2
	call WriteString
	mov dh, 19
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr3_1
	call WriteString
	call Crlf
	mov dh, 20
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr3_2
	call WriteString
	mov dh, 22
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr4_1
	call WriteString
	mov dh, 23
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr4_2
	call WriteString
	mov dh, 24
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr4_3
	call WriteString
	mov dh, 26
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr5_1
	call WriteString
	mov dh, 27
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr5_2
	call WriteString
	mov dh, 29
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr6_1
	call WriteString
	mov dh, 30
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr6_2
	call WriteString
	mov dh, 32
	mov dl, 3
	call Gotoxy
	mov edx, offset helpStr7_1
	call WriteString
	ret
DisplayHelp ENDP
			;--------------PlaceStartText---------------------------;
			;Uses Gotoxy to set the cursor posistion and then		;
			;outputs strings for the buttons such as 'Play', 'Help'	;
			;or 'Exit'.												;
			;--------------PlaceStartText---------------------------;
placeStartText PROC
	mov eax, 15
	call SetTextColor
	mov dh,	10		;row
	mov dl,	10		;col
	call Gotoxy
	mov edx, offset playStr
	call WriteString
	mov dh,	10
	mov dl, 32
	call Gotoxy
	mov edx, offset helpStr
	call WriteString
	mov dh,	10
	mov dl, 54
	call Gotoxy
	mov edx, offset exitStr
	call WriteString
	ret
placeStartText ENDP
			;--------------GetButtonClick---------------------------;
			;Used to receive one mouseclick from the user and		;
			;stores the coordinates into two different variables.	;
			;Mouse click work was done by Jay Russo and shared to	;
			;the class. THANKS JAY!									;
			;--------------GetButtonClick---------------------------;
GetButtonClick PROC
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov rHnd, eax
	invoke SetConsoleMode, rHnd, ENABLE_LINE_INPUT OR ENABLE_MOUSE_INPUT 	OR ENABLE_EXTENDED_FLAGS
	appContinue:
		invoke GetNumberOfConsoleInputEvents, rHnd, OFFSET numEventsOccurred
		cmp numEventsOccurred, 0
			je appContinue
		invoke ReadConsoleInput, rHnd, OFFSET eventBuffer, numEventsOccurred, 	OFFSET numEventsRead
		mov ecx, numEventsRead
		mov esi, OFFSET eventBuffer
	loopOverEvents:
		cmp (INPUT_RECORD PTR [esi]).EventType, MOUSE_EVENT
			jne notMouse
		cmp (INPUT_RECORD PTR [esi]).MouseEvent.dwEventFlags, MOUSE_MOVED
			jne continue
	continue:
		test (INPUT_RECORD PTR [esi]).MouseEvent.dwButtonState, 	FROM_LEFT_1ST_BUTTON_PRESSED
		jz notMouse
		movzx eax, (INPUT_RECORD PTR [esi]).MouseEvent.dwMousePosition.x
		mov XCord, eax
		movzx eax, (INPUT_RECORD PTR [esi]).MouseEvent.dwMousePosition.y
		mov YCord, eax
		jmp done
	notMouse:
		add esi, TYPE INPUT_RECORD
	loop loopOverEvents
	jmp appContinue
	done:
	ret
GetButtonClick ENDP
END main