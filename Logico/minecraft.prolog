%Base de Conocimiento
% jugador(nombre,lista_items, hambre)
jugador(stuart, [piedra,piedra,piedra,piedra,piedra,piedra,piedra,piedra], 3).
jugador(tim, [madera,madera,madera,madera,madera,pan,carbon,carbon,carbon,pollo,pollo],8).
jugador(steve,[madera,carbon,carbon,diamante,panceta,panceta,panceta],2).
% lugar(nombre,lista_jugadores, oscuridad)
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque,[],6).
% items comestibles
comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

% 1. tieneItem/2
tieneItem(Jugador,Item):-
  jugador(Jugador,ListaItem,_), member(Item, ListaItem).

% 2. sePreocupaPorSuSalud/1
sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,ListaItem,_),
    comestible(Alimento),
    comestible(Alimento1),
    member(Alimento1,ListaItem),
    member(Alimento,ListaItem),
    Alimento \= Alimento1 .

% 3. cantidadDeItem/3
cantidadDeItem(Jugador,Item1,Cantidad):-
    jugador(Jugador,ListaItem,_),
    member(Item1,ListaItem),
    findall(Item2,member(Item2,ListaItem), R),
    findall(Long,length(R,Long),L),
    sumlist(L,Cantidad).

% 4. itemPopular/1
itemPopular(Item) :-
    jugador(_, L1, _),
    member(Item, L1),
    forall(jugador(_, L2, _), member(Item, L2)).

% 5. itemExclusivo/1

% 2)
% a. hayMonstruos/1
hayMonstruos(Lugar):-
    lugar(Lugar,_,Oscuridad),
    Oscuridad > 6.
% b. correPeligro/1

estaHambriento(Jugador):-
    jugador(Jugador,_,Hambre),
    Hambre < 4.

noMorfi(Jugador):-
    jugador(Jugador,ListaItems,_),
    forall(comestible(Alimento),not(member(Alimento,ListaItems))).

correPeligro(Jugador):-
    jugador(Jugador,_,Lugar),
    hayMonstruos(Lugar).
correPeligro(Jugador):-
    jugador(Jugador,_,_),
    noMorfi(Jugador),
    estaHambriento(Jugador).


% nivelPeligrosidad/2
poblacionLugar(Lugar,Poblacion):-
    lugar(Lugar,Habitantes,_),
    length(Habitantes,Poblacion).

cantidadHambrientos(Lugar,Cantidad):-
    lugar(Lugar,Hab,_),
    jugador(Jugador,_,_),
    findall(Jugador,member(Jugador,Hab),R),
    findall(Jugador,estaHambriento(Jugador),L),
    member(Jugador,R),
    length(L,Cantidad).

porcentajeHambrientos(Lugar,Porcentaje):-
    cantidadHambrientos(Lugar,Cantidad),
    poblacionLugar(Lugar,Poblacion),
    Porcentaje is Cantidad/Poblacion.

nivelPeligrosidad(Lugar,Nivel):-
    not(hayMonstruos(Lugar)),
    porcentajeHambrientos(Lugar,Porcentaje),
    poblacionLugar(Lugar,Poblacion),
    Nivel is Porcentaje/Poblacion.

nivelPeligrosidad(Lugar,Nivel):-
    hayMonstruos(Lugar),
    Nivel is 100.

nivelPeligrosidad(Lugar,Nivel):-
    lugar(Lugar,Hab,Pel),
    Hab = [],
    Nivel is Pel * 10.
