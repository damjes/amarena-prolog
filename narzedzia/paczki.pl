paczka(simple_template).

instaluj(Opcje) :-
	paczka(X),
	pack_install(X, Opcje),
	fail.
instaluj(_).

instaluj :-
	instaluj([interactive(false)]).