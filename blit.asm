; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;	Ellen C Wade
; 	EECS 205 - Winter 2018 - Assignment 3
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  		; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA

	;; If you need to, you can place global variables here

.CODE

DrawPixel PROC USES esi ebx ecx edx x:DWORD, y:DWORD, color:DWORD
  ; check bounds
  cmp x, 639
  jg continue
  cmp x, 0
  jl continue
  cmp y, 0
  jl continue
  cmp y, 479
  jg continue

  ; find index
  mov eax, y
  mov esi, 640
  mov edx, 0
  imul esi
  add eax, ScreenBitsPtr
  add eax, x

  ; set color
  mov ebx, color
  mov [eax], ebx

	continue:
	ret 										; Don't delete this line!!!
DrawPixel ENDP



BasicBlit PROC USES esi edi ebx ecx edx ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
LOCAL dwWidth:DWORD, dwHeight:DWORD, trans: BYTE, x_init:DWORD, y_init:DWORD

	mov esi, xcenter
	mov edi, ycenter
	mov edx, ptrBitmap

	;; move dwWidth
	mov eax, (EECS205BITMAP PTR [edx]).dwWidth
	mov dwWidth, eax							

	;; find dwHeight
	mov eax, (EECS205BITMAP PTR [edx]).dwHeight
	mov dwHeight, eax

	;; find x_init
	mov eax, dwWidth
	sar eax, 1									
	sub esi, eax								
	mov x_init, esi								

	;; find y_init
	mov eax, dwHeight
	sar eax, 1									
	sub edi, eax								
	mov y_init, edi								

	mov al, (EECS205BITMAP PTR [edx]).bTransparent	
	mov trans, al

	mov edx, (EECS205BITMAP PTR [edx]).lpBytes	

	mov edi, 0									
	mov ecx, y_init								
	jmp cond

	body:
			mov esi, 0							
			mov ebx, x_init						
			jmp cond2					
		body2:
		
			mov eax, edi						
			imul eax, dwWidth					
			add eax, esi						

			mov al, BYTE PTR [edx + eax]				
			cmp al, trans
			je resume

			; check bounds			
			cmp ebx, 0
			jl resume							 
			cmp ebx, 640				
			jge resume							

			cmp ecx, 0
			jl resume						 
			cmp ecx, 480
			jge resume					 

			movzx eax, al   					
			invoke DrawPixel, ebx, ecx, eax 	


			resume:								
			inc esi
			inc ebx

		cond2:
			cmp esi, dwWidth
			jl body2  						
			inc edi					
			inc ecx
	cond:
		cmp edi, dwHeight
		jl body 							

	ret 										; Don't delete this line!!!	
BasicBlit ENDP

RotateBlit PROC lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
LOCAL cosa: FXPT, sina: FXPT, shiftX: DWORD, shiftY: DWORD, dstWidth: DWORD, dstHeight: DWORD
LOCAL srcX: DWORD, srcY: DWORD, x: DWORD, y: DWORD

  invoke FixedCos, angle
  mov ebx, eax                                          
  mov cosa, ebx

  invoke FixedSin, angle
  mov ecx, eax                                         
  mov sina, ecx

  mov esi, lpBmp                                          
  mov edx, (EECS205BITMAP PTR[esi]).dwWidth              
  mov edi, (EECS205BITMAP PTR[esi]).dwHeight              

; set shiftX
  mov eax, (EECS205BITMAP PTR [esi]).dwWidth
  shl eax, 16
  imul cosa
  mov eax, edx
  mov ecx, 2
  mov edx, 0
  idiv ecx
  mov ecx, eax
  mov eax, (EECS205BITMAP PTR [esi]).dwHeight
  shl eax, 16
  imul sina
  mov eax, edx
  mov edi, 2
  mov edx, 0
  idiv edi
  sub ecx, eax
  mov shiftX, ecx

  ; set shiftY
  mov eax, (EECS205BITMAP PTR [esi]).dwHeight
  shl eax, 16
  imul cosa
  mov eax, edx
  mov ecx, 2
  mov edx, 0
  idiv ecx
  mov ecx, eax
  mov eax, (EECS205BITMAP PTR [esi]).dwWidth
  shl eax, 16
  imul sina
  mov eax, edx
  mov edi, 2
  mov edx, 0
  idiv edi
  sub ecx, eax
  mov shiftY, ecx                                         

  ; find dstWidth and dstHeight
  mov edi, (EECS205BITMAP PTR[esi]).dwHeight
  add edi, (EECS205BITMAP PTR[esi]).dwWidth
  mov dstWidth, edi
  mov dstHeight, edi

  ; loop
  ; initialize outer
  neg edi
  jmp cond

  body:
    ; initialize inner
    mov ecx, dstHeight
    neg ecx
    jmp cond2

    body2:
      ; find srcX
      mov eax, edi
      sal eax, 16
      imul cosa
      mov srcX, edx

      mov eax, ecx
      sal eax, 16
      imul sina
      add srcX, edx


      ; find srcY
      mov eax, ecx
      sal eax, 16
      imul cosa
      mov srcY, edx

      mov eax, ecx
      sal eax, 16
      imul sina
      sub srcY, edx

      ; very complicated if statement
      mov eax, xcenter
      add eax, edi
      sub eax, shiftX
	  
      cmp eax, 0
      jl resume
      cmp eax, 639
      jge resume
      mov x, eax

      mov eax, ycenter
      add eax, ecx
      sub eax, shiftY

      cmp eax, 0
      jl resume
      cmp eax, 479
      jge resume
      mov y, eax

  cmp srcX, 0
  jl resume
  mov eax, (EECS205BITMAP PTR [esi]).dwWidth
  cmp srcX, eax
  jge resume

  cmp srcY, 0
  jl resume
  mov eax, (EECS205BITMAP PTR [esi]).dwHeight
  cmp srcY, eax
  jge resume


      mov eax, srcY
      imul (EECS205BITMAP PTR[esi]).dwWidth
      add eax, srcX
      add eax, (EECS205BITMAP PTR[esi]).lpBytes
      mov al, BYTE PTR [eax]

      ;; compare to transparent
      cmp al, (EECS205BITMAP PTR[esi]).bTransparent
      je resume

      movzx eax, al
      INVOKE DrawPixel, x, y, eax

      resume:

      inc ecx
    cond2:
      cmp ecx, dstHeight
      jl body2

    inc edi
  cond:
    cmp edi, dstWidth
    jl body



	ret 										; Don't delete this line!!!		
RotateBlit ENDP



END
