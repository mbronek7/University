USE List3DB;
GO

DROP TABLE IF EXISTS Bufor;
GO

DROP TABLE IF EXISTS Historia;
GO

DROP TABLE IF EXISTS Parametry;
GO

CREATE TABLE Bufor(
	ID INT IDENTITY PRIMARY KEY,
	AdresUrl VARCHAR(256) NOT NULL,
	OstatnieWejscie DATE NOT NULL
);
GO

CREATE TABLE Historia(
	ID INT IDENTITY PRIMARY KEY,
	AdresUrl VARCHAR(256) NOT NULL,
	OstatnieWejscie DATETIME2 NOT NULL
);
GO

CREATE TABLE Parametry(
	Nazwa VARCHAR(256) NOT NULL,
	Wartosc INT NOT NULL
);
GO

INSERT INTO Parametry VALUES
	('max_cache', 3);
GO

INSERT INTO Bufor (AdresUrl, OstatnieWejscie) VALUES
	('https://onet.pl', CURRENT_TIMESTAMP),
	('https://interia.pl', CURRENT_TIMESTAMP);
GO

IF OBJECT_ID ('insert_page', 'TR') IS NOT NULL
   DROP TRIGGER insert_page;
GO

CREATE TRIGGER insert_page
ON Bufor
INSTEAD OF INSERT
AS BEGIN
	IF (EXISTS (SELECT * FROM Bufor
			WHERE AdresUrl = (SELECT AdresUrl FROM inserted)))
		UPDATE Bufor
			SET OstatnieWejscie=(SELECT OstatnieWejscie FROM inserted)
			WHERE AdresUrl = (SELECT AdresUrl FROM inserted);
	ELSE
	BEGIN
		IF ((SELECT COUNT(*) FROM Bufor) <
				(SELECT Wartosc FROM Parametry WHERE Nazwa='max_cache'))
			INSERT INTO Bufor (AdresUrl, OstatnieWejscie)
				SELECT AdresUrl, OstatnieWejscie FROM inserted;
		ELSE
		BEGIN
			DECLARE @least_recently_visited TABLE(
				ID INT, AdresUrl VARCHAR(256), OstatnieWejscie DATETIME2);
			INSERT INTO @least_recently_visited
				SELECT TOP 1 * FROM Bufor ORDER BY OstatnieWejscie ASC;

			IF (EXISTS (SELECT * FROM Historia
					WHERE AdresUrl = (SELECT AdresUrl FROM @least_recently_visited)))
				UPDATE Historia
					SET OstatnieWejscie=(SELECT OstatnieWejscie FROM @least_recently_visited)
					WHERE AdresUrl = (SELECT AdresUrl FROM @least_recently_visited);
			ELSE
				INSERT INTO Historia (AdresUrl, OstatnieWejscie)
					SELECT AdresUrl, OstatnieWejscie FROM @least_recently_visited;

			DELETE FROM Bufor WHERE ID =
				(SELECT ID FROM @least_recently_visited);
			INSERT INTO Bufor (AdresUrl, OstatnieWejscie)
				SELECT AdresUrl, OstatnieWejscie FROM inserted;
		END
	END
END
GO

INSERT INTO Bufor (AdresUrl, OstatnieWejscie) VALUES
	('https://onet.pl', CURRENT_TIMESTAMP);
INSERT INTO Bufor (AdresUrl, OstatnieWejscie) VALUES
	('https://wp.pl', CURRENT_TIMESTAMP);
INSERT INTO Bufor (AdresUrl, OstatnieWejscie) VALUES
	('https://facebook.com', CURRENT_TIMESTAMP);
GO

SELECT * FROM Bufor;
SELECT * FROM Historia;
GO
	