SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: connect; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA connect;


SET search_path = connect, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: connection_events; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE connection_events (
    id integer NOT NULL,
    connection_id integer NOT NULL,
    initiated_by_type character varying,
    initiated_by_id uuid,
    event character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: connection_events_id_seq; Type: SEQUENCE; Schema: connect; Owner: -
--

CREATE SEQUENCE connection_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connection_events_id_seq; Type: SEQUENCE OWNED BY; Schema: connect; Owner: -
--

ALTER SEQUENCE connection_events_id_seq OWNED BY connection_events.id;


--
-- Name: connection_members; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE connection_members (
    id integer NOT NULL,
    connection_id integer NOT NULL,
    member_type character varying,
    member_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: connection_members_id_seq; Type: SEQUENCE; Schema: connect; Owner: -
--

CREATE SEQUENCE connection_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connection_members_id_seq; Type: SEQUENCE OWNED BY; Schema: connect; Owner: -
--

ALTER SEQUENCE connection_members_id_seq OWNED BY connection_members.id;


--
-- Name: connections; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE connections (
    id integer NOT NULL,
    status character varying NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invited_email_address public.citext,
    initiated_by_type character varying,
    initiated_by_id uuid
);


--
-- Name: connections_id_seq; Type: SEQUENCE; Schema: connect; Owner: -
--

CREATE SEQUENCE connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connections_id_seq; Type: SEQUENCE OWNED BY; Schema: connect; Owner: -
--

ALTER SEQUENCE connections_id_seq OWNED BY connections.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scores; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE scores (
    id integer NOT NULL,
    name character varying NOT NULL,
    thinker_id integer NOT NULL,
    data json NOT NULL,
    uuid uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    generated_at timestamp without time zone NOT NULL
);


--
-- Name: scores_id_seq; Type: SEQUENCE; Schema: connect; Owner: -
--

CREATE SEQUENCE scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scores_id_seq; Type: SEQUENCE OWNED BY; Schema: connect; Owner: -
--

ALTER SEQUENCE scores_id_seq OWNED BY scores.id;


--
-- Name: thinkers; Type: TABLE; Schema: connect; Owner: -
--

CREATE TABLE thinkers (
    id integer NOT NULL,
    name character varying NOT NULL,
    email public.citext NOT NULL,
    uuid uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: thinkers_id_seq; Type: SEQUENCE; Schema: connect; Owner: -
--

CREATE SEQUENCE thinkers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: thinkers_id_seq; Type: SEQUENCE OWNED BY; Schema: connect; Owner: -
--

ALTER SEQUENCE thinkers_id_seq OWNED BY thinkers.id;


SET search_path = public, pg_catalog;

--
-- Name: que_bus_subscribers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE que_bus_subscribers (
    id integer NOT NULL,
    subscriber_id text,
    job_class text NOT NULL,
    topics text
);


--
-- Name: TABLE que_bus_subscribers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_bus_subscribers IS '2';


--
-- Name: que_bus_subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_bus_subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_bus_subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_bus_subscribers_id_seq OWNED BY que_bus_subscribers.id;


--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


SET search_path = connect, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connection_events ALTER COLUMN id SET DEFAULT nextval('connection_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connection_members ALTER COLUMN id SET DEFAULT nextval('connection_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connections ALTER COLUMN id SET DEFAULT nextval('connections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: connect; Owner: -
--

ALTER TABLE ONLY scores ALTER COLUMN id SET DEFAULT nextval('scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: connect; Owner: -
--

ALTER TABLE ONLY thinkers ALTER COLUMN id SET DEFAULT nextval('thinkers_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_bus_subscribers ALTER COLUMN id SET DEFAULT nextval('que_bus_subscribers_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


SET search_path = connect, pg_catalog;

--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: connection_events_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connection_events
    ADD CONSTRAINT connection_events_pkey PRIMARY KEY (id);


--
-- Name: connection_members_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connection_members
    ADD CONSTRAINT connection_members_pkey PRIMARY KEY (id);


--
-- Name: connections_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connections
    ADD CONSTRAINT connections_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scores_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id);


--
-- Name: thinkers_pkey; Type: CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY thinkers
    ADD CONSTRAINT thinkers_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: que_bus_subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_bus_subscribers
    ADD CONSTRAINT que_bus_subscribers_pkey PRIMARY KEY (id);


--
-- Name: que_bus_subscribers_subscriber_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_bus_subscribers
    ADD CONSTRAINT que_bus_subscribers_subscriber_id_key UNIQUE (subscriber_id);


--
-- Name: que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


SET search_path = connect, pg_catalog;

--
-- Name: index_connection_events_on_connection_id; Type: INDEX; Schema: connect; Owner: -
--

CREATE INDEX index_connection_events_on_connection_id ON connection_events USING btree (connection_id);


--
-- Name: index_connection_events_on_initiated_by; Type: INDEX; Schema: connect; Owner: -
--

CREATE INDEX index_connection_events_on_initiated_by ON connection_events USING btree (initiated_by_type, initiated_by_id);


--
-- Name: index_connection_members_on_connection_id; Type: INDEX; Schema: connect; Owner: -
--

CREATE INDEX index_connection_members_on_connection_id ON connection_members USING btree (connection_id);


--
-- Name: index_connection_members_on_connection_id_and_member_id; Type: INDEX; Schema: connect; Owner: -
--

CREATE UNIQUE INDEX index_connection_members_on_connection_id_and_member_id ON connection_members USING btree (connection_id, member_id);


--
-- Name: index_connection_members_on_member_type_and_member_id; Type: INDEX; Schema: connect; Owner: -
--

CREATE INDEX index_connection_members_on_member_type_and_member_id ON connection_members USING btree (member_type, member_id);


--
-- Name: index_connection_on_initiated_by; Type: INDEX; Schema: connect; Owner: -
--

CREATE INDEX index_connection_on_initiated_by ON connections USING btree (initiated_by_type, initiated_by_id);


--
-- Name: index_scores_on_thinker_id; Type: INDEX; Schema: connect; Owner: -
--

CREATE INDEX index_scores_on_thinker_id ON scores USING btree (thinker_id);


--
-- Name: index_scores_on_uuid; Type: INDEX; Schema: connect; Owner: -
--

CREATE UNIQUE INDEX index_scores_on_uuid ON scores USING btree (uuid);


--
-- Name: index_thinkers_on_email; Type: INDEX; Schema: connect; Owner: -
--

CREATE UNIQUE INDEX index_thinkers_on_email ON thinkers USING btree (email);


--
-- Name: index_thinkers_on_uuid; Type: INDEX; Schema: connect; Owner: -
--

CREATE UNIQUE INDEX index_thinkers_on_uuid ON thinkers USING btree (uuid);


--
-- Name: fk_rails_0aaaa32acc; Type: FK CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY scores
    ADD CONSTRAINT fk_rails_0aaaa32acc FOREIGN KEY (thinker_id) REFERENCES thinkers(id) ON DELETE CASCADE;


--
-- Name: fk_rails_7352e0c641; Type: FK CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connection_events
    ADD CONSTRAINT fk_rails_7352e0c641 FOREIGN KEY (connection_id) REFERENCES connections(id) ON DELETE CASCADE;


--
-- Name: fk_rails_8b5000f871; Type: FK CONSTRAINT; Schema: connect; Owner: -
--

ALTER TABLE ONLY connection_members
    ADD CONSTRAINT fk_rails_8b5000f871 FOREIGN KEY (connection_id) REFERENCES connections(id) ON DELETE RESTRICT DEFERRABLE;


--
-- PostgreSQL database dump complete
--

SET search_path TO connect,public;

INSERT INTO "schema_migrations" (version) VALUES
('20170408041637'),
('20170421165139'),
('20170421200003'),
('20170421215528'),
('20170427204432');


