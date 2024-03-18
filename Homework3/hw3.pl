% hw3.pl
% Savannah Lescas

% ------------------------------------------------
% #1 (Undergraduate/Graduate) (5/5 pts)
% Determine the Maximum of two int numbers
% maxnums(A, B, MAX).

% if B is greater than A return B
maxnums(A, B, MAX) :- B > A, MAX is B.

% if A is greater than B return A
maxnums(A, B, MAX) :- A > B, MAX is A.

% if A and B are equal return A
maxnums(A, B, MAX) :- A = B, MAX is A.

% maxnums(-12, 12, MAX). -> MAX = 12
% maxnums(11232, 92674, MAX). -> MAX = 92674
% maxnums(1, 1, MAX). -> MAX = 1 
% ------------------------------------------------
% #2 (Undergraduate/Graduate) (5/5 pts)
% Determine the summation of a list of integer numbers
% sum(LST, SUM).

% if the list is empty the sum is 0
sum([], 0).

% adds the head to the sum variable then runs again with the tail
% and sum variable
sum([H|T], SUM) :- sum(T, S), SUM is S + H.

% sum([1, 2, 3, 4], SUM). -> SUM = 10
% sum([10, -10], SUM). -> SUM = 0
% sum([], SUM). -> SUM = 0
% ------------------------------------------------
% #3 (Undergraduate/Graduate) (5/5 pts)
% Determine the Maximum of list of integer numbers
% ** You MUST use/call your maxnums predicate that you defined in #1
%    as part of your solution.
% ** You can always assume that the given LST is not empty. 
% max(LST, MAX).

% if there is one element it is the max
max([MAX], MAX).

% uses maxnums to compare the 2 heads, gets its max, then runs again 
% on a new list with the max and the rest of the list
max([H1,H2|T], MAX) :- maxnums(H1, H2, M), append([M], T, L), max(L, MAX).

% max([-5, -5, -5], MAX). -> MAX = -5
% max([1], MAX). -> MAX = 1
% max([413, 0, 977], MAX). -> MAX = 977
% ------------------------------------------------
% #4 (Undergraduate/Graduate) (5/5 pts)
% Determine if a list of integer numbers can be split into two lists 
% that sum to the same value.
% ** You MUST use/call your sum predicate that you defined in #2
%    as part of your solution.
% ** You can always assume that the given LST is not empty. 
% partitionable(LST).

% if the list has only one element return true
partitionable([LST]).

% run the sum method on just the head and then the tail and if they are
% equal return true
partitionable([H|T]) :- sum([H], SUM1), sum(T, SUM2), SUM1 = SUM2.

% add the heads of the list to make a list get its sum and compare it to 
% the sum of the rest of the list by running the other verison of partitionable
partitionable([H1,H2|T]) :- append([H1],[H2],L), sum(L, SUM), partitionable(SUM, T).

% form of partitionable that takes in a sum and compares it to the sum of the
% rest of the list
partitionable(SUM, T) :- sum(T, SUM2), SUM = SUM2.

% recursively goes through and adds the head to the sum of the left side
% and compares it to the sum of the right side
partitionable(S, [H|T]) :- SUM is S + H, partitionable(SUM, T).
 
% partitionable([1, 2, 3, 4, 10]). -> true. because [10, 10]
% partitionable([2, 1, 1]). -> true. because [2, 2]
% partitionable([0]). -> true.
% partitionable([1, 4, 8]). -> false.
% partitionable([3, 2]). -> false.
% ------------------------------------------------
% #5 (Undergraduate/Graduate) (5/5 pts)
% Determine whether the given integer number does exist in the given 
% list of integer numbers
% elementExist(E, LST).

% if the element is found then return true
elementExist(E, [H|_]) :- H = E.

% if the element is not found keep checking the list
elementExist(E, [_|T]) :- elementExist(E, T).

% elementExist(1, [1, 2, 3]). -> true.
% elementExist(1, []). -> false.
% elementExist(-10, [-34, -56, 2]). -> false.
% ------------------------------------------------
% #6 (Undergraduate/Graduate) (5/5 pts)
% Determine the reverse list of integer numbers
% reverse(LST, REVLST).

