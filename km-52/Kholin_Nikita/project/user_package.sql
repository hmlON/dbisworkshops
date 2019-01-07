CREATE OR REPLACE PACKAGE users_pack IS
    FUNCTION total_users
    RETURN NUMBER;
END users_pack;
/

CREATE OR REPLACE PACKAGE BODY users_pack IS
    FUNCTION total_users
    RETURN NUMBER IS
        total AUTH_USER.id%TYPE;
    BEGIN
        select count(*) into total from AUTH_USER;
        RETURN(total);
    END total_users;
END users_pack;
/