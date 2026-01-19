.ORIG x3000

START
    AND R1, R1, #0      ; R1 will be our Total (Input Number)

READ_LOOP
    GETC                ; R0 holds input
    OUT                 ; Echo to console

    ; Check for SPACE
    LD  R2, NEG_SPACE   
    ADD R3, R0, R2      
    BRz START_LOGIC     

    ; Check for NEWLINE
    LD  R2, NEG_NEWLINE 
    ADD R3, R0, R2      
    BRz START_LOGIC     

    ADD R3, R1, R1      ; R3 = 2 * R1
    ADD R4, R3, R3      ; R4 = 4 * R1
    ADD R4, R4, R4      ; R4 = 8 * R1
    ADD R1, R4, R3      ; R1 = 10 * R1

    ; Convert Char to Integer
    LD  R2, NEG_ZERO    
    ADD R0, R0, R2      ; Convert ASCII to Int
    ADD R1, R1, R0      ; Add to Total

    BRnzp READ_LOOP


START_LOGIC
    
    AND R2, R2, #0      
    ADD R2, R2, #2      ; R2 is our "Current Divisor". Start at 2.

TEST_LOOP
    ; 1. Check if Divisor (R2) == Number (R1)
    NOT R3, R2
    ADD R3, R3, #1      ; R3 = -Divisor
    ADD R4, R1, R3      ; R4 = Number - Divisor
    BRz IS_PRIME        ; If Zero, we finished the loop -> Prime

    ; 2. Modulo Check (R1 % R2)
    ADD R5, R1, #0      ; Copy R1 to R5 (Dividend)

MOD_LOOP
    ADD R5, R5, R3      ; Dividend - Divisor
    BRp MOD_LOOP        ; If positive, keep subtracting
    BRz IS_NOT_PRIME    ; If ZERO, it divides perfectly! -> NOT PRIME
    
    ; If Negative, try next divisor
    ADD R2, R2, #1
    BRnzp TEST_LOOP


IS_PRIME
    JSR PRINT_NUM       ; Print X (R1)
    LEA R0, STR_PRIME   ; Load string
    PUTS
    
    LD R0, NEWLINE
    OUT
    HALT

IS_NOT_PRIME
    ST R2, SAVE_DIVISOR ; Save Divisor R2, because PRINT_NUM clobbers R2!
    
    JSR PRINT_NUM       ; Print X (R1). This corrupts R2.
    LEA R0, STR_NOT     ; Load string
    PUTS
    
    LD R1, SAVE_DIVISOR ; Restore Divisor into R1 for printing
    JSR PRINT_NUM       ; Print Y
    
    LD R0, NEWLINE
    OUT
    HALT

PRINT_NUM
    ST R7, SAVE_R7      ; Save return address
    ST R1, SAVE_R1      ; Save value

    LEA R4, POWERS      ; Load table of powers
    AND R5, R5, #0      ; Leading Zero flag

P_LOOP
    LDR R2, R4, #0      ; Load power (e.g., 10000) into R2
    BRz P_DONE          ; If 0, done

    NOT R2, R2
    ADD R2, R2, #1      ; R2 = -Power
    AND R0, R0, #0      ; Digit counter

SUB_LOOP
    ADD R3, R1, R2      ; Val - Power
    BRn END_SUB
    ADD R1, R3, #0      ; Update Val
    ADD R0, R0, #1      ; Increment Digit
    BRnzp SUB_LOOP

END_SUB
    ADD R6, R0, R5      ; Check if Digit=0 and Flag=0
    BRz SKIP_DIGIT
    
    LD R6, ASCII_OFFSET ; Load +48
    ADD R0, R0, R6
    OUT
    ADD R5, R5, #1      ; Set flag that we have started printing

SKIP_DIGIT
    ADD R4, R4, #1      ; Next power
    BRnzp P_LOOP

P_DONE
    ; Fix for number 0 (if input was 0, nothing printed)
    LD R1, SAVE_R1      
    BRnp RESTORE        ; If original was not 0, skip
    LD R0, ASCII_OFFSET ; Print '0'
    OUT

RESTORE
    LD R1, SAVE_R1
    LD R7, SAVE_R7
    RET


NEG_SPACE   .FILL #-32
NEG_NEWLINE .FILL #-10
NEG_ZERO    .FILL #-48
ASCII_OFFSET .FILL x0030
NEWLINE     .FILL x000A

STR_PRIME   .STRINGZ " is a prime number"
STR_NOT     .STRINGZ " is not a prime number as it is divisible by "

SAVE_R7     .BLKW 1
SAVE_R1     .BLKW 1
SAVE_DIVISOR .BLKW 1 

; Powers of 10
POWERS      .FILL #10000
            .FILL #1000
            .FILL #100
            .FILL #10
            .FILL #1
            .FILL #0

.END