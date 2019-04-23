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