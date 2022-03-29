%:- module(orm, [
	%szukaj/3,
	%utworz/0,
	%aktualizuj/0,
	%usun/0,
	%usun_wiele/0
	%]).

:- use_module(library(st/st_render)).
:- use_module(library(odbc)).

:- dynamic szablon_orma/3.
:- volatile szablon_orma/3.

%tymczasowo
:- odbc_connect(amarena, db, [alias(db), user(root)]).

kolumna_typ(X, kolumna{nazwa: X, typ: default}) :-
	X \= _-_.
kolumna_typ(X-Y, kolumna{nazwa: X, typ: Y}).

dziel_parametry([], [], [], [], []).
dziel_parametry([Kolumna=Wartosc | Opcje],
		[KolumnaTyp | Kolumny],
		[Wartosc | Wartosci],
		Sortuj,
		Okno) :-
	kolumna_typ(Kolumna, KolumnaTyp),
	dziel_parametry(Opcje, Kolumny, Wartosci, Sortuj, Okno).
dziel_parametry([asc(Kolumna) | Opcje],
		Kolumny,
		Wartosci,
		[sortuj{nazwa: Kolumna, kierunek: 'ASC'} | Sortuj],
		Okno) :-
	dziel_parametry(Opcje, Kolumny, Wartosci, Sortuj, Okno).
dziel_parametry([desc(Kolumna) | Opcje],
		Kolumny,
		Wartosci,
		[sortuj{nazwa: Kolumna, kierunek: 'DESC'} | Sortuj],
		Okno) :-
	dziel_parametry(Opcje, Kolumny, Wartosci, Sortuj, Okno).
dziel_parametry([okno(Pomin, Ile) | Opcje],
		Kolumny,
		Wartosci,
		Sortuj,
		[Pomin, Ile]) :-
	dziel_parametry(Opcje, Kolumny, Wartosci, Sortuj, []).

stan_okna([_, _], okno).
stan_okna([], []).

dodaj_niepuste(_:[], Dict, Dict).
dodaj_niepuste(A:B, Dict, Dict.put(A, B)) :- B \= [].

podziel_opcje(Tabela, Opcje, SlownikOpcji, Parametry) :-
	dziel_parametry(Opcje, Kolumny, Wartosci, Sortuj, Okno),
	stan_okna(Okno, StanOkna),
	append(Wartosci, Okno, Parametry),
	SlownikOpcji  = orm{tabela: Tabela}
.dodaj_niepuste(warunki: Kolumny)
.dodaj_niepuste(sortuj: Sortuj)
.dodaj_niepuste(okno: StanOkna).

dopisz_okno(okno, [integer, integer]).
dopisz_okno([], []).

ustal_typ(Kolumna, Kolumna.get(typ, default)).

przygotuj_parametry(select, SlownikOpcji, ParametryZOknem) :-
	maplist(get_dict(typ), SlownikOpcji.get(warunki, []), Parametry),
	append(Parametry, ParametryOkna, ParametryZOknem),
	dopisz_okno(SlownikOpcji.get(okno, []), ParametryOkna).
przygotuj_parametry(insert, SlownikOpcji, Parametry) :-
	maplist(ustal_typ, SlownikOpcji.get(kolumny, []), Parametry).

daj_szablon(Nazwa, SlownikOpcji, Szablon) :-
	szablon_orma(Nazwa, SlownikOpcji, Szablon), !.
daj_szablon(Nazwa, SlownikOpcji, Szablon) :-
	with_output_to(string(Zapytanie), (
		current_output(Out),
		st_render_file(szablony/sql/Nazwa, SlownikOpcji, Out, [
			extension(tmpl),
			strip(true),
			undefined(false)]))),
	% writeln('DEBUG: pokaż zapytanie:'),
	% writeln(Zapytanie),
	przygotuj_parametry(Nazwa, SlownikOpcji, Parametry),
	odbc_prepare(db, Zapytanie, Parametry, Szablon, [source(true)]),
	assert(szablon_orma(Nazwa, SlownikOpcji, Szablon)).

przeksztalc_wynik(column(_Tabela, Kolumna, Wartosc), Kolumna-Wartosc).

zrob_slownik(Tabela, Wiersz, Slownik) :-
	Wiersz =.. [_ | Kolumny],
	maplist(przeksztalc_wynik, Kolumny, Pary),
	dict_pairs(Slownik, Tabela, Pary).

szukaj(Tabela, Opcje, Slownik) :-
	podziel_opcje(Tabela, Opcje, SlownikOpcji, WartosciParametrow),
	daj_szablon(select, SlownikOpcji, Szablon),
	odbc_execute(Szablon, WartosciParametrow, Wiersz),
	zrob_slownik(Tabela, Wiersz, Slownik).

wyciagnij_dane(Nazwa-WartoscTyp, SlownikKolumny, Wartosc) :-
	kolumna_typ(WartoscTyp, SlownikWartosci), % dla X-Y zwraca nazwa: X, typ: Y
	SlownikKolumny = _{nazwa: Nazwa, typ: SlownikWartosci.typ},
	Wartosc = SlownikWartosci.nazwa.

obrob_kolumny(Slownik, Tabela, Kolumny, Wartosci) :-
	dict_pairs(Slownik, Tabela, Pary),
	maplist(wyciagnij_dane, Pary, Kolumny, Wartosci).

utworz(Slownik) :-
	obrob_kolumny(Slownik, Tabela, Kolumny, Wartosci),
	daj_szablon(insert, _{tabela: Tabela, kolumny: Kolumny}, Szablon),
	odbc_execute(Szablon, Wartosci, _).
