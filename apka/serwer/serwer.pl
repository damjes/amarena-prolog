:- module(serwer, [start_serwera/0]).

:- use_module(library(arouter)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).

:- use_module(apka/inne/czytanie_konfiga).
:- use_module(apka/kontroler/odczyt).

start_serwera :-
	sekcja_konfiga(http, ListaKonfig),
	http_server(zadanie_http, ListaKonfig).

zadanie_http(Zadanie) :-
	route(Zadanie), !.
zadanie_http(Zadanie) :-
	http_dispatch(Zadanie), !.
zadanie_http(_) :-
	fail. % TODO: dorobić stronę błędu 500

:- route_get('/', pokaz_profil).

:- http_handler('/statyczne/', http_reply_from_files(statyczne, []), [prefix]).
