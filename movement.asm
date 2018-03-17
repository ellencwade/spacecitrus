; #########################################################################
;
;   movement.asm - Assembly file for EECS205 Assignment 4/5
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
include keys.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib

.DATA

.CODE
; resets ammo
hit PROC USES ecx amm: PTR thing

	invoke explode
	mov ecx, amm
	mov (thing PTR [ecx]).state, 0

	ret
hit ENDP

; bammo hit
hitship PROC USES ecx edx esi amm: PTR thing, shooter: PTR thing

	invoke explode
	mov ecx, amm
	mov eax, offset orange
	mov edx, shooter
	mov esi, (thing PTR [edx]).y
	mov (thing PTR [ecx]).y, esi
	invoke shootback, ecx, eax, eax, edx

	ret
hitship ENDP

; up
hitup PROC amm: PTR thing

	invoke explode
	mov eax, amm
	mov (thing PTR [eax]).y, 479
	invoke fallup, eax, offset orange

	ret
hitup ENDP

; down
hitdown PROC amm: PTR thing

	invoke explode
	mov eax, amm
	mov (thing PTR [eax]).y, 0
	invoke falldown, eax, offset orange

	ret
hitdown ENDP

; right
hitright PROC amm: PTR thing

	invoke explode
	mov eax, amm
	mov (thing PTR [eax]).x, 0
	invoke fallright, eax, offset orange

	ret
hitright ENDP

; left
hitleft PROC amm: PTR thing

	invoke explode
	mov eax, amm
	mov (thing PTR [eax]).x, 639
	invoke fallleft, eax, offset orange

	ret
hitleft ENDP

CheckIntersect PROC USES edx edi esi ebx ecx oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, 
				twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 
	LOCAL oneWidth: DWORD, twoWidth: DWORD, oneHeight: DWORD, twoHeight: DWORD

	mov edx, oneBitmap
	mov ecx, twoBitmap

	mov eax, (EECS205BITMAP PTR[edx]).dwWidth
	mov oneWidth, eax
	mov eax, (EECS205BITMAP PTR[edx]).dwHeight
	mov oneHeight, eax
	mov eax, (EECS205BITMAP PTR[ecx]).dwWidth
	mov twoWidth, eax
	mov eax, (EECS205BITMAP PTR[ecx]).dwHeight
	mov twoHeight, eax

	; check if one in horizontal range of two
	check_horiz:
	mov eax, oneX
	sub eax, twoX
	mov ebx, eax
	; compare difference in x values
	cmp ebx, 0
	jge cont_h
	; take abs of difference
	neg ebx

	cont_h:
	mov eax, oneWidth
	add eax, twoWidth
	mov esi, 2
	mov edx, 0
	idiv esi

	;compare space in between centers to size of each half-width summed
	cmp ebx, eax
	jg no

	check_vert:
	mov eax, oneY
	sub eax, twoY
	mov ebx, eax


	cmp ebx, 0
	jge cont_v
	neg ebx

	cont_v:
	mov eax, oneHeight
	add eax, twoHeight
	mov esi, 2
	mov edx, 0
	idiv esi

	cmp ebx, eax
	jl yes

	no:
	mov eax, 0
	jmp resume

	yes:
	mov eax, 1

	resume:

	ret
CheckIntersect ENDP

shoot PROC USES esi edi amm: PTR thing, ammBmp: PTR EECS205Bitmap, 
		shooter: PTR thing

	mov eax, amm
	cmp KeyPress, 20h
	je set
	mov esi, (thing PTR [eax]).state
	cmp esi, 1
	jne resume
	je move

	set:
	mov (thing PTR [eax]).state, 1

	move:
	mov esi, (thing PTR [eax]).y
	sub esi, 15
	mov (thing PTR [eax]).y, esi
	cmp esi, 0
	jle clear
	jmp stop

	; hide from screen, reset y value
	clear:
	mov eax, amm
	mov (thing PTR [eax]).state, 0

	resume:
	mov edi, shooter
	mov esi, (thing PTR [edi]).x
	mov (thing PTR [eax]).x, esi
	mov esi, (thing PTR [edi]).y
	mov (thing PTR [eax]).y, esi	

	stop:
	mov edi, ammBmp
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y

	ret
shoot ENDP
	
shootback PROC USES esi edi edx amm: PTR thing, amm2: PTR thing, ammBmp: PTR EECS205Bitmap, 
		shooter: PTR thing
	
	mov eax, shooter
	cmp (thing PTR [eax]).vis, 1
	jne stop

	mov edi, ammBmp
	mov eax, amm
	mov esi, (thing PTR [eax]).y
	add esi, 4				
	mov (thing PTR [eax]).y, esi
	cmp esi, 480
	jge clear
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y
	jmp next

	; hide from screen, reset y value
	clear:
	mov eax, amm
	mov edi, shooter
	mov esi, (thing PTR [edi]).x
	mov edx, (thing PTR [eax]).dir
	add esi, edx
	mov (thing PTR [eax]).x, esi
	mov esi, (thing PTR [edi]).y
	mov (thing PTR [eax]).y, esi

	next:
	mov eax, amm2
	mov esi, (thing PTR [eax]).y
	add esi, 4
	mov (thing PTR [eax]).y, esi
	cmp esi, 480
	jge clear2
	mov edi, ammBmp
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y
	jmp stop

	; hide from screen, reset y value
	clear2:
	mov eax, amm2
	mov edi, shooter
	mov esi, (thing PTR [edi]).x
	mov edx, (thing PTR [eax]).dir
	add esi, edx
	mov (thing PTR [eax]).x, esi
	mov esi, (thing PTR [edi]).y
	mov (thing PTR [eax]).y, esi

	stop:

	ret
