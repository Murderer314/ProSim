search_and_catch(1,X:Y):-
	children_at(X,Y),
	not(yard_at(X,Y)),
	find_closest_corral(X:Y,Path,_),
	move_robot(Path,y),
	print_aa(_).

search_and_catch(0,X:Y):-
	(not(children_at(X,Y));	(yard_at(X,Y))),
	find_closest_child(X:Y,Path,_),
	move_robot(Path,c),
	print_aa(_).

to_clean(2,X:Y):-
	dirty_at(X,Y),
	retract(dirty_at(X,Y)),
	print_aa(_).

to_clean(3,X:Y):-
	not(dirty_at(X,Y)),
	find_closest_dirty(X:Y,Path,_),
	move_robot(Path,d),
	print_aa(_).

simulate_robot(R):-
	robot_at(X,Y),
	aggregate_all(count, out_of_order(_), Count),
	choose_action(X:Y,Count,R).
choose_action(X:Y,0,R):-
	to_clean(R,X:Y),!.
choose_action(X:Y,_,R):-
	search_and_catch(R,X:Y),!.
