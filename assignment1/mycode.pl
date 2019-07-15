
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						Q1						 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sumsq_even(Numbers, Sum)


% ?- sumsq_even([1,3,5,2,-4,6,8,-7], Sum).
%    Sum = 120 



% determine whether Number is even or odd
is_even(Number) :-
	%% if this Number is integer
	integer(Number),
	%% and if this Number is even
	0 is Number mod 2.

is_odd(Number) :-
	integer(Number),
	1 is Number mod 2.



% Base case: (empty list)
sumsq_even([], 0).

% Inductive Step: (loop case)
sumsq_even([Item | Rest], Sum) :-
	% loop until the Rest is empty
	sumsq_even(Rest, Sum_of_Rest),
	% then, judge the 'last' Item is even or not 
	is_even(Item),
	% if is_even is true, then, calculate
	Sum is Item * Item + Sum_of_Rest.

% However, odd numbers should be ignored
sumsq_even([Item | Rest], Sum) :-
	% if Item is odd
	is_odd(Item),
	% then, move to the remaining list 
	% and keep the Sum constant
	sumsq_even(Rest, Sum).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						Q2						 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% same_name(Person1,Person2)


% ?- same_name(pat, brian).
% false.

% ?- same_name(jenny, jim).
% true 



% base case: 
% if Ancestor is parent of Person
% and Ancestor is also a male
ancestor(Person, Ancestor) :-
	male(Ancestor),
	parent(Ancestor, Person).

% Inductive Step: (loop case)
ancestor(Person, Ancestor) :-
	% if this Person has Parent
	parent(Parent, Person),
	% and the Parent is male
	% if Parent is female, it will not continue, 
	% and return false in this step
	male(Parent),
	% then, judge whether Parent has Ancestor
	ancestor(Parent, Ancestor).



% function 'same name'
% base case:
% they are same person
same_name(Person1, Person2) :-
	Person1 == Person2.

% case 1:
% Person1 is ancestor of Person2
same_name(Person1, Person2) :-
	ancestor(Person1, Person2).

% case 2:
% Person2 is ancestor of Person1
same_name(Person1, Person2) :-
	ancestor(Person2, Person1).

% case 3:
% Person1 has same ancestor(male) with Person2
same_name(Person1, Person2) :-
	% if they have the same ancestor, 
	% then, they have same name
	ancestor(Person1, Same_Ancestor),
	ancestor(Person2, Same_Ancestor).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						Q3						 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sqrt_list(NumberList, ResultList)

% ?- sqrt_list([0,2,289], Result).
% Result = [[0, 0.0], [2, 1.4142135623730951], [289, 17.0]].



% required to write copy_list(L, R)
copy_list(L, R) :-
	sqrt_list(L, R).


% base case:
sqrt_list([], []).

% other case:
sqrt_list([Item | Rest_List], [[Item, Sqrt_Item] | Result_List]) :-
	Item >= 0,
	Sqrt_Item is sqrt(Item),
	sqrt_list(Rest_List, Result_List).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						Q4						 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sign_runs(List, RunList)


% test case: 
% ?- sign_runs([8,-1,-3,0,2,0,-4], RunList).
% RunList = [[8], [-1, -3], [0, 2, 0], [-4]].

% ?- sign_runs([8,-1,-3,0,2,0,-4, 5, 5, 5, -5, 1, -5], RunList).
% RunList = [[8], [-1, -3], [0, 2, 0], [-4], [5, 5, 5], [-5], [1], [-5]] .


% add Item into the end of list
% base case:
add(Item, [], [Item]).

% other case:
add(Item, [Head | Tail], [Head | New_Tail]) :-
	add(Item, Tail, New_Tail).


% base case:
sign_runs([], []).

% other case:
sign_runs(List, RunList) :-
	% required more parameters
	% L1, L2 = [], []
	% Temp_List is an empty list
	% I use underline to represent the this variable
	loop(List, [], [], _, RunList).



