.ORIG x3000

        LD R1, NUM1_PTR
        LD R2, NUM1_PTR

READ_NUM1
        GETC
        OUT

        LD R3, SPACE_NEG
        ADD R3, R0, R3
        BRz FINISH_NUM1
        
        LD R3, CR_NEG
        ADD R3, R0, R3
        BRz READ_NUM1

        STR R0, R2, #0
        ADD R2, R2, #1
        BRnzp READ_NUM1

FINISH_NUM1
        ST R1, START_NUM1
        ADD R2, R2, #-1
        ST R2, END_NUM1

        LD R1, NUM2_PTR
        LD R2, NUM2_PTR

READ_NUM2
        GETC
        OUT

        LD R3, NEWLINE_NEG
        ADD R3, R0, R3
        BRz FINISH_NUM2
        
        LD R3, CR_NEG
        ADD R3, R0, R3
        BRz READ_NUM2

        STR R0, R2, #0
        ADD R2, R2, #1
        BRnzp READ_NUM2

FINISH_NUM2
        ST R1, START_NUM2
        ADD R2, R2, #-1
        ST R2, END_NUM2

START_CALC
        LD R1, END_NUM1
        LD R2, END_NUM2
        
        LD R3, RESULT_PTR
        LD R4, MAX_SIZE
        ADD R3, R3, R4      
        ADD R3, R3, #-1
        ST R3, END_RESULT   
        
        AND R5, R5, #0
        LD R6, ASCII_OFFSET

CALC_LOOP
        LD R4, START_NUM1
        NOT R4, R4
        ADD R4, R4, #1
        ADD R4, R1, R4      
        BRzp PROCEED

        LD R4, START_NUM2
        NOT R4, R4
        ADD R4, R4, #1
        ADD R4, R2, R4      
        BRzp PROCEED

        ADD R5, R5, #0
        BRz START_PRINT

PROCEED
        AND R0, R0, #0
        ADD R0, R0, R5

        LD R4, START_NUM1
        NOT R4, R4
        ADD R4, R4, #1
        ADD R4, R1, R4
        BRn SKIP_ADD1       

        LDR R4, R1, #0      
        ADD R4, R4, R6      
        ADD R0, R0, R4      
        ADD R1, R1, #-1     
SKIP_ADD1

        LD R4, START_NUM2
        NOT R4, R4
        ADD R4, R4, #1
        ADD R4, R2, R4
        BRn SKIP_ADD2       

        LDR R4, R2, #0
        ADD R4, R4, R6
        ADD R0, R0, R4
        ADD R2, R2, #-1     
SKIP_ADD2

        ADD R4, R0, #-10    
        BRzp IS_CARRY

        AND R5, R5, #0
        BRnzp STORE

IS_CARRY
        AND R5, R5, #0
        ADD R5, R5, #1
        ADD R0, R4, #0

STORE
        LD R4, ASCII_RESTORE
        ADD R0, R0, R4
        STR R0, R3, #0
        ADD R3, R3, #-1
        BRnzp CALC_LOOP

START_PRINT
        ADD R1, R3, #1
        LD R2, END_RESULT

        AND R5, R5, #0
        ADD R5, R5, #1

PRINT_LOOP
        NOT R4, R2
        ADD R4, R4, #1
        ADD R4, R1, R4      
        BRp DONE

        LDR R0, R1, #0

        ADD R5, R5, #0
        BRz PRINT_IT

        LD R6, ASCII_OFFSET
        ADD R4, R0, R6
        BRnp CLEAR_FLAG

        NOT R4, R2
        ADD R4, R4, #1
        ADD R4, R1, R4
        BRz PRINT_IT

        BRnzp NEXT_CHAR

CLEAR_FLAG
        AND R5, R5, #0

PRINT_IT
        OUT

NEXT_CHAR
        ADD R1, R1, #1
        BRnzp PRINT_LOOP

DONE
        LD R0, NEWLINE_CHAR
        OUT
        HALT

NUM1_PTR    .FILL NUM1
NUM2_PTR    .FILL NUM2
RESULT_PTR  .FILL RESULT

START_NUM1  .FILL #0
END_NUM1    .FILL #0
START_NUM2  .FILL #0
END_NUM2    .FILL #0
END_RESULT  .FILL #0

ASCII_OFFSET    .FILL xFFD0
ASCII_RESTORE   .FILL x0030

SPACE_NEG       .FILL #-32
CR_NEG          .FILL #-13
NEWLINE_NEG     .FILL #-10
NEWLINE_CHAR    .FILL x000A

MAX_SIZE        .FILL #10001

NUM1    .BLKW #10000
NUM2    .BLKW #10000
RESULT  .BLKW #10001

.END