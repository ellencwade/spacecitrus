; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
;	Ellen C Wade
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc
include movement.inc
include audiovisual.inc
include \masm32\include\windows.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
include keys.inc

	
.DATA

; things
ship thing <320, 300, 0, 1, 0>
boss thing <0, 570, 0, 1, 1>
boss2 thing <300, 170, 1, 1, 1>
boss3 thing <200, 270, 0, 1, 1>
ammo thing <320, 300, 0, 1, 0>
bammo thing <-40, 70, 1, 1, 40>
bammo21 thing <-40, 170, 1, 1, 40>
bammo31 thing <-40, 270, 1, 1, 40>
bammo2 thing <40, 70, 1, 1, -40>
bammo22 thing <40, 170, 1, 1, -40>
bammo32 thing <40, 270, 1, 1, -40>
projup thing <100, 0, 1, 1, 1>
projdown thing <400, 0, 1, 1, 0>
projright thing <0, 200, 1, 1, 1>
projleft thing <0, 300, 1, 1, 0>

; string values
score_val DWORD 0
scoreStr BYTE "Score: %d", 0
liveStr BYTE "Lives: %d", 0
lives_val DWORD 3
outStr BYTE 256 DUP(0)

; FLAGS
; begin
b DWORD 0
; pause 
p DWORD 0
; end 
e DWORD 0
; # bosses
bb DWORD 3

.CODE

; new projectiles


; display
lives PROC
	
	mov eax, lives_val
	push eax
	push offset liveStr
	push offset outStr
	call wsprintf
	add esp, 12
	invoke DrawStr, offset outStr, 530, 30, 0ffh
	
	ret
lives ENDP

score PROC
	
	mov eax, score_val
	push eax
	push offset scoreStr
	push offset outStr
	call wsprintf
	add esp, 12
	invoke DrawStr, offset outStr, 530, 60, 0ffh
	
	ret
score ENDP

score2 PROC
	
	mov eax, score_val
	push eax
	push offset scoreStr
	push offset outStr
	call wsprintf
	add esp, 12
	invoke DrawStr, offset outStr, 280, 285, 0ffh
	
	ret
score2 ENDP

score3 PROC
	
	mov eax, score_val
	push eax
	push offset scoreStr
	push offset outStr
	call wsprintf
	add esp, 12
	invoke DrawStr, offset outStr, 280, 330, 0ffh

	ret
score3 ENDP
; main part

beginGame PROC

	invoke BlackStarField
	invoke BasicBlit, offset beginscreen11, 320, 240

	ret
beginGame ENDP

beginGame2 PROC
	invoke BlackStarField
	invoke BasicBlit, offset beginscreen12, 320, 240
	mov b, 1

	ret
beginGame2 ENDP

beginGame25 PROC
	invoke BlackStarField
	invoke BasicBlit, offset beginscreen125, 320, 240
	mov b, 2

	ret
beginGame25 ENDP

beginGame3 PROC 
	invoke BlackStarField
	invoke BasicBlit, offset beginscreen13, 320, 240
	mov b, 3
	invoke restartgame

	ret
beginGame3 ENDP

endGame PROC

	invoke BlackStarField
	cmp bb, 0
	jle win
	cmp score_val, 300
	jge win
	jmp dead
	win:
	invoke BasicBlit, offset winscreen, 320, 240
	invoke score3
	jmp cont
	dead:
	invoke BasicBlit, offset escreen, 320, 240
	invoke shit
	invoke score2
	cont:

	ret
endGame ENDP

restartgame PROC

	invoke restartship
	invoke restartbosses
	invoke restartprojs
	invoke resetnumbs

	ret
restartgame ENDP

restartship PROC

	mov eax, offset ship
	mov (thing PTR [eax]).x, 320
	mov (thing PTR [eax]).y, 300

	ret
restartship ENDP

restartbosses PROC
	invoke restartboss
	invoke restartboss2
	invoke restartboss3

	ret
restartbosses ENDP

restartboss PROC

	rdtsc
	invoke nseed, eax

	mov esi, offset boss
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	invoke nrandom, 300
	mov (thing PTR [esi]).y, eax
	mov (thing PTR [esi]).vis, 1
	mov eax, offset bammo
	mov (thing PTR [eax]).vis, 1
	mov eax, offset bammo2
	mov (thing PTR [eax]).vis, 1

	ret
restartboss ENDP

