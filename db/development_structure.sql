--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reservations (
    id integer NOT NULL,
    room_id integer,
    user_id integer,
    comment text,
    begining_at timestamp without time zone,
    end_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: room_reservations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE room_reservations (
    id integer NOT NULL,
    supplicant character varying(255),
    comment text,
    begining_at timestamp without time zone,
    end_at timestamp without time zone,
    room_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rooms (
    id integer NOT NULL,
    name character varying(255),
    number integer,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    login character varying(40),
    name character varying(100) DEFAULT ''::character varying,
    email character varying(100),
    crypted_password character varying(40),
    salt character varying(40),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_token character varying(40),
    remember_token_expires_at timestamp without time zone
);


--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reservations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reservations_id_seq OWNED BY reservations.id;


--
-- Name: room_reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE room_reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: room_reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE room_reservations_id_seq OWNED BY room_reservations.id;


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rooms_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rooms_id_seq OWNED BY rooms.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE reservations ALTER COLUMN id SET DEFAULT nextval('reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE room_reservations ALTER COLUMN id SET DEFAULT nextval('room_reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rooms ALTER COLUMN id SET DEFAULT nextval('rooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: room_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY room_reservations
    ADD CONSTRAINT room_reservations_pkey PRIMARY KEY (id);


--
-- Name: rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20081125105539');

INSERT INTO schema_migrations (version) VALUES ('20081125130355');

INSERT INTO schema_migrations (version) VALUES ('20081127130830');

INSERT INTO schema_migrations (version) VALUES ('20081127130928');

INSERT INTO schema_migrations (version) VALUES ('20081125105303');