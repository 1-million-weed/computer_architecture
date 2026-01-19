.ORIG x3000

    AND R1, R1, #0 
    AND R5, R5, #0
    
    
READ_FIRST
    GETC                ; R0 holds the input char
    PUTC

    ;Check for SPACE
    LD  R2, NEG_SPACE   ; Load -32
    ADD R3, R0, R2      ; Use R3 for check,
    BRz READ_SECOND            ; If zero, we are done

    ; Check for NEWLINE
    LD  R2, NEG_NEWLINE ; Load -10
    ADD R3, R0, R2      ; Use R3 for check
    BRz READ_SECOND            ; If zero, we are done

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
    
    BR READ_FIRST


READ_SECOND
    GETC                ; R0 holds the input char
    PUTC

    ;Check for SPACE
    LD  R2, NEG_SPACE   ; Load -32
    ADD R3, R0, R2      ; Use R3 for check,
    BRz PRINT_NUMBERS            ; If zero, we are done

    ; Check for NEWLINE
    LD  R2, NEG_NEWLINE ; Load -10
    ADD R3, R0, R2      ; Use R3 for check
    BRz PRINT_NUMBERS            ; If zero, we are done

    ; Multiply Current Total (R1) by 10
    ADD R3, R5, R5      ; R3 = 2 * R1
    ADD R4, R3, R3      ; R4 = 4 * R1
    ADD R4, R4, R4      ; R4 = 8 * R1
    ADD R5, R4, R3      ; R1 = 8*R1 + 2*R1 = 10 * R1

    ; Convert Char to Integer
    ; '0' is x30 (48). We must subtract 48 to get the integer.
    LD  R2, NEG_ZERO    ; Load -48
    ADD R0, R0, R2      ; R0 now holds the integer value 

    ; Add new digit to Total
    ADD R5, R5, R0      ; Total = (Total * 10) + Digit
    
    BR READ_SECOND


PRINT_NUMBERS
    ; Print newline first
    ;LD R0, NEWLINE
    ;PUTC
    
    ; R1 has first number (start)
    ; R5 has second number (end)
    ; R6 will be our counter
    ADD R6, R1, #0      ; R6 = start number

PRINT_LOOP
    ; Print current number - convert to ASCII and print
    LD R0, ASCII_ZERO
    ADD R0, R0, R6
    PUTC
    
    ; Check if we're done (R6 == R5)
    NOT R3, R5          ; R3 = -R5
    ADD R3, R3, #1      
    ADD R3, R6, R3      ; R3 = R6 - R5
    BRz DONE            ; If equal, we're done
    
    ; Not done, print space and increment
    LD R0, SPACE
    PUTC
    ADD R6, R6, #1
    BR PRINT_LOOP
    
DONE
    ; Print final newline
    LD R0, NEWLINE
    PUTC
    HALT
SPACE       .FILL x0020
NEWLINE     .FILL x000A
ASCII_ZERO  .FILL x0030
NEG_SPACE   .FILL #-32
NEG_NEWLINE .FILL #-10
NEG_ZERO    .FILL #-48

.END