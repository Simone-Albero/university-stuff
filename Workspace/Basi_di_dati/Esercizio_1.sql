DROP TABLE IF EXISTS Retribuzioni;
CREATE TABLE Retribuzioni (
  Numero INTEGER PRIMARY KEY,
  Lordo INTEGER,
  Imposte INTEGER,
  Netto INTEGER,
  Verifica BOOLEAN );
ALTER TABLE Retribuzioni add CONSTRAINT Vincolo_lordo
CHECK ( ( ( Netto = Lordo - Imposte) AND (Verifica = true)) OR ((Netto <> Lordo - Imposte) AND (Verifica = false ) ) );

INSERT INTO Retribuzioni VALUES (1,3000,800,2200,true);
INSERT INTO Retribuzioni VALUES (2,4000,1000,3000,true);
INSERT INTO Retribuzioni VALUES (3,3000,1000,2200,false);