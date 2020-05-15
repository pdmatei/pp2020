/*

    ! (cut), not (negatia)


Semantica pt !(cut) ce face el.
   - ! este un scop special in Prolog
   - cand este scopul "!" satisfacut?
       a)- scopul ! este intotdeauna satisfacut atunci cand este intalnit prima oara.
       b)- scopul ! intotdeauna esueaza atunci cand este resatisfacut.

   Exemplu de clauza:

   q(X,Y) :- p(X), !, r(Y).

*/
student(tim).
student(bob).
student(john).
student(mary).

male(john).
male(tim).
male(bob).

female(mary).

lecture(pp).
lecture(aa).

studies(tim,aa).
studies(mary,pp).
studies(mary,aa).
studies(john,pp).
studies(john,aa).

%withFemaleColleague(bob).
withFemaleColleague(X) :- male(X), !, studies(X,L), studies(Y,L), female(Y).

/*
  Cut pentru implementarea negatiei.
*/

/*
not(X > 1)
not(male(X))
not( (male(X), studies(X,aa)) )  % ~(male(X) ^ studies(X,aa))
not(male(X), studies(X,aa)) % not nu are aritate 2 !!
*/

% succ - folosite pt. reprezentare, nu ca scopuri
% ele ar putea fi folosite ca scopuri

% UN TERMEN POATE FI FOLOSIT CA UN SCOP


%not(G) :- G, fail.
%not(G).
% daca G este fals, implementarea se comporta corect. not(G) e satisfacut.
% daca G este adevarat: not(G) este DIN NOU satifacut (NU E CORECT)

not(G) :- G, !, fail.
not(_).

% G e satisfacut cel mult odata
% daca G esueaza, atunci not(G) e satisfacut folosind clauza a doua.


q(X,Y) :- c1(X), c2(Y), c3(X,Y), r(X).
q(X,Y) :- c1(X), c2(Y), c3(X,Y), p(Y).

q(X,Y) :- c1(X), c2(Y), c3(X,Y), (r(X); p(Y)).
%                                verifica r(X) SAU p(Y)


/*
    Drumuri prin grafuri

    Cum reprezentam un graf.
    G = [V,E]  - lista cu doua elemente
        V - o lista de noduri
        E - o lista muchii, unde o muchie e o lista [X,Y] reprezinta muchia neorientata (X,Y) si (Y,X)
    
% V = [1,2,3,4,5]
% E = [[1,5], [1,2], [1,3], [2,3], [3,4]]
% G = [ [1,2,3,4,5], [[1,5], [1,2], [1,3], [2,3], [3,4]]]


       1 ------ 5
      |  \
      |   \
      2 -- 3 -- 4 

*/
% graph/1
graph([ [1,2,3,4,5], [[1,5], [1,2], [1,3], [2,3], [3,4]]]).

%edge/3
edge(X,Y,[_,E]) :- member([X,Y],E).
edge(X,Y,[_,E]) :- member([Y,X],E).

%connected/3
%connected(X,Y,G) :- edge(X,Y,G).
%   X --muchie-- Z si  Z--cale--Y
%connected(X,Y,G) :- edge(X,Z,G), connected(Z,Y,G).

/*
1---->4
connected(1,4,G)
    edge(1,Z,G)
          Z = 5  (1,5)  5--->4
        connected(5,4,G)
            edge(5,Z',G)
                Z' = 1  (5,1)  1---->4
                   connected(1,4,G)  

*/

%connected/4
%connected(X,Y,G,Path) :- not(member(Y,Path)), edge(X,Y,G).
%connected(X,Y,G,Path) :- edge(X,Z,G), not(member(Z,Path)), connected(Z,Y,G,[Z|Path]).


%connected/5
% Path reprezinta calea curenta (var neinstantiata)
% Visited nodurile vizitate (var instantiata)
connected(X,Y,G,[X,Y],Visited) :- not(member(Y,Visited)), edge(X,Y,G).
connected(X,Y,G,[X|Path],Visited) :- edge(X,Z,G), not(member(Z,Visited)),
                                     connected(Z,Y,G,Path,[Z|Visited]).
% connected(1,4,G,P,[1])
/*
    P = [1|P'], Visited = [1]
    P' = [2|P''], Visited = [1,2]
    P'' = [3|P'''], Visited = [1,2,3]

*/ 


/*
X...Z ... Y
     Path
X | Path
*/

