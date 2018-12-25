CREATE OR REPLACE PACKAGE music_services_add IS
    PROCEDURE add_services(
        music_service_id IN music_services.music_service_id%TYPE,
        name    IN  music_services.name%TYPE, 
        user_id IN  music_services.user_id%TYPE,
        configuration IN  music_services.configuration%TYPE,
        message OUT STRING
        );
END music_services_add;
/

CREATE OR REPLACE PACKAGE BODY music_services_add IS 
    PROCEDURE add_services ( 
        music_service_id IN music_services.music_service_id%TYPE,
        name    IN  music_services.name%TYPE, 
        user_id IN  music_services.user_id%TYPE,
        configuration IN  music_services.configuration%TYPE,
        message OUT STRING
        ) IS
        PRAGMA autonomous_transaction; 
    BEGIN 
        INSERT INTO music_services(music_service_id, name, user_id,configuration) 
            VALUES(music_service_id, name, user_id,configuration); 
        message := 'Operation successful'; 
        COMMIT; 
    END add_services;
END music_services_add;
/