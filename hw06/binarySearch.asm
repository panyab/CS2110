;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Binary Search
;;=============================================================
;; Name: Panya Bhinder
;;============================================================

;; In this file, you must implement the 'binarySearch' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'binarySearch' label.


;; Pseudocode:

;; Nodes are blocks of size 3 in memory:

;; The data is located in the 1st memory location
;; The node's left child address is located in the 2nd memory location
;; The node's right child address is located in the 3rd memory location

;; Binary Search

;; binarySearch(Node root (addr), int data):
;;   if (root == 0):
;;	    return 0
;;   if (data == root.data):
;;      return root
;;   if (data < root.data):
;;      return binarySearch(root.left, data)
;;   return binarySearch(root.right, data)

.orig x3000
    ;; you do not need to write anything here
HALT

binary_search   ;; please do not change the name of your subroutine
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
    LDR R1, R5, #4 ;; R1 = root addr
    LDR R2, R5, #5 ;; R2 = data
    ;; perform Search
    AND R0, R0, 0 ;; clear R0
    ADD R1, R1, 0

    BRz STACKTEARDOWN ;; if root == 0

    LDR R3, R1, 0 ;; R3 = root data 
    NOT R4, R3
    ADD R4, R4, 1 ;; R4 = - root data
    ADD R4, R2, R4 ;; R4 = data - root data
    
    BRnp IF ;; if data == root data
        ADD R0, R0, R1
        BR STACKTEARDOWN

    IF
    ADD R4, R4, 0
    BRp ELSE1 ;; if data < root data
        AND R4, R4, 0
        LDR R4, R1, 1 ;; R4 = root left addr
        ADD R6, R6, #-1
        STR R2, R6, 0 ;; push data
        ADD R6, R6, #-1
        STR R4, R6, 0 ;; push root left
        JSR binary_search
        LDR R0, R6, 0 ;; R0 = return
        ADD R6, R6, #3 ;; pop arguments
        BR STACKTEARDOWN
    
    ELSE1 ;; data > root data
        AND R4, R4, 0
        LDR R4, R1, 2 ;; R4 = root right addr
        ADD R6, R6, #-1
        STR R2, R6, 0 ;; push data
        ADD R6, R6, #-1
        STR R4, R6, 0 ;; push root right
        JSR binary_search
        LDR R0, R6, 0 ;; R0 = return
        ADD R6, R6, #3 ;; pop arguments
        BR STACKTEARDOWN

    STACKTEARDOWN
    STR R0, R5, 3
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

;; Assuming the tree starts at address x4000, here's how the tree (see below and in the pdf) represents in memory
;;
;;              4
;;            /   \
;;           2     8 
;;         /   \
;;        1     3 
;;
;; Memory address           Data
;; x4000                    4
;; x4001                    x4004
;; x4002                    x4008
;; x4003                    Don't Know
;; x4004                    2
;; x4005                    x400C
;; x4006                    x4010
;; x4007                    Don't Know
;; x4008                    8
;; x4009                    0(NULL)
;; x400A                    0(NULL)
;; x400B                    Don't Know
;; x400C                    1
;; x400D                    0(NULL)
;; x400E                    0(NULL)
;; x400F                    Dont't Know
;; x4010                    3
;; x4011                    0(NULL)
;; x4012                    0(NULL)
;; x4013                    Dont't Know
;;
;; *note: 0 is equivalent to NULL in assembly