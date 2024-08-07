--EXERCISE4 SCENE3
CREATE FUNCTION HasSufficientBalance (
    @AccountID INT,
    @Amount DECIMAL(18, 2)
)
RETURNS BIT
AS
BEGIN
    DECLARE @CurrentBalance DECIMAL(18, 2);
    DECLARE @HasSufficient BIT;

    -- Retrieve the current balance for the specified account
    SELECT @CurrentBalance = Balance
    FROM Accounts
    WHERE AccountID = @AccountID;

    -- Check if the account exists and if the balance is sufficient
    IF @CurrentBalance IS NULL
    BEGIN
        -- Account does not exist
        SET @HasSufficient = 0;
    END
    ELSE IF @CurrentBalance >= @Amount
    BEGIN
        -- Sufficient balance
        SET @HasSufficient = 1;
    END
    ELSE
    BEGIN
        -- Insufficient balance
        SET @HasSufficient = 0;
    END

    RETURN @HasSufficient;
END
GO
