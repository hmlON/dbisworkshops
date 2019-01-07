CREATE OR REPLACE PACKAGE integrations IS
    FUNCTION create_or_update_integration(
        in_user_id             IN INTEGRATIONS_INTEGRATION.user_id%TYPE,
        in_identifier          IN INTEGRATIONS_INTEGRATION.identifier%TYPE,
        in_access_token        IN INTEGRATIONS_INTEGRATION.access_token%TYPE,
        in_refresh_token       IN INTEGRATIONS_INTEGRATION.refresh_token%TYPE,
        in_integration_user_id IN INTEGRATIONS_INTEGRATION.integration_user_id%TYPE)
    RETURN STRING;

    FUNCTION total_integrations
    RETURN NUMBER;
END integrations;
/

CREATE OR REPLACE PACKAGE BODY integrations IS
    FUNCTION create_or_update_integration(
        in_user_id             IN INTEGRATIONS_INTEGRATION.user_id%TYPE,
        in_identifier          IN INTEGRATIONS_INTEGRATION.identifier%TYPE,
        in_access_token        IN INTEGRATIONS_INTEGRATION.access_token%TYPE,
        in_refresh_token       IN INTEGRATIONS_INTEGRATION.refresh_token%TYPE,
        in_integration_user_id IN INTEGRATIONS_INTEGRATION.integration_user_id%TYPE)
    RETURN STRING IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO INTEGRATIONS_INTEGRATION
                   (user_id,
                    identifier,
                    access_token,
                    refresh_token,
                    integration_user_id,
                    CREATED_AT,
                    UPDATED_AT)
            VALUES
                   (in_user_id,
                    in_identifier,
                    in_access_token,
                    in_refresh_token,
                    in_integration_user_id,
                    (SELECT sysdate from dual),
                    (SELECT sysdate from dual));
        COMMIT;
        RETURN('success');
    EXCEPTION
        WHEN dup_val_on_index THEN
            update INTEGRATIONS_INTEGRATION set
                    access_token=in_access_token,
                    refresh_token=in_refresh_token,
                    integration_user_id=in_integration_user_id,
                    UPDATED_AT = (SELECT sysdate from dual)
                where
                    user_id=in_user_id AND identifier=in_identifier;
            COMMIT;
            RETURN('updated');
    END create_or_update_integration;

    FUNCTION total_integrations
    RETURN NUMBER IS
        total AUTH_USER.id%TYPE;
    BEGIN
        select count(*) into total from INTEGRATIONS_INTEGRATION;
        RETURN(total);
    END total_integrations;
END integrations;
/