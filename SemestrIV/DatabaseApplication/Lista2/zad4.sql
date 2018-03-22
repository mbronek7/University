drop procedure if exists SumaDni;

drop type if exists CzytelnicyTableType;

CREATE TYPE CzytelnicyTableType AS TABLE   
( 
 Czytelnik_ID int
 );
GO 

 CREATE PROCEDURE SumaDni
    @Czytelnicy CzytelnicyTableType READONLY 
    AS   
    BEGIN
    SELECT ct.Czytelnik_ID AS ID,Sum(Wypozyczenie.Liczba_Dni) AS SumaDni
    FROM Wypozyczenie
    INNER JOIN @Czytelnicy ct ON Wypozyczenie.Czytelnik_ID = ct.Czytelnik_ID 
    GROUP BY ct.Czytelnik_ID
    END
GO

DECLARE @Czytelnicy AS CzytelnicyTableType;

INSERT INTO @Czytelnicy SELECT Czytelnik_ID FROM Czytelnik;

EXEC SumaDni @Czytelnicy; 
