CREATE OR REPLACE PACKAGE user_authorization IS
    PROCEDURE registration(
        user_id IN  users.user_id%TYPE,
        email   IN  users.email%TYPE, 
        password    IN  users.password%TYPE,
        message OUT STRING
        );
    
    FUNCTION login(
        email  IN  users.email%TYPE, 
        password   IN  users.password%TYPE,
        message out STRING)
    RETURN users.email%Type;
END user_authorization;
/

CREATE OR REPLACE PACKAGE BODY user_authorization IS 
    PROCEDURE registration ( 
        user_id IN  users.user_id%TYPE, 
        email   IN  users.email%TYPE,  
        password    IN  users.password%TYPE, 
        message OUT STRING 
        ) IS
        PRAGMA autonomous_transaction; 
    BEGIN 
        INSERT INTO users(user_id, email, password) 
            VALUES(user_id, email, password); 
        message := 'Operation successful'; 
        COMMIT; 
    END registration;

    FUNCTION login(
        email  IN  users.email%TYPE, 
        password   IN  users.password%TYPE,
        message out STRING
        ) 
    RETURN users.email%Type
    IS
        CURSOR user_list is
            SELECT email FROM users;
            BEGIN
            FOR current_element in user_list
            LOOP
                IF current_element.email = email THEN
                    message := 'Successfully logged in';
                    RETURN email;
                ELSE
                    message := 'You are not signed on yet. Please, sign on';
                    RETURN Null;
                END IF;
            END LOOP;
        END login;
END user_authorization;
/