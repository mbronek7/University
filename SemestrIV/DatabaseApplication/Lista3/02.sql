USE List3DB;
GO

DROP TABLE IF EXISTS SalaryHistory;
GO

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees(
	ID INT IDENTITY PRIMARY KEY,
	SalaryGross DECIMAL(10,2)
);
GO

CREATE TABLE SalaryHistory(
	ID INT IDENTITY PRIMARY KEY,
	EmployeeID INT FOREIGN KEY REFERENCES Employees(ID),
	YearNo INT,
	MonthNo INT,
	SalaryNet DECIMAL(10, 2),
	SalaryGross DECIMAL(10, 2)
);
GO

INSERT INTO Employees (SalaryGross) VALUES
(1234.56),
(234.34),
(23423.23),
(123213.45),
(123.34),
(60000.09);
GO


CREATE OR ALTER PROCEDURE compute_salaries
	@month INT
AS
	DECLARE @threshold DECIMAL(10, 2) = 85528.00; -- prog wyzszego podatku
	DECLARE @last_known_month INT = ISNULL((SELECT MAX(MonthNo) FROM SalaryHistory), 0); -- ostatni miesiac z pensja
	DECLARE @SalarySums TABLE(
		EmployeeID INT,
		SalaryGrossSum DECIMAL(10, 2) DEFAULT 0.0
	);
	IF (@last_known_month = 0)                                                      -- liczenie sumy pensji w danym roku do liczenia podatku
		INSERT INTO @SalarySums (EmployeeID)
			SELECT ID FROM Employees;
	ELSE
		INSERT INTO @SalarySums
			SELECT EmployeeID, SUM(SalaryGross)
			FROM SalaryHistory
			WHERE YearNo = YEAR(GETDATE()) AND MonthNo < @month
			GROUP BY EmployeeID;


	DECLARE c CURSOR FOR                -- przejscie kursorem po wszystkich pracownikach 
		SELECT * FROM @SalarySums;
	OPEN c;
		DECLARE
			@EmployeeID INT,
			@SalaryGrossSum DECIMAL(10, 2),
			@SalaryGross DECIMAL(10, 2),
			@SalaryNet DECIMAL(10, 2),
			@current_month INT;

		FETCH NEXT FROM c INTO @EmployeeID, @SalaryGross;
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @SalaryGross = (SELECT SalaryGross FROM Employees WHERE ID=@EmployeeID);
			SET @SalaryGrossSum = (SELECT SalaryGrossSum FROM @SalarySums WHERE EmployeeID=@EmployeeID);
			SET @current_month = @last_known_month + 1

			WHILE (@current_month <= @month)
			BEGIN
			    IF (@SalaryGrossSum + @SalaryGross <= @threshold)   -- ponizej progu
					SET @SalaryNet = @SalaryGross * (1 - 0.18)
				ELSE
					SET @SalaryNet = (@threshold - @SalaryGrossSum) * (1 - 0.18)    --wieksza stawke placimy tylko od wiekszego dochodu nie od mniejszego
						+ (@SalaryGrossSum + @SalaryGross - @threshold) * (1 - 0.32);
				SET @SalaryGrossSum = @SalaryGrossSum + @SalaryGross

				INSERT INTO SalaryHistory                                               -- aktualizacja historii dochodów
					(EmployeeID, YearNo, MonthNo, SalaryNet, SalaryGross) VALUES
					(@EmployeeID, YEAR(GETDATE()), @current_month, @SalaryNet, @SalaryGross);

					SET @current_month = @current_month + 1
			END
			FETCH NEXT FROM c INTO @EmployeeID, @SalaryGross;
		END
	CLOSE c;
	DEALLOCATE c;
GO

EXEC compute_salaries 3;
GO

SELECT * FROM SalaryHistory 
	ORDER BY EmployeeID ASC, MonthNo ASC;
GO