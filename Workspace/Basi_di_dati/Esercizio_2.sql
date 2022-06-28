drop table if EXISTS Esami;
CREATE TABLE Esami (
  Matricola INTEGER PRIMARY KEY,
  Voto INTEGER,
  Crediti INTEGER );
ALTER TABLE Esami Add CONSTRAINT vincolo_cerditi 
CHECK ((Voto >= 18 and Crediti > 0) OR (Voto <= 18 and Crediti < 0));