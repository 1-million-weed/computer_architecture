.ORIG x3000

    AND R1, R1, #0      ; R1 will be our Total (Clear it)

READ_LOOP
    GETC                ; R0 holds the input char
    PUTC

    ;Check for SPACE
    LD  R2, NEG_SPACE   ; Load -32
    ADD R3, R0, R2      ; Use R3 for check,
    BRz DONE            ; If zero, we are done

    ; Check for NEWLINE
    LD  R2, NEG_NEWLINE ; Load -10
    ADD R3, R0, R2      ; Use R3 for check
    BRz DONE            ; If zero, we are done

    ; Multiply Current Total (R1) by 10
    ADD R3, R1, R1      ; R3 = 2 * R1
    ADD R4, R3, R3      ; R4 = 4 * R1
    ADD R4, R4, R4      ; R4 = 8 * R1
    ADD R1, R4, R3      ; R1 = 8*R1 + 2*R1 = 10 * R1

    ; Convert Char to Integer
    ; '0' is x30 (48). We must subtract 48 to get the integer.
    LD  R2, NEG_ZERO    ; Load -48
    ADD R0, R0, R2      ; R0 now holds the integer value 

    ; Add new digit to Total
    ADD R1, R1, R0      ; Total = (Total * 10) + Digit

    BRnzp READ_LOOP     ; Go back for next char

DONE
    HALT

NEG_SPACE   .FILL #-32
NEG_NEWLINE .FILL #-10
NEG_ZERO    .FILL #-48

.END