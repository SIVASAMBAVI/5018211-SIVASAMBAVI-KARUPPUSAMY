--EXERCISE 2 SCENE2
CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_employee_id IN employees.employee_id%TYPE,
    p_percentage IN NUMBER
)
IS
    v_current_salary employees.salary%TYPE;
    v_new_salary employees.salary%TYPE;
    v_error_message VARCHAR2(4000);
BEGIN
    -- Fetch the current salary of the employee
    BEGIN
        SELECT salary INTO v_current_salary
        FROM employees
        WHERE employee_id = p_employee_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_error_message := 'Employee ID ' || p_employee_id || ' does not exist.';
            INSERT INTO error_log (error_message, error_time)
            VALUES (v_error_message, SYSDATE);
            DBMS_OUTPUT.PUT_LINE(v_error_message);
            RETURN;
    END;

    -- Calculate the new salary
    v_new_salary := v_current_salary * (1 + p_percentage / 100);

    -- Update the employee's salary
    UPDATE employees
    SET salary = v_new_salary
    WHERE employee_id = p_employee_id;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salary of employee ID ' || p_employee_id || 
                         ' has been increased by ' || p_percentage || '% to ' || v_new_salary || '.');
EXCEPTION
    WHEN OTHERS THEN
        -- Log the error message
        v_error_message := SQLERRM;
        INSERT INTO error_log (error_message, error_time)
        VALUES (v_error_message, SYSDATE);

        -- Rollback the transaction
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE('Error occurred while updating salary: ' || v_error_message);
END UpdateSalary;
/

