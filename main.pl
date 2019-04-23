:-dynamic
	t/1,n/1,m/1,
	d/1,o/1,c/1,
	dirty_at/2,
	obstacle_at/2,
	yard_at/2,
	children_at/3,
	robot_at/3,
	visited/1.

:-consult(myDebug).
:-consult(generator).
:-consult(utils).
:-consult(myPrint).
:-consult(actions).
:-consult(robotLeandro).
% :-consult(robotZahuis).
% :-include(actions).
:-debug.

%	-------------
%	|	|	|	|	NxM
%	-------------
%	|	|	|	|	2*3
%	-------------

start:-
	initialize_variables,
	% generate_enviroment(N,M,DIRTY,OBSTACLE,CHILDREN),
	% debug_all(D,O,C,Y),
	% print((D,O,C,Y)),
	% get_lines(R),
	% print_aa(R),
	% print(A),
 	simulate(0),
	fail.

% union(A,[H|T],R):- member(H, A),union(A,T,R).
% union(A,[H|T],R):- not(member(H, A)),append(A,H,A1),union(A1,T,R).

start.