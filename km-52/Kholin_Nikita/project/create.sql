/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     10/21/2017 10:12:18 AM                       */
/*==============================================================*/


alter table friends
   drop constraint fk_friend_2;

alter table friends
   drop constraint fk_friend_1;

alter table user_has_skills
   drop constraint fk_skills_user;

alter table user_has_skills
   drop constraint fk_user_skills;

drop index first_friend_fk;

drop table friends cascade constraints;

drop table skill cascade constraints;

drop table "user" cascade constraints;

drop table user_has_skills cascade constraints;

/*==============================================================*/
/* Table: friends                                               */
/*==============================================================*/
create table friends 
(
   user_id1_fk          integer              not null,
   user_id2_fk          integer              not null,
   friends_date         date                 not null,
   constraint pk_friends primary key (user_id1_fk, user_id2_fk, friends_date)
);

/*==============================================================*/
/* Index: first_friend_fk                                       */
/*==============================================================*/
create index first_friend_fk on friends (
   user_id2_fk asc
);

/*==============================================================*/
/* Table: skill                                                 */
/*==============================================================*/
create table skill 
(
   skill_name           varchar2(40)         not null,
   constraint pk_skill primary key (skill_name)
);

/*==============================================================*/
/* Table: "user"                                                */
/*==============================================================*/
create table "user" 
(
   user_id              integer              not null,
   user_studybook       varchar2(6)          not null,
   user_year            date                 not null,
   user_name            varchar2(20)         not null,
   user_email           varchar2(40),
   user_birthday        date                 not null
);


/*======ADDED MANUALLY=======*/
ALTER TABLE "user"
  ADD CONSTRAINT user_PK PRIMARY KEY (user_id);

ALTER TABLE "user"
  ADD CONSTRAINT user_unique UNIQUE (user_studybook, user_year);

ALTER TABLE "user"
  ADD CONSTRAINT email_unique UNIQUE (user_email);
  
ALTER TABLE "user"
  ADD CONSTRAINT check_email
  CHECK ( REGEXP_LIKE (user_email, '[A-Z0-9._]+@[A-Z0-9._]+\.[A-Z]{2,4}'));

ALTER TABLE "user"
  ADD CONSTRAINT check_name 
  CHECK (REGEXP_LIKE(user_name,'[A-Z][a-z]{1,19}','c'));  
  
ALTER TABLE "user"
  ADD CONSTRAINT check_user_studybook 
  CHECK (REGEXP_LIKE(user_studybook,'[A-Z]{2}\d{4}','c'));  
  
ALTER TABLE "user"
  ADD CONSTRAINT check_birthday
  CHECK ( user_birthday > date '1900-01-01');

ALTER TABLE "user"
  ADD CONSTRAINT check_user_year
  CHECK ( user_year > user_birthday);  
/*==============================================================*/
/* Table: user_has_skills                                       */
/*==============================================================*/
create table user_has_skills 
(
   skill_name           varchar2(40)         not null,
   user_id              integer              not null
);

alter table friends
   add constraint fk_friend_2 foreign key (user_id2_fk)
      references "user" (user_id)
      on delete cascade;

alter table friends
   add constraint fk_friend_1 foreign key (user_id1_fk)
      references "user" (user_id)
      on delete cascade;

alter table user_has_skills
   add constraint fk_skills_user foreign key (skill_name)
      references skill (skill_name)
      on delete cascade;

alter table user_has_skills
   add constraint fk_user_skills foreign key (user_id)
      references "user" (user_id)
      on delete cascade;

