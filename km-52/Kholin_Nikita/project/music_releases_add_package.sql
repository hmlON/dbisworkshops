CREATE OR REPLACE PACKAGE music_releases_add IS
    PROCEDURE add_releases(
        release_id  IN music_releases.release_id%TYPE,
        artist_name IN  music_releases.artist_name%TYPE, 
        title       IN  music_releases.title%TYPE,
        music_service_id IN  music_releases.music_service_id%TYPE,
        message OUT STRING
        );
END music_releases_add;
/

CREATE OR REPLACE PACKAGE BODY music_releases_add IS 
    PROCEDURE add_releases ( 
        release_id  IN music_releases.release_id%TYPE,
        artist_name IN  music_releases.artist_name%TYPE, 
        title       IN  music_releases.title%TYPE,
        music_service_id IN  music_releases.music_service_id%TYPE,
        message OUT STRING
        ) IS
        PRAGMA autonomous_transaction; 
    BEGIN 
        INSERT INTO music_releases(release_id, artist_name, title,music_service_id) 
            VALUES(release_id, artist_name, title,music_service_id); 
        message := 'Operation successful'; 
        COMMIT; 
    END add_releases;
END music_releases_add;
/