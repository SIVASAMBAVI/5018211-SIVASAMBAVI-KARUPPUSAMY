--EXERCISE3 SCENE3
CREATE PROCEDURE TransferFunds
    @SourceAccountID INT,
    @DestinationAccountID INT,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    -- Declare variables
    DECLARE @SourceBalance DECIMAL(18, 2);

    -- Start a transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the source account has sufficient balance
        SELECT @SourceBalance = Balance
        FROM Accounts
        WHERE AccountID = @SourceAccountID;

        IF @SourceBalance IS NULL
        BEGIN
            RAISERROR('Source account does not exist.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        IF @SourceBalance < @Amount
        BEGIN
            RAISERROR('Insufficient balance in the source account.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Deduct the amount from the source account
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @SourceAccountID;

        -- Add the amount to the destination account
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @DestinationAccountID;

        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of error
        ROLLBACK TRANSACTION;

        -- Raise an error with the message
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);

        RETURN -1;
    END CATCH

    -- Return success code
    RETURN 0;
END
GO
