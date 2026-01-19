.ORIG x3000


    LEA R1, MAT_A       ; R1 points to start of Matrix A
    JSR READ_MAT        ; Call input subroutine

    LEA R1, MAT_B       ; R1 points to start of Matrix B
    JSR READ_MAT        ; Call input subroutine

    LD R0, MAIN_NL
    OUT

    JSR MATRIX_MULTIPLY

    LEA R1, MAT_C       ; R1 points to Result Matrix
    JSR PRINT_MAT       ; Call print subroutine

    HALT

MAIN_NL .FILL 10

MAT_A   .BLKW 9
MAT_B   .BLKW 9
MAT_C   .BLKW 9

READ_MAT
    ST  R7, RM_SaveR7   ; Save Return Address
    ST  R2, RM_SaveR2   ; Save Loop Counter
    
    AND R2, R2, #0      
    ADD R2, R2, #9      ; Set loop counter to 9

RM_LOOP
    ; Get character loop (Skip non-digits)
RM_GETC
    GETC                ; Read char -> R0
    OUT                 ; Echo char to console
    
    ADD R3, R0, #-10    
    BRz RM_GETC         
    
    ADD R3, R0, #-13    
    BRz RM_GETC

    ADD R3, R0, #-16    
    ADD R3, R3, #-16    
    BRz RM_GETC         
    
    LD  R3, ASCII_OFF_N ; Load -48
    ADD R0, R0, R3      ; R0 is now integer
    
    STR R0, R1, #0      ; Store in Matrix [R1]
    ADD R1, R1, #1      ; Increment pointer
    ADD R2, R2, #-1     ; Decrement counter
    BRp RM_LOOP         ; Loop if positive

    LD  R2, RM_SaveR2   ; Restore R2
    LD  R7, RM_SaveR7   ; Restore R7
    RET

RM_SaveR7   .BLKW 1
RM_SaveR2   .BLKW 1
ASCII_OFF_N .FILL -48

MATRIX_MULTIPLY
    ST R7, MM_SaveR7

    AND R1, R1, #0      ; R1 = i (Row Counter)
LOOP_I
    ADD R4, R1, #-3     ; Check if i < 3
    BRz END_I

    AND R2, R2, #0      ; R2 = j (Col Counter)
LOOP_J
    ADD R4, R2, #-3     ; Check if j < 3
    BRz END_J

    ; Addr = MAT_C + 3*i + j
    LEA R5, MAT_C       ; Load Base C
    ADD R4, R1, R1      ; R4 = 2*i
    ADD R4, R4, R1      ; R4 = 3*i
    ADD R4, R4, R2      ; R4 = 3*i + j
    ADD R5, R5, R4      ; R5 = Address of C[i][j]
    
    AND R6, R6, #0      ; R6 = Accumulator (Sum)
    
    AND R3, R3, #0      ; R3 = k (Inner Loop)
LOOP_K
    ADD R4, R3, #-3     ; Check if k < 3
    BRz END_K

    LEA R0, MAT_A
    ADD R4, R1, R1      ; 2*i
    ADD R4, R4, R1      ; 3*i
    ADD R4, R4, R3      ; 3*i + k
    ADD R0, R0, R4      ; Address of A[i][k]
    LDR R0, R0, #0      ; R0 = Value A

    LEA R4, MAT_B
    ADD R7, R3, R3      ; 2*k
    ADD R7, R7, R3      ; 3*k
    ADD R7, R7, R2      ; 3*k + j
    ADD R4, R4, R7      ; Address of B[k][j]
    LDR R4, R4, #0      ; R4 = Value B

    ST R1, MM_TmpI      ; Save loops before JSR
    ST R2, MM_TmpJ
    ST R3, MM_TmpK
    
    ADD R1, R4, #0      ; Setup MUL input (A in R0, B in R1)
    JSR MUL             ; Result in R0
    
    LD R1, MM_TmpI      ; Restore loops
    LD R2, MM_TmpJ
    LD R3, MM_TmpK

    ADD R6, R6, R0      ; Sum += Result

    ADD R3, R3, #1      ; k++
    BR LOOP_K
END_K
    
    STR R6, R5, #0      ; Store Sum in C[i][j]

    ADD R2, R2, #1      ; j++
    BR LOOP_J
END_J

    ADD R1, R1, #1      ; i++
    BR LOOP_I
END_I

    LD R7, MM_SaveR7
    RET

MM_SaveR7 .BLKW 1
MM_TmpI   .BLKW 1
MM_TmpJ   .BLKW 1
MM_TmpK   .BLKW 1


MUL
    ST R2, MUL_SaveR2
    ST R3, MUL_SaveR3
    
    ADD R2, R0, #0      ; Move Operand A to R2
    ADD R3, R1, #0      ; Move Operand B to R3 (Counter)
    AND R0, R0, #0      ; Clear Result
    
    ADD R3, R3, #0      ; Check if B is 0
    BRz MUL_DONE
    