restartboss2 PROC

	rdtsc
	invoke nseed, eax

	mov esi, offset boss2
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	invoke nrandom, 300
	mov (thing PTR [esi]).y, eax
	mov (thing PTR [esi]).vis, 1
	mov eax, offset bammo21
	mov (thing PTR [eax]).vis, 1
	mov eax, offset bammo22
	mov (thing PTR [eax]).vis, 1

	ret
restartboss2 ENDP

restartboss3 PROC

	rdtsc
	invoke nseed, eax

	mov esi, offset boss3
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	invoke nrandom, 300
	mov (thing PTR [esi]).y, eax
	mov (thing PTR [esi]).vis, 1
	mov eax, offset bammo31
	mov (thing PTR [eax]).vis, 1
	mov eax, offset bammo32
	mov (thing PTR [eax]).vis, 1

	ret
restartboss3 ENDP

restartprojs PROC

	mov eax, offset projup
	mov (thing PTR [eax]).y, 479
	mov eax, offset projdown
	mov (thing PTR [eax]).y, 0
	mov eax, offset projleft
	mov (thing PTR [eax]).x, 639
	mov eax, offset projright
	mov (thing PTR [eax]).x, 0

	ret
restartprojs ENDP

resetnumbs PROC
	
	mov lives_val, 3
	mov score_val, 0
	mov bb, 3
	mov e, 0
	mov p, 0

	ret
resetnumbs ENDP

