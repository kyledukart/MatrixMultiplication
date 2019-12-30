*-----------------------------------------------------------
* Title      : 4v4 Matrix Multiplication
* Written by : Kyle Dukart
* Date       : 11/15/19
* Description: This program takes in two 4x4 matrices and multiplies them.
*-----------------------------------------------------------

A_rows      equ 4
A_columns   equ 4
B_rows      equ 4
B_columns   equ 4

A_Array     equ $4500
B_Array     equ $5000
Ans_Array   equ $5500
word        equ 2


    ORG    $1000
START:                  ; first instruction of program

* set test data *

    MOVEA.W #A_Array,A0     ; move pointer to first array in A0
    MOVEA.W #B_Array,A1     ; move pointer to second array in A1
    
    MOVE.W  #2, (A0)+
    MOVE.W  #3, (A0)+
    MOVE.W  #4, (A0)+
    MOVE.W  #5, (A0)+
    MOVE.W  #1, (A0)+
    MOVE.W  #1, (A0)+
    MOVE.W  #1, (A0)+
    MOVE.W  #1, (A0)+
    MOVE.W  #2, (A0)+
    MOVE.W  #2, (A0)+
    MOVE.W  #2, (A0)+
    MOVE.W  #2, (A0)+
    MOVE.W  #3, (A0)+
    MOVE.W  #4, (A0)+
    MOVE.W  #5, (A0)+
    MOVE.W  #6, (A0)+
     
    MOVE.W  #3, (A1)+
    MOVE.W  #3, (A1)+
    MOVE.W  #3, (A1)+
    MOVE.W  #3, (A1)+
    MOVE.W  #4, (A1)+
    MOVE.W  #4, (A1)+
    MOVE.W  #5, (A1)+
    MOVE.W  #5, (A1)+
    MOVE.W  #6, (A1)+
    MOVE.W  #6, (A1)+
    MOVE.W  #7, (A1)+
    MOVE.W  #7, (A1)+
    MOVE.W  #8, (A1)+
    MOVE.W  #8, (A1)+
    MOVE.W  #9, (A1)+
    MOVE.W  #9, (A1)+


* end test data input *

    MOVEA.W #A_Array,A0     ; move pointer to first array in A0
    MOVEA.W #B_Array,A1     ; move pointer to second array in A1
    MOVEA.W #Ans_Array,A2   ; move pointer to answer array in A2
    
    MOVE.W #A_columns, D2   ; move number of columns in matrix A to D2 for comparison
    CMP.W #B_rows, D2       ; compare B rows to A columns
    BEQ Valid_columns       ; branch if equal
    LEA ERRORMSG, A1
    MOVE #14,D0
    TRAP #15
    BRA Stop
    
Valid_columns:
    
    CLR     D0              ; D0 used as offset for traversing A
    CLR     D1              ; D1 used as offset for traversing B
    CLR     D2              ; D2 used as offset for traversing Ans
    MOVE.W  #A_rows,D3       ; store number of A rows in D3
    CLR     D4              ; D4 is a row counter used to find the end of loop 1
    CLR     D6              ; D6 stores the multiplication result
    CLR     D7              ; D7 stores the sum result

Loop1:                      ; traverse to each spot in Ans
    CLR.W   D7
    MOVE.W  #B_Columns,D5   ; D5 is a column counter to find end of loop2
Loop2:                      ; calculate the sum for a single position in the matrix
    CLR     D6              ; clear the sum
    MOVE.W  (A0,D0.W),D6    ; move current value in A into D7
    MULS    (A1,D1.W),D6    ; multiply 
    ADD.W   D6,D7           ; add the current multiplication result to the sum
    ADD.W   #word,D0        ; increment A's offset
    ADD.W   #B_Columns,D1   ; add #B_Columns to B's offset
    ADD.W   #B_Columns,D1   ; add a second time to increment by words not bytes
    SUB.W   #1,D5           ; decrement column counter
    BNE Loop2               ; if not equal then continue looping
    MOVE.W  D7,(A2,D2.W)    ; put value into the answer array
    ADD.W   #word,D2        ; increment the Ans Offset
    ADD.W   #1,D4           ; increment row counter
    CMP.W   #B_Columns,D4   ; compare row counter to number of rows
    BNE Next_Column         ; we are still in the same row, move to next column
    CLR.W   D4              ; clear row counter, we are in a new row
    CLR.W   D1              ; clear offset for matrix B
    SUB.W   #1,D3           ; decrement number of rows
    BNE Loop1               ; we have more rows to traverse, go to loop1
    BRA Stop                ; no more rows to traverse, finished with matrix mult
    
Next_Column:
    SUB.W   #A_Rows,D0      ; move A's traversal back to the first row
    SUB.W   #A_Rows,D0      ; sub a second time to increment by words not bytes
    MULU    #2,D4           ; multiply D4 by 2 so it is measured in words
    MOVE.W  D4,D1           ; offset D1 so it is pointing to next column
    DIVS    #2,D4           ; Divide D4 by 2 so it returns to its original counter
    CLR.W   D7              ; reset the sum result
    BRA     Loop1

Stop:

    SIMHALT             ; halt simulator

* Put variables and constants here

ERRORMSG    DC.B    'The current matrices have invalid dimensions for multiplication',0

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