MUL_LOOP
    ADD R0, R0, R2      ; Result += A
    ADD R3, R3, #-1     ; Decrement Counter
    BRp MUL_LOOP
    
MUL_DONE
    LD R2, MUL_SaveR2
    LD R3, MUL_SaveR3
    RET

MUL_SaveR2 .BLKW 1
MUL_SaveR3 .BLKW 1

PRINT_MAT
    ST R7, PM_SaveR7
    AND R2, R2, #0      ; Counter (0 to 8)

PM_LOOP
    LDR R0, R1, #0      ; Load number to print
    ST  R1, PM_SavePtr  ; Save pointer
    ST  R2, PM_SaveCnt  ; Save counter
    
    JSR PRINT_NUM       ; Print the number in R0
    
    LD  R1, PM_SavePtr  ; Restore pointer
    LD  R2, PM_SaveCnt  ; Restore counter
    
    ADD R1, R1, #1      ; Increment Pointer
    ADD R2, R2, #1      ; Increment Counter
    
    ; Check mod 3 logic for Newline vs Space
    ADD R3, R2, #-3
    BRz PM_NEWLINE
    ADD R3, R2, #-6
    BRz PM_NEWLINE
    ADD R3, R2, #-9
    BRz PM_NEWLINE      ; FIX: If 9 (Done), also go to Newline
    
    ; Print Space
    LD R0, CHAR_SPACE
    OUT
    BR PM_LOOP

PM_NEWLINE
    LD R0, CHAR_NL
    OUT
    ADD R3, R2, #-9     ; Check if done (== 9)
    BRz PM_DONE
    BR PM_LOOP

PM_DONE
    LD R7, PM_SaveR7
    RET

PM_SaveR7   .BLKW 1
PM_SavePtr  .BLKW 1
PM_SaveCnt  .BLKW 1
CHAR_SPACE  .FILL 32
CHAR_NL     .FILL 10


PRINT_NUM
    ST R7, PN_SaveR7
    ST R0, PN_SaveR0
    ST R1, PN_SaveR1
    ST R2, PN_SaveR2
    ST R4, PN_SaveR4

    AND R4, R4, #0      ; R4 = Flag (Has Printed non-zero?)
    
    ; --- HUNDREDS ---
    LD  R2, NEG_100
    AND R1, R1, #0      ; Digit Counter
H_LOOP
    ADD R3, R0, R2      ; Val - 100
    BRn H_DONE
    ADD R0, R3, #0      ; Update Val
    ADD R1, R1, #1      ; Increment Digit
    BR H_LOOP
H_DONE
    ; If Hundreds Digit > 0, print it
    ADD R1, R1, #0
    BRz T_CHECK
    
    ST  R0, PN_TmpRem   ; Save Remainder
    LD  R3, ASCII_0
    ADD R0, R1, R3      ; Convert digit to ASCII
    OUT
    LD  R0, PN_TmpRem   ; Restore Remainder
    ADD R4, R4, #1      ; Set Flag = 1

T_CHECK
    ; --- TENS ---
    LD  R2, NEG_10
    AND R1, R1, #0      ; Digit Counter
T_LOOP
    ADD R3, R0, R2      ; Val - 10
    BRn T_DONE
    ADD R0, R3, #0      ; Update Val
    ADD R1, R1, #1      ; Increment Digit
    BR T_LOOP
T_DONE
    ; If Tens > 0 OR Flag == 1, print Tens
    ADD R1, R1, #0
    BRp PRINT_TENS
    ADD R4, R4, #0      ; Check Flag
    BRp PRINT_TENS
    BR  O_CHECK         ; Skip printing tens
    
PRINT_TENS
    ST  R0, PN_TmpRem   ; Save Remainder
    LD  R3, ASCII_0
    ADD R0, R1, R3
    OUT
    LD  R0, PN_TmpRem   ; Restore Remainder

O_CHECK
    ; --- ONES ---
    ; Always print Ones (R0 holds the remainder 0-9)
    LD  R3, ASCII_0
    ADD R0, R0, R3
    OUT

    LD R4, PN_SaveR4
    LD R2, PN_SaveR2
    LD R1, PN_SaveR1
    LD R0, PN_SaveR0
    LD R7, PN_SaveR7
    RET

PN_SaveR7 .BLKW 1
PN_SaveR0 .BLKW 1
PN_SaveR1 .BLKW 1
PN_SaveR2 .BLKW 1
PN_SaveR4 .BLKW 1
PN_TmpRem .BLKW 1
NEG_100   .FILL -100
NEG_10    .FILL -10
ASCII_0   .FILL 48

.END