% base case
reverse([], []).

% does the reversing by adding whatever is the head to the list
reverse([H|T], REVLST) :- append(NL, [H], REVLST), reverse(T, NL).

% reverse([], REVLST). -> REVLST = []
% reverse([1, 1, 1], REVLST). -> REVLST = [1, 1, 1]
% reverse([4, 0, -4, 6], REVLST). -> REVLST = [6, -4, 0, 4]
% reverse([47391], REVLST). -> REVLST = [47391]
% ------------------------------------------------
% #7 (Undergraduate/Graduate) (5/5 pts)
% Determine the list of integer numbers that are only one digit numbers
% collectOneDigits(LST, NEWLST). 

% helper that determines if the number is one digit
oneDigit(E) :- E < 10, E > -10.

% base case
collectOneDigits([],[]).

% if the number is one digit add it to the list then repeat with the rest of the list
collectOneDigits([H|T], NEWLST) :- oneDigit(H), append([H], NL, NEWLST), collectOneDigits(T,NL).

% if the number is not one digit just repeat with the rest of the list
collectOneDigits([H|T], NEWLST) :- collectOneDigits(T,NEWLST).

% collectOneDigits([10, 90, -20], NEWLST). -> NEWLST = []
% collectOneDigits([], NEWLST). -> NEWLST = []
% collectOneDigits([10, 90, -20, 5, -6], NEWLST). -> NEWLST = [5, -6]
% ------------------------------------------------
% #8 (Undergraduate/Graduate) (5/5 pts)
% Consult the 'zipcodes.pl' file, and study it.
% It contains facts about the US zipcodes.
 location(Zipcode, Place, State, Location, Latitude, Longitude).
% Example: for getting all the Zipcodes and Sates you can do 
%         location(Z, _, S, _, _, _). 
% Determine all places based on given state and zipcode.
% getStateInfo(PLACE, STATE, ZIPCODE).

% get's whatever is needed from zipcodes.pl
getStateInfo(Place, State, Zipcode) :- location(Zipcode, Place, State, _, _, _).

% getStateInfo('Oxford', State, 45056). -> State = 'OH'
% getStateInfo('Oxford', State, _). -> 
% State = 'AL' 
% State = 'AR' 
% State = 'CT' 
% State = 'FL' 
% State = 'GA' 
% State = 'GA' 
% State = 'IA' 
% State = 'IN' 
% State = 'KS' 
% State = 'MA' 
% State = 'MD' 
% State = 'ME' 
% State = 'MI' 
% State = 'MI' 
% State = 'MS' 
% State = 'NC' 
% State = 'NE' 
% State = 'NJ' 
% State = 'NY' 
% State = 'OH' 
% State = 'PA' 
% State = 'WI'
% 
% getStateInfo(_, 'OH', 48122) -> false.
% ------------------------------------------------
% #9 (Undergrad/Grad) (15/5 pts)
% Consult the 'zipcodes.pl' file, and study it.
% It contains facts about the US zipcodes.
% location(Zipcode, Plcae, State, Location, Latitude, Longitude).
% Example: for getting all the Zipcodes and Sates you can do 
%         location(Z, _, S, _, _, _). 
% Gets place names that are common to both STATE1 and STATE2, 
% where STATE1 and STATE2 differ
% ** The order of places is not important
% ** Duplicate values should be removed
% ** You are to do your own search to find a way to return all 
%    places as a single list. You can use any necessary predicate 
%    from Prolog library. Being able to learn something
%    about a new programming language on your own is a skil that takes
%    practice. 
% getCommon(STATE1, STATE2, PLACELST).

% returns the places of a state
getPlaces(State, Place) :- location(_, Place, State, _, _, _).

% creates a list of everything returned from getPlaces using findall predicate
% discovered the findall predicate through stackoverflow.com and watched a YouTube
% video on how to implement it
listPlaces(State, PlaceLST) :- findall(Place, getPlaces(State, Place), PlaceLST).

% base case for helper
findCommons([],_,[]).

% if an element we are checking in state1's list is in state2's place list, add it to the combined list
findCommons([H1|T1], P2, PlaceLST) :- elementExist(H1, P2), append([H1], NL, PlaceLST), findCommons(T1, P2, NL).

