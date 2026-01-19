.ORIG x3000

        
        AND R2, R2, #0      ; Clear R2 (Quotient)
        ADD R3, R0, #0      ; Copy R0 into R3 (Remainder starts as Dividend)

        ; Prepare Negative Divisor (for subtraction)
        NOT R4, R1          ; Invert bits of Divisor
        ADD R4, R4, #1

DIV_LOOP
        ; Calculate (Remainder - Divisor)
        ADD R0, R3, R4      ; R0 is a temp register here to check the result

        ; Check if we went negative
        BRn DIV_DONE        ; If (Remainder - Divisor) < 0, we are done!

        ; Update Real Remainder and Quotient
        ADD R3, R0, #0      ; Update Remainder (Keep the subtraction result)
        ADD R2, R2, #1      ; Increment Quotient
        BRnzp DIV_LOOP     

DIV_DONE
        ; Result is now in R2 (Quotient) and R3 (Remainder)
        HALT

        .END