--EXERCISE3 SCENE2
CREATE PROCEDURE UpdateEmployeeBonus
    @DepartmentName NVARCHAR(100),
    @BonusPercentage DECIMAL(5, 2)
AS
BEGIN
    -- Validate the bonus percentage
    IF @BonusPercentage < 0
    BEGIN
        RAISERROR('Bonus percentage must be a positive value.', 16, 1);
        RETURN -1;
    END

    -- Update the salary of employees in the specified department
    UPDATE Employees
    SET Salary = Salary + (Salary * (@BonusPercentage / 100))
    WHERE Department = @DepartmentName;

    -- Log the operation (optional)
    INSERT INTO BonusProcessingLog (ProcessingDate, DepartmentName, BonusPercentage)
    VALUES (GETDATE(), @DepartmentName, @BonusPercentage);

    -- Return success code
    RETURN 0;
END
GO
