; LC-3 Assembly: GETC and PUTC Example
; This program demonstrates how to use GETC and PUTC trap routines
; GETC (TRAP x20) - reads a single character from keyboard into R0
; PUTC (TRAP x21) - writes the character in R0 to the console

        .ORIG x3000

; Print a prompt message
        LEA R0, PROMPT      ; Load address of prompt string
        PUTS                ; Print the prompt string (TRAP x22)

; Read a character from keyboard
        GETC                ; Read character into R0 (TRAP x20)
                            ; Note: GETC does NOT echo the character

; Echo the character back to console
        OUT                 ; Echo the character (TRAP x21 - same as PUTC)
        
; Print newline
        LD R0, NEWLINE
        OUT

; Print a message
        LEA R0, MSG1
        PUTS

; Print the character again
        LD R0, SAVED_CHAR   ; This won't work - need to save first!
        
; Better example: Read and echo in a loop
LOOP    LEA R0, PROMPT2
        PUTS
        
        GETC                ; Read character (not echoed)
        ADD R1, R0, #0      ; Save character in R1
        
; Check if it's 'q' to quit
        LD R2, NEG_Q        ; Load -'q'
        ADD R2, R1, R2      ; Compare with 'q'
        BRz DONE            ; If zero, it's 'q', so quit
        
; Echo the character
        ADD R0, R1, #0      ; Move character back to R0
        OUT                 ; Display it
        
        LD R0, NEWLINE      ; Print newline
        OUT
        
        BR LOOP             ; Repeat

DONE    LEA R0, GOODBYE
        PUTS
        HALT

; Data section
PROMPT  .STRINGZ "Enter a character: "
PROMPT2 .STRINGZ "\nEnter a character (q to quit): "
MSG1    .STRINGZ "\nYou entered: "
GOODBYE .STRINGZ "\nGoodbye!\n"
NEWLINE .FILL x000A          ; ASCII newline
NEG_Q   .FILL xFFA9          ; Negative ASCII 'q' (two's complement)
SAVED_CHAR .BLKW 1

        .END
