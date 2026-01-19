.ORIG x3000


    JSR GET_NUM
    ST  R0, COUNT
    
    LD  R1, ARRAY_PTR
    LD  R2, COUNT
    
READ_LOOP
    ADD R2, R2, #0
    BRz START_PROCESS
    
    JSR GET_NUM
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRnzp READ_LOOP

START_PROCESS
    LD  R1, ARRAY_PTR
    LD  R2, COUNT

PROCESS_LOOP
    ADD R2, R2, #0
    BRz DONE
    
    LDR R0, R1, #0
    ST  R0, CURR_NUM
    ST  R1, CURR_PTR
    ST  R2, CURR_CNT

    LD  R0, CURR_NUM
    JSR PRINT_NUM
    
    LD  R0, CURR_NUM
    JSR IS_PRIME
    
    ADD R0, R0, #0
    BRnp NOT_PRIME_MSG
    
    LEA R0, MSG_IS_P
    PUTS
    BRnzp NEXT_ITER

NOT_PRIME_MSG
    ST  R0, DIVISOR
    LEA R0, MSG_NOT_P
    PUTS
    LEA R0, MSG_DIV
    PUTS
    LD  R0, DIVISOR
    JSR PRINT_NUM
    LD  R0, CHAR_NL
    OUT

NEXT_ITER
    LD  R1, CURR_PTR
    ADD R1, R1, #1
    LD  R2, CURR_CNT
    ADD R2, R2, #-1
    BRnzp PROCESS_LOOP

DONE
    HALT


COUNT       .BLKW 1
ARRAY_PTR   .FILL x4000
CURR_NUM    .BLKW 1
CURR_PTR    .BLKW 1
CURR_CNT    .BLKW 1
DIVISOR     .BLKW 1
CHAR_NL     .FILL x000A
MSG_IS_P    .STRINGZ " is a prime number\n"
MSG_NOT_P   .STRINGZ " is not a prime number"
MSG_DIV     .STRINGZ " as it is divisible by "


; SUBROUTINE: IS_PRIME
; Input: R0 (Number to check)
; Output: R0 (0 if prime, else the smallest divisor)

IS_PRIME
    ST  R1, SAVER1
    ST  R2, SAVER2
    ST  R3, SAVER3
    ST  R4, SAVER4

    ADD R3, R0, #0
    
    ADD R4, R3, #-2
    BRn IS_PRIME_NO

    ADD R4, R3, #-2
    BRz IS_PRIME_YES

    LD R4, CONST_2
    
LOOP_REAL
    ; Check if R4 >= R3 (checked all possible divisors)
    NOT R5, R3
    ADD R5, R5, #1
    ADD R5, R4, R5
    BRzp IS_PRIME_YES
    
    ADD R0, R3, #0
    ADD R2, R4, #0
    JSR DIV_MOD
    ADD R1, R1, #0
    BRz FOUND_DIVISOR_REAL
    
    ADD R4, R4, #1
    BRnzp LOOP_REAL

IS_PRIME_NO
    ADD R0, R3, #0
    BRnzp PRIME_EXIT

IS_PRIME_YES
    AND R0, R0, #0
    BRnzp PRIME_EXIT

FOUND_DIVISOR_REAL
    ADD R0, R4, #0
    BRnzp PRIME_EXIT

CONST_2 .FILL #2

PRIME_EXIT
    LD  R1, SAVER1
    LD  R2, SAVER2
    LD  R3, SAVER3
    LD  R4, SAVER4
    RET

SAVER1 .BLKW 1
SAVER2 .BLKW 1
SAVER3 .BLKW 1
SAVER4 .BLKW 1

; SUBROUTINE: DIV_MOD
; Input: R0 (Dividend), R2 (Divisor)
; Output: R0 (Quotient), R1 (Remainder)
; Logic: Repeated Subtraction

