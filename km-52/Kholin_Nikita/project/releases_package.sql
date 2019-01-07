CREATE OR REPLACE PACKAGE releases IS
    FUNCTION create_or_update_release(
        in_artist_id              IN INTEGRATIONS_RELEASE.artist_id%TYPE,
        in_integration_release_id IN INTEGRATIONS_RELEASE.integration_release_id%TYPE,
        in_title                  IN INTEGRATIONS_RELEASE.title%TYPE,
        in_cover_url              IN INTEGRATIONS_RELEASE.cover_url%TYPE,
        in_date                   IN INTEGRATIONS_RELEASE.date%TYPE,
        in_release_type           IN INTEGRATIONS_RELEASE.release_type%TYPE)
    RETURN STRING;

    TYPE row_show_releases IS RECORD(
        title INTEGRATIONS_RELEASE.title%TYPE,
        release_date INTEGRATIONS_RELEASE."DATE"%TYPE,
        cover_url INTEGRATIONS_RELEASE.cover_url%TYPE,
        artist_name INTEGRATIONS_ARTIST.name%TYPE
    );

    TYPE tbl_show_releases IS TABLE OF row_show_releases;

    FUNCTION artist_releases (artist_name in INTEGRATIONS_ARTIST.NAME%TYPE)
        RETURN tbl_show_releases
        PIPELINED;

    FUNCTION latest_releases
        RETURN tbl_show_releases
        PIPELINED;

    FUNCTION releases_from_time(from_date in INTEGRATIONS_RELEASE."DATE"%TYPE)
        RETURN tbl_show_releases
        PIPELINED;
END releases;
/

CREATE OR REPLACE PACKAGE BODY releases IS
    FUNCTION create_or_update_release(
        in_artist_id              IN INTEGRATIONS_RELEASE.artist_id%TYPE,
        in_integration_release_id IN INTEGRATIONS_RELEASE.integration_release_id%TYPE,
        in_title                  IN INTEGRATIONS_RELEASE.title%TYPE,
        in_cover_url              IN INTEGRATIONS_RELEASE.cover_url%TYPE,
        in_date                   IN INTEGRATIONS_RELEASE.date%TYPE,
        in_release_type           IN INTEGRATIONS_RELEASE.release_type%TYPE)
    RETURN STRING IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO INTEGRATIONS_RELEASE
                   (ARTIST_ID,
                    integration_release_id,
                    title,
                    "DATE",
                    cover_url,
                    release_type,
                    CREATED_AT,
                    UPDATED_AT)
            VALUES
                   (in_artist_id,
                    in_integration_release_id,
                    in_title,
                    in_date,
                    in_cover_url,
                    in_release_type,
                    (SELECT sysdate from dual),
                    (SELECT sysdate from dual));
        COMMIT;
        RETURN('success');
    EXCEPTION
        WHEN dup_val_on_index THEN
            update INTEGRATIONS_RELEASE set
                    title=in_title,
                    cover_url=in_cover_url,
                    "DATE"=in_date,
                    release_type=in_release_type,
                    UPDATED_AT = (SELECT sysdate from dual)
                where
                    artist_id=in_artist_id AND integration_release_id=in_integration_release_id;
            COMMIT;
            RETURN('updated');
    END create_or_update_release;

    FUNCTION artist_releases (artist_name in INTEGRATIONS_ARTIST.NAME%TYPE)
        RETURN tbl_show_releases
        PIPELINED
        IS
            CURSOR my_cur IS
                select integrations_release.title,
                       integrations_release."DATE",
                       integrations_release.cover_url,
                       INTEGRATIONS_ARTIST.name
              from integrations_release join INTEGRATIONS_ARTIST on INTEGRATIONS_RELEASE.ARTIST_ID = INTEGRATIONS_ARTIST.ID
                where lower(INTEGRATIONS_ARTIST.name) = lower(artist_name);
                BEGIN
                    FOR curr IN my_cur
                    LOOP
                      PIPE ROW (curr);
                    END LOOP;
        END artist_releases;

      FUNCTION latest_releases
          RETURN tbl_show_releases
          PIPELINED
          IS
            CURSOR my_cur IS
              select integrations_release.title,
                     TO_DATE(integrations_release."DATE"),
                     integrations_release.cover_url,
                     INTEGRATIONS_ARTIST.name
              from integrations_release join INTEGRATIONS_ARTIST on INTEGRATIONS_RELEASE.ARTIST_ID = INTEGRATIONS_ARTIST.ID
              where rownum < 101
              order by integrations_release."DATE" desc;
             -- FETCH FIRST 200 ROWS ONLY;
              BEGIN
                FOR curr IN my_cur
                LOOP
                  PIPE ROW (curr);
                END LOOP;
        END latest_releases;

      FUNCTION releases_from_time(from_date in INTEGRATIONS_RELEASE."DATE"%TYPE)
          RETURN tbl_show_releases
          PIPELINED
          IS
            CURSOR my_cur IS
              select integrations_release.title,
                     integrations_release."DATE",
                     integrations_release.cover_url,
                     INTEGRATIONS_ARTIST.name
              from integrations_release join INTEGRATIONS_ARTIST on INTEGRATIONS_RELEASE.ARTIST_ID = INTEGRATIONS_ARTIST.ID
              where integrations_release."DATE" > from_date;
              BEGIN
                FOR curr IN my_cur
                LOOP
                  PIPE ROW (curr);
                END LOOP;
        END releases_from_time;
END releases;
/
