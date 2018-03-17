; #########################################################################
;
;   movement.inc - Includes for EECS205 Assignment 4/5
;
;
; #########################################################################

;; User Defined Functions
hit PROTO amm: PTR thing
hitship PROTO amm: PTR thing, shooter: PTR thing
hitup PROTO amm: PTR thing
hitdown PROTO amm: PTR thing
hitright PROTO amm: PTR thing
hitleft PROTO amm: PTR thing
CheckIntersect PROTO oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, 
				twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 
shoot PROTO amm: PTR thing, ammBmp: PTR EECS205Bitmap, shooter: PTR thing
shootback PROTO amm: PTR thing, amm2: PTR thing, ammBmp: PTR EECS205Bitmap, shooter: PTR thing
kbmove PROTO obj: PTR thing
mmove PROTO obj: PTR thing
floatHoriz PROTO obj: PTR thing
falldown PROTO amm: PTR thing, ammBmp: PTR EECS205Bitmap
fallup PROTO amm: PTR thing, ammBmp: PTR EECS205Bitmap
fallright PROTO amm: PTR thing, ammBmp: PTR EECS205Bitmap
fallleft PROTO amm: PTR thing, ammBmp: PTR EECS205Bitmap