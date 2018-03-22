drop PROCEDURE  if exists ilosc
go
CREATE PROCEDURE Ilosc
 @tytul VARCHAR(255) = NULL,
 @autor VARCHAR(255) = NULL,
 @rok  INT = NULL
AS
BEGIN
  DECLARE @sql nvarchar(1000)
  SET @sql = 'SELECT Ksiazka.ksiazka_ID,COUNT(Egzemplarz.Ksiazka_ID) AS Ilosc FROM Egzemplarz
      INNER JOIN Ksiazka ON KSiazka.Ksiazka_ID = Egzemplarz.Ksiazka_ID WHERE Ksiazka.Rok_Wydania > 1900'
      +convert(varchar, case when isnull(@autor,'')!='' then 'AND Ksiazka.Autor = ''' + @autor + '''' else '' end)
      +convert(varchar, case when isnull(@tytul,'')!='' then 'AND Ksiazka.Tytul = ''' + @tytul + '''' else '' end)
      +convert(varchar, case when isnull(@rok,'')!=''   then 'AND Ksiazka.Rok_Wydania = ' + convert(varchar,@rok) + ''else '' end)
      + 'GROUP BY Ksiazka.Ksiazka_ID' 
  EXEC(@sql)

END
go
EXEC Ilosc