% L1 record elements which are >= 0
% L2 record elements which are < 0
% Temp_List record [L1 | [Item]]
% and, copy L2 into the head of 'Run_List'
loop([Item | RestList], L1, L2, Temp_List, [L2 | Run_List]) :-
	%% if Item >= 0
	Item >= 0,
	%% and if L2 not equal to empty list
	L2 \= [],
	%% then, Temp_List = L1 + [Item]
	%% (notice: Item should be placed in the end of this list)
	add(Item, L1, Temp_List),
	%% finally, 
	%% L1 is replaced with Temp_List
	%% reset L2 to be empty list
	%% and reset Temp_List as a variable
	loop(RestList, Temp_List, [], _, Run_List).


% if Item >= 0 but L2 is equal to empty list
% then, do not change 'Run_List'
loop([Item | RestList], L1, L2, Temp_List, Run_List) :-
	%% if Item >= 0
	Item >= 0,
	%% but L2 is equal to empty list
	L2 == [],
	%% then, positive number should also be added into Temp_List
	add(Item, L1, Temp_List),
	%% loop, but 'Run_List' do not need to be modified
	%% (see the last parameter in this function)
	loop(RestList, Temp_List, [], _, Run_List).




% similar as above
loop([Item | RestList], L1, L2, Temp_List, [L1 | Run_List]) :-
	Item < 0,
	L1 \= [],
	add(Item, L2, Temp_List),
	loop(RestList, [], Temp_List, _, Run_List).


loop([Item | RestList], L1, L2, Temp_List, Run_List) :-
	Item < 0,
	L1 == [],
	add(Item, L2, Temp_List),
	loop(RestList, [], Temp_List, _, Run_List).




% there is a remaining list which is not added into Run_List
% so, the last step is to add the remaining list into Run_List
%
%% if 'RestList' is []
%% and if L1 exists
%% then, make 'Run_List' = [L1]
%% (notice: L2 and Temp_List is not necessary and it is not important)
loop([], L1, _, _, [L1]) :-
	L1 \= [].

loop([], _, L2, _, [L2]) :-
	L2 \= [].






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						Q5						 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% is_heap()

% ?- is_heap(tree(tree(tree(empty,4,empty),3,tree(empty,5,empty)),6,tree(tree(empty,9,empty),7,empty))).
% false.

% ?- is_heap(tree(empty,3,tree(tree(empty,8,empty),5,tree(empty,7,empty)))).
% true



% base case:
%% if left child and right child are empty
%% then, is_heap should return true
is_heap(tree(empty, _, empty)).



% case 1: (if left subtree is empty)
%% if Left_Subtree is empty, which means no Left_Number
%% so just consider about the Right_Subtree and Right_Number
is_heap(tree(empty, Number, Right_Subtree)) :-
	%% the left subtree and right subtree of Right_Subtree is not important
	%% just need to consider the Right_Number of Right_Subtree
	%% the follow code is to get the Right_Number of Right_Subtree
	Right_Subtree = tree(_, Right_Number, _),
	%% if Number <= Right_Number
	Number =< Right_Number,
	%% then, continue to consider the subtrees of Right_Subtree
	is_heap(Right_Subtree).


% case 2: (if right subtree is empty)
%% similar as above
is_heap(tree(Left_Subtree, Number, empty)) :-
	Left_Subtree = tree(_, Left_Number, _),
	Number =< Left_Number,
	is_heap(Left_Subtree).


% case 3: (if both left subtree and right subtree are exist)
%% consider both side
is_heap(tree(Left_Subtree, Number, Right_Subtree)) :-
	%% consider Left_Subtree and get the Left_Number
	Left_Subtree = tree(_, Left_Number, _),
	%% consider Right_Subtree and get the Right_Number
	Right_Subtree = tree(_, Right_Number, _),
	%% whether Number is less than or equal to Left_Number
	Number =< Left_Number,
	%% whether Number is less than or equal to Right_Number
	Number =< Right_Number,
	%% if code above is true,
	%% then, go to the Left_Subtree and Right_Subtree,
	%% and check whether Left_Subtree and Right_Subtree is
	%% also satisfy the condition
	%% which is the number of non-leaf node <= the number of it's child node
	is_heap(Left_Subtree),
	is_heap(Right_Subtree).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						end						  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