% if the element being checked from state1 is not in state2's place list don't add it and repeat with 
% the rest of the list
findCommons([H1|T1], P2, PlaceLST) :- findCommons(T1, P2, PlaceLST).

% when the states are the same, return an empty list
getCommon(State1, State1, []).

% calls to listPlaces gets the lists of all the places from state1 stores them in P1 does the same for State2 
% with P2, and then recursive calls to findCommons with those lists and PlaceLST.
% found the sort predicate through stackoverflow.com
getCommon(State1, State2, PlaceLST) :- listPlaces(State1, P1), listPlaces(State2, P2), findCommons(P1, P2, WithDupes), sort(WithDupes, PlaceLST).


% getCommon('OH','MI',PLACELST). -> *Should be 131 unique places* 
% ['Manchester','Unionville','Athens','Saint
% Johns','Belmont','Bellaire','Bridgeport','Lansing','Flushing','D
% ecatur','Hamilton','Oxford','Trenton','Monroe','Augusta','Carrol
% lton','Milford','Moscow','New
% Richmond','Williamsburg','Clarksville','Midland','Elkton','Salem
% ','Blissfield','Bedford','Greenville','North Star','Union
% City','Sherwood','Ashley','Birmingham','Milan','Sandusky','Colum
% bus','Lyons','Metamora','Burton','Alpha','Cedarville','Jamestown
% ','Fairview','Harrison','Arcadia','Kenton','Ridgeway','Ada','Alg
% er','Freeport','Harrisville','Napoleon','Highland','Lakeville','
% Millersburg','Nashville','Bellevue','New
% Haven','Jackson','Wellston','Bloomingdale','Empire','Mount
% Pleasant','Richmond','Perry','Eastlake','Homer','Utica','Lakevie
% w','Quincy','Holland','Ellsworth','Petersburg','Marion','Caledon
% ia','Brunswick','Chippewa
% Lake','Litchfield','Portland','Coldwater','Mendon','Rockford','C
% ovington','Troy','Clayton','Vandalia','Fulton','Sparta','Rosevil
% le','Martin','Somerset','Jasper','Wakefield','Ravenna','Wayland'
% ,'Deerfield','Camden','Cloverdale','Plymouth','Shelby','Frankfor
% t','Kingston','Fremont','Adrian','Attica','Flat
% Rock','Fostoria','Republic','Sidney','Paris','Canton','Bath','Cl
% inton','Hudson','Akron','Fowler','Hartford','Niles','Warren','Du
% ndee','Marysville','Ray','Franklin','Mason','Lowell','Newport','
% Waterford','Sterling','Portage','Wayne','Grand Rapids','Weston']
% 
% ------------------------------------------------
% #10 ( -- /Graduate) (0/10 pts)
% Download the 'parse.pl' from canvas and study it.
% Write Prolog rules to parse simple English sentences 
% (similar to how it was done in parse.pl). The difference here is that 
% the number (i.e., plurality) of the noun phrase and verb phrase must match. 
% That is, “The sun shines” and “The suns shine” is proper, 
% whereas “The suns shines” and “The sun shine” are not. 
% Make sure your code also includes the following vocabulary.
% singular nouns: sun, bus, deer, grass, party
% plural nouns: suns, buses, deer, grasses, parties
% articles: a, an, the
% adverbs: loudly, brightly
% adjectives: yellow, big, brown, green, party
% plural verbs: shine, continue, party, eat
% singular verbs: shines, continues, parties, eats


% sentence([the, party, bus, shines, brightly]). -> true.
% sentence([the, big, party, continues]). -> true.
% sentence([a, big, brown, deer, eats, loudly]). -> true.
% sentence([big, brown, deer, eat, loudly]). -> true.
% sentence([the, sun, shines, brightly]). -> true.
% sentence([the, suns, shine, brightly]). -> true.
% sentence([the, deer, eats, loudly]). -> true.
% sentence([the, deer, eat, loudly]). -> true.
% sentence([the, sun, shine, brightly]). -> false.
%sentence([the, suns, shines, brightly]). -> false.
% ------------------------------------------------

