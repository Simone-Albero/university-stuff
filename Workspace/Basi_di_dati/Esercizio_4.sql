DROP TABLE if EXISTS vette,itinerari;
CREATE TABLE Vette (
  Cima TEXT PRIMARY KEY,
  Altezza INTEGER );
  
CREATE TABLE Itinerari (
  Cima TEXT,
  FOREIGN KEY (Cima) REFERENCES Vette (Cima),
  Itinerario TEXT,
  PRIMARY KEY (Cima, Itinerario),
  Tempo INTEGER,
  Difficoltà TEXT );

INSERT INTO Vette VALUES ('Vetta Centrale', 3101);
INSERT INTO Vette VALUES ('Vetta Ovest', 3007);
INSERT INTO Vette VALUES ('Vetta Est', 3007);
INSERT INTO Vette VALUES ('Vetta Sud', 2999);

INSERT INTO Itinerari VALUES ('Vetta Ovest', 'via normale', 3, 'facile');
INSERT INTO Itinerari VALUES ('Vetta Ovest', 'via diretta', 2, 'difficile');
INSERT INTO Itinerari VALUES ('Vetta Est', 'canale nord', 2, 'difficile');
INSERT INTO Itinerari VALUES ('Vetta Est', 'via normale', 4, 'facile');
INSERT INTO Itinerari VALUES ('Vetta Sud', 'via normale', 3, 'poco difficile');