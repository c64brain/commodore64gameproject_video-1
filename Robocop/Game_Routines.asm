;===================================================================================================
;                                                                               CORE ROUTINES
;===================================================================================================
#region "CopyChars"

;===============================================================================
; COPY CHARACTER SET TO MEMORY
;===============================================================================

; MAP_MEM = ZEROPAGE_POINTER_1
; LEVEL_1_MAP = ZEROPAGE_POINTER_2

;        loadPointer ZEROPAGE_POINTER_1, MAP_MEM         ; source
;        loadPointer ZEROPAGE_POINTER_2, LEVEL_1_MAP     ; destination

; CHAR_MEM = ZEROPAGE_POINTER_1
; LEVEL_1_CHARS = ZEROPAGE_POINTER_2

;        loadPointer ZEROPAGE_POINTER_1, CHAR_MEM
;        loadPointer ZEROPAGE_POINTER_2, LEVEL_1_CHARS

; Copies the CharPad Map binaary file to ZEROPAGE_POINTER_1
; Copies the CharPad

CopyChars
        
        saveRegs

        ldx #$00                                ; clear X, Y, A and PARAM2
        ldy #$00
        lda #$00
        sta PARAM2
@NextLine



        lda (ZEROPAGE_POINTER_1),Y              ; MAP_MEM/CHAR_MEM = CharPad binary map data
        sta (ZEROPAGE_POINTER_2),Y              ; LEVEL_1_MAP/LEVEL_1_CHARS

        inx                                     ; increment x / y
        iny                                     
        cpx #$08                                ; test for next character block (8 bytes)
        bne @NextLine                           ; copy next line
        cpy #$00                                ; test for edge of page (256 wraps back to 0)
        bne @PageBoundryNotReached

        inc ZEROPAGE_POINTER_1 + 1              ; if reached 256 bytes, increment high byte
        inc ZEROPAGE_POINTER_2 + 1              ; of source and target

@PageBoundryNotReached
        inc PARAM2                              ; Only copy 254 characters (to keep irq vectors intact)
        lda PARAM2                              ; If copying to F000-FFFF block
        cmp #255
        beq @CopyCharactersDone
        ldx #$00
        jmp @NextLine

@CopyCharactersDone

        restoreRegs

        rts
#endregion
