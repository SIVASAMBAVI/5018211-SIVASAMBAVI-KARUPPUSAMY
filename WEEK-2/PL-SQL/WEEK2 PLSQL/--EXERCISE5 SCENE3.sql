--EXERCISE5 SCENE3
CREATE TRIGGER CheckTransactionRules
ON Transactions
INSTEAD OF INSERT
AS
BEGIN
    -- Variable to store the current balance
    DECLARE @CurrentBalance DECIMAL(18, 2);

    -- Check for each transaction being inserted
    -- We will use a temporary table to store the valid transactions
    CREATE TABLE #ValidTransactions (
        TransactionID INT,
        AccountID INT,
        TransactionDate DATETIME,
        Amount DECIMAL(18, 2),
        TransactionType CHAR(1) -- 'D' for Deposit, 'W' for Withdrawal
    );

    -- Check deposits and withdrawals
    INSERT INTO #ValidTransactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
    SELECT
        i.TransactionID,
        i.AccountID,
        i.TransactionDate,
        i.Amount,
        i.TransactionType
    FROM inserted i
    WHERE 
        (i.TransactionType = 'D' AND i.Amount > 0) -- Check deposit
        OR 
        (i.TransactionType = 'W' AND i.Amount > 0 AND EXISTS (
            SELECT 1
            FROM Accounts a
            WHERE a.AccountID = i.AccountID
            AND a.Balance >= i.Amount
        )); -- Check withdrawal

    -- If there are valid transactions, insert them into the Transactions table
    IF EXISTS (SELECT 1 FROM #ValidTransactions)
    BEGIN
        INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
        SELECT TransactionID, AccountID, TransactionDate, Amount, TransactionType
        FROM #ValidTransactions;
    END

    -- Drop the temporary table
    DROP TABLE #ValidTransactions;
END
GO
