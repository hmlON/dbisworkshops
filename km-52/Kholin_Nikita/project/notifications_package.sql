CREATE OR REPLACE PACKAGE notifications IS
    FUNCTION create_notification(
        in_user_id       IN NOTIFICATIONS_NOTIFICATION.user_id%TYPE,
        in_channel       IN  NOTIFICATIONS_NOTIFICATION.channel%TYPE,
        in_connect_token IN  NOTIFICATIONS_NOTIFICATION.connect_token%TYPE)
    RETURN STRING;

    FUNCTION update_notification(
        in_id       IN NOTIFICATIONS_NOTIFICATION.id%TYPE,
        in_enabled       IN  NOTIFICATIONS_NOTIFICATION.enabled%TYPE,
        in_connect_token IN  NOTIFICATIONS_NOTIFICATION.connect_token%TYPE)
    RETURN STRING;

    FUNCTION total_notifications
    RETURN NUMBER;

    TYPE row_notifications_by_identifier IS RECORD(
        out_count   NOTIFICATIONS_NOTIFICATION.id%TYPE,
        out_channel NOTIFICATIONS_NOTIFICATION.channel%TYPE
    );
    TYPE tbl_notifications_by_identifier IS TABLE OF row_notifications_by_identifier;
    FUNCTION notifications_by_identifier
    RETURN tbl_notifications_by_identifier pipelined;
END notifications;
/

CREATE OR REPLACE PACKAGE BODY notifications IS
    FUNCTION create_notification(
        in_user_id       IN NOTIFICATIONS_NOTIFICATION.user_id%TYPE,
        in_channel       IN  NOTIFICATIONS_NOTIFICATION.channel%TYPE,
        in_connect_token IN  NOTIFICATIONS_NOTIFICATION.connect_token%TYPE)
    RETURN STRING IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO NOTIFICATIONS_NOTIFICATION
                   (user_id,
                    channel,
                    connect_token,
                    LAST_SENT_AT,
                    ENABLED,
                    CREATED_AT,
                    UPDATED_AT)
            VALUES
                   (in_user_id,
                    in_channel,
                    in_connect_token,
                    (SELECT sysdate from dual),
                    1,
                    (SELECT sysdate from dual),
                    (SELECT sysdate from dual));
        COMMIT;
        RETURN('success');
    EXCEPTION
        WHEN dup_val_on_index THEN
            return('exists');
    END create_notification;

    FUNCTION update_notification(
        in_id       IN NOTIFICATIONS_NOTIFICATION.id%TYPE,
        in_enabled       IN  NOTIFICATIONS_NOTIFICATION.enabled%TYPE,
        in_connect_token IN  NOTIFICATIONS_NOTIFICATION.connect_token%TYPE)
    RETURN STRING IS
        PRAGMA autonomous_transaction;
    BEGIN
        update NOTIFICATIONS_NOTIFICATION set
            enabled = in_enabled,
            connect_token = in_connect_token
            where id = in_id;
        COMMIT;
        RETURN('success');
    END update_notification;

    FUNCTION total_notifications
    RETURN NUMBER IS
        total NOTIFICATIONS_NOTIFICATION.id%TYPE;
    BEGIN
        select count(*) into total from NOTIFICATIONS_NOTIFICATION;
        RETURN(total);
    END total_notifications;

    FUNCTION notifications_by_identifier
    RETURN tbl_notifications_by_identifier PIPELINED
    IS
        CURSOR my_cur IS
            select count(*), "CHANNEL" from NOTIFICATIONS_NOTIFICATION
            group by "CHANNEL";
    BEGIN
        FOR curr IN my_cur
        LOOP
            PIPE ROW (curr);
        END LOOP;
    END notifications_by_identifier;
END notifications;
/

