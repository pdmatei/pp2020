/*
    Prolog
      - clauze (atomi, termeni, predicate)
      - atom (predicat de aritate zero)
      "string"
      'X' - un atom
       x - un atom
      - termen: predicat(q(z,w), a) - e1, e2 sunt termeni la randul lor

    Unificare
    Arbori de "demonstrare" -> descriu o executie (interogam un scop) a unui program prolog      


    Predicate "generative" -> cele mai simple "design patterns" sau stiluri de programare logica.
    Algoritmi nedeterministi - k_clica(k,G)
              sunt generativi

*/

% Preliminarii
% o reprezentare pentru liste.
% L = cons(H,T) unde H e o valoare si T este o lista.   L = [H|T]
% L = void.                                             L = []

isList(cons(_,T)) :- isList(T).
isList(void).

% head/2  head(L,H). L este input, H este output.
head(cons(H,_),H).
tail(cons(_,T),T).

% size/2
size(void,0).
size(cons(_,T),R) :- size(T,Rp), R is Rp + 1.

%greseli posibile
% size(cons(H,T),R) :- R is Rp + 1, size(T,Rp).
% size1(cons(H,T),succ(N))

% app/3 concatenarea a doua liste app(L1,L2,R)
app(void,L,L).
app(cons(H,T),L, cons(H,Rp)) :- app(T,L,Rp).
/*
                               Rp = cons(1,cons(2,void))
                               R = cons(?, cons(1,cons(2,void)))

app(cons(H,T),L, R) :- R = cons(H,Rp), app(T,L,Rp).
                       R = cons(?, Rp),
                                        Rp = cons(1,cons(2,void))
                                        R = cons(?, cons(1,cons(2,void)))
                                        */
% take/3 take(L,N,R) L e o lista, N e un numar, R o lista ce contine primele N numere din L
take1(_,0,void).
take1(cons(H,T), N, cons(H,Rp)) :- N > 0, Np is N-1, take1(T,Np,Rp).

% o strategie IMPERATIVA de a scrie un program.

% o strategie DECLARATIVA de a scrie programe. 
  % ce ESTE o solutie, nu
  % cum calculam (sau cum ajungem la) o solutie.

% ce este o solutie R (calculata de predicul take)?
% L = R ++ U unde R are dimensiune N, si U este o lista oarecare.
take2(L,N,R) :- size(R,N), app(R,_,L).

% observatii:
/* apelul ?- size(L,2) produce

size(void,0).
size(cons(_,T),R) :- size(T,Rp), R is Rp + 1.
      L = cons(_,T)
      apoi incercam sa satisfacem
        size(T,Rp)
           - T = void, Rp = 0 (esueaza)
        size(T,Rp)
           - T = cons(_,Tp), Rp neinstantiata
               size(Tp,Rpp)
                  - Tp = void, Rpp = 0 (are succes)
                  - Tp = cons(_,Tpp) 
                     ... ...
      2 is 1 + 1.

MORALA:
  - in Prolog putem avea scopuri definite in care unele variabile pot fi folosite si
    ca input si ca output.

*/
size1(void,zero).
size1(cons(_,T),succ(N)) :- size1(T,N).

take3(L,N,R) :- size1(R,N), app(R,_,L).

%prefix/2 va genera toate prefixele unei liste L. prefix(L,P). P este un prefix al listei L.
prefix(L,P) :- app(_,P,L).

% app (concatenarea) este un caz special in care putem scrie o implementare 
% care sa functioneze dupa mai multe strategii de input/output.

%mem/2 (member) un element apartine unei liste
% var. IMPERATIVA
mem(cons(H,_),H).
mem(cons(E,T),H) :- E \= H, mem(T,H). 

% mem functioneza cand lista e cunoscuta.

% var. generativa
mem1(cons(H,_),H).
mem1(cons(_,T),H) :- mem1(T,H).

%twodistinct/1. twodistinct(L) e satisfacut daca L contine doua elemente diferite!.
twodistinct(L) :- mem1(L,A), mem1(L,B), A \= B.

%sublist/2 - genereaza toate sub-listele unei liste.
%   L = X ++ S ++ Y
%sublist(L,S) :- app(_,S,R1), app(R1,_,L).
/*
                S nu e inst.
                R1 nu e inst.
                             R1 inst la o lista arbitrara.
                             L este instantiata.
*/
sublist(_,void).
sublist(L,cons(H,T)) :- app(R1,_,L), app(_,cons(H,T),R1).




