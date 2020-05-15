/*




*/

%some_filter/2
%some_filter([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],R).
% elem. X trebuie sa fie in intervalul [5, 20] si trebuie sa fie impare.

%some_filter([],[]).
%some_filter([H|T], [H|R]) :- H > 5, H < 20, H mod 2 =:= 1, some_filter(T,R).
%some_filter([H|T], R) :- not((H > 5, H < 20, H mod 2 =:= 1)), some_filter(T,R).

some_filter([],[]).
some_filter([H|T], [H|R]) :- H > 5, H < 20, H mod 2 =:= 1, some_filter(T,R), !.
some_filter([_|T], R) :- some_filter(T,R).


predicat(X) :- X > 5, X < 20, X mod 2 =:= 1.

% include / exclude
% filter/3 - valoarea la care este legata variabila Pr, este un predicat de aritate 1
% filter([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],predicat,R).
%                     Pr = p   call(Pr,H) este echivalentul p(H).
filter([],_,[]).
filter([H|T],Pr,[H|R]) :- call(Pr,H), filter(T,Pr,R), !.
filter([_|T],Pr, R) :- filter(T,Pr,R).


% echivalentul comportamental al functiei map din prolog.
%mapp/3 map(L,G,R), unde L este o lista, G este un predicat de aritate 2 (usage: p(X,Y).)
% folosind predicatul G, vom transforma fiecare element din lista L.

% in implementarea voastra, call va avea aritate 3
twotimes(X,Y) :- Y is X*2.
mapp([],_,[]).
mapp([H|T],Pr,[Y|Rest]) :- call(Pr,H,Y), mapp(T,Pr,Rest).
%              Pr = p, echiv p(H,Y)

%csp - Constraint Satisfaction Problem (o categorie de probleme NP complete)
%      Linear Programming (Answer Set Programming)
%
% csp/4
% csp(X,Pr,Dom, R)
% X e o variabila neinstantiata
% Pr este o constrangere asupra variabilei X
% Dom este un domeniu de valori pentru X
% R va fi legat la acele valori din Dom care satisfac Pr

% csp([X,Y] (X+Y>0, X-Y<4), [[0,1,2,3,4,5,6,7], [2,3,4]],  R).
%     ^      |
%     |      |
%      ------
%        X
%                                               R = [[4,3,...], ]

% csp(X, (X>0, X<4), [0,1,2,3,4,5,6,7,8,9], R).

%csp(_,_,[],[]).
%csp(X, Pr, [H|T], [H|R]) :- X = H, Pr, csp(X,Pr,T,R), !.
%csp(X, Pr, [_|T], R) :- csp(X,Pr,T,R).



% putem verifica conditia Pr, fara ca X sa ramana legata?

% not(G) :- G, !, fail.
% not(_).  
% daca not(G) e satisfacut, NICI O VARIABILA (posibila) din G nu ramane legata.
% not((X = 2, X>0,X<4))

csp(_,_,[],[]).
csp(X, Pr, [H|T], R) :- not((X = H, Pr)), csp(X,Pr,T,R), !.     % complement conditie
csp(X, Pr, [H|T], [H|R]) :- csp(X,Pr,T,R).                          % conditie (nu mai este explicitat datorita !)

/*                                       ^
                                         in acel punct, variabila X ramane libera
*/




