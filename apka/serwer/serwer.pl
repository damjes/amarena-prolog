:- module(serwer, [start_serwera/0]).

:- use_module(library(arouter)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).

:- [konfig/konfig].

start_serwera :-
	findall([Nazwa, Wartosc], konfig(http, Nazwa, Wartosc), ListaListKonfig),
	maplist('=..', ListaKonfig, ListaListKonfig),
	writeln(ListaKonfig),
	http_server(zadanie_http, ListaKonfig).

zadanie_http(Zadanie) :-
	route(Zadanie), !.
zadanie_http(Zadanie) :-
	http_dispatch(Zadanie), !.
zadanie_http(_) :-
	fail. % TODO: dorobić stronę błędu 500

:- http_handler('/statyczne/', http_reply_file(statyczne, []), [prefix]).
