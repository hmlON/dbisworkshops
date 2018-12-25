--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO users (user_id, email, password) VALUES (1, 'nik.kholin@gmail.com', 'myunhackablepassword');
INSERT INTO users (user_id, email, password) VALUES (2, 'other.person@talkable.com', 'anotherunhackablepassword');

--
-- Data for Name: music_services; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO music_services (id, name, configuration, user_id, created_at, updated_at) VALUES (1, 'deezer', '700513741', 1, '2018-12-14 12:26:32.210753+02', '2018-12-14 12:26:32.229953+02');
INSERT INTO music_services (id, name, configuration, user_id, created_at, updated_at) VALUES (2, 'spotify', 'hmlon', 1, '2018-12-14 12:26:32.210753+02', '2018-12-14 15:22:17.385782+02');


--
-- Data for Name: music_releases; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (57, 'Unsteady (Lakechild Remixes)', 'https://api.deezer.com/album/13366949/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (58, 'American Oxygen', 'https://api.deezer.com/album/12686728/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (59, 'Unsteady (Remixes)', 'https://api.deezer.com/album/12494762/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (60, 'Unsteady (Grizfolk Remix)', 'https://api.deezer.com/album/12505504/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (61, 'Unsteady (Jack Novak & Stravy Remix)', 'https://api.deezer.com/album/11674374/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (62, 'Renegades (Astrolith Remix)', 'https://api.deezer.com/album/11016738/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (49, 'Home', 'https://api.deezer.com/album/51483952/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (50, 'Ahead Of Myself', 'https://api.deezer.com/album/44672721/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (51, 'The Devil You Know', 'https://api.deezer.com/album/42499651/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (52, 'Torches', 'https://api.deezer.com/album/40459451/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (53, 'Hoping', 'https://api.deezer.com/album/15579482/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (54, 'Unsteady (Fancy Cars Remix)', 'https://api.deezer.com/album/14521238/image', 'X-Ambassadors' 1);
INSERT INTO music_releases (release_id, title, artist_name, music_service_id) VALUES (55, 'Low Life 2.0 (Boehm Remix)', 'https://api.deezer.com/album/14459084/image', 'X-Ambassadors' 1);

--
-- Data for Name: notification_configs; Type: TABLE DATA; Schema: public; Owner: mun
--

INSERT INTO notification_configs (config_id, channel, last_sent_at, enabled, user_id, sending_config) VALUES (1, 'email', '2018-12-14 12:40:52.493951+02', 1, 1, 'nik.kholin@gmail.com');
INSERT INTO notification_configs (config_id, channel, last_sent_at, enabled, user_id, sending_config) VALUES (2, 'telegram', '2018-12-14 12:44:08.079621+02', 1, 1, '220746547');
