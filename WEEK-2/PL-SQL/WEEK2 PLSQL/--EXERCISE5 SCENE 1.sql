--EXERCISE5 SCENE 1
CREATE TRIGGER UpdateCustomerLastModified
ON Customers
AFTER UPDATE
AS
BEGIN
    -- Update the LastModified column to the current date and time for the updated rows
    UPDATE Customers
    SET LastModified = GETDATE()
    FROM Customers
    INNER JOIN inserted ON Customers.CustomerID = inserted.CustomerID;
END
GO
