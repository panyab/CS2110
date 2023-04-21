;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - fourCharacterStrings
;;=============================================================
;; Name: Panya Bhinder
;;=============================================================


;; Pseudocode (see PDF for explanation)
;;
;; int count = 0;
;; int chars = 0;
;; int i = 0;
;;
;;  while(str[i] != '\0') {
;;      if (str[i] != ' ') 
;;          chars++;
;;      
;;      else {
;;          if (chars == 4) 
;;              count++;   
;;          chars = 0;
;;      }
;;      i++;
;;  }
;; ***IMPORTANT***
;; - Assume that all strings provided will end with a space (' ').
;; - Special characters do not have to be treated differently. For instance, strings like "it's" and "But," are considered 4 character strings.
;;

;; R0 = count 
;; R1 = chars
;; R2 = i
;; R3 = STRING
;; R4 = SPACE
;; R5 = 
;; R6 = 
;; R7 = 

.orig x3000
	AND R0, R0, 0 ; clear registers
	AND R1, R1, 0
	AND R2, R2, 0

	WHILE 
	LD R3, STRING 
	ADD R3, R3, R2 ; R3 = string + i
	LDR R3, R3, 0 

	BRz ENDW
	LD R4, SPACE
	ADD R3, R3, R4 ; R3 = string + space 

	BRz ELSE1 ; if 0 go to else1
	ADD R1, R1, 1
	BR ENDIF1

	ELSE1
	ADD R5, R1, -4 ; R5 = chars - 4

	BRnp ENDIF2 ; if its not 0 go to endif2
	ADD R0, R0, 1 ; count++
	
	ENDIF2
	AND R1, R1, 0 ; chars = 0
	ENDIF1
	ADD R2, R2, 1 ; i++

	BR WHILE
	ENDW

	ST R0, ANSWER

	HALT


SPACE 	.fill #-32
STRING	.fill x4000
ANSWER .blkw 1

.end


.orig x4000

.stringz "I love CS 2110 and assembly is very fun! "

.end
