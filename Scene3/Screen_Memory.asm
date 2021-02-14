;===============================================================================
;                                                               SCREEN ROUTINES
;===============================================================================
;                                                            Peter 'Sig' Hewett
;                                                                   - 2016/2017
;-------------------------------------------------------------------------------

;===============================================================================
; FETCH LINE ADDRESS
;===============================================================================
; A helper routine to return the line address for the correct screen to draw to
; Given the screen base in WPARAM1, and the line in X (Y coord) we test
; the high byte in WPARAM1 and use the correct lookup table to get the line
; address, returning it in ZEROPAGE_POINTER_1

; An additional 'jump in' point "FetchScreenLineAddress" can be used that will
; only consider the CURRENT_SCREEN pointer, likewise "FetchBufferLineAddress"
; will jump in and substitute the current buffer.
;
; X - Line required
;
; returns ZEROPAGE_POINTER_1
;
; Modifies A
;
;-------------------------------------------------------------------------------
#region "GetLineAddress"

GetScreenLineAddress
        lda SCREEN1_LINE_OFFSET_TABLE_LO,x
        sta ZEROPAGE_POINTER_1
        lda SCREEN1_LINE_OFFSET_TABLE_HI,x
        sta ZEROPAGE_POINTER_1 + 1
        rts

#endRegion
     

; Screen Line Offset Tables
; Query a line with lda (POINTER TO TABLE),x (where x holds the line number)
; and it will return the screen address for that line

; C64 PRG STUDIO has a lack of expression support that makes creating some tables very problematic
; Be aware that you can only use ONE expression after a defined constant, no braces, and be sure to
; account for order of precedence.

; For these tables you MUST have the Operator Calc directive set at the top of your main file
; or have it checked in options or BAD THINGS WILL HAPPEN!! It basically means that calculations
; will be performed BEFORE giving back the hi/lo byte with '>' rather than the default of
; hi/lo byte THEN the calculation
SCREEN_LINE_OFFSET_TABLE_LO                                            
SCREEN1_LINE_OFFSET_TABLE_LO        
          byte <SCREEN_MEM                      
          byte <SCREEN_MEM + 40                 
          byte <SCREEN_MEM + 80
          byte <SCREEN_MEM + 120
          byte <SCREEN_MEM + 160
          byte <SCREEN_MEM + 200
          byte <SCREEN_MEM + 240
          byte <SCREEN_MEM + 280
          byte <SCREEN_MEM + 320
          byte <SCREEN_MEM + 360
          byte <SCREEN_MEM + 400
          byte <SCREEN_MEM + 440
          byte <SCREEN_MEM + 480
          byte <SCREEN_MEM + 520
          byte <SCREEN_MEM + 560
          byte <SCREEN_MEM + 600
          byte <SCREEN_MEM + 640
          byte <SCREEN_MEM + 680
          byte <SCREEN_MEM + 720
          byte <SCREEN_MEM + 760
          byte <SCREEN_MEM + 800
          byte <SCREEN_MEM + 840
          byte <SCREEN_MEM + 880
          byte <SCREEN_MEM + 920
          byte <SCREEN_MEM + 960

SCREEN_LINE_OFFSET_TABLE_HI
SCREEN1_LINE_OFFSET_TABLE_HI
          byte >SCREEN_MEM
          byte >SCREEN_MEM + 40
          byte >SCREEN_MEM + 80
          byte >SCREEN_MEM + 120
          byte >SCREEN_MEM + 160
          byte >SCREEN_MEM + 200
          byte >SCREEN_MEM + 240
          byte >SCREEN_MEM + 280
          byte >SCREEN_MEM + 320
          byte >SCREEN_MEM + 360
          byte >SCREEN_MEM + 400
          byte >SCREEN_MEM + 440
          byte >SCREEN_MEM + 480
          byte >SCREEN_MEM + 520
          byte >SCREEN_MEM + 560
          byte >SCREEN_MEM + 600
          byte >SCREEN_MEM + 640
          byte >SCREEN_MEM + 680
          byte >SCREEN_MEM + 720
          byte >SCREEN_MEM + 760
          byte >SCREEN_MEM + 800
          byte >SCREEN_MEM + 840
          byte >SCREEN_MEM + 880
          byte >SCREEN_MEM + 920
          byte >SCREEN_MEM + 960
                                                  
COLOR_LINE_OFFSET_TABLE_LO        
          byte <COLOR_MEM                      
          byte <COLOR_MEM + 40                 
          byte <COLOR_MEM + 80
          byte <COLOR_MEM + 120
          byte <COLOR_MEM + 160
          byte <COLOR_MEM + 200
          byte <COLOR_MEM + 240
          byte <COLOR_MEM + 280
          byte <COLOR_MEM + 320
          byte <COLOR_MEM + 360
          byte <COLOR_MEM + 400
          byte <COLOR_MEM + 440
          byte <COLOR_MEM + 480
          byte <COLOR_MEM + 520
          byte <COLOR_MEM + 560
          byte <COLOR_MEM + 600
          byte <COLOR_MEM + 640
          byte <COLOR_MEM + 680
          byte <COLOR_MEM + 720
          byte <COLOR_MEM + 760
          byte <COLOR_MEM + 800
          byte <COLOR_MEM + 840
          byte <COLOR_MEM + 880
          byte <COLOR_MEM + 920
          byte <COLOR_MEM + 960

COLOR_LINE_OFFSET_TABLE_HI
          byte >COLOR_MEM
          byte >COLOR_MEM + 40
          byte >COLOR_MEM + 80
          byte >COLOR_MEM + 120
          byte >COLOR_MEM + 160
          byte >COLOR_MEM + 200
          byte >COLOR_MEM + 240
          byte >COLOR_MEM + 280
          byte >COLOR_MEM + 320
          byte >COLOR_MEM + 360
          byte >COLOR_MEM + 400
          byte >COLOR_MEM + 440
          byte >COLOR_MEM + 480
          byte >COLOR_MEM + 520
          byte >COLOR_MEM + 560
          byte >COLOR_MEM + 600
          byte >COLOR_MEM + 640
          byte >COLOR_MEM + 680
          byte >COLOR_MEM + 720
          byte >COLOR_MEM + 760
          byte >COLOR_MEM + 800
          byte >COLOR_MEM + 840
          byte >COLOR_MEM + 880
          byte >COLOR_MEM + 920
          byte >COLOR_MEM + 960
