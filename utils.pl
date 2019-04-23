children_at(X,Y):-children_at(X,Y,_).
robot_at(X,Y):-robot_at(X,Y,_).

collider(Sx:Sy,X:Y):-
	valid_direction(Sx,Sy,X,Y),
	not(visited(X:Y)),
	not(obstacle_at(X,Y)),
	assert(visited(X:Y)).
consed(A,B,[B|A]).
is_empty(X,Y):-
	not(dirty_at(X,Y)),
	not(obstacle_at(X,Y)),
	not(yard_at(X,Y)),
	not(children_at(X,Y,_)),
	not(robot_at(X,Y,_)).

find_empty(X,Y):-
	n(N),
	m(M),
	random(0,N,X),
	random(0,M,Y),
	not(dirty_at(X,Y)),
	not(obstacle_at(X,Y)),
	not(yard_at(X,Y)),
	!.

find_empty(X,Y):-
	find_empty(X,Y).

find_clean(X,Y):-
	find_empty(X,Y),
	not(children_at(X,Y,_)),
	!.
find_clean(X,Y):-
	find_clean(X,Y).

valid(X,Y):-
	n(N),
	m(M),
	X>=0,
	Y>=0,
	X<N,
	Y<M.

valid_robot_move(X,Y):-
	valid(X,Y),
	not(obstacle_at(X,Y)).
valid_robot_direction(X,Y,X1,Y1):-
	valid_direction(X,Y,X1,Y1),
	not(obstacle_at(X1,Y1)).
%
direction8(X,Y,X1,Y1):-
	X1 is X-1,
	Y1 is Y-1.
direction8(X,Y,X1,Y1):-
	X1 is X-1,
	Y1 is Y+1.
direction8(X,Y,X1,Y1):-
	X1 is X+1,
	Y1 is Y+1.
direction8(X,Y,X1,Y1):-
	X1 is X+1,
	Y1 is Y-1.
direction4(X,Y,X1,Y1):-
	X1 is X-1,
	Y1 is Y.
direction4(X,Y,X1,Y1):-
	X1 is X,
	Y1 is Y+1.
direction4(X,Y,X1,Y1):-
	X1 is X+1,
	Y1 is Y.
direction4(X,Y,X1,Y1):-
	X1 is X,
	Y1 is Y-1.
direction(X,Y,X1,Y1):-
	direction4(X,Y,X1,Y1).
direction(X,Y,X1,Y1):-
	direction8(X,Y,X1,Y1).
valid_direction4(X,Y,X1,Y1):-
	direction4(X,Y,X1,Y1),
	valid(X1,Y1).
valid_direction8(X,Y,X1,Y1):-
	direction8(X,Y,X1,Y1),
	valid(X1,Y1).
valid_direction(X,Y,X1,Y1):-
	valid_direction4(X,Y,X1,Y1).
valid_direction(X,Y,X1,Y1):-
	valid_direction8(X,Y,X1,Y1).
%
destuple(A:B,A,B).

find_yard(X,Y):-
	findall(A:B,yard_at(A,B),L),				%tengo en L todos los yard_at
	random_member(X1:Y1,L),			%escogo uno random
	% destuple(YARD_POINT,X1,Y1),
	findall(C:D,valid_direction4(X1,Y1,C,D),L1),	%cojo todas las direcciones
	random_member(X:Y,L1),			%escogo uno random
	is_empty(X,Y),
	% destuple(YARD_POINT1, X,Y),
	!.
find_yard(X,Y):-
	find_yard(X,Y).

out_of_order(X:Y):-
	children_at(X,Y),
	not(yard_at(X,Y)).

count_child(X,Y,C):-
	findall(X1:X2,valid_direction(X,Y,X1,X2),L),
	aggregate_all(count,children_list(L), C1),
	C is C1+1.


bfs(Gx:Gy, [[Gx:Gy|Visited]|_], Path,y):- 
	yard_at(Gx,Gy),
	not(children_at(Gx,Gy)),
	reverse([Gx:Gy|Visited], Path),!.
bfs(Gx:Gy, [[Gx:Gy|Visited]|_], Path,c):- 
	children_at(Gx,Gy),
	not(yard_at(Gx,Gy)),
	reverse([Gx:Gy|Visited], Path),!.
bfs(Gx:Gy, [[Gx:Gy|Visited]|_], Path,d):- 
	dirty_at(Gx,Gy),
	reverse([Gx:Gy|Visited], Path),!.
bfs(Gx:Gy, [Visited|Rest], Path, O) :-                     % take one from front
    Visited = [Sx:Sy|_],            
    % Sx:Sy \== Gx:Gy,
    findall(X:Y,collider(Sx:Sy,X:Y),[T|Extend]),
    maplist( consed(Visited), [T|Extend], VisitedExtended),      % make many
    append(Rest, VisitedExtended, UpdatedQueue),       % put them at the end
    bfs( Gx:Gy, UpdatedQueue, Path, O),!.
bfs(Gx:Gy, [_|Rest], Path, O):-
	bfs(Gx:Gy, Rest, Path, O).
breadth_first(Sx:Sy, Gx:Gy, Path, O):-
	retractall(visited(_)),
	assert(visited(Sx:Sy)),
	bfs( Gx:Gy, [[Sx:Sy]], Path, O).

move_robot([Xs:Ys|Path],Mode):-
	length(Path, L),
	(
		(
			(L =:= 1;L =:= 2),
			last(Path, Xd:Yd),
			update_pos(Xs:Ys,Xd:Yd,Mode)
		);
		(
			L > 2,
			nth1(2,Path, Xd:Yd),
			update_pos(Xs:Ys,Xd:Yd,Mode)
		)
	).
update_pos(Xs:Ys,Xd:Yd,Mode):-
	retract(robot_at(Xs,Ys,IDr)),
	assert(robot_at(Xd,Yd,IDr)),
	update_element(Xs:Ys,Xd:Yd,Mode).

update_element(Xs:Ys,Xd:Yd,y):-
	retract(children_at(Xs,Ys,IDc)),
	assert(children_at(Xd,Yd,IDc)),!.
update_element(_,_,_).

random_mover(X,Y):-
	findall(X1:Y1,valid_robot_direction(X,Y,X1,Y1),L),
	random_member(X1:Y1, L),		
	update_pos(X:Y,X1:Y1,c).

is_clean(Count):-
	n(N),
	m(M),
	TOTAL is N*M,
	aggregate_all(count, dirty_at(_,_), Count),
	TOTAL*3 div 5 > Count.

win_game:-
	robot_at(_,_),
	aggregate_all(count, out_of_order(_), CountC),
	CountC =:= 0,
	is_clean(CountD),
	CountD =:= 0.

end_game(CURRENT):-
	t(T),
	CURRENT1 is T*100,
	CURRENT =:= CURRENT1.

keep_playing(CURRENT):-
	not(win_game),
	not(end_game(CURRENT)),
	is_clean(_).

initialize_variables:-
	T is 30,
	N is 5,
	M is 10,
	DIRTY is 10,	%10
	OBSTACLE is 10,	%15
	CHILDREN is 2, %20
	retractall(t),
	retractall(n),
	retractall(m),
	retractall(d),
	retractall(o),
	retractall(c),
	assert(t(T)),
	assert(n(N)),
	assert(m(M)),
	assert(d(DIRTY)),
	assert(o(OBSTACLE)),
	assert(c(CHILDREN)),!.