--
-- PostgreSQL database dump
--

\restrict N0toBPKp4ovILkrUmzhEmug0iIivYvcmRvytv23fDpJDSUBcToEZtjhl7jBNoe7

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    member_user_id integer NOT NULL,
    house_number character varying(20),
    street character varying(255),
    town character varying(100)
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    appointment_id integer NOT NULL,
    caregiver_user_id integer,
    member_user_id integer,
    appointment_date date NOT NULL,
    appointment_time time without time zone NOT NULL,
    work_hours numeric(6,2) NOT NULL,
    status character varying(50) NOT NULL
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_appointment_id_seq OWNER TO postgres;

--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_appointment_id_seq OWNED BY public.appointment.appointment_id;


--
-- Name: caregiver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caregiver (
    caregiver_user_id integer NOT NULL,
    photo character varying(255),
    gender character varying(20),
    caregiving_type character varying(100),
    hourly_rate numeric(8,2) NOT NULL
);


ALTER TABLE public.caregiver OWNER TO postgres;

--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    job_id integer NOT NULL,
    member_user_id integer,
    required_caregiving_type character varying(100),
    other_requirements text,
    date_posted date NOT NULL
);


ALTER TABLE public.job OWNER TO postgres;

--
-- Name: job_application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_application (
    caregiver_user_id integer NOT NULL,
    job_id integer NOT NULL,
    date_applied date NOT NULL
);


ALTER TABLE public.job_application OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    given_name character varying(100) NOT NULL,
    surname character varying(100) NOT NULL,
    city character varying(100),
    phone_number character varying(50),
    profile_description text,
    password character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: job_applicants; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.job_applicants AS
 SELECT ja.job_id,
    ja.date_applied,
    u.user_id AS applicant_user_id,
    u.given_name,
    u.surname,
    c.caregiving_type,
    c.hourly_rate
   FROM ((public.job_application ja
     JOIN public.caregiver c ON ((ja.caregiver_user_id = c.caregiver_user_id)))
     JOIN public.users u ON ((c.caregiver_user_id = u.user_id)));


ALTER TABLE public.job_applicants OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_job_id_seq OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_job_id_seq OWNED BY public.job.job_id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    member_user_id integer NOT NULL,
    house_rules text,
    dependent_description text
);


ALTER TABLE public.member OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: appointment appointment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointment_appointment_id_seq'::regclass);


--
-- Name: job job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job ALTER COLUMN job_id SET DEFAULT nextval('public.job_job_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (member_user_id, house_number, street, town) FROM stdin;
8	45	Azattyq	Astana
9	7	Al-Farabi	Almaty
11	20	Dostyk	Astana
12	3	Saryarka	Astana
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment (appointment_id, caregiver_user_id, member_user_id, appointment_date, appointment_time, work_hours, status) FROM stdin;
2	3	8	2025-10-03	18:00:00	3.50	accepted
3	4	9	2025-10-05	14:00:00	5.00	pending
5	6	8	2025-10-09	10:00:00	2.50	rejected
6	1	11	2025-10-11	09:00:00	6.00	accepted
7	4	12	2025-10-13	08:00:00	3.00	accepted
\.


--
-- Data for Name: caregiver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caregiver (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) FROM stdin;
3	bekzat.jpg	male	Babysitter	9.80
5	nurzhan.jpg	male	Night Care	8.80
1	arman.jpg	male	Elderly Care	13.20
4	gulnara.jpg	female	Elderly Care	16.50
6	aliya.jpg	female	Babysitter	12.10
7	serik.jpg	male	Special Needs	14.30
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (job_id, member_user_id, required_caregiving_type, other_requirements, date_posted) FROM stdin;
2	8	Babysitter	Evening hours; CPR certified	2025-09-05
3	9	Elderly Care	No heavy lifting; patient required	2025-09-10
6	11	Elderly Care	Soft-spoken; experience with dementia	2025-09-18
7	12	Elderly Care	Weekly visits; companionship	2025-09-20
8	8	Babysitter	Weekend mornings	2025-09-22
10	8	Babysitter	No pets; fun with kids	2025-09-28
11	9	Elderly Care	Soft-spoken and patient	2025-09-30
\.


--
-- Data for Name: job_application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_application (caregiver_user_id, job_id, date_applied) FROM stdin;
3	2	2025-09-06
6	2	2025-09-07
3	8	2025-09-23
6	10	2025-09-29
1	3	2025-09-11
4	6	2025-09-19
7	7	2025-09-21
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member (member_user_id, house_rules, dependent_description) FROM stdin;
8	No pets	Toddler, 2 years old.
9	No smoking	Elderly mother with mobility issues.
11	No pets	Senior with dementia.
12	No shoes indoors; No pets	Elderly, needs weekly visits.
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, given_name, surname, city, phone_number, profile_description, password) FROM stdin;
2	amina.aminova@example.com	Amina	Aminova	Almaty	+77007654321	Looking for part-time caregiver roles.	pass2
3	bekzat.s@example.com	Bekzat	Suleimenov	Astana	+77001112233	Reliable babysitter and tutor.	pass3
4	gulnara.g@example.com	Gulnara	Gabitova	Shymkent	+77004445566	Compassionate elderly-care specialist.	pass4
5	nurzhan.n@example.com	Nurzhan	Nuraliev	Astana	+77005556677	Nightshift caregiver available.	pass5
6	aliya.a@example.com	Aliya	Akhmetova	Astana	+77006667788	Baby-sitting and light housekeeping.	pass6
7	serik.s@example.com	Serik	Sadykov	Karaganda	+77007778899	Experienced with special needs dependents.	pass7
8	zhanar.z@example.com	Zhanar	Zhaksylyk	Astana	+77008889900	Seeking daytime help for toddler.	pass8
9	diana.d@example.com	Diana	Dosanova	Almaty	+77009990011	Looking after elderly mother.	pass9
10	olzhas.o@example.com	Olzhas	Ospanov	Astana	+77010011000	Flexible caregiver.	pass10
11	madina.m@example.com	Madina	Muratova	Astana	+77012013014	No pets at home.	pass11
12	yerbol.y@example.com	Yerbol	Yessimov	Astana	+77014015016	Part-time elder care.	pass12
1	arman.armanov@example.com	Arman	Armanov	Astana	+77773414141	Experienced caregiver for elderly clients.	pass1
\.


--
-- Name: appointment_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_appointment_id_seq', 8, true);


--
-- Name: job_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_job_id_seq', 12, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 12, true);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (member_user_id);


--
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id);


--
-- Name: caregiver caregiver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver
    ADD CONSTRAINT caregiver_pkey PRIMARY KEY (caregiver_user_id);


--
-- Name: job_application job_application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_pkey PRIMARY KEY (caregiver_user_id, job_id);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: address address_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- Name: appointment appointment_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregiver(caregiver_user_id) ON DELETE CASCADE;


--
-- Name: appointment appointment_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- Name: caregiver caregiver_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver
    ADD CONSTRAINT caregiver_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: job_application job_application_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregiver(caregiver_user_id) ON DELETE CASCADE;


--
-- Name: job_application job_application_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.job(job_id) ON DELETE CASCADE;


--
-- Name: job job_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- Name: member member_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict N0toBPKp4ovILkrUmzhEmug0iIivYvcmRvytv23fDpJDSUBcToEZtjhl7jBNoe7

