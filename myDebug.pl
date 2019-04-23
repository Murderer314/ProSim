debug_dirty(R):-
	findall(X:Y,dirty_at(X,Y),R).
debug_obstacle(R):-
	findall(X:Y,obstacle_at(X,Y),R).
debug_children(R):-
	findall(X:Y:ID,children_at(X,Y,ID),R).
debug_yard(R):-
	findall(X:Y,yard_at(X,Y),R).

debug_all(D,O,C,Y):-
	debug_dirty(D),
	debug_obstacle(O),
	debug_children(C),
	debug_yard(Y).