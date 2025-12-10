.ORIG x3000
ADD R4, R4, #0  ; init R4


; Check for 0
ADD R3, R3, #0
BRz ADDITION

; Check for +1
ADD R4, R3, #-1
BRz MULTIPLICATION

; Check for -1
ADD R4, R3, #1
BRz SUBTRACT
BR DONE         ; If no match, halt


SUBTRACT 
    AND R4, R4, #0 ; Clear R4
    NOT R4, R2     ; Negate R2 into R4 (don't modify R2)
    ADD R4, R4, #1
    ADD R4, R4, R1 ; R4 = -R2 + R1 = R1 - R2
    BR DONE


ADDITION 
    AND R4, R4, #0 ; Clear R4
    ADD R4, R1, R2
    BR DONE


MULTIPLICATION 
    AND R4, R4, #0 ; Clear R4
    AND R5, R5, #0      ; Flag for negative first number
    
    ; Check if R2 is zero first
    ADD R2, R2, #0      ; Set condition codes for R1
    BRz DONE            ; If R1 = 0, result is 0, skip everything
    
    ; Check if R1 is negative
    BRp MULTI           ; If R1 > 0, start multiplication
    NOT R2, R2          ; R1 is negative, negate it
    ADD R2, R2, #1
    ADD R5, R5, #1      ; mark as negative
    
    ; Multiplication loop
    MULTI 
        ADD R4, R4, R1    ; repeated addition stored in R0
        ADD R2, R2, #-1   ; Decrement counter R1
        BRp MULTI         ; If R1 > 0, loop back
    
    ; Check if we need to negate the result
    ADD R5, R5, #0      ; Set condition codes based on R3
    BRz DONE            ; If R3 = 0 (wasn't negative), skip negation
    NOT R4, R4          ; Negate the result
    ADD R4, R4, #1










DONE HALT
    .end