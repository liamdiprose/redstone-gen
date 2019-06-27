#!/usr/bin/clingo

#const width = 10.

dim(1..width).

wireID(1).

% Redstone can be anywhere on the board
{redstone(X, Y) : dim(X), dim(Y)}.

% Adjacent
adjacent(0,-1 ;; 0,1 ;; -1,0 ;; 1,0).

% The start is Reachable
start(1,1,1).
start(2,9,1).


reachable(ID,X,Y) :- redstone(X,Y), start(ID,X,Y).

% Some position (NY,NX) [any reachble position (X,Y) moved 
% in any adjacent (DX,DY) direction], is reachable if 
% redstone can be placed there
reachable(ID,NX,NY) :-
    reachable(ID,X,Y),
    adjacent(DX,DY),
    NX = X + DX,
    NY = Y + DY,
    redstone(NX, NY).

shortcircuit :-
    reachable(ID1, X, Y),
    adjacent(DX,DY),
    NX = X + DX,
    NY = Y + DY,
    reachable(ID2, NX, NY),
    ID1 != ID2.

overlapping :-
    reachable(ID1, X, Y),
    reachable(ID2, X, Y),
    ID1 != ID2.

:- shortcircuit.
:- overlapping.

% Mark maps as complete if they have a reachable finsih
finish(1,5,4).
finish(2,1,6).
complete(ID) :- reachable(ID,X,Y), finish(ID,X,Y).


% Throw away maps that are incomplete
:- not complete(1).
:- not complete(2).

#minimize { 1, ID, X, Y :  reachable(ID, X,Y) } .

% vim:ft=prolog
