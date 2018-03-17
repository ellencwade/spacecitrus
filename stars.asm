; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;   Ellen Wade
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc

	;; draws 16 stars on the starfield
	INVOKE DrawStar, 100, 200
	INVOKE DrawStar, 120, 150
	INVOKE DrawStar, 140, 400
	INVOKE DrawStar, 150, 280
	INVOKE DrawStar, 170, 200
	INVOKE DrawStar, 180, 100
	INVOKE DrawStar, 200, 280
	INVOKE DrawStar, 215, 350
	INVOKE DrawStar, 220, 420
	INVOKE DrawStar, 270, 300
	INVOKE DrawStar, 290, 380
	INVOKE DrawStar, 339, 140
	INVOKE DrawStar, 480, 120
	INVOKE DrawStar, 505, 240
	INVOKE DrawStar, 550, 300
	INVOKE DrawStar, 600, 151
	
	ret  			
DrawStarField endp

DrawStarField2 proc

	;; draws 16 stars on the starfield
	INVOKE DrawStar, 105, 200
	INVOKE DrawStar, 120, 155
	INVOKE DrawStar, 135, 395
	INVOKE DrawStar, 155, 285
	INVOKE DrawStar, 170, 215
	INVOKE DrawStar, 175, 100
	INVOKE DrawStar, 205, 280
	INVOKE DrawStar, 220, 345
	INVOKE DrawStar, 220, 425
	INVOKE DrawStar, 275, 295
	INVOKE DrawStar, 295, 385
	INVOKE DrawStar, 335, 140
	INVOKE DrawStar, 485, 125
	INVOKE DrawStar, 500, 235
	INVOKE DrawStar, 555, 300
	INVOKE DrawStar, 600, 155
	
	ret  			
DrawStarField2 endp

DrawStarField3 proc

	;; draws 16 stars on the starfield
	INVOKE DrawStar, 110, 200
	INVOKE DrawStar, 120, 160
	INVOKE DrawStar, 145, 400
	INVOKE DrawStar, 150, 285
	INVOKE DrawStar, 180, 200
	INVOKE DrawStar, 175, 110
	INVOKE DrawStar, 210, 280
	INVOKE DrawStar, 215, 360
	INVOKE DrawStar, 225, 420
	INVOKE DrawStar, 280, 305
	INVOKE DrawStar, 295, 380
	INVOKE DrawStar, 339, 140
	INVOKE DrawStar, 485, 115
	INVOKE DrawStar, 505, 235
	INVOKE DrawStar, 560, 300
	INVOKE DrawStar, 600, 155
	
	ret  			
DrawStarField3 endp

DrawStarField4 proc

	;; draws 16 stars on the starfield
	INVOKE DrawStar, 100, 200
	INVOKE DrawStar, 120, 150
	INVOKE DrawStar, 140, 400
	INVOKE DrawStar, 150, 280
	INVOKE DrawStar, 170, 200
	INVOKE DrawStar, 180, 100
	INVOKE DrawStar, 200, 280
	INVOKE DrawStar, 215, 350
	INVOKE DrawStar, 220, 420
	INVOKE DrawStar, 270, 300
	INVOKE DrawStar, 290, 380
	INVOKE DrawStar, 339, 140
	INVOKE DrawStar, 480, 120
	INVOKE DrawStar, 505, 240
	INVOKE DrawStar, 550, 300
	INVOKE DrawStar, 600, 151
	
	ret  			
DrawStarField4 endp

DrawStarField5 proc

	;; draws 16 stars on the starfield
	INVOKE DrawStar, 100, 200
	INVOKE DrawStar, 120, 150
	INVOKE DrawStar, 140, 400
	INVOKE DrawStar, 150, 280
	INVOKE DrawStar, 170, 200
	INVOKE DrawStar, 180, 100
	INVOKE DrawStar, 200, 280
	INVOKE DrawStar, 215, 350
	INVOKE DrawStar, 220, 420
	INVOKE DrawStar, 270, 300
	INVOKE DrawStar, 290, 380
	INVOKE DrawStar, 339, 140
	INVOKE DrawStar, 480, 120
	INVOKE DrawStar, 505, 240
	INVOKE DrawStar, 550, 300
	INVOKE DrawStar, 600, 151
	
	ret  			
DrawStarField5 endp

END
