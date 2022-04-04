:- use_module(apka/serwer/serwer).
:- use_module(apka/model/orm).

:- initialization(startuj).

startuj :-
	start_bazy,
	start_serwera,
	nl,
	writeln('Serwer uruchomiony'),
	writeln('^D lub halt. by go zatrzymać'),
	nl.
