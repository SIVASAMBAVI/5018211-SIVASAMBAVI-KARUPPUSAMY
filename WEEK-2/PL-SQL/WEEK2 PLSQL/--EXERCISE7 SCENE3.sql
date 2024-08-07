--EXERCISE7 SCENE3
CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    -- Implementation of procedure to open a new account
    PROCEDURE OpenAccount(p_AccountID IN NUMBER, p_CustomerID IN NUMBER, p_InitialBalance IN NUMBER) IS
    BEGIN
        INSERT INTO Accounts (AccountID, CustomerID, Balance)
        VALUES (p_AccountID, p_CustomerID, p_InitialBalance);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: AccountID ' || p_AccountID || ' already exists.');
    END OpenAccount;

    -- Implementation of procedure to close an account
    PROCEDURE CloseAccount(p_AccountID IN NUMBER) IS
    BEGIN
        DELETE FROM Accounts
        WHERE AccountID = p_AccountID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: AccountID ' || p_AccountID || ' does not exist.');
        ELSE
            COMMIT;
        END IF;
    END CloseAccount;

    -- Implementation of function to get the total balance of a customer across all accounts
    FUNCTION GetTotalBalance(p_CustomerID IN NUMBER) RETURN NUMBER IS
        v_TotalBalance NUMBER;
    BEGIN
        SELECT SUM(Balance)
        INTO v_TotalBalance
        FROM Accounts
        WHERE CustomerID = p_CustomerID;

        RETURN NVL(v_TotalBalance, 0); -- Return 0 if no accounts are found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: CustomerID ' || p_CustomerID || ' does not exist.');
            RETURN 0;
    END GetTotalBalance;

END AccountOperations;
/
