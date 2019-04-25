simulate_robot(R):-
    robot_at(X,Y),
    (
		(
			children_at(X,Y,_),
			not(yard_at(X,Y)),
			find_closest_corral(X:Y,Path,_),
			move_robot(Path,y),!
		);
		(
			not(children_at(X,Y))
		);
		(
			yard_at(X,Y)	
		)
	);
	(
		(	not(children_at(X,Y)),
			dirty_at(X,Y),
			retract(dirty_at(X,Y))
		);
		(	
			random_mover(X,Y)
		)
	),
	R is 1,
	print_aa(_).