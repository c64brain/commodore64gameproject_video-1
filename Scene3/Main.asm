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
;===============================================================================
; SYSTEM INITIALIZATION
;===============================================================================
#region "System Setup"
System_Setup

        ; Here is where we copy level 1 data from the start setup to under
        ; $E000 so we can use it later when the game resets.
        ; A little bank switching is involved here.
        sei       

        ; Here you load and store the Processor Port ($0001), then use 
        ; it to turn off LORAM (BASIC), HIRAM (KERNAL), CHAREN (CHARACTER ROM)
        ; then use a routine to copy your sprite and character mem under there
        ; before restoring the original value of $0001 and turning interrupts
        ; back on.

        lda PROC_PORT                   ; store ram setup
        sta PARAM1

        ; When the game starts, Level 1 tiles and characters are stored in place to run,
        ; However, when the game resets we will need to restore these levels intact.
        ; So we're saving them away to load later under the KERNAL at $E000-$EFFF (4k)
        ; To do this we need to do some bank switching, copy data, then restore as
        ; we may use the KERNAL later for some things.

        loadPointer ZEROPAGE_POINTER_1, MAP_MEM         ; source
        loadPointer ZEROPAGE_POINTER_2, LEVEL_1_MAP     ; destination

        jsr CopyChars                   ; CopyChars for charsets copys 2048 bytes of character
                                        ; data, the same size as our tile maps, so we use that
                                        ; routine

        loadPointer ZEROPAGE_POINTER_1, CHAR_MEM
        loadPointer ZEROPAGE_POINTER_2, LEVEL_1_CHARS
        jsr  CopyChars

        lda PARAM1                      ; restore ram setup
        sta PROC_PORT
        cli
#endregion
;===============================================================================
; SCREEN SETUP
;===============================================================================
#region "Screen Setup"
Screen_Setup
        lda #COLOR_BLACK
        sta VIC_BACKGROUND_COLOR 
        lda #COLOR_ORANGE
        sta VIC_CHARSET_MULTICOLOR_1
        lda #COLOR_BROWN
        sta VIC_CHARSET_MULTICOLOR_2

;===================================================================================================
;  MAP POSITION
;===================================================================================================

        ;-------------------------------------------------- CHARPAD LEVEL SETUP
        lda #1                          ; Start Level = 1
        sta CURRENT_LEVEL
        jsr LoadLevel                   ; load level 1 data

        ldx #27                        ; Y start pos (in tile coords) (129,26=default)
        ldy #4                          ; X start pos (in tile coords)

        jsr DrawMap                     ; Draw the level map (Screen1)
                                        ; And initialize it
        
        lda #%00011000                  ; Default (Y scroll = 3 by default)                                      ; 
        sta VIC_SCREEN_CONTROL          ; $D011
        lda #COLOR_BLACK 
        sta VIC_BORDER_COLOR
        lda #%00010000
        sta VIC_SCREEN_CONTROL_X                ; $D016 - (53270) - multicolor control 

        lda #%00000010                  ; Set VIC to Screen0, Charset 1
        sta VIC_MEMORY_CONTROL          ; $D018 (53272) = $0800 (2048)

#endregion

;===================================================================================================
;  MAIN LOOP
;===================================================================================================
MainLoop
        lda #1
        sta 2048

        jmp MainLoop

;===============================================================================
; FILES IN GAME PROJECT
;===============================================================================
;        incAsm "Game_Interrupts.asm"
        incAsm "Game_Routines.asm"                  ; core framework routines
        incAsm "Screen_Memory.asm"                ; screen drawing and handling
        incAsm "Start_Level.asm"

;---------------------------------------------------------------------------------------------------
*=$4000
;===============================================================================
;                                                       VIC MEMORY BLOCK
;                                                       CHARSET AND SPRITE DATA
;===============================================================================
; Charset and Sprite data directly loaded here.

VIC_DATA_INCLUDES

; VIC VIDEO MEMORY LAYOUT - BANK 1 ($4000 - $7FFF)
; SCREEN_1      = $4000 - $43FF         (Screen 0)      ; Double buffered
; SCREEN_2      = $4400 - $47FF         (Screen 1)      ; game screen
; MAP_CHARS     = $4800 - $5FFF         (Charset 1)     ; game chars (tiles)
; SCORE_CHARS   = $5000 - $57FF         (Charset 2)     ; Scoreboard chars
; SCORE_SCREEN  = $5800 - $5BFF         (Screen 6)      ; Scoreboard Screen
; SPRITES       = $5COO - $7FFF         (144 Sprite Images)

;---------------------
; CHARACTER SET SETUP
;---------------------
; Going with the 'Bear Essentials' model would be :
;
; 000 - 063    Normal font (letters / numbers / punctuation, sprite will pass over)
; 064 - 127    Backgrounds (sprite will pass over)
; 128 - 143    Collapsing platforms (deteriorate and eventually disappear when stood on)
; 144 - 153    Conveyors (move the character left or right when stood on)
; 154 - 191    Semi solid platforms (can be stood on, but can jump and walk through)
; 192 - 239    Solid platforms (cannot pass through)
; 240 - 255    Death (spikes etc)
;

*=$4800
MAP_CHAR_MEM                            ; Character set for map screen
incbin"Parkour_Maps/Parkour Redo Chset6.bin"

;---------------------------------------------------------- SPRITE DATA
*=$5C00

; Reserve later for sprites

;===================================================================================================
;  LEVEL DATA
;===================================================================================================
; Each Level has a character set (2k) an attribute/color list (256 bytes) 64 4x4 tiles (1k)
; and a 64 x 32 (or 32 x 64) map (2k).

; The current level map will be put at $8000 with Attribute lists (256 bytes) and Tiles (1k)
; Starting after it at 8800
;
*=$8000

MAP_MEM
incbin"Parkour_Maps/Parkour Redo Map6.bin"


ATTRIBUTE_MEM
incbin"Parkour_Maps/Parkour Redo ChsetAttrib6.bin"

TILE_MEM
incbin"Parkour_Maps/Parkour Redo Tileset6.bin"