shootback ENDP

kbmove PROC USES edx esi obj: PTR thing

	mov esi, obj
	mov eax, (thing PTR [esi]).x
	mov edx, (thing PTR [esi]).y

	; controls obj location
	left:
	cmp KeyPress, 25h
	jne right
	cmp (thing PTR [esi]).x, 0
	jle cont
	sub eax, 7
	mov (thing PTR [esi]).x, eax
	jmp cont

	right: 
	cmp KeyPress, 27h
	jne down
	cmp (thing PTR [esi]).x, 640
	jge cont
	add eax, 7
	mov (thing PTR [esi]).x, eax
	jmp cont

	down: 
	cmp KeyPress, 28h
	jne up
	cmp (thing PTR [esi]).y, 480
	jge cont
	add edx, 7
	mov (thing PTR [esi]).y, edx
	jmp cont

	up: 
	cmp KeyPress, 26h
	jne cont
	cmp (thing PTR [esi]).y, 0
	jle cont
	sub edx, 7
	mov (thing PTR [esi]).y, edx

	cont:

	ret
kbmove ENDP

mmove PROC USES esi edi obj: PTR thing
	
	mov esi, obj
	mov edi, OFFSET MouseStatus
	cmp (MouseInfo PTR [edi]).buttons, MK_LBUTTON
	jne resume
	mov eax, (MouseInfo PTR [edi]).horiz
	mov (thing PTR [esi]).x, eax
	mov eax, (MouseInfo PTR [edi]).vert
	mov (thing PTR [esi]).y, eax

	resume:

	ret
mmove ENDP

floatHoriz PROC USES esi obj: PTR thing

	mov esi, obj
	cmp (thing PTR [esi]).vis, 1
	jne stop

	cmp (thing PTR [esi]).state, 1
	jne left
	right:
	cmp (thing PTR [esi]).x, 640
	jl keep_right
	mov (thing PTR [esi]).state, 0
	jmp keep_left
	keep_right:
	inc (thing PTR [esi]).x
	jmp resume

	left:
	cmp (thing PTR [esi]).x, 0
	jg keep_left
	mov (thing PTR [esi]).state, 1
	jmp keep_right

	keep_left:
	dec (thing PTR [esi]).x
	jmp resume

	resume:
	invoke BasicBlit, OFFSET fighter_001, (thing PTR [esi]).x, (thing PTR [esi]).y

	stop:

	ret
floatHoriz ENDP

falldown PROC USES esi edi amm: PTR thing, ammBmp: PTR EECS205Bitmap

	rdtsc
	invoke nseed, eax

	resume:
	mov eax, amm
	mov esi, (thing PTR [eax]).y
	add esi, 2
	mov (thing PTR [eax]).y, esi
	cmp esi, 479
	jge clear
	mov edi, ammBmp
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y
	jmp stop

	; hide from screen, reset y value
	clear:
	mov esi, amm
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	mov (thing PTR [esi]).y, 0

	stop:

ret
falldown ENDP

fallup PROC USES esi edi amm: PTR thing, ammBmp: PTR EECS205Bitmap

	rdtsc
	invoke nseed, eax
	
	mov eax, amm
	mov esi, (thing PTR [eax]).y
	sub esi, 2
	mov (thing PTR [eax]).y, esi
	cmp esi, 0
	jle clear
	mov edi, ammBmp
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y
	jmp stop

	; hide from screen, reset y value
	clear:
	mov esi, amm
	invoke nrandom, 639
	mov (thing PTR [esi]).x, eax
	mov (thing PTR [esi]).y, 479

	stop:

	ret
fallup ENDP

fallright PROC USES esi edi amm: PTR thing, ammBmp: PTR EECS205Bitmap

	rdtsc
	invoke nseed, eax

	mov eax, amm
	mov esi, (thing PTR [eax]).x
	add esi, 2
	mov (thing PTR [eax]).x, esi
	cmp esi, 639
	jge clear
	mov edi, ammBmp
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y
	jmp stop

	; hide from screen, reset y value
	clear:
	mov esi, amm
	invoke nrandom, 479
	mov (thing PTR [esi]).x, 0
	mov (thing PTR [esi]).y, eax

	stop:

ret
fallright ENDP

fallleft PROC USES esi edi amm: PTR thing, ammBmp: PTR EECS205Bitmap

	rdtsc
	invoke nseed, eax

	mov eax, amm
	mov esi, (thing PTR [eax]).x
	sub esi, 2
	mov (thing PTR [eax]).x, esi
	cmp esi, 0
	jle clear
	mov edi, ammBmp
	invoke BasicBlit, edi, (thing PTR [eax]).x, (thing PTR [eax]).y
	jmp stop

	; hide from screen, reset y value
	clear:
	mov esi, amm
	invoke nrandom, 479
	mov (thing PTR [esi]).x, 639
	mov (thing PTR [esi]).y, eax

	stop:

ret
fallleft ENDP

END