checkhits PROC USES edx esi

	; interactions:
	; return 1 if life lost
	; 		 2 if 100 pt gain
	;		 3 if 10 pt gain
	rdtsc
	invoke nseed, eax

	; check ship/boss crash
	crash:
	mov eax, offset ship
	mov edx, offset boss
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000, 
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET fighter_001
	cmp eax, 1
	jne crash2
	mov edx, offset boss
	cmp (thing PTR [edx]).vis, 1
	jne crash2
	invoke explode
	invoke restartship
	invoke restartboss
	invoke restartprojs
	mov eax, 1
	jmp cont
	
	crash2:
	mov eax, offset ship
	mov edx, offset boss2
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000, 
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET fighter_001
	cmp eax, 1
	jne crash3
	mov edx, offset boss2
	cmp (thing PTR [edx]).vis, 1
	jne crash3
	invoke explode
	invoke restartship
	invoke restartboss2
	invoke restartprojs
	mov eax, 1
	jmp cont

	crash3:
	mov eax, offset ship
	mov edx, offset boss3
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000, 
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET fighter_001
	cmp eax, 1
	jne lemonhit
	mov edx, offset boss3
	cmp (thing PTR [edx]).vis, 1
	jne lemonhit
	invoke explode
	invoke restartship
	invoke restartboss3
	invoke restartprojs
	mov eax, 1
	jmp cont

	; lemon hit boss
	lemonhit:
	mov eax, offset boss
	mov edx, offset ammo
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_001, 
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET lemon
	cmp eax, 1
	jne lemonhit2
	mov edx, offset boss
	cmp (thing PTR [edx]).vis, 1
	jne lemonhit2
	invoke hit, offset ammo
	mov eax, offset boss
	mov (thing PTR [eax]).vis, 0
	mov eax, offset bammo
	mov (thing PTR [eax]).vis, 0
	mov eax, offset bammo2
	mov (thing PTR [eax]).vis, 0
	dec bb
	mov eax, 2
	jmp cont

	lemonhit2:
	mov eax, offset boss2
	mov edx, offset ammo
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_001, 
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET lemon
	cmp eax, 1
	jne lemonhit3
	mov edx, offset boss2
	cmp (thing PTR [edx]).vis, 1
	jne lemonhit3
	invoke hit, offset ammo
	mov eax, offset boss2
	mov (thing PTR [eax]).vis, 0
	mov eax, offset bammo21
	mov (thing PTR [eax]).vis, 0
	mov eax, offset bammo22
	mov (thing PTR [eax]).vis, 0
	dec bb
	mov eax, 2
	jmp cont

	lemonhit3:
	mov eax, offset boss3
	mov edx, offset ammo
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_001, 
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET lemon
	cmp eax, 1
	jne orange1
	mov edx, offset boss3
	cmp (thing PTR [edx]).vis, 1
	jne orange1
	invoke hit, offset ammo
	mov eax, offset boss3
	mov (thing PTR [eax]).vis, 0
	mov eax, offset bammo31
	mov (thing PTR [eax]).vis, 0
	mov eax, offset bammo32
	mov (thing PTR [eax]).vis, 0	
	dec bb
	mov eax, 2
	jmp cont
	
	; ship hit by orange 1
	orange1:
	mov eax, offset ship
	mov edx, offset bammo
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne orange2
	mov edx, offset bammo
	cmp (thing PTR [edx]).vis, 1
	jne orange2
	invoke hitship, offset bammo, offset boss
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; hit by orange 2
	orange2:
	mov eax, offset ship
	mov edx, offset bammo2
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne orange3
	mov edx, offset bammo2
	cmp (thing PTR [edx]).vis, 1
	jne orange3
	invoke hitship, offset bammo2, offset boss
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont

	; hit by orange 3
	orange3:
	mov eax, offset ship
	mov edx, offset bammo21
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne orange4
	mov edx, offset bammo21
	cmp (thing PTR [edx]).vis, 1
	jne orange4
	invoke hitship, offset bammo21, offset boss2
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; hit by orange 4
	orange4:
	mov eax, offset ship
	mov edx, offset bammo22
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne orange5
	mov edx, offset bammo22
	cmp (thing PTR [edx]).vis, 1
	jne orange5
	invoke hitship, offset bammo22, offset boss2
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont

	; hit by orange 5
	orange5:
	mov eax, offset ship
	mov edx, offset bammo31
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne orange6
	mov edx, offset bammo31
	cmp (thing PTR [edx]).vis, 1
	jne orange6
	invoke hitship, offset bammo31, offset boss3
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; hit by orange 6
	orange6:
	mov eax, offset ship 	
	mov edx, offset bammo32
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne pro1
	mov edx, offset bammo32
	cmp (thing PTR [edx]).vis, 1
	jne pro1
	invoke hitship, offset bammo32, offset boss3
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; ship hit by projup
	pro1:
	mov eax, offset ship
	mov edx, offset projup
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne pro2
	invoke hitup, offset projup
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; hit projdown
	pro2:
	mov eax, offset ship
	mov edx, offset projdown
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne pro3
	invoke hitdown, offset projdown
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; hit projright
	pro3:
	mov eax, offset ship
	mov edx, offset projright
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne pro4
	invoke hitright, offset projright
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont
	; hit projleft
	pro4:
	mov eax, offset ship
	mov edx, offset projleft
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET fighter_000,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne bl1
	invoke hitleft, offset projleft
	invoke restartship
	invoke restartprojs
	mov eax, 1
	jmp cont

	; check lemon/orange interactions
	bl1:
	mov eax, offset ammo
	mov edx, offset bammo
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne bl2
	mov edx, offset bammo
	cmp (thing PTR [edx]).vis, 1
	jne bl2
	invoke hit, offset ammo
	mov eax, offset bammo
	mov (thing PTR [eax]).y, 475
	mov eax, 3
	jmp cont

	bl2:
	mov eax, offset ammo
	mov edx, offset bammo2
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne bl21
	mov edx, offset bammo2
	cmp (thing PTR [edx]).vis, 1
	jne bl21
	invoke hit, offset ammo
	mov eax, offset bammo2
	mov (thing PTR [eax]).y, 475
	mov eax, 3
	jmp cont

	bl21:
	mov eax, offset ammo
	mov edx, offset bammo21
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne bl22
	mov edx, offset bammo21
	cmp (thing PTR [edx]).vis, 1
	jne bl22
	invoke hit, offset ammo
	mov eax, offset bammo21
	mov (thing PTR [eax]).y, 475
	mov eax, 3
	jmp cont

	bl22:
	mov eax, offset ammo
	mov edx, offset bammo22
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne bl31
	mov edx, offset bammo22
	cmp (thing PTR [edx]).vis, 1
	jne bl31
	invoke hit, offset ammo
	mov eax, offset bammo22
	mov (thing PTR [eax]).y, 475
	mov eax, 3
	jmp cont
		
	bl31:
	mov eax, offset ammo
	mov edx, offset bammo31
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne bl32
	mov edx, offset bammo31
	cmp (thing PTR [edx]).vis, 1
	jne bl32
	invoke hit, offset ammo
	mov eax, offset bammo31
	mov (thing PTR [eax]).y, 475
	mov eax, 3
	jmp cont

	bl32:
	mov eax, offset ammo
	mov edx, offset bammo32
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne lo1
	mov edx, offset bammo32
	cmp (thing PTR [edx]).vis, 1
	jne lo1
	invoke hit, offset ammo
	mov eax, offset bammo32
	mov (thing PTR [eax]).y, 475
	mov eax, 3
	jmp cont

	lo1:
	mov eax, offset ammo
	mov edx, offset projup
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne lo2
	invoke hit, offset ammo
	mov esi, offset projup
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	invoke hitup, offset projup
	mov eax, 3
	jmp cont
	
	lo2:
	mov eax, offset ammo
	mov edx, offset projdown
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne lo3
	invoke hit, offset ammo
	mov esi, offset projdown
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	invoke hitdown, offset projdown
	mov eax, 3
	jmp cont

	lo3:
	mov eax, offset ammo
	mov edx, offset projright
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne lo4
	invoke hit, offset ammo
	mov esi, offset projright
	invoke nrandom, 479
	mov (thing PTR [esi]).y, eax
	invoke hitright, offset projright
	mov eax, 3
	jmp cont

	lo4:
	mov eax, offset ammo
	mov edx, offset projleft
	invoke CheckIntersect, (thing PTR [eax]).x, (thing PTR [eax]).y, OFFSET lemon,
			(thing PTR [edx]).x, (thing PTR [edx]).y, OFFSET orange
	cmp eax, 1
	jne cont
	invoke hit, offset ammo
	mov esi, offset projleft
	invoke nrandom, 479
	mov (thing PTR [esi]).y, eax
	invoke hitleft, offset projleft
	mov eax, 3
	jmp cont

	cont:

	ret
