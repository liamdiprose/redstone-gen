#!/usr/bin/clingo

#const width = 4.

dim(1..width).

wireID(1).

% Redstone can be anywhere on the board
{redstone(X, Y) : dim(X), dim(Y)}.

% Adjacent 
adjacent(0,-1 ;; 0,1 ;; -1,0 ;; 1,0).

% The start is Reachable
start(1,1,1).
reachable(1, X,Y) :- redstone(X,Y), start(1,X,Y).

% Some position (NY,NX) [any reachble position (X,Y) moved in any adjacent (DX,DY) direction], is reachable if redstone can be placed there
reachable(1, NX,NY) :- 
    reachable(1, X,Y),
    adjacent(DX,DY),
    NX = X + DX,
    NY = Y + DY,
    redstone(NX, NY).
% TODO: Not adjacent other wireID's


% Mark maps as complete if they have a reachable finsih
finish(1,4,4).
complete :- reachable(1,X,Y), finish(1,X,Y).


% Throw away maps that are incomplete
:- not complete.

#minimize { 1, X, Y :  redstone(X,Y) } .
