:- module(kontroler_odczyt, [
	pokaz_profil/0]).

:- use_module(library(http/http_pwp)).
:- use_module(library(http/http_wrapper)).

:- use_module(apka/model/orm).

:- dynamic dane_pwp/2.
:- volatile dane_pwp/2.
:- thread_local dane_pwp/2.

pokaz_profil :-
	http_current_request(Zadanie),
	assert(dane_pwp(test, aaa)),
	reply_pwp_page('szablony/pwp/profil_uz.xml', [mime_type('text/xml')], Zadanie),
	retractall(dane_pwp(_, _)).

