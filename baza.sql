SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `amarena` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `amarena`;

CREATE TABLE `liczby` (
  `liczba` int(11) NOT NULL,
  `nazwa` tinytext CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `liczby` (`liczba`, `nazwa`) VALUES
(1, 'jeden'),
(2, 'dwa'),
(3, 'trzy'),
(4, 'cztery'),
(5, 'pięć'),
(6, 'sześć'),
(7, 'siedem'),
(8, 'osiem'),
(9, 'dziewięć'),
(10, 'dziesięć'),
(11, 'jedenaście'),
(12, 'dwanaście'),
(13, 'trzynaście');

CREATE TABLE `odpowiedz` (
  `id_pytania` int(11) NOT NULL,
  `timestamp_odpowiedzi` timestamp NOT NULL DEFAULT current_timestamp(),
  `odpowiedz` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `odpowiedz` (`id_pytania`, `timestamp_odpowiedzi`, `odpowiedz`) VALUES
(1, '2022-03-16 13:36:04', 'Jeszcze jak!');

CREATE TABLE `pytanie` (
  `id_pytania` int(11) NOT NULL,
  `kto` int(11) NOT NULL,
  `komu` int(11) NOT NULL,
  `pytanie` text CHARACTER SET utf8 NOT NULL,
  `timestamp_pytania` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `pytanie` (`id_pytania`, `kto`, `komu`, `pytanie`, `timestamp_pytania`) VALUES
(1, 3, 1, 'Co?', '2022-03-16 13:35:03'),
(2, 2, 1, 'Jak skutecznie jabłko?', '2022-03-16 13:35:31');

CREATE TABLE `smietnik` (
  `liczba` int(11) NOT NULL,
  `tekst` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `uzyszkodnik` (
  `id_uzyszkodnika` int(11) NOT NULL,
  `login` varchar(64) NOT NULL,
  `hasz` tinytext NOT NULL,
  `mail` tinytext NOT NULL,
  `widocznosc` enum('publiczny','zalogowany','prywatny') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `uzyszkodnik` (`id_uzyszkodnika`, `login`, `hasz`, `mail`, `widocznosc`) VALUES
(1, 'damjes', 'aaa', 'damjes@damj.es', 'publiczny'),
(2, 'ziomek', 'ccc', 'zio@m.ek', 'zalogowany'),
(3, 'skryta', 'bbb', 'skryta@dev.null', 'prywatny');

CREATE TABLE `wisienka` (
  `kto` int(11) NOT NULL,
  `komu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `wisienka` (`kto`, `komu`) VALUES
(1, 2),
(1, 3),
(2, 3),
(3, 1);


ALTER TABLE `liczby`
  ADD PRIMARY KEY (`liczba`);

ALTER TABLE `odpowiedz`
  ADD PRIMARY KEY (`id_pytania`);

ALTER TABLE `pytanie`
  ADD PRIMARY KEY (`id_pytania`),
  ADD KEY `kto` (`kto`),
  ADD KEY `komu` (`komu`);

ALTER TABLE `smietnik`
  ADD PRIMARY KEY (`liczba`);

ALTER TABLE `uzyszkodnik`
  ADD PRIMARY KEY (`id_uzyszkodnika`),
  ADD UNIQUE KEY `login` (`login`),
  ADD UNIQUE KEY `mail` (`mail`) USING HASH;

ALTER TABLE `wisienka`
  ADD PRIMARY KEY (`kto`,`komu`),
  ADD KEY `komu` (`komu`);


ALTER TABLE `pytanie`
  MODIFY `id_pytania` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

ALTER TABLE `smietnik`
  MODIFY `liczba` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2138;

ALTER TABLE `uzyszkodnik`
  MODIFY `id_uzyszkodnika` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;


ALTER TABLE `odpowiedz`
  ADD CONSTRAINT `odpowiedz_ibfk_1` FOREIGN KEY (`id_pytania`) REFERENCES `pytanie` (`id_pytania`);

ALTER TABLE `pytanie`
  ADD CONSTRAINT `pytanie_ibfk_1` FOREIGN KEY (`kto`) REFERENCES `uzyszkodnik` (`id_uzyszkodnika`),
  ADD CONSTRAINT `pytanie_ibfk_2` FOREIGN KEY (`komu`) REFERENCES `uzyszkodnik` (`id_uzyszkodnika`);

ALTER TABLE `wisienka`
  ADD CONSTRAINT `wisienka_ibfk_1` FOREIGN KEY (`kto`) REFERENCES `uzyszkodnik` (`id_uzyszkodnika`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `wisienka_ibfk_2` FOREIGN KEY (`komu`) REFERENCES `uzyszkodnik` (`id_uzyszkodnika`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
