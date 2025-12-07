
CREATE PROCEDURE sp_ETL_Satislar 
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		INSERT INTO Transaction_Logs (TransactionName,Situation)
		VALUES ('ETL Baþladý','Baþladý');

		INSERT INTO Fact_Satislar (CustomerName,ProductCode,Ciro,RegistrationDate)
		SELECT 
			Customername,
			ProductCode,
			(TRY_CAST(Price AS DECIMAL(18,2))) * Amount,
			TransactionDate
		FROM Raw_Satislar
		WHERE (TRY_CAST(Price AS DECIMAL(18,2))) is not null 
		AND Amount > 0;

		TRUNCATE TABLE Raw_Satislar;

		INSERT INTO Transaction_Logs (TransactionName,Situation)
		VALUES ('ETL Süreci','Baþarýlý');

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		INSERT INTO Transaction_Logs(TransactionName,Situation)
		VALUES ('ETL Hatasý', CAST(ERROR_MESSAGE() AS NVARCHAR(100)));
	END CATCH
END;

EXEC sp_ETL_Satislar;

SELECT * FROM Fact_Satislar;
SELECT * FROM Transaction_Logs;
