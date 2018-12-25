CREATE TABLE users(
    user_id INT NOT NULL,
    email VARCHAR2(255) NOT NULL UNIQUE,
    password VARCHAR2(255) NOT NULL,
    constraint PK_USER_ID primary key (user_id)
    );

CREATE TABLE notification_configs(
    config_id INT NOT NULL,
    user_id INT NOT NULL,
    enabled INT DEFAULT 1,
    sending_config VARCHAR2(255) NOT NULL,
    channel VARCHAR2(255) NOT NULL,
    last_sent_at DATE NOT NULL,
    sending_period VARCHAR2(255),
    sending_hour INT,
    sending_day INT,
    constraint PK_CONFIG_ID primary key (config_id)
    );

CREATE TABLE music_services(
    music_service_id INT NOT NULL,
    name VARCHAR2(255) NOT NULL,
    user_id INT NOT NULL,
    configuration VARCHAR2(255) NOT NULL,
    constraint PK_SERVICE_ID primary key (music_service_id)
    );

CREATE TABLE music_releases(
    release_id INT NOT NULL,
    artist_name VARCHAR2(255) NOT NULL,
    title VARCHAR2(255) NOT NULL,
    music_service_id INT NOT NULL,
    constraint PK_RELEASE_ID primary key (release_id)
    );

alter table music_services
   add constraint FK_USER_ID_MUSIC foreign key (user_id)
      references users(user_id);

alter table notification_configs
   add constraint FK_USER_ID_NOTIF foreign key (user_id)
      references users(user_id);

alter table music_releases
   add constraint FK_SERVICE_ID foreign key (music_service_id)
      references music_services(music_service_id);
