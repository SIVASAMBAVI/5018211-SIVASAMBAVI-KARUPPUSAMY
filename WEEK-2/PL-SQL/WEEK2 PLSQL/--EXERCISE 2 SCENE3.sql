--EXERCISE 2 SCENE3
CREATE PROCEDURE AddNewCustomer
    @CustomerID INT,
    @CustomerName NVARCHAR(100),
    @ContactNumber NVARCHAR(15),
    @Email NVARCHAR(100)
AS
BEGIN
    -- Declare a variable to store the error message
    DECLARE @ErrorMessage NVARCHAR(250);

    -- Check if a customer with the same ID already exists
    IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
    BEGIN
        -- Set the error message
        SET @ErrorMessage = 'Customer with ID ' + CAST(@CustomerID AS NVARCHAR) + ' already exists.';

        -- Log the error (this assumes you have an ErrorLog table for logging errors)
        INSERT INTO ErrorLog (ErrorMessage, ErrorDate)
        VALUES (@ErrorMessage, GETDATE());

        -- Return an error code
        RETURN -1;
    END

    -- Insert the new customer
    BEGIN TRY
        INSERT INTO Customers (CustomerID, CustomerName, ContactNumber, Email)
        VALUES (@CustomerID, @CustomerName, @ContactNumber, @Email);
    END TRY
    BEGIN CATCH
        -- Set the error message from the catch block
        SET @ErrorMessage = ERROR_MESSAGE();

        -- Log the error
        INSERT INTO ErrorLog (ErrorMessage, ErrorDate)
        VALUES (@ErrorMessage, GETDATE());

        -- Return an error code
        RETURN -1;
    END CATCH

    -- Return success code
    RETURN 0;
END
GO
