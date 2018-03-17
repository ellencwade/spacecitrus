; #########################################################################
;
;   game.inc - Includes for EECS205 Assignment 4/5
;
;
; #########################################################################

thing STRUCT
	x DWORD ?
	y DWORD ?
	state DWORD ?
	vis DWORD ?
	dir DWORD ?
thing ENDS

;; Library Definitions
MouseInfo STRUCT
 horiz DWORD ?
 vert  DWORD ?
 buttons DWORD ?
MouseInfo ENDS

MK_CONTROL  = 0008h  ;; The CTRL key is down.
MK_LBUTTON  = 0001h  ;; The left mouse button is down.
MK_MBUTTON  = 0010h  ;; The middle mouse button is down.
MK_RBUTTON  = 0002h  ;; The right mouse button is down.
MK_SHIFT    = 0004h  ;; The SHIFT key is down.
MK_XBUTTON1 = 0020h  ;; The first X button is down.
MK_XBUTTON2 = 0040h  ;; The second X button is down.

;; Library Functions
BlackStarField	PROTO
DrawStr PROTO myStr:PTR BYTE, x:DWORD, y:DWORD, color:DWORD

;; Library Data
EXTERNDEF beginscreen11: EECS205BITMAP
EXTERNDEF beginscreen12: EECS205BITMAP
EXTERNDEF beginscreen125: EECS205BITMAP
EXTERNDEF beginscreen13: EECS205BITMAP
EXTERNDEF escreen: EECS205BITMAP
EXTERNDEF winscreen: EECS205BITMAP
EXTERNDEF fighter_000: EECS205BITMAP
EXTERNDEF fighter_001: EECS205BITMAP
EXTERNDEF dart: EECS205BITMAP
EXTERNDEF fireworks: EECS205BITMAP
EXTERNDEF StarBitmap:EECS205BITMAP
EXTERNDEF lemon: EECS205BITMAP
EXTERNDEF orange: EECS205BITMAP
EXTERNDEF MouseStatus:MouseInfo
EXTERNDEF KeyUp:DWORD
EXTERNDEF KeyDown:DWORD
EXTERNDEF KeyPress:DWORD

;; User Defined Functions

lives PROTO
score PROTO
score2 PROTO
endGame PROTO
restartgame PROTO
restartship PROTO
restartbosses PROTO
restartboss PROTO
restartboss2 PROTO
restartboss3 PROTO
restartprojs PROTO
resetnumbs PROTO
beginGame PROTO
beginGame2 PROTO
beginGame25 PROTO
beginGame3 PROTO
checkhits PROTO
GameInit PROTO
GamePlay PROTO



