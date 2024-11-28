Amarena
=======

Aplikacja Amarena ma być przykładem na możliwości Prologa jako narzędzia
do (głównie backendowego) webdevu. Ma to być aplikacja wykorzystująca nietypowe
mechanizmy, takie jak:
- samodzielnie naklepane mapowanie RDBMS-Prolog (z generatorem SQLa opartym
  o simple_template, żeby pokazać różnorodność)
- generowanie CSSa za pomocą gramatyk DCG
- backendowo generowany XML za pomocą PWP
- strony w XMLu konwertowane frontendowo do HTMLa za pomocą XSLT
- wykorzystanie Prologa jako bazy danych do pliku konfiguracyjnego

Uruchomienie
===========

1. Zainstalować [SWI-Prolog](http://www.swi-prolog.org/). Wsparcie Prologa
   dla ODBC jest wymagane.
2. Skonfigurować źródło ODBC DSN o nazwie `amarena`.
3. Przygotować plik konfiguracyjny `konfig/konfig.pl` na podstawie `konfig/konfig-szablon.pl`.
4. Zainstalować brakujące dodatki do Prologa:
   ```bash
   $ swipl -s narzedzia/paczki.pl -t instaluj
   ```
5. Wystartować serwer:
   ```bash
   $ swipl -s amarena.pl
   ```
