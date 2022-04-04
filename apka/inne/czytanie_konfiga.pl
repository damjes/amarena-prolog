:- module(czytanie_konfiga, [sekcja_konfiga/2]).

:- [konfig/konfig].

 sekcja_konfiga(Sekcja, Lista) :-
	findall([Nazwa, Wartosc], konfig(Sekcja, Nazwa, Wartosc), ListaList),
	maplist('=..', Lista, ListaList).
