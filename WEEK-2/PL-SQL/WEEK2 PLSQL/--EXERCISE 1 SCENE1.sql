--EXERCISE 1 SCENE1
DECLARE
    CURSOR c_customers IS
        SELECT customer_id, loan_interest_rate, TRUNC((SYSDATE - date_of_birth) / 365.25) AS age
        FROM customers;

    v_customer_id customers.customer_id%TYPE;
    v_loan_interest_rate customers.loan_interest_rate%TYPE;
    v_age NUMBER;

BEGIN
    OPEN c_customers;
    LOOP
        FETCH c_customers INTO v_customer_id, v_loan_interest_rate, v_age;
        EXIT WHEN c_customers%NOTFOUND;

        IF v_age > 60 THEN
            UPDATE customers
            SET loan_interest_rate = loan_interest_rate * 0.99
            WHERE customer_id = v_customer_id;
        END IF;
    END LOOP;

    CLOSE c_customers;
    COMMIT;
END;
/
