;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Factorial
;;=============================================================
;; Name: Panya Bhinder
;;============================================================

;; In this file, you must implement the 'factorial' and "mult" subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'factorial' or 'mult' label.

;; Pseudocode

;; Factorial

;;    factorial(int n):
;;        int ret = 1
;;        for (int x = 2; x < n+1; x++) {    n+1 - x > 0
;;            ret = mult(ret, x)
;;        }
;;        return ret

;; Multiply
         
;;    mult(int a, int b):
;;        int ret = 0
;;        int copyB = b
;;        while (copyB > 0):
;;            ret += a;
;;            copyB--
;;        return ret


.orig x3000
    ;; you do not need to write anything here
HALT

factorial   ;; please do not change the name of your subroutine
    ;; stack buildup
    ADD R6, R6, #-4 ;; set up stack frame storage
    STR R7, R6, #2 ;; save return address
    STR R5, R6, #1 ;; save old frame pointer
    ADD R5, R6, #0 ;; set curr frame pointer
    ADD R6, R6, #-5 ;; store registers onto stack 
    STR R0, R5, #-1 ;; save all registers
    STR R1, R5, #-2
    STR R2, R5, #-3
    STR R3, R5, #-4
    STR R4, R5, #-5
    ;; get arguments 
    LDR R0, R5, #4 ;; R0 > n
    ;; perform factorial
    AND R1, R1, 0
    AND R2, R2, 0
    ADD R1, R1, #1 ;; R1 > ret 
    ADD R2, R2, #2 ;; R2 > x
    ADD R0, R0, #1 ;; R0 > n + 1
    
    WHILE ;; while (n+1) - x > 0
    NOT R3, R2 
    ADD R3, R3, 1 ;; R3 > -x
    ADD R3, R0, R3 ;; R3 > n+1 - x

    BRnz END ;; if x < n+1 end loop
    ADD R6, R6, #-2
    STR R2, R6, 1 ;; push R2
    STR R1, R6, 0 ;; push R1
    JSR  mult
    LDR R1, R6, 0 ;; R1 = return
    ADD R6, R6, #3 ;; pop arguments
    ADD R2, R2, #1
    BR WHILE
    END
    STR R1, R5, 3
    ;; stack teardown 
    LDR R4, R5, #-5
    LDR R3, R5, #-4
    LDR R2, R5, #-3
    LDR R1, R5, #-2
    LDR R0, R5, #-1
    ADD R6, R5, #0
    LDR R5, R6, #1
    LDR R7, R6, #2
    ADD R6, R6, #3
    RET
    
mult        ;; please do not change the name of your subroutine
    
    ;; stack buildup
    ADD R6, R6, #-4 ;; set up stack frame storage
    STR R7, R6, #2 ;; save return address
    STR R5, R6, #1 ;; save old frame pointer
    ADD R5, R6, #0 ;; set curr frame pointer
    ADD R6, R6, #-5 ;; store registers onto stack 
    STR R0, R5, #-1 ;; save all registers
    STR R1, R5, #-2
    STR R2, R5, #-3
    STR R3, R5, #-4
    STR R4, R5, #-5

    ;; extract params
    LDR R1, R5, #4 ;; R1 > a
    LDR R2, R5, #5 ;; R2 > b

    ;; perform mult
    AND R0, R0, 0 ;; R0 > ret
    AND R3, R3, 0 ;; clear R3
    ADD R3, R3, R2 ;; R3 > copy b

    MWHILE
    BRnz MEND
    ADD R0, R0, R1
    ADD R3, R3, #-1
    BR MWHILE 
    MEND

    STR R0, R5, 0
    STR R0, R5, #3
    ;; stack teardown 
    LDR R4, R5, #-5
    LDR R3, R5, #-4
    LDR R2, R5, #-3
    LDR R1, R5, #-2
    LDR R0, R5, #-1
    ADD R6, R5, #0
    LDR R5, R6, #1
    LDR R7, R6, #2
    ADD R6, R6, #3

    RET

STACK .fill xF000
.end
