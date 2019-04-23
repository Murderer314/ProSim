simulate_robot(R):-
	robot_at(X,Y),
	children_at(X,Y),
	not(yard_at(X,Y)),
	find_closest_corral(X:Y,Path),
	move_robot(Path,y),
	R is 1,
	print_aa(_).

simulate_robot(R):-
	robot_at(X,Y),
	find_closest_child(X:Y,Path),
	move_robot(Path,c),
	R is 0,
	print_aa(_).

move_robot(Path,c):-
	nth0(0, Path, Xr:Yr),
	length(Path, L),
	(
		(
			(L =:= 2;L =:= 3),
			last(Path, Xl:Yl),
			retract(robot_at(Xr,Yr,IDr)),
			assert(robot_at(Xl,Yl,IDr))
		);
		(
			L > 3,
			nth0(2,Path, Xl:Yl),
			retract(robot_at(Xr,Yr,IDr)),
			assert(robot_at(Xl,Yl,IDr))
		)
	).
move_robot(Path,y):-
	nth0(0, Path, Xr:Yr),
	length(Path, L),
	(
		(
			(L =:= 2;L =:= 3),
			last(Path, Xl:Yl),
			retract(robot_at(Xr,Yr,IDr)),
			assert(robot_at(Xl,Yl,IDr)),
			retract(children_at(Xr,Yr,IDc)),
			assert(children_at(Xl,Yl,IDc))
		);
		(
			L > 3,
			nth0(2,Path, Xl:Yl),
			retract(robot_at(Xr,Yr,IDr)),
			assert(robot_at(Xl,Yl,IDr)),
			retract(children_at(Xr,Yr,IDc)),
			assert(children_at(Xl,Yl,IDc))
		)
	).