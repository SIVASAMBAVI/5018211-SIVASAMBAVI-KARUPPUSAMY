--EXERCISE 1 SCENE3
DECLARE
    CURSOR c_due_loans IS
        SELECT l.loan_id, l.due_date, c.customer_id, c.customer_name
        FROM loans l
        JOIN customers c ON l.customer_id = c.customer_id
        WHERE l.due_date BETWEEN SYSDATE AND SYSDATE + 30;

    v_loan_id loans.loan_id%TYPE;
    v_due_date loans.due_date%TYPE;
    v_customer_id customers.customer_id%TYPE;
    v_customer_name customers.customer_name%TYPE;

BEGIN
    OPEN c_due_loans;
    LOOP
        FETCH c_due_loans INTO v_loan_id, v_due_date, v_customer_id, v_customer_name;
        EXIT WHEN c_due_loans%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Reminder: Customer ' || v_customer_name || ' (ID: ' || v_customer_id || 
                             ') has a loan (ID: ' || v_loan_id || ') due on ' || TO_CHAR(v_due_date, 'DD-MON-YYYY') || '.');
    END LOOP;

    CLOSE c_due_loans;
END;
/
