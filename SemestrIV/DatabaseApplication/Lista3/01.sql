USE List3DB;
GO

DROP TABLE IF EXISTS Ceny;
GO

DROP TABLE IF EXISTS Towary;
GO

DROP TABLE IF EXISTS Kursy;
GO

CREATE TABLE Towary(
	ID INT IDENTITY PRIMARY KEY,
	NazwaTowaru VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Kursy(
	Waluta CHAR(3) NOT NULL PRIMARY KEY,
	CenaPLN DECIMAL(10, 2)
);
GO

CREATE TABLE Ceny(
	TowarID INT FOREIGN KEY REFERENCES Towary(ID),
	Waluta CHAR(3) FOREIGN KEY REFERENCES Kursy(Waluta),
	Cena DECIMAL(10, 2)
);
GO

INSERT INTO Towary (NazwaTowaru) VALUES
	('gazeta'),
	('czapka'),
	('szynka'),
	('grzejnik'),
	('telefon'),
	('skarpety');
GO

INSERT INTO Kursy VALUES
	('PLN', 1.00),
	('JEN', 33.65),
	('USD', 3.31);
GO

INSERT INTO Ceny VALUES
	(1, 'PLN', 3.50),
	(2, 'PLN', 30.00),
	(3, 'PLN', 3.80),
	(4, 'PLN', 150.99),
	(5, 'PLN', 600.00),
	(6, 'PLN', 9.99),
	(1, 'JEN', 0.70),
	(2, 'USD', 3.00),
	(3, 'USD', 2.00),
	(4, 'JEN', 0.99),
	(6, 'USD', 1.50);
GO

CREATE OR ALTER PROCEDURE aktualne_ceny AS
SELECT * FROM Ceny ORDER BY TowarID ASC;
GO

EXEC aktualne_ceny;
GO

DECLARE j CURSOR FOR SELECT * FROM Ceny;

OPEN j;

	DECLARE @Towary_ID INT, @Waluta CHAR(3), @Cena DECIMAL(10, 2);

	FETCH NEXT FROM j INTO @Towary_ID, @Waluta, @Cena;
	WHILE (@@FETCH_STATUS=0)
	BEGIN
		IF (@Waluta NOT IN (SELECT Waluta FROM Kursy))
		BEGIN
			DELETE FROM Ceny WHERE CURRENT OF j;
			FETCH NEXT FROM j INTO @Towary_ID, @Waluta, @Cena;
			CONTINUE;
		END

		UPDATE Ceny SET Cena=
			(SELECT Cena FROM Ceny WHERE TowarID=@Towary_ID AND Waluta='PLN') *
			(SELECT CenaPLN FROM Kursy WHERE Waluta=@Waluta)
		WHERE CURRENT OF j;

		FETCH NEXT FROM j INTO @Towary_ID, @Waluta, @Cena;
	END

CLOSE j;
DEALLOCATE j;
GO

EXEC aktualne_ceny;
GO