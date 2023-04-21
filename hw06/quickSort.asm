;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Quick Sort
;;=============================================================
;; Name: Panya Bhinder
;;============================================================

;; In this file, you must implement the 'quicksort' and 'partition' subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'quicksort' or 'partition' label.


;; Pseudocode:

;; Partition

;;    partition(arr[], int low, int high):
;;        pivot = arr[high]
;;        i = low - 1
;;        for (j = low; j < high - 1; j++)
;;            if (arr[j] < pivot):
;;                i++
;;                temp = arr[j]
;;                arr[j] = arr[i]
;;                arr[i] = temp
;;        temp = arr[high]
;;        arr[high] = arr[i + 1]
;;        arr[i + 1] = temp
;;        return i + 1
        
;; Quicksort

;;    quicksort(int[] arr, int left, int right):
;;        if (left < right):
;;            pi = partition(arr, left, right)
;;            quicksort(arr, left, pi - 1)
;;            quicksort(arr, pi + 1, right)


.orig x3000
    ;; you do not need to write anything here
HALT

partition   ;; please do not change the name of your subroutine
    ;; stack buildup
    ADD R6, R6, #-4 ;; set up stack frame storage
    STR R7, R6, #2 ;; save return address
    STR R5, R6, #1 ;; save old frame pointer
    ADD R5, R6, #0 ;; set curr frame pointer
    ADD R6, R6, #-7 ;; store registers onto stack 
    STR R0, R5, #-3 ;; save all registers
    STR R1, R5, #-4
    STR R2, R5, #-5
    STR R3, R5, #-6
    STR R4, R5, #-7
    ;; get arguments 
    LDR R0, R5, #4 ;; R0 = arr
    LDR R1, R5, #5 ;; R1 = low / j
    LDR R2, R5, #6 ;; R2 = high 
    
    AND R3, R3, 0 
    ADD R0, R0, R2
    LDR R3, R0, 0 ;; R3 = pivot = arr[high]
    STR R3, R5, 0 ;; pivot = local var at 0

    ADD R4, R1, -1 ; R4 = i = low - 1
    STR R4, R5, -1 ; i = local var at -1
    STR R1, R5, -2 ; j = local var at -2

    ;; perform partition

    WHILE ;; while (high-1) - j > 0
    
    LDR R2, R5, #6 ;; R2 = high 
    ADD R2, R2, #-1 ;; R2 = high - 1
    LDR R1, R5, -2
    NOT R1, R1
    ADD R1, R1, #1 ;; R1 = -j 
    ADD R2, R2, R1 ;; R2 = high-1 - j 
    
    
    BRnz END ; if negative or zero, branch to end

    LDR R1, R5, -2 ; R1 = J
    LDR R0, R5, #4 ;; R0 = arr
    ADD R0, R0, R1 
    LDR R1, R0, 0 ;; R1 = arr[j]
    
    LDR R3, R5, 0 ; R3 = pivot
    NOT R3, R3
    ADD R3, R3, 1 ; R3 = -pivot
    ADD R3, R1, R3 ; R3 = arr[j] - pivot

    BRzp POSTIF ; if zero or pos branch to after if 
    
    LDR R4, R5, -1
    ADD R4, R4, 1 ; i++ 
    STR R4, R5, -1

    LDR R2, R5, -1 ; R2 = i
    LDR R0, R5, #4 ;; R0 = arr
    ADD R2, R0, R2 ; R2 = addr OF ARR[I]
    LDR R3, R2, 0 ;; R3 = arr[i]

    LDR R1, R5, -2 ; R1 = j
    LDR R0, R5, #4 ;; R0 = arr
    ADD R1, R0, R1 ; r1 = addr of arr[j]

    AND R4, R4, 0
    LDR R4, R1, 0 ; R4 = temp = arr[j]

    STR R3, R1, 0 ;; arr[j] = arr[i]

    STR R4, R2, 0 ;; arr[i] = temp 

    
    POSTIF
    
    LDR R3, R5, -2 ; R3 = j
    ADD R3, R3, 1 ; R3 = j + 1 
    STR R3, R5, -2 ; ; store j+1 back in local var


    BR WHILE
    END

    LDR R1, R5, 0 ;; R1 = arr[high] 
    LDR R2, R5, -1 ;; R2 = i 
    ADD R2, R2, 1 ;; R2 = i+1

    LDR R0, R5, 4 ; R0 = arr
    ADD R2, R0, R2 ; R2 = ADDR OF ARR[I+1]
    LDR R3, R2, 0 ;; R3 = arr[i+1]

    LDR R0, R5, 4 ; R0 = arr
    LDR R4, R5, 6 ; R4 = high
    ADD R4, R0, R4 ; R4 = ADDR OF ARR[HIGH]

    STR R3, R4, 0 ; arr[high] = arr[i+1]
    STR R1, R3, 0 ; arr[i+1] = temp

    LDR R2, R5, -1
    ADD R2, R2, -1
    STR R2, R5, 3 ; store i+1 in result

    ;; stack teardown 
    LDR R4, R5, #-7
    LDR R3, R5, #-6
    LDR R2, R5, #-5
    LDR R1, R5, #-4
    LDR R0, R5, #-3
    ADD R6, R5, #0
    LDR R5, R6, #1
    LDR R7, R6, #2
    ADD R6, R6, #3

    RET

quicksort   ;; please do not change the name of your subroutine
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

    ; get arguments
    LDR R0, R5, 6 ; RIGHT
    LDR R1, R5, 5 ; LEFT
    LDR R2, R5, 4 ; ARR

    ; perform quicksort
    NOT R3, R0 
    ADD R3, R3, 1 ; R3 = -RIGHT
    ADD R3, R1, R3 ; R3 = LEFT - RIGHT

    BRzp ENDIF ; if left-right >= 0 branch to end if
    ADD R6, R6, #-3
    STR R0, R6, 2 ;; push RIGHT
    STR R1, R6, 1 ;; push LEFT 
    STR R2, R6, 0 ;; push ARR
    JSR partition 
    LDR R4, R6, 0 ;; R4 = return = pi
    ADD R6, R6, 4 ;; pop arguments

    ADD R4, R4, -1
    ADD R6, R6, -3
    STR R4, R6, 2 ;; push pi-1
    STR R1, R6, 1 ;; push left 
    STR R2, R6, 0 ;; push arr
    JSR quicksort 
    ADD R6, R6, 4 ;; pop arguments 

    ADD R4, R4, 2 ;; R4 = pi+1
    ADD R6, R6, -3 
    STR R0, R6, 2 ;; push RIGHT 
    STR R4, R6, 1 ;; push pi+1
    STR R2, R6, 0 ;; push arr
    JSR quicksort 
    ADD R6, R6, 4 ;; pop arguments 
    ENDIF

    ;; stack tear down 

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


;; Assuming the array starts at address x4000, here's how the array [1,3,2,5] represents in memory
;; Memory address           Data
;; x4000                    1
;; x4001                    3
;; x4002                    2
;; x4003                    5
