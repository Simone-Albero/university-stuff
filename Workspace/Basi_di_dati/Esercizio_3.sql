CREATE TABLE Tratte (
  Codice INTEGER PRIMARY KEY,
  Isola TEXT,
  Durata INTEGER,
  Prezzo INTEGER );


CREATE TABLE Partenze (
   Tratta INTEGER,
   FOREIGN KEY (Tratta) REFERENCES Tratte (Codice),
   Codice_Partenza Integer,
   PRIMARY KEY (Tratta,Codice_partenza),
   Orario INTEGER,
   Battello TEXT );

INSERT into Tratte VALUES(1, "Isola Lunga", 2, 10);
INSERT into Tratte VALUES(2, "Isola Grande", 3, 15);
INSERT into Tratte VALUES(3, "Isola Remota", 4, NULL);

INSERT into Partenze VALUES(1, 1, 10, "Venere");
INSERT into Partenze VALUES(1, 2, 10, "Proserpina");
INSERT into Partenze VALUES(1, 3, 19, "Proserpina");
INSERT into Partenze VALUES(2, 1, 13, "Venere");
  
