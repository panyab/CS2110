;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - buildMaxArray
;;=============================================================
;; Name: Panya Bhinder
;;=============================================================


;; Pseudocode (see PDF for explanation)
;;
;;	int A[] = {1,2,3};
;;	int B[] = {-1, 7, 8};
;;	int C[3];
;;
;;	int i = 0;
;;
;;	while (i < A.length) {
;;		if (A[i] < B[i])
;;			C[i] = B[i];
;;		else
;;			C[i] = A[i];
;;
;;		i += 1;
;;	}

;; r0 = a[i]
;; r1 = i
;; r2 = length > length - i
;; r3 = b[i]
;; r4 = 
;; r5 =
;; r6 = a - b (neg - true)
;; r7 = c[i]

.orig x3000
	AND R1, R1, 0 ; clear R1
	ADD R1, R1, 0 ; R1 = i = 0

	WHILE
	LD R2, LEN ; R2 = length 
	NOT R2, R2 ; R2 = ~R2
	ADD R2, R2, 1 ; R2 = -R2
	ADD R2, R1, R2 ; R2 = i - length

    BRzp END ; if i - length >= 0 - go to end
    
	LD R0, A ; R0 = a
	ADD R0, R0, R1 ; 
	LDR R0, R0, 0

	LD R3, B 
	ADD R3, R3, R1
	LDR R3, R3, 0

	NOT R4, R3
	ADD R4, R4, 1
	ADD R4, R0, R4

	BRzp ELSE
	LD R7, C 
	ADD R7, R7, R1
	STR R3, R7, 0
	BR E1
	
	ELSE 
	LD R7, C 
	ADD R7, R7, R1
	STR R0, R7, 0
	BR E1
	
	E1
	ADD R1, R1, 1

    BR WHILE
    END




	HALT


A 	.fill x3200
B 	.fill x3300
C 	.fill x3400
LEN .fill 5

.end

.orig x3200
	.fill -100
	.fill -50
	.fill 0
	.fill 50
	.fill 100
.end

.orig x3300
	.fill -10
	.fill -5
	.fill 0
	.fill 50
	.fill 100
.end

.orig x3400
	.blkw 4
.end


