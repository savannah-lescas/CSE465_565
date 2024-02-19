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
        ; lists are not of equal length
        ((or (null? lst1) (null? lst2))
             #f
        )
        (else
         (cond
           ; if the elements are both lists
           ((and (list? (car lst1)) (list? (car lst2)))
            ; check if the length of the lists are equal
            (if (= (length (car lst1)) (length (car lst2)))
                ; if they are equal check the inner list for
                ; more nested lists as well as check the rest
                ; of the original list
                (and (struct (car lst1) (car lst2)) (struct (cdr lst1) (cdr lst2)))
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

; helper method to do the pairings
(define (pairElements leftelt lst2)
  ; base case
  (if (null? lst2)
      '()
      ; creates a list of the left element with the next
      ; element of lst2 with recursion
      (cons (list leftelt (car lst2))
            (pairElements leftelt (cdr lst2)))
  )
)
(define (crossproduct lst1 lst2)
         ; base case
	(if (or (null? lst1) (null? lst2))
           '()
           ; add the pairs to the list by running the helper
           ; method to get the correct products and using recursion
           ; to do it for each element of the list
           (append (pairElements (car lst1) lst2) (crossproduct (cdr lst1) lst2))
        )
)
(line "crossproduct")
(mydisplay (crossproduct '(1 2) '(a b c)))
(line "crossproduct")
; ---------------------------------------------

; Return the first latitude and longitude of a particular zip code.
; if there are multiple pairs for the same zip code, the function should
; only return the first pair
; zipcode -- 5 digit integer
; zips -- the zipcode DB- You MUST pass the 'zipcodes' function
; from the 'zipcodes.scm' file for this. You can just call 'zipcodes' directly
; as shown in the sample example
(define (getLatLon zipcode zips)
        ; base case: if the zipcode is not found return
        ; an empty list
        (if (null? zips)
                 '()
                 ; else check if the zipcode matches
                 (if (= (caar zips) zipcode)
                        ; if the zipcodes match, make a list of the pair
                        (cons (cadr (cdddar zips)) (cddr (cdddar zips)))
                        ; otherwise continue to check for the zipcode
                        (getLatLon zipcode (cdr zips))
                  )
        )
)

(line "getLatLon")
(mydisplay (getLatLon 45056 zipcodes))
(line "getLatLon")
; ---------------------------------------------

; Returns a list of all the place names common to two states.
; placeName -- is the text corresponding to the name of the place
; zips -- the zipcode DB
(define (ismember city lst)
	(cond
		((null? lst) #f) ; if part
		((equal? city (car lst)) #t) ; else-if
		(else (ismember city (cdr lst))) ; else
	)
)
(define (findPlacesOfState state zips)
  (if (null? zips)
      '()
      (if (equal? (caddar zips) state) ; need to find a way to add "not in the list"
          (cons (cadar zips) (findPlacesOfState state (cdr zips)))
          (findPlacesOfState state (cdr zips))
      )
  )
)
(define (comparePlaces places1 places2)
  (if (null? places2)
      '()
      (if (equal? (car places1) (car places2))
          (cons (car places1) (comparePlaces  places1 (cdr places2)))
          (comparePlaces places1 (cdr places2))
      )
  )

)
(define (comparisonLoop placesOfState1 placesOfState2)
        (if (null? placesOfState1)
            '()
            (append (comparePlaces placesOfState1 placesOfState2) (comparisonLoop (cdr placesOfState1) placesOfState2))
        )
)
(define (noDuplicates placeList)
  (if (null? placeList)
      '()
      (if (ismember (car placeList) (cdr placeList)) ; need to be checking the list already printing ugh
            (cons (car placeList) (noDuplicates (cdr placeList)))
            (append (noDuplicates (cdr placeList)))
      )
   )
)
(define (getCommonPlaces state1 state2 zips)
        ;(define lst1 '("Franklin" "Oxford" "Akron" "Trenton"))
        ;(define lst2 '("Oxford" "Akron" "Columbus" "Franklin"))
        
        ;(if (null? lst1)
            ;'()
            ;(comparisonLoop lst1 lst2)
        ;)
        (define placesOfState1 (findPlacesOfState state1 zips))
        (define placesOfState2 (findPlacesOfState state2 zips))
        (define fullList (comparisonLoop placesOfState1 placesOfState2))
        ;(display (noDuplicates lst1))
        (if (null? placesOfState1)
            '()
            ;(comparisonLoop (noDuplicates placesOfState1) (noDuplicates placesOfState2))
            (noDuplicates fullList)
        )
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
	'()
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
        ; base case
	(if (null? zips)
            0
            ; if the state from zips equals the state given
            (if (equal? (caddar zips) state)
                 ; that means it is a zipcode entry for the particular
                 ; state so add 1 to the count and check again
                 (+ 1 (zipCount state (cdr zips)))
                 ; otherwise it is the wrong state so keep checking
                 ; without adding to the counts
                 (zipCount state (cdr zips))
            )
        )
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
(define (EVEN? x) (= (modulo x 2) 0))
(define (LARGE? x) (>= (abs x) 10))
(define (SMALL? x) (not (LARGE? x)))

; Returns a list of items that satisfy a set of predicates.
; For example (filterList '(1 2 3 4 100) '(EVEN?)) should return the even numbers (2 4 100)
; (filterList '(1 2 3 4 100) '(EVEN? SMALL?)) should return (2 4)
; lst -- flat list of items
; filters -- list of predicates to apply to the individual elements

; chatgpt
(define (resolve name)
  (cond
    ((eq? name 'POS?) POS?)
    ((eq? name 'NEG?) NEG?)
    ((eq? name 'EVEN?) EVEN?)
    ((eq? name 'LARGE?) LARGE?)
    ((eq? name 'SMALL?) SMALL?)
    (else (error "Unknown predicate:" name))
  )
)

(define (performPredicate filter lst)
  (if (null? lst)
      '()
      (let ((predicate (resolve filter)))
         (if (predicate (car lst))
             (cons (car lst) (performPredicate filter (cdr lst)))
             (performPredicate filter (cdr lst))
          )
      )
   )
)
(define (formNewList filters lst)
    (append (performPredicate (car filters) lst))
)

(define (filterList lst filters)
      (if (null? filters)
          '()
          ;(formNewList filters lst) 
          (append (formNewList filters lst) (filterList (formNewList filters lst) (cdr filters)))        
          ;(cons (performPredicate (car filters) lst) (filterList lst (cdr filters)))
      )
)

(line "filterList")
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) '(POS?)))
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) '(POS? EVEN?)))
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) '(POS? EVEN? LARGE?)))
(line "filterList")
; ---------------------------------------------