checkhits ENDP

GameInit PROC

	invoke BasicBlit, offset beginscreen11, 320, 240
	rdtsc 
	invoke nseed, eax

	ret         
GameInit ENDP

GamePlay PROC USES edx ecx esi

	; space to start
	cmp KeyPress, 20h
	jne next
	cmp b, 0
	je beg
	cmp b, 1
	je beg2
	cmp b, 2
	je beg3
	cmp b, 3
	je beg4

	cmp e, 1
	jne next
	mov e, 0
	je beg

	next:
	;skips
	cmp b, 0
	je cont
	cmp b, 1
	je cont
	cmp b, 2
	je cont
	cmp b, 3
	je cont
	cmp e, 1
	je cont
	; p to pause
	cmp KeyPress, 50h
	je paus
	cmp p, 1
	je cont

	reg:
	invoke BlackStarField
	invoke DrawStarField
	nums:
	invoke lives
	invoke score
	players:
	invoke kbmove, OFFSET ship
	mov eax, offset ship
	invoke BasicBlit, offset fighter_000, (thing PTR [eax]).x, (thing PTR [eax]).y
	invoke floatHoriz, OFFSET boss
	invoke floatHoriz, offset boss2
	invoke floatHoriz, offset boss3
	invoke shoot, OFFSET ammo, OFFSET lemon, OFFSET ship
	invoke shootback, OFFSET bammo, offset bammo2, OFFSET orange, OFFSET boss
	invoke shootback, OFFSET bammo21, offset bammo22, OFFSET orange, OFFSET boss2
	invoke shootback, OFFSET bammo31, offset bammo32, OFFSET orange, OFFSET boss3
	invoke fallup, offset projup, offset orange
	invoke falldown, offset projdown, offset orange
	invoke fallright, offset projright, offset orange
	invoke fallleft, offset projleft, offset orange
	invoke checkhits

	cmp eax, 2
	jne points
	add score_val, 100
	jmp points2

	points:
	cmp eax, 3
	jne life
	add score_val, 25

	points2:
	xor edx, edx
	mov eax, score_val
	mov esi, 100
	idiv esi
	cmp edx, 0
	jne points3
	add lives_val, 1

	points3:
	cmp score_val, 300
	jge ended
	jmp cont

	life:
	cmp bb, 0
	jle ended
	cmp eax, 1
	jne cont
	dec lives_val
	cmp lives_val, 0
	jle ended
	invoke restartprojs
	invoke restartship
	mov score_val, 0
	jmp cont
	;start/pause/end
	beg: 
	mov b, 1
	invoke beginGame2
	jmp cont

	beg2:
	mov b, 2
	invoke beginGame25
	jmp cont

	beg3: 
	mov b, 3
	invoke beginGame3
	jmp cont

	beg4:
	mov b, 4
	invoke restartgame
	jmp cont

	paus:
	cmp p, 1
	jne other
	mov p, 0
 	jmp cont
	other:
	mov p, 1
	jmp cont

	ended:
	mov e, 1
	invoke endGame

	cont:

	ret         ;; Do not delete this line!!!
GamePlay ENDP

END