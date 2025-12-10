.ORIG x3000
AND R2, R2, #0      ; Initialize R2
AND R3, R3, #0      ; Flag for negative first number

; Check if R1 is zero first
ADD R1, R1, #0      ; Set condition codes for R1
BRz DONE            ; If R1 = 0, result is 0, skip everything

; Check if R1 is negative
BRp MULTI           ; If R1 > 0, start multiplication
NOT R1, R1          ; R1 is negative, negate it
ADD R1, R1, #1
ADD R3, R3, #1      ; mark as negative

; Multiplication loop
MULTI ADD R2, R2, R0    ; repeated addition stored in R0
      ADD R1, R1, #-1   ; Decrement counter R1
      BRp MULTI         ; If R1 > 0, loop back

; Check if we need to negate the result
ADD R3, R3, #0      ; Set condition codes based on R3
BRz DONE            ; If R3 = 0 (wasn't negative), skip negation
NOT R2, R2          ; Negate the result
ADD R2, R2, #1

DONE HALT
.END