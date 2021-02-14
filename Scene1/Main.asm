;===============================================================================
; Commodore 64: "Your Game Project"
;
; File: Project 1
;===============================================================================
;===============================================================================

;===============================================================================
; SCROLLING MAP EXAMPLE 1 - C64 YouTube Game Project
; 2016/17 - Peter 'Sig' Hewett aka RetroRomIcon (contributions)
; Additional coding by Steve Morrow
;===============================================================================
Operator Calc        ; IMPORTANT - calculations are made BEFORE hi/lo bytes
                     ;             in precidence (for expressions and tables)
;===============================================================================
;                                                                   DEFINITIONS
;===============================================================================
IncAsm "VIC_Registers.asm"             ; VICII register includes
IncAsm "Game_Macros.asm"                    ; macro includes
;===============================================================================
;===============================================================================
;                                                                     CONSTANTS
;===============================================================================

#region "Constants"
SCREEN_MEM   = $4000
COLOR_MEM  = $D800                   ; Color mem never changes
CHAR_MEM   = $4800                   ; Base of character set memory (set 1)
LEVEL_1_MAP   = $E000                ;Address of level 1 tiles/charsets
LEVEL_1_CHARS = $E800
#endregion

;===============================================================================
; ZERO PAGE LABELS
;===============================================================================
#region "ZeroPage"
PARAM1 = $03                 ; These will be used to pass parameters to routines
PARAM2 = $04                 ; when you can't use registers or other reasons
PARAM3 = $05                            
PARAM4 = $06                 ; essentially, think of these as extra data registers
PARAM5 = $07

;---------------------------- $11 - $16 available

ZEROPAGE_POINTER_1 = $17     ; Similar only for pointers that hold a word long address
ZEROPAGE_POINTER_2 = $19
ZEROPAGE_POINTER_3 = $21
ZEROPAGE_POINTER_4 = $23

                            ; All data is for the top left corner of the visible map area
MAP_X_POS       = $30       ; Current map x position (in tiles)
MAP_Y_POS       = $31       ; Current map y position (in tiles)

#endregion

;===============================================================================
; BASIC KICKSTART
;===============================================================================
KICKSTART
; Sys call to start the program - 10 SYS (2064)

*=$0801

        BYTE $0E,$08,$0A,$00,$9E,$20,$28,$32,$30,$36,$34,$29,$00,$00,$00

;===============================================================================
; START OF GAME PROJECT
;===============================================================================
*=$0810

;===============================================================================
; SETUP VIC BANK MEMORY
;===============================================================================
#region "VIC Setup"

        ; To set the VIC bank we have to change the first 2 bits in the
        ; CIA 2 register. So we want to be careful and only change the
        ; bits we need to.

        lda VIC_BANK            ; Fetch the status of CIA 2 ($DD00)
        and #%11111100          ; mask for bits 2-8
        ora #%00000010          ; the first 2 bits are your desired VIC bank value
                                ; In this case bank 1 ($4000 - $7FFF)
        sta VIC_BANK

#endregion

;===================================================================================================
;  MAIN LOOP
;===================================================================================================
MainLoop
        lda #1
        sta 2048

        jmp MainLoop
