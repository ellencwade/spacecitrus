; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;	Ellen C Wade
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

getSin PROC USES edx esi angle:FXPT
	
	; 0 case
	cmp angle, 0
	jne pi_2
	mov eax, 0
	jmp next
	; pi/2 case
	pi_2:
	cmp angle, PI_HALF
	jne resume
	mov eax, 1
	shl eax, 16
	jmp next

	; other cases
	resume:
	mov eax, angle
	mov esi, PI_INC_RECIP
	mov edx, 0
	mul esi
	mov eax, edx
	shl eax, 1
	mov eax, FXPT PTR [SINTAB + eax]

	next:


	ret
getSin ENDP

FixedSin PROC USES edx edi angle:FXPT

	mov edi, 0

	reduce_angle:
	cmp angle, TWO_PI
	jl change_sign
	sub angle, TWO_PI
	jmp reduce_angle

	; changes sign
	change_sign:
	cmp angle, 0
	jge check_half
	add angle, TWO_PI
	jmp change_sign

	check_half:
	cmp angle, PI_HALF
	jg check_pi
	invoke getSin, angle
	jmp resume

	; for angles PI_HALF < angle <= PI
	check_pi:
	cmp angle, PI
	jg check_pi_and_half
	mov eax, PI
	mov edx, angle
	sub eax, edx
	mov angle, eax
	invoke getSin, angle
	jmp resume

	; for angles PI < angle <= PI_HALF
	check_pi_and_half:
	cmp angle, PI + PI_HALF
	jg check_two_pi
	sub angle, PI
	invoke getSin, angle
	neg eax
	jmp resume

	; for angles PI+PI_HALF < angle <= 2PI
	check_two_pi:
	add angle, PI_HALF
	sub angle, TWO_PI
	mov eax, PI_HALF
	sub eax, angle
	mov angle, eax 
	invoke getSin, angle
	neg eax
	jmp resume

	resume:

	ret			; Don't delete this line!!!
FixedSin ENDP 
	
FixedCos PROC angle:FXPT

	mov eax, angle
	add eax, PI_HALF
	mov angle, eax
	invoke FixedSin, angle

	ret			; Don't delete this line!!!	
FixedCos ENDP	
END
