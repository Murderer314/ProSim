generate_yard(0):-!.
generate_yard(1):-
	find_clean(X,Y),
	assert(yard_at(X,Y)),
	!.
generate_yard(COUNT):-
	COUNT > 1,
	C is COUNT-1,
	generate_yard(C),
	find_yard(X,Y),
	assert(yard_at(X,Y)).

generate_dirty(0):-!.
generate_dirty(COUNT):-
	COUNT > 0,
	C is COUNT-1,
	find_clean(X,Y),
	assert(dirty_at(X,Y)),
	generate_dirty(C).

generate_obstacle(0):-!.
generate_obstacle(COUNT):-
	COUNT > 0,
	C is COUNT-1,
	find_clean(X,Y),
	assert(obstacle_at(X,Y)),
	generate_obstacle(C).

generate_children(0):-!.
generate_children(COUNT):-
	COUNT > 0,
	C is COUNT-1,
	ID is COUNT+1,
	generate_children(C),
	find_clean(X,Y),
	assert(children_at(X,Y,ID)).

generate_robot:-
	find_clean(X,Y),
	assert(robot_at(X,Y,1)),
	!.
generate_robot:-
	generate_robot.

generate_enviroment(N,M,D,O,C):-
	DIRTY is N*M*D div 100,
	OBSTACLE is N*M*O div 100,
	CHILDREN is C,
	retractall(yard_at(_,_)),
	retractall(dirty_at(_,_)),
	retractall(obstacle_at(_,_)),
	retractall(children_at(_,_,_)),
	retractall(robot_at(_,_,_)),
	generate_yard(CHILDREN),
	generate_dirty(DIRTY),
	generate_obstacle(OBSTACLE),
	generate_children(CHILDREN),
	generate_robot.