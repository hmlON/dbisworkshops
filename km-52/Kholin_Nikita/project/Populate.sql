--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO users (user_id, email, password) VALUES (1, 'nik.kholin@gmail.com', 'myunhackablepassword');
INSERT INTO users (user_id, email, password) VALUES (2, 'other.person@talkable.com', 'anotherunhackablepassword');

--
-- Data for Name: music_services; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO music_services (music_service_id, name, configuration, user_id) VALUES (1, 'deezer', '700513741', 1);
INSERT INTO music_services (music_service_id, name, configuration, user_id) VALUES (2, 'spotify', 'hmlon', 1);


--
-- Data for Name: music_releases; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (57, 'Unsteady (Lakechild Remixes)', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (58, 'American Oxygen', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (59, 'Unsteady (Remixes)', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (60, 'Unsteady (Grizfolk Remix)', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (61, 'Unsteady (Jack Novak & Stravy Remix)', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (62, 'Renegades (Astrolith Remix)', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (49, 'Home', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (50, 'Ahead Of Myself', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (51, 'The Devil You Know', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (52, 'Torches', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (53, 'Hoping', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (54, 'Unsteady (Fancy Cars Remix)', 'X-Ambassadors', 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (55, 'Low Life 2.0 (Boehm Remix)', 'X-Ambassadors', 1);

--
-- Data for Name: notification_configs; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO notification_configs (config_id, channel, last_sent_at, enabled, user_id, sending_config) VALUES (1, 'email', DATE '2018-12-14', 1, 1, 'nik.kholin@gmail.com');
INSERT INTO notification_configs (config_id, channel, last_sent_at, enabled, user_id, sending_config) VALUES (2, 'telegram', DATE '2018-12-14', 1, 1, '220746547');
