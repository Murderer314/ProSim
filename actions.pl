move_obstacle(X:Y,X1:Y1):-
	is_empty(X1,Y1),
	retract(obstacle_at(X,Y)),
	assert(obstacle_at(X1,Y1)),
	!.
move_obstacle(X:Y,X1:Y1):-
	obstacle_at(X1,Y1),
	X2 is 2*X1-X,
	Y2 is 2*Y1-Y,
	valid(X2,Y2),
	move_obstacle(X1:Y1,X2:Y2),
	retract(obstacle_at(X,Y)),
	assert(obstacle_at(X1,Y1)).

move_and_push(X,Y,X1,Y1):-
	obstacle_at(X1,Y1),
	X2 is 2*X1-X,
	Y2 is 2*Y1-Y,
	valid(X2,Y2),
	move_obstacle(X1:Y1,X2:Y2),
	retract(children_at(X,Y,ID)),
	assert(children_at(X1,Y1,ID)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

move_and_push(X,Y,X1,Y1):-
	not(obstacle_at(X1,Y1)),
	retract(children_at(X,Y,ID)),
	assert(children_at(X1,Y1,ID)).

child_move(X,Y):-
	try_move(X,Y),
	!.
child_move(_,_).

children_list(L):-
	member(X1:X2, L),
	children_at(X1,X2,_).

try_move(X,Y):-
	findall(X1:Y1,direction(X,Y,X1,Y1),L),
	random_member(X1:Y1, L),
	% destuple(DIR,X1,Y1),
	valid(X1,Y1),
	not(children_at(X1,Y1)),
	not(robot_at(X1,Y1)),
	not(yard_at(X1,Y1)),
	move_and_push(X,Y,X1,Y1).
	
to_dirty(X,Y):-
	count_child(X,Y,C),
	to_dirty(X,Y,C),
	!.
to_dirty(_,_).

to_dirty(_,_,0).
to_dirty(X,Y,1):-
	findall(X1:X2,valid_direction(X,Y,X1,X2),L1),
	append(L1,[X:Y],L),
	random_member(X1:Y1, L),
	not(dirty_at(X1,Y1)),
	not(yard_at(X1,Y1)),
	not(obstacle_at(X1,Y1)),
	assert(dirty_at(X1,Y1)).
to_dirty(X,Y,2):-
	to_dirty(X,Y,2,2).

to_dirty(_,_,_,0).
to_dirty(X,Y,_,C):-
	C=\=0,
	C1 is C-1,
	to_dirty(X,Y,1),
	to_dirty(X,Y,_,C1),
	!.
to_dirty(X,Y,_,C):-
	C=\=0,
	C1 is C-1,
	to_dirty(X,Y,_,C1).

try_to_generate(CURRENT,R):-
	t(T),
	RESTO is CURRENT mod T,
	RESTO =:= 0,
	n(N),m(M),d(DIRTY),o(OBSTACLE),c(CHILDREN),
	generate_enviroment(N,M,DIRTY,OBSTACLE,CHILDREN),
	print_aa(_),
	R is 1,
	!.
try_to_generate(_,0).



% bfs(Goal, [[Goal|Visited]|_], Path):- 
% 	reverse([Goal|Visited], Path),!.
% bfs(Goal, [Visited|Rest], Path) :-                     % take one from front
%     Visited = [Start|_],            
%     Start \== Goal,
%     findall(X,
%         (connected2(X,Start,_),not(visited(X)),assert(visited(X))),
%         % (connected2(X,Start,_),not(member(X,Visited))),
%         [T|Extend]),
%     maplist( consed(Visited), [T|Extend], VisitedExtended),      % make many
%     append(Rest, VisitedExtended, UpdatedQueue),       % put them at the end
%     bfs( Goal, UpdatedQueue, Path ),!.
% bfs(Goal, [Visited|Rest], Path):-
% 	bfs(Goal, Rest, Path).
% breadth_first( Start, Goal, Path):- retractall(visited(_)),assert(visited(Start)), bfs( Goal, [[Start]], Path).


find_closest_corral(X:Y,Path,Xr:Yr):-
	breadth_first(X:Y,Xr:Yr,Path,y).
find_closest_child(X:Y,Path,Xr:Yr):-
	breadth_first(X:Y,Xr:Yr,Path,c).
find_closest_dirty(X:Y,Path,Xr:Yr):-
	breadth_first(X:Y,Xr:Yr,Path,d).

child_action(_,X:Y):-
	% member([ID,X:Y], L),
	not(robot_at(X,Y,_)),
	not(yard_at(X,Y)),
	to_dirty(X,Y),
	child_move(X,Y),
	print_aa(_),!.
child_action(_,_):-
	print_aa(_),!.
simulate_children(1):-
	findall([ID,A:B],children_at(A,B,ID),L),
	sort(L,Sorted),
	foreach(member([ID,X:Y], Sorted),child_action(ID,X:Y)),!.
% findall
	
	% findall(1,child_action(Sorted),_),!.
simulate_children(0).

simulate_agents:-
	simulate_robot(_),
	simulate_children(_).

simulate(CURRENT):-
	keep_playing(CURRENT),
	try_to_generate(CURRENT,_),
	writeln(CURRENT),
	simulate_agents,
	CURRENT1 is CURRENT + 1,
	simulate(CURRENT1),!.
simulate(CURRENT):-
	win_game,
	t(T),
	Pasos is CURRENT mod T,
	Juego is (CURRENT div T) + 1,
	concat('Ganaste el juego en ',Pasos,R1),
	concat(R1,' pasos de juego #',R2),
	concat(R2,Juego,R3),
	writeln(R3),!.

simulate(CURRENT):-
	not(is_clean(_)),
	t(T),
	Pasos is CURRENT mod T,
	Juego is (CURRENT div T) + 1,
	concat('Perdiste el juego por suciedad en ',Pasos,R1),
	concat(R1,' pasos de juego #',R2),
	concat(R2,Juego,R3),
	writeln(R3),!.

simulate(CURRENT):-
	end_game(CURRENT),
	t(T),
	Pasos is CURRENT mod T,
	Juego is (CURRENT div T) + 1,
	concat('Perdiste el juego por tiempo en ',Pasos,R1),
	concat(R1,' pasos de juego #',R2),
	concat(R2,Juego,R3),
	writeln(R3),!.