; #########################################################################
;;
;   audiovisual.asm - Assembly file for EECS205 Assignment 4/5
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
include \masm32\include\windows.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib
include keys.inc

.DATA
explosion BYTE "Explosion+7.wav", 0
background BYTE "background.wav", 0
awshit BYTE "awshit.wav", 0

.CODE

shit PROC

	invoke PlaySound, offset awshit, 0, SND_ASYNC
	ret
shit ENDP
backgroundsound PROC

	invoke PlaySound, offset background, 0, SND_LOOP

	ret
backgroundsound ENDP

drawStars PROC

	invoke DrawStarField
	;; stars fall or pass BY
	;; OR stars twinkle

	ret
drawStars ENDP

explode PROC
	
	invoke PlaySound, offset explosion, 0, SND_ASYNC

	ret

explode ENDP

END