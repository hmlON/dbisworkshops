CREATE OR REPLACE PACKAGE notif_config_add IS
    PROCEDURE configs_add(
        config_id IN notification_configs.config_id%TYPE,
        user_id   IN notification_configs.user_id%TYPE,
        enabled   IN notification_configs.enabled%TYPE,
        sending_config IN notification_configs.sending_config%TYPE,
        channel   IN notification_configs.channel%TYPE,
        last_sent_at IN notification_configs.last_sent_at%TYPE,
        sending_period IN notification_configs.sending_period%TYPE, 
        sending_hour  IN notification_configs.sending_hour%TYPE,
        sending_day IN notification_configs.sending_day%TYPE,
        message OUT STRING
        );
END notif_config_add;
/

CREATE OR REPLACE PACKAGE BODY notif_config_add IS 
    PROCEDURE configs_add ( 
        config_id IN notification_configs.config_id%TYPE,
        user_id   IN notification_configs.user_id%TYPE,
        enabled   IN notification_configs.enabled%TYPE,
        sending_config IN notification_configs.sending_config%TYPE,
        channel   IN notification_configs.channel%TYPE,
        last_sent_at IN notification_configs.last_sent_at%TYPE,
        sending_period IN notification_configs.sending_period%TYPE, 
        sending_hour  IN notification_configs.sending_hour%TYPE,
        sending_day IN notification_configs.sending_day%TYPE,
        message OUT STRING
        ) IS
        PRAGMA autonomous_transaction; 
    BEGIN 
        INSERT INTO notification_configs(config_id, user_id, enabled, sending_config,channel,last_sent_at,sending_period,sending_hour,sending_day) 
            VALUES(config_id, user_id, enabled, sending_config,channel,last_sent_at,sending_period,sending_hour,sending_day); 
        message := 'Operation successful'; 
        COMMIT; 
    END configs_add;
END notif_config_add;
/