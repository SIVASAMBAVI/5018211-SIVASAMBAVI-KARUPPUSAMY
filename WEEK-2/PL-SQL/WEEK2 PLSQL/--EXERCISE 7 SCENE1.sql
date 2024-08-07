--EXERCISE 7 SCENE1
CREATE OR REPLACE PACKAGE BODY CustomerManagement AS

    -- Implementation of procedure to add a new customer
    PROCEDURE AddNewCustomer(p_CustomerID IN NUMBER, p_CustomerName IN VARCHAR2, p_InitialBalance IN NUMBER) IS
    BEGIN
        INSERT INTO Customers (CustomerID, CustomerName, Balance)
        VALUES (p_CustomerID, p_CustomerName, p_InitialBalance);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: CustomerID ' || p_CustomerID || ' already exists.');
    END AddNewCustomer;

    -- Implementation of procedure to update customer details
    PROCEDURE UpdateCustomerDetails(p_CustomerID IN NUMBER, p_NewCustomerName IN VARCHAR2, p_NewBalance IN NUMBER) IS
    BEGIN
        UPDATE Customers
        SET CustomerName = p_NewCustomerName, Balance = p_NewBalance
        WHERE CustomerID = p_CustomerID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: CustomerID ' || p_CustomerID || ' does not exist.');
        ELSE
            COMMIT;
        END IF;
    END UpdateCustomerDetails;

    -- Implementation of function to get the customer balance
    FUNCTION GetCustomerBalance(p_CustomerID IN NUMBER) RETURN NUMBER IS
        v_Balance NUMBER;
    BEGIN
        SELECT Balance
        INTO v_Balance
        FROM Customers
        WHERE CustomerID = p_CustomerID;

        RETURN v_Balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: CustomerID ' || p_CustomerID || ' does not exist.');
            RETURN NULL;
    END GetCustomerBalance;

END CustomerManagement;
/
