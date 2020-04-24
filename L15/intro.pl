student(tim).
student(bob).
student(john).
student(mary).

male(tim).
male(bob).
male(john).

female(mary).

lecture(pp).
lecture(aa).

studies(tim,aa).
studies(mary,pp).
studies(mary,aa).
studies(john,pp).


% "male student with at least one female colleague, in some lecture".
% male(X), studies(X,L), studies(Y,L), female(Y).


% predicate: student, male, female, etc. aritate.
% student/1, studies/2
% atomi: tim, bob, john, etc.

% "filozofia de modelare: CLOSED-WORLD ASSUMPTION".

% female(X) , studies(X,aa).
% female(X) ^ studies(X,aa)


% "lecture with at least two students."
% goal (scop), query.

% studies(A,X), studies(B,X).
% lecture(L), studies(A,L), studies(B,L), X \= Y.
% studies(A,L), studies(B,L), lecture(L)

%%%%% 
%% Rules / horn clauses
%%%%%

%            head    <=  body.
%twoStudentLecture(L) :- lecture(L), studies(X,L), studies(Y,L), X \= Y.


% p1(...), p2(...), ... pn(...) => p(...).
% body => head.
% lecture(L) ^ studies(X,L) ^ studies(Y,L) ^ X \= Y  => twoStudentLecture(L).

% studies(tim,aa).
% true => studies(tim,aa).

/*
studies(tim,aa) :- true.
studies(X,Y) :- X = tim, Y = aa.

studies(tim,aa).
*/
withFemaleColleague(X) :- male(X), studies(X,L), studies(Y,L), female(Y).


twoStudentLecture(lfa). %cunostinta factuala
twoStudentLecture(L) :- lecture(L), studies(X,L), studies(Y,L), X \= Y.
%twoStudentLecture(L) :- lecture(L), studies(X,L), withFemaleColleague(X).

%%%%% 
%% Numere in PROLOG
%%%%%

% Codificare (cum arata numerele)
%
% zero - atomul "zero" reprezinta 0
% succ/1 - un predicat de aritate 1
% succ(succ(succ(zero))). - reprezentarea lui 3.
% 
% un predicat poate inrola TERMENI (nu doar ATOMI).
% succ(zero) - NU ESTE UN APEL DE FUNCTIE, NU INTOARCE. DOAR O REPREZENTARE.

% nat/1 - ce este un numar natural.
nat(zero).
nat(X) :- X = succ(Y), nat(Y).

% succ(succ(zero)) este numar
% succ(matei) nu este un numar

% OBIECTIVE
% isZero/1 - este un numar egal cu zero 
% add      - adunarea a doua numere naturale
% add/?

% add(X,Y,Res) - relatie peste TREI NUMERE. X + Y = Res.
%               predicatele (din PROLOG) definesc "adevaruri".
%               programatorul scrie programe care iau un INPUT si intorc un OUTPUT.
%               Input ---> OUTPUT
%               R(Input,Output) - "programul" R asociaza unui Input un Output
%               X,Y joaca rol de "input", pe cand Res joaca rol de output
%               daca X si Y sunt legate la valori (nat), atunci satisfacand predicatul add
%               Res va fi legat la suma celor doua.
%               add(X,Y,Res).

add(zero,Y,Y).
add(succ(X),Y,succ(Res)) :- add(X,Y,Res). 


% toNat/2 (convertim numere din Prolog in numerele noastre)
toNat(0,zero).
toNat(X,succ(Res)) :- X>0, Xp is X-1, toNat(Xp,Res). 


% toNat(0,R).  R = zero.
% toNat(0,succ(Res)) :- Xp = -1, toNat(-1,Res),    

% fromNat
fromNat(zero,0).
fromNat(succ(X),R) :- fromNat(X,Rp), R is Rp + 1. 

% add(X,Y,R), toNat(4,X), toNat(3,Y), fromNat(R,O).
% nu am construit valorile X si Y inainte de a face adunarea
% toNat(4,X), toNat(3,Y), add(X,Y,R), fromNat(R,O).


% add(X,Y,R), toNat(0,X), toNat(1,Y).
/*


*/


