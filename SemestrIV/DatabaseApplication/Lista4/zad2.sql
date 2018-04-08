-- ZAD2 -- 
BEGIN
ALTER DATABASE SQLLISTA4
SET single_user WITH ROLLBACK IMMEDIATE
DROP DATABASE SQLLISTA4
END
GO
CREATE DATABASE SQLLISTA4
GO
USE SQLLISTA4
GO
CREATE TABLE ExampleTable(
a INT
,b VARCHAR(100)
)
GO
USE SQLLISTA4
GO
INSERT INTO ExampleTable VALUES (1, 'Adam')
GO
INSERT INTO ExampleTable VALUES (2, 'Grzesiek')
GO
INSERT INTO ExampleTable VALUES (3, 'Tomek')
GO

-- READ COMMITTED --
GO
BEGIN TRAN
UPDATE ExampleTable
SET a = 99
WHERE a = 1


GO
BEGIN TRAN
SELECT *
FROM   ExampleTable
WHERE a = 1
--  SELECT zatrzyma się o ile będzie chciał przeczytać rekord zmodyfikowany przez inną nie zatwierdzoną transakcję. --

-- Read Committed Snapshot-- 
ALTER DATABASE SQLLISTA4
SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE
GO


BEGIN TRAN
UPDATE ExampleTable
SET a = 99
WHERE a = 1


BEGIN TRAN
SELECT *
FROM   ExampleTable
WHERE a = 1

-- Tym razem pokazuje nam się stara wartość, ponieważ tranzakcja nie jest jeszcze skomittowana, jest to sposób na na odczytania danych bedacych aktualnie commitowanych --
