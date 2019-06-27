#!/usr/bin/clingo

#const width = 4.

dim(1..width).

%wire_id(one ;; two).

% Redstone can be anywhere on the board
{redstone(X, Y) : dim(X), dim(Y)}.

% Adjacent
adjacent(0,-1 ;; 0,1 ;; -1,0 ;; 1,0).

% The start is Reachable
start(1,1).

reachable(X,Y) :- start(X,Y), redstone(X,Y).

% Some position (X,Y) is reachable, if it is the start and redstone can be placed there
%reachable(X,Y) :- start(X,Y), redstone(X,Y).


% Some position (NY,NX) [any reachble position (X,Y) moved in any adjacent (DX,DY) direction], is reachable if redstone can be placed there
reachable(NX,NY) :- 
    reachable(X,Y),
    adjacent(DX,DY),
    NX = X + DX,
    NY = Y + DY,
    redstone(NX, NY).


% Mark maps as complete if they have a reachable finsih
finish(4,4).
complete :- finish(X,Y), reachable(X,Y).


% Throw away maps that are incomplete
:- not complete.

#minimize { 1, X, Y :  redstone(X,Y) } .
% vim:ft=prolog
