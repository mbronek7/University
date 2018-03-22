DROP PROCEDURE IF exists Przetrzymuja
GO
CREATE PROCEDURE [Przetrzymuja] @dni int
AS
BEGIN
SELECT Czytelnik.PESEL,COUNT(Wypozyczenie.Egzemplarz_ID)
FROM Wypozyczenie
INNER JOIN Czytelnik ON Wypozyczenie.Czytelnik_ID = Czytelnik.Czytelnik_ID 
WHERE DATEDIFF(day, Wypozyczenie.Data, GETDATE()) >= @dni
GROUP BY Czytelnik.PESEL
END
GO
EXEC Przetrzymuja 1
