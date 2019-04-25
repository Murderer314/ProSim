create_line_row(0,'').
create_line_row(L,R):- L=\=0, L1 is L-1, create_line_row(L1,R1),concat('------', R1, R).
create_first_line_row(L,L,'').
create_first_line_row(L,C,R):- C=\=L, C1 is C+1, create_first_line_row(L,C1,R1),concat('  ', C, R2),concat(R2, '  ', R3),concat(R3, ' ', R4),concat(R4, R1, R).
get_line(L,R):-create_line_row(L,R1),concat('-',R1,R).
get_line_first(L,R):-
	create_first_line_row(L,0,R1),
	get_line(L,R2),
	append([R1],[R2],R).

get_cell(X,Y,"|░®░☺░"):-
	dirty_at(X,Y),
	robot_at(X,Y,_),
	children_at(X,Y,_),!.
get_cell(X,Y,"|® [☺]"):-
	yard_at(X,Y),
	robot_at(X,Y,_),
	children_at(X,Y,_),!.
get_cell(X,Y,"| [®] "):-
	yard_at(X,Y),
	robot_at(X,Y,_),!.
get_cell(X,Y,"| ® ☺ "):-
	robot_at(X,Y,_),
	children_at(X,Y,_),!.
get_cell(X,Y,"| ░®░ "):-
	robot_at(X,Y,_),
	dirty_at(X,Y),!.
get_cell(X,Y,"| [☺] "):-
	children_at(X,Y,_),
	yard_at(X,Y),!.
get_cell(X,Y,"| ░☺░ "):-
	children_at(X,Y,_),
	dirty_at(X,Y),!.
get_cell(X,Y,"|  ®  "):-
	robot_at(X,Y,_),!.
get_cell(X,Y,"| ░░░ "):-
	dirty_at(X,Y),!.
get_cell(X,Y,"| ███ "):-
	obstacle_at(X,Y),!.
get_cell(X,Y,"|  ☺  "):-
	children_at(X,Y,_),!.
get_cell(X,Y,"| [ ] "):-
	yard_at(X,Y),!.
get_cell(_,_,"|     "):-!.
	% concat("| ","0 ",R).

print_list_aux([],_,_).
print_list_aux(LIST,M,M):-
	writeln('|'),
	print_line(M),
	print_list_aux(LIST,M,0).
print_list_aux([X|XS],M,C):-
	print_cell(X),
	C1 is C+1,
	print_list_aux(XS,M,C1).
print_list([X|XS],_,M):-
	print_line(M),
	print_list_aux([X|XS],M,0).


%

get_horizontal_aux(0,'').
get_horizontal_aux(L,R):-
	L1 is L-1,
	get_horizontal_aux(L1,R1),
	concat('----', R1, R).
get_horizontal(L,R):-
	get_horizontal_aux(L,R1),
	concat('-',R1,R).

get_lines_aux(N,_,N,0,_,R,R).
get_lines_aux(N,M,X,M,AUX,R1,R):-
	X =\= N,
	X1 is X+1,
	concat(AUX,"| ",AUX1),
	concat(AUX1,X,AUX2),
	append(R1,[AUX2],R2),
	get_line(M,R3),
	append(R2,[R3],R4),
	get_lines_aux(N,M,X1,0,'',R4,R),
	!.
get_lines_aux(N,M,X,Y,AUX,R1,R):-
	X =\= N,
	Y =\= M,
	Y1 is Y+1,
	get_cell(X,Y,R2),
	concat(AUX,R2,AUX1),
	get_lines_aux(N,M,X,Y1,AUX1,R1,R),
	!.

get_lines(R):-
	% get_horizontal(M,R),
	n(N),
	m(M),
	get_line_first(M,R1),
	get_lines_aux(N,M,0,0,'',[],R2),
	append(R1,R2,R).

print_a([]):-!.
print_a([H|R]):-
	writeln(H),
	print_a(R).

print_aa(R):-
	fail,
	get_lines(R),
	print_a(R),!.
print_aa(1).
	% findall(R,print_a(R),L).
print_aaa(R):-
	get_lines(R),
	print_a(R),!.
	