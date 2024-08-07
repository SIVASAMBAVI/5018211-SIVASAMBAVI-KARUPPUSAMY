--EXERCISE7 SCENE2
CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    -- Implementation of procedure to hire a new employee
    PROCEDURE HireEmployee(p_EmployeeID IN NUMBER, p_EmployeeName IN VARCHAR2, p_MonthlySalary IN NUMBER) IS
    BEGIN
        INSERT INTO Employees (EmployeeID, EmployeeName, MonthlySalary)
        VALUES (p_EmployeeID, p_EmployeeName, p_MonthlySalary);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: EmployeeID ' || p_EmployeeID || ' already exists.');
    END HireEmployee;

    -- Implementation of procedure to update employee details
    PROCEDURE UpdateEmployeeDetails(p_EmployeeID IN NUMBER, p_NewEmployeeName IN VARCHAR2, p_NewMonthlySalary IN NUMBER) IS
    BEGIN
        UPDATE Employees
        SET EmployeeName = p_NewEmployeeName, MonthlySalary = p_NewMonthlySalary
        WHERE EmployeeID = p_EmployeeID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: EmployeeID ' || p_EmployeeID || ' does not exist.');
        ELSE
            COMMIT;
        END IF;
    END UpdateEmployeeDetails;

    -- Implementation of function to calculate annual salary
    FUNCTION CalculateAnnualSalary(p_MonthlySalary IN NUMBER) RETURN NUMBER IS
        v_AnnualSalary NUMBER;
    BEGIN
        v_AnnualSalary := p_MonthlySalary * 12;
        RETURN v_AnnualSalary;
    END CalculateAnnualSalary;

END EmployeeManagement;
/