DIV_MOD
    ST  R3, DM_SAVER3
    ST  R4, DM_SAVER4
    ST  R5, DM_SAVER5
    
    ; R0 has dividend, R2 has divisor
    ADD R1, R0, #0      ; R1 = Remainder (starts as dividend)
    AND R0, R0, #0      ; R0 = Quotient (starts at 0)
    
    ; Prepare negative divisor
    NOT R4, R2
    ADD R4, R4, #1      ; R4 = -R2

DM_LOOP
    ADD R5, R1, R4      ; R5 = Remainder - Divisor
    BRn DM_DONE         ; If negative, done
    
    ADD R1, R5, #0      ; Update remainder
    ADD R0, R0, #1      ; Increment quotient
    BRnzp DM_LOOP

DM_DONE
    LD  R3, DM_SAVER3
    LD  R4, DM_SAVER4
    LD  R5, DM_SAVER5
    RET
DM_SAVER3 .BLKW 1
DM_SAVER4 .BLKW 1
DM_SAVER5 .BLKW 1

; SUBROUTINE: GET_NUM
; Inputs specific multidigit number from console (handles ' ' and '\n')
; Returns: R0 (Value in Binary)

GET_NUM
    ST  R1, GN_SAVER1
    ST  R2, GN_SAVER2
    ST  R3, GN_SAVER3
    
    AND R1, R1, #0
    
GN_READ
    GETC
    OUT
    
    ADD R2, R0, #-10
    BRz GN_DONE
    ADD R2, R0, #-16
    ADD R2, R0, #-16
    LD  R2, ASCII_SPC
    NOT R2, R2
    ADD R2, R2, #1
    ADD R2, R0, R2
    BRz GN_DONE
    
    LD  R2, ASCII_0
    NOT R2, R2
    ADD R2, R2, #1
    ADD R0, R0, R2
    
    ADD R2, R1, R1
    ADD R3, R2, R2
    ADD R3, R3, R3
    ADD R1, R3, R2
    
    ADD R1, R1, R0
    BRnzp GN_READ
    
GN_DONE
    ADD R0, R1, #0
    LD  R1, GN_SAVER1
    LD  R2, GN_SAVER2
    LD  R3, GN_SAVER3
    RET

ASCII_0   .FILL x30
ASCII_SPC .FILL x20
GN_SAVER1 .BLKW 1
GN_SAVER2 .BLKW 1
GN_SAVER3 .BLKW 1


; SUBROUTINE: PRINT_NUM
; Prints value in R0 as ASCII decimal
PRINT_NUM
    ST  R0, PN_SAVER0
    ST  R1, PN_SAVER1
    ST  R7, PN_SAVER7
    
    ADD R1, R0, #0
    BRnp PN_START
    LD  R0, ASCII_0
    OUT
    BRnzp PN_EXIT

PN_START
    LEA R1, PN_BUFFER
    ADD R1, R1, #5
    ST  R1, PN_PTR
    AND R2, R2, #0
    STR R2, R1, #0
    
    LD  R2, PN_NEG_10
    ADD R3, R0, #0

PN_LOOP
    ADD R3, R3, #0
    BRz PN_PRINT_NOW
    
    ADD R0, R3, #0
    AND R2, R2, #0
    ADD R2, R2, #10
    JSR DIV_MOD
    
    LD  R4, ASCII_0
    ADD R1, R1, R4
    
    LD  R4, PN_PTR
    ADD R4, R4, #-1
    ST  R4, PN_PTR
    STR R1, R4, #0
    
    ADD R3, R0, #0
    BRnzp PN_LOOP

PN_PRINT_NOW
    LD  R0, PN_PTR
    PUTS
    
PN_EXIT
    LD  R0, PN_SAVER0
    LD  R1, PN_SAVER1
    LD  R7, PN_SAVER7
    RET

PN_NEG_10 .FILL #-10
PN_BUFFER .BLKW 6
PN_PTR    .BLKW 1
PN_SAVER0 .BLKW 1
PN_SAVER1 .BLKW 1
PN_SAVER7 .BLKW 1

.END