--
-- PostgreSQL database dump
--pg_dump -U postgres -h localhost -p 5432 task_management_db > backup_file.sql


-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: task_priority_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_priority_enum AS ENUM (
    'HIGH',
    'MEDIUM',
    'LOW'
);


ALTER TYPE public.task_priority_enum OWNER TO postgres;

--
-- Name: task_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_status_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'COMPLETED'
);


ALTER TYPE public.task_status_enum OWNER TO postgres;

--
-- Name: token_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.token_type_enum AS ENUM (
    'VERIFICATION',
    'RESET_PASSWORD',
    'ACCESS',
    'REFRESH'
);


ALTER TYPE public.token_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_seq OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text,
    status public.task_status_enum DEFAULT 'PENDING'::public.task_status_enum NOT NULL,
    priority public.task_priority_enum DEFAULT 'MEDIUM'::public.task_priority_enum NOT NULL,
    category character varying,
    "dueDate" timestamp without time zone,
    "isCompleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "createdById" integer,
    "assignedToId" integer,
    "approvedById" integer
);


ALTER TABLE public.task OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_id_seq OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_id_seq OWNED BY public.task.id;


--
-- Name: token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token (
    id integer NOT NULL,
    token character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userId" integer,
    type public.token_type_enum NOT NULL
);


ALTER TABLE public.token OWNER TO postgres;

--
-- Name: token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.token_id_seq OWNER TO postgres;

--
-- Name: token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_id_seq OWNED BY public.token.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    username character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    "avatarUrl" character varying,
    phone character varying,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "roleId" integer,
    id integer NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    "lastActiveAt" timestamp without time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task ALTER COLUMN id SET DEFAULT nextval('public.task_id_seq'::regclass);


--
-- Name: token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token ALTER COLUMN id SET DEFAULT nextval('public.token_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, name) FROM stdin;
1	Admin
2	Manager
3	Collaborator
4	Client
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task (id, title, description, status, priority, category, "dueDate", "isCompleted", "createdAt", "updatedAt", "createdById", "assignedToId", "approvedById") FROM stdin;
12	Write Authentication Module	Implement signup/login/logout functionality	APPROVED	HIGH	Backend	2025-05-10 16:54:09.580225	f	2025-04-26 16:54:09.580225	2025-04-26 16:54:09.580225	9	\N	\N
13	Prepare Project Presentation	Slides and documentation for project kickoff	REJECTED	LOW	Management	2025-05-01 16:54:09.580225	f	2025-04-26 16:54:09.580225	2025-04-26 16:54:09.580225	9	\N	\N
11	Design Database Schema	Create ERD diagram and database models	APPROVED	MEDIUM	Database	2025-05-06 16:54:09.580225	f	2025-04-26 16:54:09.580225	2025-04-27 01:56:17.465374	9	5	1
1	Setup Project Repo	Initialize GitHub repo and basic project setup	APPROVED	HIGH	Development	2025-05-06 16:54:09.580225	f	2025-04-26 16:45:34.171544	2025-04-27 01:52:38.524822	9	5	1
\.


--
-- Data for Name: token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.token (id, token, "createdAt", "userId", type) FROM stdin;
71	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoibWFuYWdlckBleGFtcGxlLmNvbSIsInJvbGUiOiJNYW5hZ2VyIiwiaWF0IjoxNzQ1NzAwMjE3LCJleHAiOjE3NDU3MDIwMTd9.deR0OIIgBgoMQ5RKSLBSVySBNpjqHCj-vikUJJid3XM	2025-04-27 02:43:37.578217	1	ACCESS
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (username, email, password, "avatarUrl", phone, "createdAt", "updatedAt", "roleId", id, "isVerified", "lastActiveAt") FROM stdin;
manager01	manager@example.com	newPass1234	\N	0012323232232	2025-04-21 00:44:04.049909	2025-04-27 02:48:42.168405	2	1	t	2025-04-27 02:48:42.164
Test User	newucser1@example.com	123456	\N	\N	2025-04-22 15:52:05.433177	2025-04-22 15:53:36.433159	\N	10	t	\N
email	tamimc@gmail.com	sdadsadsa231	\N	\N	2025-04-25 01:42:11.066599	2025-04-25 01:42:49.647115	\N	12	t	\N
exampleuser	example@example.com	dsasdasdasda567	\N	23123121	2025-04-26 20:23:10.631456	2025-04-26 22:21:25.484906	4	14	t	2025-04-26 22:21:25.475
nptsdadsa	cje@gmail.com	tamim@gmail.com	\N	\N	2025-04-25 15:12:35.898174	2025-04-25 15:36:39.825719	\N	13	t	\N
managero2	tamim@gmail.com	sdasdadsasda	http://localhost:3000/uploads/1745596537139.jpg	3232132131221	2025-04-24 23:06:34.495483	2025-04-25 21:55:37.143626	2	11	t	2025-04-25 21:55:37.098
collab1	collab1@example.com	$2b$10$Y1eMp.hYuI4E/e2M60g6Z.BYXsSR5SK7YIy7uy4EgpoXFEeemK/ii	\N	\N	2025-04-21 00:45:49.028048	2025-04-21 00:45:49.028048	3	2	t	\N
collab2	johan@example.com	123456	\N	\N	2025-04-22 00:20:39.960898	2025-04-22 00:21:18.675308	3	5	t	\N
Client1	newuser1@example.com	123456	\N	\N	2025-04-22 15:49:38.466003	2025-04-22 15:49:38.466003	4	9	t	\N
\.


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 3, true);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_id_seq', 14, true);


--
-- Name: token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_id_seq', 71, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 14, true);


--
-- Name: token PK_82fae97f905930df5d62a702fc9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT "PK_82fae97f905930df5d62a702fc9" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: task PK_fb213f79ee45060ba925ecd576e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT "PK_fb213f79ee45060ba925ecd576e" PRIMARY KEY (id);


--
-- Name: role UQ_ae4578dcaed5adff96595e61660; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "UQ_ae4578dcaed5adff96595e61660" UNIQUE (name);


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: task FK_197540ab395d97e4012e8a4eb8d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT "FK_197540ab395d97e4012e8a4eb8d" FOREIGN KEY ("approvedById") REFERENCES public."user"(id);


--
-- Name: task FK_91d76dd2ae372b9b7dfb6bf3fd2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT "FK_91d76dd2ae372b9b7dfb6bf3fd2" FOREIGN KEY ("createdById") REFERENCES public."user"(id);


--
-- Name: token FK_94f168faad896c0786646fa3d4a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT "FK_94f168faad896c0786646fa3d4a" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user FK_c28e52f758e7bbc53828db92194; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_c28e52f758e7bbc53828db92194" FOREIGN KEY ("roleId") REFERENCES public.role(id);


--
-- Name: task FK_fd5f652e2fcdc4a5ab30aaff7a7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT "FK_fd5f652e2fcdc4a5ab30aaff7a7" FOREIGN KEY ("assignedToId") REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

