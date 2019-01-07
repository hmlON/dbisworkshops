CREATE OR REPLACE PACKAGE artists IS
    FUNCTION create_or_update_artist(
        in_INTEGRATION_ID        IN INTEGRATIONS_ARTIST.INTEGRATION_ID%TYPE,
        in_integration_artist_id IN INTEGRATIONS_ARTIST.integration_artist_id%TYPE,
        in_name                  IN INTEGRATIONS_ARTIST.name%TYPE)
    RETURN STRING;
END artists;
/

CREATE OR REPLACE PACKAGE BODY artists IS
    FUNCTION create_or_update_artist(
        in_INTEGRATION_ID        IN INTEGRATIONS_ARTIST.INTEGRATION_ID%TYPE,
        in_integration_artist_id IN INTEGRATIONS_ARTIST.integration_artist_id%TYPE,
        in_name                  IN INTEGRATIONS_ARTIST.name%TYPE)
    RETURN STRING IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO INTEGRATIONS_ARTIST
                   (INTEGRATION_ID,
                    integration_artist_id,
                    name,
                    CREATED_AT,
                    UPDATED_AT)
            VALUES
                   (in_INTEGRATION_ID,
                    in_integration_artist_id,
                    in_name,
                    (SELECT sysdate from dual),
                    (SELECT sysdate from dual));
        COMMIT;
        RETURN('success');
    EXCEPTION
        WHEN dup_val_on_index THEN
            update INTEGRATIONS_ARTIST set
                    name=in_name,
                    UPDATED_AT = (SELECT sysdate from dual)
                where
                    integration_artist_id=in_integration_artist_id AND
                    INTEGRATION_ID=in_INTEGRATION_ID;
            COMMIT;
            RETURN('updated');
    END create_or_update_artist;
END artists;
/