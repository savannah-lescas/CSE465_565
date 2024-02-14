#lang scheme
; ---------------------------------------------
; DO NOT REMOVE OR CHANGE ANYTHING UNTIL LINE 40
; ---------------------------------------------

; zipcodes.scm contains all the US zipcodes.
; This file must be in the same folder as hw2.scm file.
; You should not modify this file. Your code
; should work for other instances of this file.
(require "zipcodes.scm")

; Helper function
(define (mydisplay value)
	(display value)
	(newline)
)

; Helper function
(define (line func)
        (display "--------- ")
        (display func)
        (display " ------------")
        (newline)
)

; ================ Solve the following functions ===================
; Return a list with only the negatives items
(define (negatives lst)
        ; base case
	(if (null? lst)
            ; list is null
            '()
            ; list is not null
            (if (<= (car lst) 0)
                ; element is negative so add to list and
                ; repeat with rest of list
                (cons (car lst) (negatives (cdr lst)))
                ; element is not negative so repeat with
                ; rest of list
                (negatives (cdr lst))
             )
        )
)

(line "negatives")
(mydisplay (negatives '()))  ; -> ()
(mydisplay (negatives '(-1)))  ; -> (-1)
(mydisplay (negatives '(-1 1 2 3 4 -4 5)))  ; -> (-1 -4)
(mydisplay (negatives '(1 1 2 3 4 4 5)))  ; -> ()
(line "negatives")
; ---------------------------------------------

; Returns true if the two lists have identical structure
; in terms of how many elements and nested lists they have in the same order
(define (struct lst1 lst2)
     (cond
        ; the lists end up both empty at the end so they
        ; are equal lengths
	((and (null? lst1) (null? lst2))
             #t
        )
        ; the lists are not of equal length
        ((or (null? lst1) (null? lst2))
             #f
        )
        (else
            (cond
              ; if the elements are both lists
              ((and (list? (car lst1)) (list? (car lst2)))
                ; check if the length of the lists are equal
                (if (= (length (car lst1)) (length (car lst2)))
                    ; if they are equal go ahead and keep checking
                    ; lst1 and lst2
                    (struct (cdr lst1) (cdr lst2))
                    ; if the inner lists are not equal return false
                    #f
                ))
              ; if both elements are not lists
              ((and (not (list? (car lst1))) (not (list? (car lst2))))
                    ; continue checking the lists together as normal
                    (struct (cdr lst1) (cdr lst2))
               )
              (else
                    ; if one car is a list and the other is a single
                    ; element the structure is not the same so return
                    ; false
                    #f
               )
            )
        )
     )
)

(line "struct")
(mydisplay (struct '(a b c (c a b)) '(1 2 3 (a b c))))  ; -> #t
(mydisplay (struct '(a b c d (c a b)) '(1 2 3 (a b c))))  ; -> #f
(mydisplay (struct '(a b c (c a b)) '(1 2 3 (a b c) 0)))  ; -> #f
(line "struct")
; ---------------------------------------------

; Returns a list of two numeric values. The first is the smallest
; in the list and the second is the largest in the list. 
; lst -- contains numeric values, and length is >= 1.

; method to find the minimum
(define (minelt lst)
  (if (= 1 (length lst))
      (car lst)
      (min (car lst) (minelt (cdr lst)))
   )
 )
; method to find the maximum
(define (maxelt lst)
    (if (= 1 (length lst))
         (car lst)
         (max (car lst) (maxelt (cdr lst)))
     )
 )
(define (minAndMax lst)
        ; use the other functions to find the minimum and
        ; maximum and then make a list with them
	(list (minelt lst) (maxelt lst))
)

(line "minAndMax")
(mydisplay (minAndMax '(1 2 -3 4 2)))  ; -> (-3 4)
(mydisplay (minAndMax '(1)))  ; -> (1 1)
(line "minAndMax")
; ---------------------------------------------

; Returns a list identical to the first list, while having all elements
; that are inside nested loops taken out. So we want to flatten all elements and have
; them all in a single list. For example '(a (a a) a))) should become (a a a a)
(define (flatten lst)
        ; base case
	(if (null? lst)
            '()
            (if (list? (car lst))
                ; if the element is a list, recursively go through
                ; that list to see if it contains another list
                ; then append it all and recursively flatten the
                ; rest of the list
                (append (flatten (car lst)) (flatten (cdr lst)))
                ; otherwise just add the single element to the list
                (cons (car lst) (flatten (cdr lst)))
            )
        )
)

(line "flatten")
(mydisplay (flatten '(a b c)))  ; -> (a b c)
(mydisplay (flatten '(a (a a) a)))  ; -> (a a a a)
(mydisplay (flatten '((a b) (c (d) e) f)))  ; -> (a b c d e f)
(line "flatten")
; ---------------------------------------------

; The paramters are two lists. The result should contain the cross product
; between the two lists: 
; The inputs '(1 2) and '(a b c) should return a single list:
; ((1 a) (1 b) (1 c) (2 a) (2 b) (2 c))
; lst1 & lst2 -- two flat lists.
(define (crossproduct lst1 lst2)
	(if (or (null? lst1) (null? lst2))
           
           lst1
          (cons (list (car lst1) (car lst2)) ; Combine the first elements of each list into a pair and cons it
            (crossproduct lst1 (cdr lst2))) ; Recursively call zip on the rest of the lists
        )
)

(line "crossproduct")
(mydisplay (crossproduct '(1 2) '(a b c)))
(line "crossproduct")
; ---------------------------------------------

; Returns all the latitude and longitude of particular zip code.
; Returns the first lat/lon, if multiple entries have same zip code.
; zipcode -- 5 digit integer
; zips -- the zipcode DB- You MUST pass the 'zipcodes' function
; from the 'zipcodes.scm' file for this. You can just call 'zipcodes' directly
; as shown in the sample example
(define (getLatLon zipcode zips)
	(list zipcode (car zips))
)

(line "getLatLon")
(mydisplay (getLatLon 45056 zipcodes))
(line "getLatLon")
; ---------------------------------------------

; Returns a list of all the place names common to two states.
; placeName -- is the text corresponding to the name of the place
; zips -- the zipcode DB
(define (getCommonPlaces state1 state2 zips)
	(list state1 state2)
)

(line "getCommonPlaces")
(mydisplay (getCommonPlaces "OH" "MI" zipcodes))
(line "getCommonPlaces")
; ---------------------------------------------

; #### Only for Graduate Students ####
; Returns a list of all the place names common to a set of states.
; states -- is list of state names
; zips -- the zipcode DB
(define (getCommonPlaces2 states zips)
	'("Oxford" "Franklin")
)

(line "getCommonPlaces2")
(mydisplay (getCommonPlaces2 '("OH" "MI" "PA") zipcodes))
(line "getCommonPlaces2")
; ---------------------------------------------

; Returns the number of zipcode entries for a particular state.
; If a zipcode appears multiple times in zipcodes.scm, count one
; for each occurance.
; state -- state
; zips -- zipcode DB
(define (zipCount state zips)
	0
)

(line "zipCount")
(mydisplay (zipCount "OH" zipcodes))
(line "zipCount")
; ---------------------------------------------

; #### Only for Graduate Students ####
; Returns the distance between two zip codes.
; Use lat/lon. Do some research to compute this.
; zip1 & zip2 -- the two zip codes in question.
; zips -- zipcode DB
(define (getDistanceBetweenZipCodes zip1 zip2 zips)
	0
)

(line "getDistanceBetweenZipCodes")
(mydisplay (getDistanceBetweenZipCodes 45056 48122 zipcodes))
(line "getDistanceBetweenZipCodes")
; ---------------------------------------------

; Some sample predicates
(define (POS? x) (> x 0))
(define (NEG? x) (> x 0))
(define (LARGE? x) (>= (abs x) 10))
(define (SMALL? x) (not (LARGE? x)))

; Returns a list of items that satisfy a set of predicates.
; For example (filterList '(1 2 3 4 100) '(EVEN?)) should return the even numbers (2 4 100)
; (filterList '(1 2 3 4 100) '(EVEN? SMALL?)) should return (2 4)
; lst -- flat list of items
; filters -- list of predicates to apply to the individual elements
(define (filterList lst filters)
	lst
)

(line "filterList")
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) '(POS?)))
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) '(POS? EVEN?)))
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) '(POS? EVEN? LARGE?)))
(line "filterList")
; ---------------------------------------------

