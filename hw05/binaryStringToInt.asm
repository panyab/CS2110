;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - binaryStringToInt
;;=============================================================
;; Name: Panya Bhinder
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;;    int result = x4000; (given memory address to save the converted value)
;;    String binaryString= "01000000"; (given binary string)
;;    int length = 8; (given length of the above binary string)
;;    int base = 1;
;;    int value = 0;
;;    while (length > 0) {
;;        int y = binaryString.charAt(length - 1) - 48;
;;        if (y == 1) {
;;            value += base;
;;        }     
;;            base += base;
;;            length--;
;;    }
;;    mem[result] = value;

;; R0 = len
;; R1 = 
;; R2 = binary string
;; R3 = base
;; R4 = value
;; R5 = 
;; R6 = 
;; R7 = result

.orig x3000
    LD R0, length
    AND R3, R3, 0
    ADD R3, R3, 1
    AND R4, R4, 0

    WHILE
    ADD R0, R0, 0

    BRNZ ENDW
    LD R2, binaryString
    ADD R2, R2, R0
    ADD R2, R2, -1
    LDR R2, R2, 0

    ADD R2, R2, -12
    ADD R2, R2, -12
    ADD R2, R2, -12
    ADD R2, R2, -12

    ADD R2, R2, -1
    BRnp ENDIF 
    ADD R4, R4, R3
    
    ENDIF
    ADD R3, R3, R3
    ADD R0, R0, -1

    BR WHILE
    ENDW

    LD R7, result
    STR R4, R7, 0

    HALT

    binaryString .fill x5000
    length .fill 8
    result .fill x4000
.end 

.orig x5000
    .stringz "010010100"
.end
