CREATE OR ALTER PROCEDURE CreateUser
	@pesel char(11),
	@nazwisko varchar(30),
	@miasto_urodzenia varchar(30),
	@data_urodzenia date
AS
	IF ISNUMERIC(@pesel) <> 1 OR LEN(@pesel) <> 11
		THROW 50001, 'Błędny pesel', 1;
	IF LEN(@nazwisko) <= 2
		THROW 50002, 'Za krotkie nazwisko', 1;
	IF LEFT(@nazwisko, 1) = LOWER(LEFT(@nazwisko, 1)) COLLATE Latin1_General_CS_AS
		THROW 50003, 'Nazwisko musi być pisane wielką literą', 1;
	IF LEFT(@pesel, 6) <> CONVERT(char(6), @data_urodzenia, 12)
		THROW 50004, 'PESEL jest niezgodny z datą urodzenia', 1;
	INSERT INTO Czytelnik (PESEL, Nazwisko, Miasto, Data_Urodzenia) VALUES
	(@pesel, @nazwisko, @miasto_urodzenia, @data_urodzenia);
GO

DELETE FROM Czytelnik WHERE Nazwisko = 'Bronikowski'
GO

EXEC CreateUser '97022801235', 'bronikowskii', 'Suwalki', '1997-02-28'
GO

SELECT * FROM Czytelnik
GO
