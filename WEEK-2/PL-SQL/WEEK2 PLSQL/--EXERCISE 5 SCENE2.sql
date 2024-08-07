--EXERCISE 5 SCENE2
CREATE TRIGGER LogTransaction
ON Transactions
AFTER INSERT
AS
BEGIN
    -- Insert a record into the AuditLog table for each new transaction
    INSERT INTO AuditLog (TransactionID, TransactionDate, Amount, Operation, LogDate)
    SELECT 
        i.TransactionID,
        i.TransactionDate,
        i.Amount,
        'INSERT' AS Operation, -- Indicates that this is an insertion
        GETDATE() AS LogDate
    FROM inserted i;
END
GO
