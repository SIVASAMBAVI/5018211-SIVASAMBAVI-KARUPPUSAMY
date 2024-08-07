--EXERCISE 3 SCENE1
CREATE PROCEDURE ProcessMonthlyInterest
AS
BEGIN
    -- Declare variables
    DECLARE @InterestRate DECIMAL(5, 2) = 0.01; -- 1% interest rate

    -- Update the balance of all savings accounts
    UPDATE SavingsAccounts
    SET Balance = Balance + (Balance * @InterestRate);

    -- Log the operation (optional)
    INSERT INTO InterestProcessingLog (ProcessingDate, InterestRate)
    VALUES (GETDATE(), @InterestRate);
END
GO
