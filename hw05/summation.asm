;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - summation
;;=============================================================
;; Name: Panya Bhinder
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;;    int result; (to save the summation of x)
;;    int x= -9; (given integer)
;;    int answer = 0;
;;    while (x > 0) {
;;        answer += x;
;;        x--;
;;    }
;;    result = answer;

.orig x3000
    LD R1, x
    AND R2, R2, 0
    ADD R2, R2, 0
    
    ADD R1, R1, 0
    WHILE ;; while (x > 0)
    BRNZ END ;; if neg or zero stop loop
    ADD R2, R2, R1
    ADD R1, R1, -1
    BR WHILE 
    END
    
    ST R2, result

    HALT

    x .fill 4
    result .blkw 1
.end

