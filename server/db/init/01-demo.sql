--
-- PostgreSQL database dump
--


-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

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

ALTER TABLE IF EXISTS ONLY public.workout_sets DROP CONSTRAINT IF EXISTS workout_sets_session_id_fkey;
ALTER TABLE IF EXISTS ONLY public.workout_sets DROP CONSTRAINT IF EXISTS workout_sets_exercise_id_fkey;
ALTER TABLE IF EXISTS ONLY public.workout_sessions DROP CONSTRAINT IF EXISTS workout_sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.workout_sessions DROP CONSTRAINT IF EXISTS workout_sessions_routine_id_fkey;
ALTER TABLE IF EXISTS ONLY public.workout_sessions DROP CONSTRAINT IF EXISTS workout_sessions_routine_day_id_fkey;
ALTER TABLE IF EXISTS ONLY public.security_audit_log DROP CONSTRAINT IF EXISTS security_audit_log_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routines DROP CONSTRAINT IF EXISTS routines_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routines DROP CONSTRAINT IF EXISTS routines_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.routine_days DROP CONSTRAINT IF EXISTS routine_days_routine_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routine_day_exercises DROP CONSTRAINT IF EXISTS routine_day_exercises_routine_day_id_fkey;
ALTER TABLE IF EXISTS ONLY public.routine_day_exercises DROP CONSTRAINT IF EXISTS routine_day_exercises_exercise_id_fkey;
ALTER TABLE IF EXISTS ONLY public.role_requests DROP CONSTRAINT IF EXISTS role_requests_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.role_requests DROP CONSTRAINT IF EXISTS role_requests_reviewed_by_fkey;
ALTER TABLE IF EXISTS ONLY public.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_replaced_by_fkey;
ALTER TABLE IF EXISTS ONLY public.personal_records DROP CONSTRAINT IF EXISTS personal_records_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.personal_records DROP CONSTRAINT IF EXISTS personal_records_session_id_fkey;
ALTER TABLE IF EXISTS ONLY public.personal_records DROP CONSTRAINT IF EXISTS personal_records_exercise_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notification_reads DROP CONSTRAINT IF EXISTS notification_reads_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lift_submissions DROP CONSTRAINT IF EXISTS lift_submissions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lift_submissions DROP CONSTRAINT IF EXISTS lift_submissions_reviewed_by_fkey;
ALTER TABLE IF EXISTS ONLY public.lift_submissions DROP CONSTRAINT IF EXISTS lift_submissions_exercise_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lift_submission_images DROP CONSTRAINT IF EXISTS lift_submission_images_submission_id_fkey;
ALTER TABLE IF EXISTS ONLY public.joint_exercises DROP CONSTRAINT IF EXISTS joint_exercises_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.hiit_workouts DROP CONSTRAINT IF EXISTS hiit_workouts_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hiit_sessions DROP CONSTRAINT IF EXISTS hiit_sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hiit_sessions DROP CONSTRAINT IF EXISTS hiit_sessions_hiit_workout_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hiit_lists DROP CONSTRAINT IF EXISTS hiit_lists_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.exercises DROP CONSTRAINT IF EXISTS exercises_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_event_id_fkey;
ALTER TABLE IF EXISTS ONLY public.body_measurements DROP CONSTRAINT IF EXISTS body_measurements_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.articles DROP CONSTRAINT IF EXISTS articles_author_id_fkey;
ALTER TABLE IF EXISTS ONLY public.article_favorites DROP CONSTRAINT IF EXISTS article_favorites_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.article_favorites DROP CONSTRAINT IF EXISTS article_favorites_article_id_fkey;
ALTER TABLE IF EXISTS ONLY public.app_notifications DROP CONSTRAINT IF EXISTS app_notifications_created_by_fkey;
DROP TRIGGER IF EXISTS users_updated_at ON public.users;
DROP TRIGGER IF EXISTS routines_updated_at ON public.routines;
DROP TRIGGER IF EXISTS events_updated_at ON public.events;
DROP TRIGGER IF EXISTS articles_updated_at ON public.articles;
DROP INDEX IF EXISTS public.idx_users_role;
DROP INDEX IF EXISTS public.idx_users_email;
DROP INDEX IF EXISTS public.idx_users_active;
DROP INDEX IF EXISTS public.idx_sets_session_id;
DROP INDEX IF EXISTS public.idx_sets_exercise_id;
DROP INDEX IF EXISTS public.idx_sessions_user_started;
DROP INDEX IF EXISTS public.idx_sessions_user_id;
DROP INDEX IF EXISTS public.idx_sessions_started_at;
DROP INDEX IF EXISTS public.idx_routines_user_id;
DROP INDEX IF EXISTS public.idx_routines_public;
DROP INDEX IF EXISTS public.idx_routine_days_routine_id;
DROP INDEX IF EXISTS public.idx_role_requests_user;
DROP INDEX IF EXISTS public.idx_role_requests_pending;
DROP INDEX IF EXISTS public.idx_refresh_tokens_user_id;
DROP INDEX IF EXISTS public.idx_refresh_tokens_hash;
DROP INDEX IF EXISTS public.idx_refresh_tokens_expires;
DROP INDEX IF EXISTS public.idx_rde_routine_day_id;
DROP INDEX IF EXISTS public.idx_pr_validated;
DROP INDEX IF EXISTS public.idx_pr_user_id;
DROP INDEX IF EXISTS public.idx_pr_exercise_id;
DROP INDEX IF EXISTS public.idx_notif_reads_user;
DROP INDEX IF EXISTS public.idx_measurements_user_id;
DROP INDEX IF EXISTS public.idx_measurements_date;
DROP INDEX IF EXISTS public.idx_lift_submissions_user;
DROP INDEX IF EXISTS public.idx_lift_submissions_pending;
DROP INDEX IF EXISTS public.idx_lift_submissions_exercise;
DROP INDEX IF EXISTS public.idx_lift_submission_images;
DROP INDEX IF EXISTS public.idx_joint_exercises_family;
DROP INDEX IF EXISTS public.idx_joint_exercises_active;
DROP INDEX IF EXISTS public.idx_hiit_workouts_user;
DROP INDEX IF EXISTS public.idx_hiit_sessions_user;
DROP INDEX IF EXISTS public.idx_hiit_lists_user;
DROP INDEX IF EXISTS public.idx_exercises_muscle_group;
DROP INDEX IF EXISTS public.idx_exercises_difficulty;
DROP INDEX IF EXISTS public.idx_exercises_active;
DROP INDEX IF EXISTS public.idx_events_date;
DROP INDEX IF EXISTS public.idx_events_active;
DROP INDEX IF EXISTS public.idx_event_interests_event;
DROP INDEX IF EXISTS public.idx_careers_active;
DROP INDEX IF EXISTS public.idx_audit_user_id;
DROP INDEX IF EXISTS public.idx_audit_created;
DROP INDEX IF EXISTS public.idx_articles_published;
DROP INDEX IF EXISTS public.idx_articles_category;
ALTER TABLE IF EXISTS ONLY public.workout_sets DROP CONSTRAINT IF EXISTS workout_sets_pkey;
ALTER TABLE IF EXISTS ONLY public.workout_sessions DROP CONSTRAINT IF EXISTS workout_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.security_audit_log DROP CONSTRAINT IF EXISTS security_audit_log_pkey;
ALTER TABLE IF EXISTS ONLY public.routines DROP CONSTRAINT IF EXISTS routines_pkey;
ALTER TABLE IF EXISTS ONLY public.routine_days DROP CONSTRAINT IF EXISTS routine_days_pkey;
ALTER TABLE IF EXISTS ONLY public.routine_day_exercises DROP CONSTRAINT IF EXISTS routine_day_exercises_pkey;
ALTER TABLE IF EXISTS ONLY public.role_requests DROP CONSTRAINT IF EXISTS role_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_hash_key;
ALTER TABLE IF EXISTS ONLY public.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.personal_records DROP CONSTRAINT IF EXISTS personal_records_user_id_exercise_id_reps_key;
ALTER TABLE IF EXISTS ONLY public.personal_records DROP CONSTRAINT IF EXISTS personal_records_pkey;
ALTER TABLE IF EXISTS ONLY public.notification_reads DROP CONSTRAINT IF EXISTS notification_reads_pkey;
ALTER TABLE IF EXISTS ONLY public.lift_submissions DROP CONSTRAINT IF EXISTS lift_submissions_pkey;
ALTER TABLE IF EXISTS ONLY public.lift_submission_images DROP CONSTRAINT IF EXISTS lift_submission_images_pkey;
ALTER TABLE IF EXISTS ONLY public.joint_exercises DROP CONSTRAINT IF EXISTS joint_exercises_pkey;
ALTER TABLE IF EXISTS ONLY public.hiit_workouts DROP CONSTRAINT IF EXISTS hiit_workouts_pkey;
ALTER TABLE IF EXISTS ONLY public.hiit_sessions DROP CONSTRAINT IF EXISTS hiit_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.hiit_lists DROP CONSTRAINT IF EXISTS hiit_lists_pkey;
ALTER TABLE IF EXISTS ONLY public.exercises DROP CONSTRAINT IF EXISTS exercises_pkey;
ALTER TABLE IF EXISTS ONLY public.events DROP CONSTRAINT IF EXISTS events_pkey;
ALTER TABLE IF EXISTS ONLY public.event_interests DROP CONSTRAINT IF EXISTS event_interests_pkey;
ALTER TABLE IF EXISTS ONLY public.careers DROP CONSTRAINT IF EXISTS careers_pkey;
ALTER TABLE IF EXISTS ONLY public.careers DROP CONSTRAINT IF EXISTS careers_name_key;
ALTER TABLE IF EXISTS ONLY public.body_measurements DROP CONSTRAINT IF EXISTS body_measurements_pkey;
ALTER TABLE IF EXISTS ONLY public.articles DROP CONSTRAINT IF EXISTS articles_pkey;
ALTER TABLE IF EXISTS ONLY public.article_favorites DROP CONSTRAINT IF EXISTS article_favorites_pkey;
ALTER TABLE IF EXISTS ONLY public.app_notifications DROP CONSTRAINT IF EXISTS app_notifications_pkey;
DROP TABLE IF EXISTS public.workout_sets;
DROP TABLE IF EXISTS public.workout_sessions;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.security_audit_log;
DROP TABLE IF EXISTS public.routines;
DROP TABLE IF EXISTS public.routine_days;
DROP TABLE IF EXISTS public.routine_day_exercises;
DROP TABLE IF EXISTS public.role_requests;
DROP TABLE IF EXISTS public.refresh_tokens;
DROP TABLE IF EXISTS public.personal_records;
DROP TABLE IF EXISTS public.notification_reads;
DROP TABLE IF EXISTS public.lift_submissions;
DROP TABLE IF EXISTS public.lift_submission_images;
DROP TABLE IF EXISTS public.joint_exercises;
DROP TABLE IF EXISTS public.hiit_workouts;
DROP TABLE IF EXISTS public.hiit_sessions;
DROP TABLE IF EXISTS public.hiit_lists;
DROP TABLE IF EXISTS public.exercises;
DROP TABLE IF EXISTS public.events;
DROP TABLE IF EXISTS public.event_interests;
DROP TABLE IF EXISTS public.careers;
DROP TABLE IF EXISTS public.body_measurements;
DROP TABLE IF EXISTS public.articles;
DROP TABLE IF EXISTS public.article_favorites;
DROP TABLE IF EXISTS public.app_notifications;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP TYPE IF EXISTS public.workout_session_status;
DROP TYPE IF EXISTS public.workout_goal;
DROP TYPE IF EXISTS public.user_role;
DROP TYPE IF EXISTS public.muscle_group;
DROP TYPE IF EXISTS public.lift_submission_status;
DROP TYPE IF EXISTS public.hiit_mode;
DROP TYPE IF EXISTS public.difficulty_level;
DROP TYPE IF EXISTS public.audit_action;
--
-- Name: audit_action; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_action AS ENUM (
    'login',
    'logout',
    'login_failed',
    'role_changed',
    'password_changed',
    'account_created',
    'account_deactivated'
);


--
-- Name: difficulty_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.difficulty_level AS ENUM (
    'principiante',
    'intermedio',
    'avanzado'
);


--
-- Name: hiit_mode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.hiit_mode AS ENUM (
    'tabata',
    'emom',
    'amrap',
    'for_time',
    'mix'
);


--
-- Name: lift_submission_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.lift_submission_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);


--
-- Name: muscle_group; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.muscle_group AS ENUM (
    'pecho',
    'espalda',
    'piernas',
    'hombros',
    'brazos',
    'core',
    'gluteos'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'student',
    'professor',
    'staff',
    'admin'
);


--
-- Name: workout_goal; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workout_goal AS ENUM (
    'fuerza',
    'hipertrofia',
    'resistencia',
    'perdida_de_peso'
);


--
-- Name: workout_session_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workout_session_status AS ENUM (
    'in_progress',
    'completed',
    'partial'
);


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
  END;
  $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type character varying(30) DEFAULT 'news'::character varying NOT NULL,
    title character varying(255) NOT NULL,
    body text NOT NULL,
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT app_notifications_type_check CHECK (((type)::text = ANY ((ARRAY['news'::character varying, 'patch'::character varying, 'feature'::character varying, 'reminder'::character varying])::text[])))
);


--
-- Name: article_favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article_favorites (
    user_id uuid NOT NULL,
    article_id uuid NOT NULL,
    saved_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    category character varying(100) NOT NULL,
    read_time_minutes integer DEFAULT 5 NOT NULL,
    excerpt text,
    content text NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    author_id uuid,
    is_published boolean DEFAULT false NOT NULL,
    published_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url text,
    bibliography text,
    resources jsonb
);


--
-- Name: body_measurements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.body_measurements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    measured_at date DEFAULT CURRENT_DATE NOT NULL,
    weight_kg numeric(5,2),
    body_fat_pct numeric(4,1),
    chest_cm numeric(5,1),
    waist_cm numeric(5,1),
    hip_cm numeric(5,1),
    arm_cm numeric(5,1),
    leg_cm numeric(5,1),
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: careers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.careers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: event_interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_interests (
    user_id uuid NOT NULL,
    event_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(100) NOT NULL,
    event_date date NOT NULL,
    event_time time without time zone,
    location character varying(255),
    description text,
    max_participants integer,
    registration_url character varying(500),
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    image_url text,
    end_date timestamp with time zone
);


--
-- Name: exercises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exercises (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    muscle_group public.muscle_group NOT NULL,
    difficulty public.difficulty_level NOT NULL,
    description text,
    muscles text[] DEFAULT '{}'::text[] NOT NULL,
    instructions text[] DEFAULT '{}'::text[] NOT NULL,
    safety_notes text,
    variations text[] DEFAULT '{}'::text[] NOT NULL,
    video_url character varying(500),
    image_url text,
    step_images text[] DEFAULT '{}'::text[] NOT NULL,
    equipment character varying(255),
    default_sets integer DEFAULT 3 NOT NULL,
    default_reps character varying(20) DEFAULT '8-12'::character varying NOT NULL,
    default_rest_seconds integer DEFAULT 90 NOT NULL,
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    exercise_type text DEFAULT 'dinamico'::text NOT NULL,
    is_rankeable boolean DEFAULT false NOT NULL,
    CONSTRAINT exercises_exercise_type_check CHECK ((exercise_type = ANY (ARRAY['dinamico'::text, 'isometrico'::text, 'calistenia'::text])))
);


--
-- Name: hiit_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hiit_lists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text NOT NULL,
    exercises jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: hiit_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hiit_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    hiit_workout_id uuid,
    name character varying(255) NOT NULL,
    mode public.hiit_mode NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    total_duration_seconds integer,
    rounds_completed integer DEFAULT 0 NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: hiit_workouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hiit_workouts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    name character varying(255) NOT NULL,
    mode public.hiit_mode NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: joint_exercises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.joint_exercises (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(20) NOT NULL,
    joint_family character varying(50) NOT NULL,
    instructions text[] DEFAULT '{}'::text[] NOT NULL,
    benefits text,
    when_to_use text,
    created_by uuid,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT joint_exercises_type_check CHECK (((type)::text = ANY ((ARRAY['movilidad'::character varying, 'fortalecimiento'::character varying])::text[])))
);


--
-- Name: lift_submission_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lift_submission_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    submission_id uuid NOT NULL,
    image_url character varying(500) NOT NULL,
    sort_order smallint DEFAULT 0 NOT NULL,
    uploaded_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: lift_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lift_submissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    exercise_id uuid NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    reps smallint DEFAULT 1 NOT NULL,
    location_name character varying(300),
    location_lat double precision,
    location_lng double precision,
    description text,
    was_witnessed boolean DEFAULT false NOT NULL,
    witness_name character varying(200),
    video_url character varying(500) NOT NULL,
    status public.lift_submission_status DEFAULT 'pending'::public.lift_submission_status NOT NULL,
    reviewed_by uuid,
    review_comment text,
    reviewed_at timestamp with time zone,
    is_record_breaking boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT lift_submissions_reps_check CHECK ((reps > 0)),
    CONSTRAINT lift_submissions_weight_kg_check CHECK ((weight_kg > (0)::numeric))
);


--
-- Name: notification_reads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_reads (
    user_id uuid NOT NULL,
    notif_type character varying(20) NOT NULL,
    reference_id uuid NOT NULL,
    read_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: personal_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    exercise_id uuid NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    reps integer DEFAULT 1 NOT NULL,
    achieved_at timestamp with time zone DEFAULT now() NOT NULL,
    session_id uuid,
    is_validated boolean DEFAULT false NOT NULL,
    duration_seconds integer
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    is_revoked boolean DEFAULT false NOT NULL,
    replaced_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: role_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    justification text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    reviewed_by uuid,
    review_comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    reviewed_at timestamp with time zone
);


--
-- Name: routine_day_exercises; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routine_day_exercises (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    routine_day_id uuid NOT NULL,
    exercise_id uuid NOT NULL,
    sets integer DEFAULT 3 NOT NULL,
    reps character varying(20) DEFAULT '8-12'::character varying NOT NULL,
    rest_seconds integer DEFAULT 90 NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    rir integer,
    duration_seconds integer,
    target_weight_kg numeric(6,2)
);


--
-- Name: routine_days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routine_days (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    routine_id uuid NOT NULL,
    day_name character varying(20) NOT NULL,
    label character varying(255) NOT NULL,
    order_index integer DEFAULT 0 NOT NULL
);


--
-- Name: routines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routines (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    name character varying(255) NOT NULL,
    description text,
    goal public.workout_goal DEFAULT 'hipertrofia'::public.workout_goal NOT NULL,
    frequency_days integer DEFAULT 3 NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    created_by uuid NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_default boolean DEFAULT false NOT NULL
);


--
-- Name: security_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.security_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    action public.audit_action NOT NULL,
    ip_address inet,
    user_agent text,
    details jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    career character varying(255),
    role public.user_role DEFAULT 'student'::public.user_role NOT NULL,
    weight_kg numeric(5,2),
    height_cm integer,
    body_fat_pct numeric(4,1),
    units character varying(3) DEFAULT 'kg'::character varying NOT NULL,
    notifications_enabled boolean DEFAULT true NOT NULL,
    private_profile boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    member_since date DEFAULT CURRENT_DATE NOT NULL,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    faculty text,
    fitness_level public.difficulty_level DEFAULT 'principiante'::public.difficulty_level NOT NULL,
    CONSTRAINT users_units_check CHECK (((units)::text = ANY ((ARRAY['kg'::character varying, 'lbs'::character varying])::text[])))
);


--
-- Name: workout_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workout_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    routine_id uuid,
    routine_day_id uuid,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone,
    duration_minutes integer,
    total_volume_kg numeric(10,2),
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    status public.workout_session_status DEFAULT 'in_progress'::public.workout_session_status NOT NULL,
    early_finish_reason text
);


--
-- Name: workout_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workout_sets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    exercise_id uuid NOT NULL,
    set_number integer NOT NULL,
    weight_kg numeric(6,2),
    reps integer,
    completed boolean DEFAULT false NOT NULL,
    rpe smallint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    duration_seconds integer,
    target_weight_kg numeric(6,2),
    target_reps integer,
    target_duration_seconds integer,
    CONSTRAINT workout_sets_rpe_check CHECK (((rpe >= 1) AND (rpe <= 10)))
);


--
-- Data for Name: app_notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_notifications (id, type, title, body, created_by, is_active, created_at) FROM stdin;
269cae3f-6e07-43cf-b31e-2bb4ce6628a1	feature	Nuevo récord	Ivan Salas rompió el récord de Press de Banca con 90.0 kg	\N	t	2026-07-05 21:45:35.525657+00
e1e4f277-d10e-4502-81c5-9086e45646ca	feature	Nuevo récord	Ivan Salas rompió el récord de Peso Muerto con 140.0 kg	\N	t	2026-07-05 21:45:35.539692+00
12869bb7-378d-483b-b33a-c0e36d505519	feature	Nuevo récord	Profesor QA Martinez rompió el récord de Sentadilla con Barra con 150.0 kg	\N	t	2026-07-05 21:45:35.553288+00
4b86f4e6-e6b8-4352-92ed-86ca24c957a7	feature	Nuevo récord	Ivan Salas rompió el récord de Press de Banca con 90.0 kg	\N	t	2026-07-05 21:58:18.642136+00
b72cd7ad-06a9-4832-9198-8d9b0fc6a3ee	feature	Nuevo récord	Ivan Salas rompió el récord de Peso Muerto con 140.0 kg	\N	t	2026-07-05 21:58:18.657086+00
6fdb3709-e522-45cc-a242-ea645dfea21e	feature	Nuevo récord	Profesor QA Martinez rompió el récord de Sentadilla con Barra con 150.0 kg	\N	t	2026-07-05 21:58:18.669419+00
30ce21fa-d100-4e57-854f-a102ef73f182	feature	Nuevo récord	Pedro Munoz rompió el récord de Press de Banca con 105.0 kg	\N	t	2026-07-05 22:17:34.952005+00
7e616514-44aa-4fe6-ad18-521e56cec7c4	feature	Nuevo récord	Pedro Munoz rompió el récord de Peso Muerto con 160.0 kg	\N	t	2026-07-05 22:17:34.96832+00
a2077142-a7c9-43ed-a1a0-6fe8d2c797ae	feature	Nuevo récord	Diego Contreras rompió el récord de Peso Muerto con 210.0 kg	\N	t	2026-07-05 22:17:34.98382+00
93d1c5e3-f40b-4e3a-a3dd-8e9175617d4f	feature	Nuevo récord	Diego Contreras rompió el récord de Press Militar con Barra con 85.0 kg	\N	t	2026-07-05 22:17:35.00047+00
\.


--
-- Data for Name: article_favorites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.article_favorites (user_id, article_id, saved_at) FROM stdin;
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.articles (id, title, category, read_time_minutes, excerpt, content, tags, author_id, is_published, published_at, created_at, updated_at, image_url, bibliography, resources) FROM stdin;
b14334d9-9449-4081-8598-6fd83339416d	Técnica correcta de la sentadilla: cómo prevenir lesiones	biomecanica	1	\N	La sentadilla es uno de los ejercicios más completos del entrenamiento de fuerza, pero también uno de los que más lesiones genera cuando se ejecuta incorrectamente.\n\n## Posición inicial\n\nLos pies deben estar a la anchura de los hombros o ligeramente más separados, con los pies apuntando ligeramente hacia afuera (entre 15 y 30 grados).\n\n## Fase de descenso\n\nInicia el movimiento empujando las caderas hacia atrás antes de doblar las rodillas. Las rodillas deben seguir la dirección de los pies.\n\n## Profundidad adecuada\n\nEl objetivo es alcanzar al menos los 90 grados (muslos paralelos al suelo), pero la prioridad siempre es mantener la postura correcta.\n\n## Errores más frecuentes\n\n- Talones que se levantan del suelo: indica falta de movilidad en el tobillo.\n- Redondeo de la espalda baja: por falta de fuerza en el core.\n- Colapso de rodillas: por glúteo medio débil.\n\nLa paciencia en la construcción de la técnica es la mejor inversión que puedes hacer.\n	{sentadilla,técnica,rodillas,espalda}	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.665293+00	2026-07-05 18:27:29.665293+00	2026-07-05 18:27:29.665293+00	\N	\N	\N
663deff8-283d-4667-b376-ab0331700a78	Nutrición pre-entrenamiento: qué comer y cuándo	nutricion	1	\N	Lo que comes antes de entrenar puede marcar una diferencia significativa en tu rendimiento.\n\n## El rol de los macronutrientes\n\nLos carbohidratos son la fuente de energía preferida del músculo durante el ejercicio de alta intensidad. Consumir carbohidratos 1-3 horas antes del entrenamiento asegura que los depósitos de glucógeno estén llenos.\n\nUna porción moderada de proteína antes de entrenar reduce el catabolismo muscular y facilita la síntesis proteica post-entrenamiento.\n\n## Timing\n\n- **2-3 horas antes**: comida completa con carbohidratos complejos y proteínas.\n- **1-1,5 horas antes**: comida más liviana.\n- **30-45 minutos antes**: snack rápido como un plátano con mantequilla de maní.\n\n## Hidratación\n\nLlega bien hidratado al entrenamiento. El rendimiento decrece con apenas un 2% de deshidratación.\n	{nutricion,pre-entreno,carbohidratos,proteína}	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.67062+00	2026-07-05 18:27:29.67062+00	2026-07-05 18:27:29.67062+00	\N	\N	\N
8ae272c8-525e-46ee-8705-49dcfcf1682e	Prevención de lesiones de hombro en el gimnasio	prevencion	1	\N	El hombro es la articulación con mayor movilidad del cuerpo humano, y por eso también es una de las más susceptibles a lesiones.\n\n## Errores comunes que generan lesiones\n\n- Press de banca con agarre demasiado ancho.\n- Dominadas y jalones detrás del cuello.\n- Press militar con excesiva extensión lumbar.\n\n## Ejercicios preventivos clave\n\n1. Rotaciones externas con banda elástica: 3 series de 15 reps.\n2. Face pulls con polea alta: activa el manguito posterior.\n3. YTW con mancuernas livianas: estabilizadora escapular.\n\nIncluye 2-3 series de ejercicios preventivos al inicio de cada sesión de empuje.\n	{hombro,"manguito rotador",lesión,prevención}	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.674348+00	2026-07-05 18:27:29.674348+00	2026-07-05 18:27:29.674348+00	\N	\N	\N
e62864e8-5d3c-42f8-b523-1701817562d3	Pausas activas en el trabajo: beneficios y rutina de 10 minutos	pausas_activas	1	\N	El sedentarismo prolongado es uno de los principales factores de riesgo para el dolor músculo-esquelético.\n\n## Beneficios comprobados\n\n- Reducción del dolor cervical y lumbar hasta un 40%.\n- Mejora de la concentración y productividad.\n- Prevención del síndrome de túnel carpiano.\n\n## Rutina de pausa activa (10 minutos)\n\n**Cuello y cervicales (2 min):** Rotaciones cervicales, inclinaciones laterales, retracción cefálica.\n\n**Hombros (3 min):** Círculos de hombros, apertura de pectorales, encogimientos y retracción escapular.\n\n**Espalda baja y caderas (3 min):** Rotaciones de cadera, inclinación suave hacia adelante.\n\n**Activación general (2 min):** 20 saltos de tijera, marcha en el lugar.\n\nPrograma recordatorios cada 90 minutos para máximo beneficio.\n	{"pausa activa",oficina,sedentarismo,movilidad}	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.679115+00	2026-07-05 18:27:29.679115+00	2026-07-05 18:27:29.679115+00	\N	\N	\N
6d73ec81-7e7c-48bf-a4f9-388dc1614b53	Recuperación muscular: estrategias basadas en evidencia	recuperacion	1	\N	La recuperación es un proceso activo mediante el cual el músculo se adapta al estímulo del entrenamiento.\n\n## Estrategias con mayor evidencia científica\n\n**1. Sueño de calidad:** 7-9 horas para adultos activos. Durante el sueño profundo se libera la mayor concentración de hormona de crecimiento.\n\n**2. Nutrición post-entrenamiento:** Carbohidratos + proteínas dentro de las 2 horas post-ejercicio. Proporción 3:1 como guía práctica.\n\n**3. Hidratación:** Orina de color amarillo pálido como indicador de buena hidratación.\n\n**4. Baños de contraste:** Agua fría (10-15°C, 1 min) alternada con agua caliente (38-40°C, 2 min) puede reducir el DOMS.\n\n**5. Movilidad activa:** 30-45 minutos de cardio suave al 50-60% de FCmáx aumenta el flujo sanguíneo sin generar daño adicional.\n	{recuperación,descanso,DOMS,sueño}	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.682872+00	2026-07-05 18:27:29.682872+00	2026-07-05 18:27:29.682872+00	\N	\N	\N
\.


--
-- Data for Name: body_measurements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.body_measurements (id, user_id, measured_at, weight_kg, body_fat_pct, chest_cm, waist_cm, hip_cm, arm_cm, leg_cm, notes, created_at) FROM stdin;
f8bfe648-fbba-4254-892b-562be555ed7c	a127e44e-8a23-401d-9c52-52d16c6a3282	2026-07-05	78.50	18.2	102.0	84.0	98.0	35.0	58.0	Medicion QA inicial	2026-07-05 21:27:41.069317+00
3635360b-144f-443a-b04a-a9c8ef934726	4fb46b65-f43a-4765-97f2-ff887468cf41	2026-06-17	62.00	25.0	94.9	73.7	94.4	29.3	49.6	Medicion QA -18d	2026-07-05 22:17:22.917724+00
603c9570-7957-45de-b3ae-8421a8cfabf6	4fb46b65-f43a-4765-97f2-ff887468cf41	2026-06-23	61.70	19.2	96.0	85.5	103.8	34.2	52.6	Medicion QA -12d	2026-07-05 22:17:23.063165+00
eaacd449-11fb-4056-9066-961f210b8451	4fb46b65-f43a-4765-97f2-ff887468cf41	2026-06-29	61.40	16.8	86.7	73.3	98.5	26.1	58.0	Medicion QA -6d	2026-07-05 22:17:23.232944+00
e9376160-38f9-4a81-a50a-147c740badb3	4fb46b65-f43a-4765-97f2-ff887468cf41	2026-07-05	61.10	16.2	90.6	73.2	96.6	33.3	51.8	Medicion QA -0d	2026-07-05 22:17:23.394112+00
ea5ec2a7-6754-4b79-a9b6-c529acda7956	03455fe8-05e0-4138-a7ed-df01b34314f2	2026-06-17	79.00	19.8	98.1	87.6	89.4	33.9	58.9	Medicion QA -18d	2026-07-05 22:17:25.685902+00
ed4e9a92-e7b8-429e-9fda-bb1f6a783e82	03455fe8-05e0-4138-a7ed-df01b34314f2	2026-06-23	78.70	23.4	100.0	80.5	90.9	35.5	52.0	Medicion QA -12d	2026-07-05 22:17:25.841226+00
b4e3e552-ae04-46cf-a31c-a4ac89b62cd5	03455fe8-05e0-4138-a7ed-df01b34314f2	2026-06-29	78.40	23.6	104.4	78.7	94.4	37.4	56.7	Medicion QA -6d	2026-07-05 22:17:25.992867+00
f3bd30fa-43e7-4b7a-9a9b-a76155711bdf	03455fe8-05e0-4138-a7ed-df01b34314f2	2026-07-05	78.10	16.0	87.5	73.3	102.5	35.7	49.8	Medicion QA -0d	2026-07-05 22:17:26.18194+00
924a2807-c97f-4e1d-83c4-ba9f7c1fae27	30c0413b-4439-4215-b063-6b0ae5976e00	2026-06-17	58.00	16.0	98.4	74.9	99.3	37.9	52.8	Medicion QA -18d	2026-07-05 22:17:28.474656+00
4cb7ea97-1fd1-4c0d-95ed-b02c101957a4	30c0413b-4439-4215-b063-6b0ae5976e00	2026-06-23	57.70	19.1	92.1	72.0	93.9	30.1	53.5	Medicion QA -12d	2026-07-05 22:17:28.657648+00
62580f6b-7773-40bc-8cf6-355eceb64256	30c0413b-4439-4215-b063-6b0ae5976e00	2026-06-29	57.40	22.4	92.7	81.4	92.7	37.5	49.4	Medicion QA -6d	2026-07-05 22:17:28.855348+00
fb27dee2-b3f6-4771-8e79-ba4f4fdf5e18	30c0413b-4439-4215-b063-6b0ae5976e00	2026-07-05	57.10	25.0	89.6	89.3	89.3	29.3	58.9	Medicion QA -0d	2026-07-05 22:17:29.006858+00
23a2c694-fbcb-487a-b146-cfe815faa79c	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	2026-06-17	91.00	18.3	85.0	78.4	95.6	32.0	50.4	Medicion QA -18d	2026-07-05 22:17:31.336634+00
f61360f8-7c57-4448-9f8b-2f059804aa8d	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	2026-06-23	90.70	20.1	85.1	75.8	89.4	30.8	48.5	Medicion QA -12d	2026-07-05 22:17:31.486594+00
6f4e3d56-aa46-4047-ada6-8027d95699f7	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	2026-06-29	90.40	14.3	91.1	75.1	97.4	32.4	57.0	Medicion QA -6d	2026-07-05 22:17:31.66882+00
49990d38-775e-48e3-b30d-d18e327626ed	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	2026-07-05	90.10	21.9	99.3	89.3	94.2	29.9	59.8	Medicion QA -0d	2026-07-05 22:17:31.834892+00
d27d0ac9-47f2-400e-80d3-8a75a96d9eb1	666ff6f7-7e31-4281-91dc-20d7b6925912	2026-06-17	65.00	21.2	97.6	76.2	89.8	30.4	54.0	Medicion QA -18d	2026-07-05 22:17:34.247744+00
8e4afc68-2da0-4125-ad92-41014e8d9db0	666ff6f7-7e31-4281-91dc-20d7b6925912	2026-06-23	64.70	24.5	92.9	73.5	103.2	34.2	52.9	Medicion QA -12d	2026-07-05 22:17:34.422239+00
fd12ce9c-aeb8-410e-a29c-0456e06377f3	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	2026-06-14	82.00	14.5	108.0	91.7	104.5	39.3	60.2	Medicion QA -21d	2026-07-05 22:07:58.047298+00
a19b470b-869e-4668-b4ce-f70fe1ced9d0	666ff6f7-7e31-4281-91dc-20d7b6925912	2026-06-29	64.40	22.7	93.3	78.3	89.9	30.0	51.9	Medicion QA -6d	2026-07-05 22:17:34.632095+00
c0692d6f-60f8-46e2-9442-c5a6d37a3346	666ff6f7-7e31-4281-91dc-20d7b6925912	2026-07-05	64.10	18.1	93.0	90.7	91.1	26.1	56.9	Medicion QA -0d	2026-07-05 22:17:34.823772+00
cc4b09ad-673b-43c7-a4c8-0875d7c6c9af	7b44888c-e917-4b70-9479-c0525d156dca	2026-06-21	87.60	18.1	101.2	78.1	103.9	38.6	61.7	Medicion QA -14d	2026-07-05 22:08:00.045838+00
b753e122-79b6-43fc-9422-a610c6c3edf2	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	2026-06-14	75.00	19.1	91.6	75.9	91.6	36.3	59.5	Medicion QA -21d	2026-07-05 22:07:56.13361+00
375754fb-0df0-43b0-bdff-83cee4f2531b	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	2026-06-21	74.60	18.2	91.1	82.6	104.9	35.3	61.7	Medicion QA -14d	2026-07-05 22:07:56.291014+00
fbec7b88-3947-4c62-98f7-c80620e750d1	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	2026-06-28	74.30	22.6	90.2	89.4	100.2	35.4	53.2	Medicion QA -7d	2026-07-05 22:07:56.453913+00
7861bb11-01f4-4647-97bc-5354b9a69e28	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	2026-07-05	74.00	20.4	92.0	83.7	96.8	39.5	60.5	Medicion QA -0d	2026-07-05 22:07:56.621779+00
a63046e2-ec39-4fbd-8f84-9ae893280ed7	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	2026-06-21	81.60	15.7	98.7	79.3	96.0	30.6	54.5	Medicion QA -14d	2026-07-05 22:07:58.21224+00
db7ef78d-6d0e-47fc-a437-f8cc097ada73	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	2026-06-28	81.30	23.9	94.8	90.7	96.8	34.2	61.5	Medicion QA -7d	2026-07-05 22:07:58.360284+00
fa20ea54-202d-4d6b-a9f0-149fa76e41c1	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	2026-07-05	81.00	24.0	100.0	89.4	92.3	33.0	61.6	Medicion QA -0d	2026-07-05 22:07:58.541884+00
8227f19e-97a0-4015-9ba5-720b395f8fdd	7b44888c-e917-4b70-9479-c0525d156dca	2026-06-14	88.00	23.0	93.8	80.0	91.5	37.8	60.6	Medicion QA -21d	2026-07-05 22:07:59.890363+00
cab2d4b8-6d29-4699-b774-27d0be0ed9db	7b44888c-e917-4b70-9479-c0525d156dca	2026-06-28	87.30	22.1	105.9	75.5	101.0	33.3	61.2	Medicion QA -7d	2026-07-05 22:08:00.1975+00
376af3b2-a801-415a-b16a-61276d5d0db0	7b44888c-e917-4b70-9479-c0525d156dca	2026-07-05	87.00	22.0	105.6	91.2	94.0	37.9	51.3	Medicion QA -0d	2026-07-05 22:08:00.365625+00
9646868d-efc3-4059-9518-4806ae1edd09	9f959d01-ad53-4931-a98b-4e0461f736b4	2026-06-14	70.00	18.1	101.3	78.9	100.4	34.9	52.9	Medicion QA -21d	2026-07-05 22:08:01.665029+00
eeeb672b-fee8-4cc5-8eb2-5e693e05a8dc	9f959d01-ad53-4931-a98b-4e0461f736b4	2026-06-21	69.60	20.6	90.1	90.0	101.6	31.1	55.1	Medicion QA -14d	2026-07-05 22:08:01.830213+00
caa4dfdc-482b-4c34-a17b-087ef34b855b	9f959d01-ad53-4931-a98b-4e0461f736b4	2026-06-28	69.30	15.8	107.2	85.4	90.8	32.5	60.2	Medicion QA -7d	2026-07-05 22:08:02.00107+00
59f4496d-d4ca-490f-85b9-8d63890eed95	9f959d01-ad53-4931-a98b-4e0461f736b4	2026-07-05	69.00	18.6	104.4	88.4	104.8	36.0	61.4	Medicion QA -0d	2026-07-05 22:08:02.141195+00
\.


--
-- Data for Name: careers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.careers (id, name, is_active, created_at) FROM stdin;
86c8cdfe-570a-4ae3-aaba-266c3cfde5f8	Arquitectura	t	2026-07-05 18:27:29.39424+00
0194ee3d-ab03-442c-895e-cdc7e5ded4bd	Diseño Industrial	t	2026-07-05 18:27:29.39803+00
ece1cb86-8d1f-479c-ac98-3d6c7738f038	Ingeniería en Construcción	t	2026-07-05 18:27:29.401441+00
5f490c71-4aa9-43a3-97fd-b0baca05372b	Bachillerato en Ciencias (Concepción)	t	2026-07-05 18:27:29.40439+00
44cccda5-87fb-4cbc-91bc-b6c54afe0bcc	Ingeniería Estadística	t	2026-07-05 18:27:29.407841+00
cd8ce9b7-5742-46cc-845b-5340df0eea8d	Contador Público y Auditor (Concepción)	t	2026-07-05 18:27:29.411422+00
52c9dc67-6def-4545-8c8b-6453dfe32500	Ingeniería Civil en Informática (Concepción)	t	2026-07-05 18:27:29.414821+00
76c6ba9e-80ce-4d9e-9263-6f1121b8ef0e	Ingeniería Comercial (Concepción)	t	2026-07-05 18:27:29.418171+00
c1ee9d51-1f53-463f-bb80-a2a9961a1ca3	Ingeniería de Ejecución en Computación e Informática	t	2026-07-05 18:27:29.421588+00
1134292a-8671-4756-932c-6f75cd8a0628	Derecho	t	2026-07-05 18:27:29.425557+00
e2727f58-9d7a-489e-b1db-873f8ccfed0b	Trabajo Social (Concepción)	t	2026-07-05 18:27:29.428994+00
f5b85980-bd3d-4652-816d-8f75d1e07455	Ingeniería Civil	t	2026-07-05 18:27:29.432381+00
96225bd5-220f-47dc-8751-20e7117d7d11	Ingeniería Civil Eléctrica	t	2026-07-05 18:27:29.436511+00
cc88bec0-ad01-4012-8a6a-1cb450be9845	Ingeniería Civil en Automatización	t	2026-07-05 18:27:29.439878+00
e2a23b07-ef2b-4dd7-b2bf-ab39e89605a5	Ingeniería Civil Industrial	t	2026-07-05 18:27:29.443253+00
84977037-5903-42a3-acab-6100b7556d52	Ingeniería Civil Mecánica	t	2026-07-05 18:27:29.446489+00
116b0dc2-dfaf-4fc9-ad18-f50d776e35cd	Ingeniería Civil Química	t	2026-07-05 18:27:29.450311+00
b8f40beb-af8d-434a-83bd-4b06593f7fbc	Ingeniería Eléctrica	t	2026-07-05 18:27:29.454151+00
91194b1c-7360-4971-929e-19d9f4f61d34	Ingeniería Electrónica	t	2026-07-05 18:27:29.457912+00
b8061dff-aebb-4362-944b-ba947a95534c	Ingeniería Mecánica	t	2026-07-05 18:27:29.461118+00
e7297ff9-68c1-4198-86de-50f7d153ac24	Diseño Gráfico	t	2026-07-05 18:27:29.465298+00
736c1def-dcaa-4341-bfba-220b6c98b790	Bachillerato en Ciencias (Chillán)	t	2026-07-05 18:27:29.469174+00
40d55eeb-ba32-4b55-b8ab-4727756dee8a	Ingeniería en Recursos Naturales	t	2026-07-05 18:27:29.473666+00
890cd9b8-f753-4ff7-b442-dd62fdcf7632	Enfermería	t	2026-07-05 18:27:29.47731+00
149e7c61-a4bd-4162-8370-e1e2b9813207	Fonoaudiología	t	2026-07-05 18:27:29.481148+00
e366ccf3-140c-4789-8285-94b6956a5c72	Ingeniería en Alimentos	t	2026-07-05 18:27:29.485478+00
5202d6c0-d976-49ad-b30f-d1acc0d84ccc	Medicina	t	2026-07-05 18:27:29.488755+00
0dfca7aa-ddbe-4229-9a73-04ef19dcb6bc	Nutrición y Dietética	t	2026-07-05 18:27:29.491934+00
3b1910db-b61e-40c5-9b3a-2540048ea678	Química y Farmacia	t	2026-07-05 18:27:29.494893+00
76c01e3d-8951-4ab2-93a1-67d207f22df3	Contador Público y Auditor (Chillán)	t	2026-07-05 18:27:29.498331+00
2f3ee8e1-ca9e-46a8-ab23-fc91334c5511	Ingeniería Civil en Informática (Chillán)	t	2026-07-05 18:27:29.502346+00
9afe0da6-908f-4604-ac49-d9350023fb45	Ingeniería Comercial (Chillán)	t	2026-07-05 18:27:29.510195+00
97be164c-f899-433c-96a4-2d8fa6ebc981	Pedagogía en Castellano y Comunicación	t	2026-07-05 18:27:29.514685+00
3f0d51bc-58bc-4153-8118-1065394600eb	Pedagogía en Ciencias Naturales	t	2026-07-05 18:27:29.518789+00
9de7690f-5e66-460e-9fd1-491d0051be18	Pedagogía en Educación Especial	t	2026-07-05 18:27:29.522155+00
2d5e8d26-7da7-4b66-965a-124b82ea40d4	Pedagogía en Educación Física	t	2026-07-05 18:27:29.525633+00
c1a035e4-0605-47ca-a751-6dc362f323a1	Pedagogía en Educación General Básica	t	2026-07-05 18:27:29.529327+00
67dabd92-9104-4f6b-b514-165e23a6530d	Pedagogía en Educación Matemática	t	2026-07-05 18:27:29.533516+00
b1f56a82-d2db-4811-b49b-901df53d0afb	Pedagogía en Educación Parvularia	t	2026-07-05 18:27:29.537856+00
22a145ff-4783-4068-b988-81865ec645a4	Pedagogía en Historia y Geografía	t	2026-07-05 18:27:29.541722+00
9b983862-71ca-4906-a863-13823415099d	Pedagogía en Inglés	t	2026-07-05 18:27:29.545823+00
1f3efb1e-7a50-476f-b1a0-035c3c89fc6c	Psicología	t	2026-07-05 18:27:29.548916+00
aa8c9cfa-eafa-4fec-a9fb-aa886d1f913e	Trabajo Social (Chillán)	t	2026-07-05 18:27:29.552312+00
e24057e0-8d8b-45de-b8df-59f19067a5cf	Ingeniería de Ejecución en Administración de Empresas	t	2026-07-05 18:27:29.555628+00
616af15c-d0f2-4ab6-9997-e219ee427cde	Ingeniería de Ejecución en Electricidad	t	2026-07-05 18:27:29.559345+00
9e2ebf98-c0ca-4138-b2e9-5de82d12a2e1	Ingeniería de Ejecución en Mecánica	t	2026-07-05 18:27:29.563094+00
\.


--
-- Data for Name: event_interests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_interests (user_id, event_id, created_at) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, title, type, event_date, event_time, location, description, max_participants, registration_url, created_by, is_active, created_at, updated_at, image_url, end_date) FROM stdin;
1dbbab26-3488-47ee-b4b5-2ace8a7511c2	Torneo de Powerlifting UBB 2026	Competencia	2026-10-03	\N	Gimnasio UBB, Campus La Castilla, Chillán	Primera competencia de powerlifting estudiantil de la Universidad del Bío-Bío. Categorías masculinas y femeninas en sentadilla, press de banca y peso muerto. Inscripción gratuita para estudiantes UBB.	\N	https://forms.gle/ejemplo	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.694028+00	2026-07-05 18:27:29.694028+00	\N	\N
6508d250-9415-41a9-b461-cea23667bb23	Charla: Nutrición Deportiva para Universitarios	Charla	2026-09-03	\N	Auditorio Facultad de Ciencias de la Salud, UBB	Charla magistral a cargo del área de Nutrición y Dietética de la Facultad de Ciencias de la Salud UBB. Temas: requerimientos calóricos para deportistas universitarios, mitos sobre suplementación y planificación de comidas.	\N	\N	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.697925+00	2026-07-05 18:27:29.697925+00	\N	\N
bc21c4cd-b593-4c01-9901-afdda9bbe28c	Jornada de Pausas Activas en Campus	Actividad	2026-08-04	\N	Campus La Castilla, UBB	Iniciativa del Gimnasio UBB en colaboración con Bienestar Estudiantil. Monitores recorrerán el campus realizando actividades de pausas activas de 10 minutos. No se requiere inscripción previa.	\N	\N	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 18:27:29.701066+00	2026-07-05 18:27:29.701066+00	\N	\N
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.exercises (id, name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, image_url, step_images, equipment, default_sets, default_reps, default_rest_seconds, created_by, is_active, created_at, exercise_type, is_rankeable) FROM stdin;
b76fc300-143d-4f4e-b71a-6692489a7bc3	Press Militar con Barra	hombros	intermedio	El ejercicio de empuje vertical por excelencia. Construye masa y fuerza en el deltoides y tríceps.	{"Deltoides anterior","Deltoides lateral","Tríceps braquial","Trapecio superior"}	{"De pie o sentado, barra a la altura de la clavícula con agarre prono.","Empuja hacia arriba en trayectoria ligeramente arqueada.","Mete la cabeza hacia adelante cuando la barra pasa por la frente.","Bloquea los brazos arriba y vuelve controladamente."}	Evita el exceso de extensión lumbar. Si hay dolor de hombro, prueba con mancuernas.	{"Press Arnold","Press con mancuernas","Push press","Press en máquina"}	https://www.youtube.com/embed/2yjwXTZQDDI	https://img.youtube.com/vi/2yjwXTZQDDI/hqdefault.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b76fc300-143d-4f4e-b71a-6692489a7bc3/b3c3b08c-a730-4fdb-84ea-d544bf6bbb47.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b76fc300-143d-4f4e-b71a-6692489a7bc3/dc833d10-0bde-426d-bbf2-49c3b0ec8fbd.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b76fc300-143d-4f4e-b71a-6692489a7bc3/e95915a0-b710-4d2e-b2c0-25672e66174f.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b76fc300-143d-4f4e-b71a-6692489a7bc3/37764fd5-504d-4aad-ae87-c97e7ee8625e.jpg}	Barra o Mancuernas	4	6-10	120	\N	t	2026-07-05 18:27:29.284779+00	dinamico	t
5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	Press de Banca	pecho	intermedio	El ejercicio rey del pecho. Trabaja pectoral mayor, tríceps y deltoides anterior con carga libre.	{"Pectoral mayor","Tríceps braquial","Deltoides anterior"}	{"Túmbate en el banco con los pies planos en el suelo.","Agarra la barra a una anchura ligeramente mayor que los hombros.","Desrackea la barra y bájala controladamente hasta rozar el pecho.","Empuja explosivamente hasta extender los codos sin bloquearlos.","Mantén los omóplatos retraídos y la espalda baja con leve arco natural."}	Usa siempre spotter o barras de seguridad. No rebotes la barra en el pecho.	{"Press inclinado","Press declinado","Press con mancuernas","Press en máquina"}	https://www.youtube.com/embed/rT7DgCr-3pg	https://img.youtube.com/vi/rT7DgCr-3pg/hqdefault.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5ed2c3d4-2c6a-4e71-813c-c29a4add5f98/69d4c67c-2511-4715-8ecd-b6b7c4411db9.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5ed2c3d4-2c6a-4e71-813c-c29a4add5f98/6d47aa71-c5ee-444f-915b-dd2f1bf2d590.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5ed2c3d4-2c6a-4e71-813c-c29a4add5f98/424d640d-b96f-4472-aa1f-9aa60c27c5ed.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5ed2c3d4-2c6a-4e71-813c-c29a4add5f98/ae682927-852a-456f-8b49-de322a19dcd9.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5ed2c3d4-2c6a-4e71-813c-c29a4add5f98/7599744e-0708-425b-a5dc-4becc52c071c.jpg}	Barra + Banco	4	5-8	120	\N	t	2026-07-05 18:27:29.196578+00	dinamico	t
94586449-2f8e-4b86-bbe5-20f006379748	Puente de Glúteos Isométrico	gluteos	principiante	Versión estática del puente de glúteos. Perfecto para activación pre-entrenamiento y trabajo preventivo de espalda baja.	{"Glúteo mayor",Isquiotibiales,Core}	{"Tumbado boca arriba, rodillas flexionadas y pies en el suelo al ancho de caderas.","Empuja caderas hacia arriba contrayendo fuertemente los glúteos.","Cuerpo en línea recta de rodillas a hombros.","Mantén la posición sin dejar caer las caderas."}	No hiperextiendas la espalda. Las costillas deben estar fijas.	{"Con banda alrededor de rodillas","Unilateral (single-leg)","Con peso en caderas"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/94586449-2f8e-4b86-bbe5-20f006379748/0e10198a-a4fc-49d7-ad99-738dfe268d45.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/94586449-2f8e-4b86-bbe5-20f006379748/3b397a0a-f8d7-4adf-a468-3985349986d2.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/94586449-2f8e-4b86-bbe5-20f006379748/7d00527a-678d-4412-873e-963d44d60b35.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/94586449-2f8e-4b86-bbe5-20f006379748/eb013e77-a756-465b-88e2-73ce586fa37d.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/94586449-2f8e-4b86-bbe5-20f006379748/60d0b333-4671-4668-93ef-89c2d3014203.jpg}	Sin equipamiento	3	30-45 seg	45	\N	t	2026-07-05 18:27:29.365624+00	isometrico	f
d65add1f-b4cd-41bc-8788-ccb8c73389e9	Pullover con Mancuerna	pecho	intermedio	Ejercicio único que trabaja pecho y dorsal simultáneamente, excelente para expansión del tórax.	{"Pectoral mayor","Dorsal ancho","Tríceps largo"}	{"Túmbate perpendicular al banco apoyando solo la zona alta de la espalda.","Sostén una mancuerna con ambas manos sobre el pecho.","Lleva la mancuerna hacia atrás describiendo un arco amplio.","Vuelve al punto de partida contrayendo el pecho."}	Mantén las caderas al nivel del banco o más bajas. No uses pesos excesivos.	{"Pullover con barra","Pullover en polea"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d65add1f-b4cd-41bc-8788-ccb8c73389e9/cf8dc67a-128b-46c0-9d8b-0e51b463fa4f.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d65add1f-b4cd-41bc-8788-ccb8c73389e9/a89032c6-555c-44d2-81f6-b6d3ad36c5e6.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d65add1f-b4cd-41bc-8788-ccb8c73389e9/e9181269-7c7f-4426-aa57-e353e5242305.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d65add1f-b4cd-41bc-8788-ccb8c73389e9/679f5475-a934-40b6-95c2-3370ffa00bd8.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d65add1f-b4cd-41bc-8788-ccb8c73389e9/5164d88c-89f3-4dcb-ba45-b9cd19411d88.jpg}	Mancuerna + Banco	3	12-15	60	\N	t	2026-07-05 18:27:29.212936+00	dinamico	f
7917a8e6-6d39-4151-af70-7a4f24b5ce94	Sentadilla con Barra	piernas	intermedio	El rey de los ejercicios de piernas. Activa cuádriceps, isquiotibiales, glúteos y core de forma integral.	{Cuádriceps,"Glúteo mayor",Isquiotibiales,Core,"Erector espinal"}	{"Coloca la barra sobre la parte alta de la espalda (sentadilla alta) o baja.","Pies al ancho de hombros o ligeramente más, punteras hacia afuera.","Desrackea, inhala y baja empujando las rodillas hacia afuera.","Profundidad mínima: muslos paralelos al suelo.","Sube empujando desde los talones manteniendo el pecho elevado."}	No colapses las rodillas hacia adentro. Nunca redondees la zona lumbar.	{"Sentadilla goblet","Sentadilla frontal","Hack squat","Sentadilla búlgara"}	https://www.youtube.com/embed/ultWZbUMPL8	https://img.youtube.com/vi/ultWZbUMPL8/hqdefault.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7917a8e6-6d39-4151-af70-7a4f24b5ce94/772ea0ce-ab38-496d-ab3b-0b863167273e.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7917a8e6-6d39-4151-af70-7a4f24b5ce94/d380bac9-8f75-4404-9b05-db16f95ee431.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7917a8e6-6d39-4151-af70-7a4f24b5ce94/320b3552-9029-490a-8420-ec0058b8ea5f.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7917a8e6-6d39-4151-af70-7a4f24b5ce94/229b63ca-297d-496d-bec0-7999a326bafc.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7917a8e6-6d39-4151-af70-7a4f24b5ce94/0d76de6f-f765-4bb0-878a-2e002db2a9fc.jpg}	Barra + Rack	4	5-8	120	\N	t	2026-07-05 18:27:29.24978+00	dinamico	t
9cd1b16b-905a-4554-b9ba-a285a154852a	Wall Sit (Sentadilla en Pared)	piernas	principiante	Ejercicio isométrico que construye resistencia muscular en cuádriceps sin carga compresiva en la rodilla.	{Cuádriceps,"Glúteo mayor",Isquiotibiales}	{"Apoya la espalda completamente contra una pared.","Desliza hacia abajo hasta que rodillas y caderas queden a 90°.","Los pies directamente debajo de las rodillas.","Mantén la posición respirando normalmente."}	No aguantes la respiración. Si sientes dolor en la rótula, sube un poco la posición.	{"Wall sit con banda","Wall sit unilateral","Wall sit con peso en muslos"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/9cd1b16b-905a-4554-b9ba-a285a154852a/cc9c6a62-266a-40c2-b9ca-4c8b4f339dcc.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/9cd1b16b-905a-4554-b9ba-a285a154852a/d5398c26-c1f0-4438-8f2c-7d38bbad4d40.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/9cd1b16b-905a-4554-b9ba-a285a154852a/bf143c4a-51c1-4f79-8f31-f95ec9418972.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/9cd1b16b-905a-4554-b9ba-a285a154852a/a01d7598-a7d7-47f3-85d1-a54a451a413f.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/9cd1b16b-905a-4554-b9ba-a285a154852a/a723267c-344f-4831-8829-137e08dfd663.jpg}	Pared	3	30-60 seg	60	\N	t	2026-07-05 18:27:29.277557+00	isometrico	f
d7a3f5c6-3e77-4da8-a5d8-351d5b019731	Elevaciones Laterales	hombros	principiante	Ejercicio de aislamiento para el deltoides lateral: el responsable de la amplitud de hombros.	{"Deltoides lateral","Deltoides anterior"}	{"De pie con mancuernas a los costados, codos ligeramente flexionados.","Eleva los brazos hacia los lados hasta la altura de los hombros.","El pulgar ligeramente hacia abajo (como verter agua de un vaso).","Baja lentamente en 3-4 segundos."}	No subas los hombros. Usa pesos que permitan control total.	{"Elevaciones en cable","Elevaciones unilaterales","Elevaciones laterales tumbado"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d7a3f5c6-3e77-4da8-a5d8-351d5b019731/8d2ef955-ef4a-4b39-a85e-e4703a780ca9.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d7a3f5c6-3e77-4da8-a5d8-351d5b019731/9f45bd2b-aa2f-476a-99f1-28ab31a8670b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d7a3f5c6-3e77-4da8-a5d8-351d5b019731/8de215dc-9c72-4cf8-9e23-4e1294bbbfb5.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d7a3f5c6-3e77-4da8-a5d8-351d5b019731/268f71a9-db73-43f3-bc26-4cc11debc3e4.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d7a3f5c6-3e77-4da8-a5d8-351d5b019731/a423f674-522e-4dfc-8559-860509593683.jpg}	Mancuernas	3	12-15	60	\N	t	2026-07-05 18:27:29.291773+00	dinamico	f
2ae9970f-b73d-4299-9946-426126a1bf8c	Push Up (Flexiones)	pecho	principiante	El ejercicio de pecho más accesible. Sin equipamiento, en cualquier lugar, con decenas de variantes.	{"Pectoral mayor","Tríceps braquial","Deltoides anterior",Core}	{"Posición de plancha alta: manos ligeramente más anchas que los hombros.","Mantén el cuerpo en línea recta de cabeza a talones, core activo.","Baja el pecho hacia el suelo flexionando los codos a 45°.","Empuja hasta extender los brazos sin bloquear los codos."}	No dejes caer las caderas. Si no aguantas el peso completo, apoya las rodillas.	{"Flexiones diamante","Flexiones declinadas","Flexiones con palmada","Archer push-up"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2ae9970f-b73d-4299-9946-426126a1bf8c/19042b93-7d03-4e60-9f05-c09daeeeffac.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2ae9970f-b73d-4299-9946-426126a1bf8c/0045044b-f53b-4a0b-8a96-37242792209a.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2ae9970f-b73d-4299-9946-426126a1bf8c/d4da09b6-decb-4d58-b87b-eca593f84e81.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2ae9970f-b73d-4299-9946-426126a1bf8c/07175d7c-9cd8-42b2-ae49-ccce2e8cb3b3.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2ae9970f-b73d-4299-9946-426126a1bf8c/17883513-0dc9-4169-a6e2-bddf0598605a.jpg}	Sin equipamiento	3	15-20	60	\N	t	2026-07-05 18:27:29.216121+00	calistenia	f
a9b226c5-1e25-47c1-809a-90588bc95bb6	Jalón de Tríceps en Polea	brazos	principiante	El ejercicio de tríceps más popular del gimnasio por su seguridad y efectividad.	{"Tríceps braquial (cabeza lateral y medial)"}	{"Polea alta con barra recta, V o cuerda. Agarra el accesorio con codos a 90°.","Codos pegados al cuerpo, estáticos durante todo el movimiento.","Extiende los brazos hacia abajo hasta bloquear los codos.","Vuelve controladamente hasta 90° de flexión."}	No separes los codos del cuerpo. El movimiento es solo de antebrazo.	{"Jalón con cuerda (separando extremos)","Jalón supino",Kickback}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/a9b226c5-1e25-47c1-809a-90588bc95bb6/971cfd3d-4217-455f-8aff-33f161c39d68.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/a9b226c5-1e25-47c1-809a-90588bc95bb6/726f3bd3-5c82-4023-b44b-83a1d059cd09.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/a9b226c5-1e25-47c1-809a-90588bc95bb6/334b4787-82da-4d80-9e29-209af92c58b7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/a9b226c5-1e25-47c1-809a-90588bc95bb6/d9d155d1-1d68-4de2-bb05-e5fc0410d190.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/a9b226c5-1e25-47c1-809a-90588bc95bb6/dd67c824-94c1-4221-8673-6f72f11df7bc.jpg}	Polea con barra o cuerda	3	12-15	60	\N	t	2026-07-05 18:27:29.319647+00	dinamico	f
1e3d0664-d00d-4324-9d43-095049eef5cb	Plancha Abdominal	core	principiante	El ejercicio isométrico de core por excelencia. Activa todos los estabilizadores del tronco.	{"Transverso abdominal","Recto abdominal",Oblicuos,Glúteos,"Erector espinal"}	{"Apoya antebrazos y puntas de los pies en el suelo.","Cuerpo en línea recta de cabeza a talones, sin que suban o bajen las caderas.","Contrae abdomen, glúteos y cuádriceps simultáneamente.","Mantén la posición respirando con normalidad."}	No aguantes la respiración. Si notas dolor lumbar, baja las caderas un poco.	{"Plancha alta","Plancha con elevación de brazo","Plancha con toque de hombro","Rueda de plancha"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1e3d0664-d00d-4324-9d43-095049eef5cb/5ee491be-00e8-4c33-8131-a4546a51f7b6.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1e3d0664-d00d-4324-9d43-095049eef5cb/97956f23-d5ae-47dd-b912-be1174a113b1.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1e3d0664-d00d-4324-9d43-095049eef5cb/734fa888-ef64-497f-a375-d462b85f9930.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1e3d0664-d00d-4324-9d43-095049eef5cb/27c20e08-1770-4cd6-9b02-9453fe681c37.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1e3d0664-d00d-4324-9d43-095049eef5cb/3489a6c1-ea3d-4d5c-967a-d810e4ed4ab0.jpg}	Sin equipamiento	3	30-60 seg	45	\N	t	2026-07-05 18:27:29.330863+00	isometrico	f
2bbeb47e-efa9-4a6f-99c0-0a3e3ccd682e	Curl Martillo	brazos	principiante	Variante con agarre neutro que enfatiza el braquial y braquiorradial, construyendo brazos más gruesos.	{Braquial,Braquiorradial,"Bíceps braquial"}	{"De pie con mancuernas en agarre neutro (pulgares hacia arriba).","Sube la mancuerna manteniendo el agarre neutro durante todo el recorrido.","Baja controladamente."}	No supines la muñeca; eso lo convierte en un curl normal.	{"Curl martillo simultáneo","Curl de cuerda en polea baja","Cross-body curl"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbeb47e-efa9-4a6f-99c0-0a3e3ccd682e/efc595c2-3460-4de7-8695-704b2c03f5fe.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbeb47e-efa9-4a6f-99c0-0a3e3ccd682e/ace8194d-f19f-4bb4-83ad-5aed2bb7e91e.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbeb47e-efa9-4a6f-99c0-0a3e3ccd682e/8725f423-c1c4-4b02-8cbf-360da9990eea.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbeb47e-efa9-4a6f-99c0-0a3e3ccd682e/5a730c6a-29dd-472a-86db-9052d9d57216.jpg}	Mancuernas	3	10-12	60	\N	t	2026-07-05 18:27:29.308665+00	dinamico	f
33aeb7e9-f37c-47ec-97b0-d94781e64109	Remo con Mancuerna	espalda	principiante	Ejercicio unilateral que permite mayor rango de movimiento y corrige desequilibrios entre lados.	{"Dorsal ancho",Romboides,"Bíceps braquial","Trapecio medio"}	{"Apoya una rodilla y la mano del mismo lado en un banco.","Sujeta la mancuerna con el brazo colgante, espalda paralela al suelo.","Tira de la mancuerna hacia la cadera llevando el codo hacia el techo.","Baja controladamente hasta extender el brazo."}	No rotes el torso al tirar. El movimiento viene del codo, no del hombro.	{"Remo en polea unilateral","Kroc row"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/33aeb7e9-f37c-47ec-97b0-d94781e64109/172a4544-f1cb-4440-8ae5-5f73d43eb1c5.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/33aeb7e9-f37c-47ec-97b0-d94781e64109/8f2226d0-0dfe-4935-b5ba-70585c3d1a4c.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/33aeb7e9-f37c-47ec-97b0-d94781e64109/a67066df-070c-4987-bf77-e363f165b359.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/33aeb7e9-f37c-47ec-97b0-d94781e64109/69f59056-8f35-4922-bd79-22e726460a62.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/33aeb7e9-f37c-47ec-97b0-d94781e64109/af4fa14e-393f-44a4-b1df-690a82751cb5.jpg}	Mancuerna + Banco	3	10-12	60	\N	t	2026-07-05 18:27:29.23915+00	dinamico	f
bc157eb4-1a52-4664-89db-4b7a26c54297	Russian Twist	core	principiante	Ejercicio rotacional para oblicuos que mejora la estabilidad del torso en movimientos deportivos.	{Oblicuos,"Recto abdominal","Transverso abdominal"}	{"Siéntate con rodillas flexionadas y torso a ~45° del suelo.","Mantén los pies levantados o apoyados para mayor facilidad.","Rota el torso de lado a lado llevando las manos (o peso) hacia el suelo."}	Con disco o balón medicinal para añadir carga. No hagas el movimiento demasiado rápido.	{"Russian twist con peso","Russian twist con pies levantados","Cable woodchop"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc157eb4-1a52-4664-89db-4b7a26c54297/56920fd0-90d3-4fb9-9384-7f80798c1679.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc157eb4-1a52-4664-89db-4b7a26c54297/a905b0bf-4ac8-4be6-9e11-7e8672d95f00.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc157eb4-1a52-4664-89db-4b7a26c54297/659db4ba-fbe4-482b-86fe-3ed71411db66.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc157eb4-1a52-4664-89db-4b7a26c54297/8f2d1041-6211-4f1b-a474-e10f67b5a586.jpg}	Sin equipamiento o Disco	3	20 (10 por lado)	45	\N	t	2026-07-05 18:27:29.35313+00	dinamico	f
979bed60-04b9-4c18-abde-c535da55483b	Mountain Climbers	core	principiante	Ejercicio funcional de core con componente cardiovascular. Ideal para HIIT y circuitos.	{"Recto abdominal",Oblicuos,Cuádriceps,Deltoides,"Hip flexors"}	{"Posición de plancha alta, manos bajo los hombros.","Lleva una rodilla al pecho de forma explosiva.","Cambia rápidamente llevando la otra rodilla al pecho.","Mantén las caderas bajas y estables, sin que suban."}	Las caderas no deben subir ni bajar. El core activo estabiliza todo el movimiento.	{"Mountain climbers lentos (técnica)","Cross-body mountain climbers (oblicuos)","Spider mountain climbers"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/979bed60-04b9-4c18-abde-c535da55483b/31c679a8-be6e-4c5c-b968-67aa9ec1bb2b.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/979bed60-04b9-4c18-abde-c535da55483b/75c5cd87-92bd-4f7c-8103-e96ec72e33ac.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/979bed60-04b9-4c18-abde-c535da55483b/ae2a836b-4e63-4949-9f2e-3dae373ee94b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/979bed60-04b9-4c18-abde-c535da55483b/99d2c0d4-4a46-4700-812f-a92fa57e4505.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/979bed60-04b9-4c18-abde-c535da55483b/bcc3eb64-1fc4-411b-96ba-3853f5a72da6.jpg}	Sin equipamiento	4	30-40 alternando	30	\N	t	2026-07-05 18:27:29.357333+00	calistenia	f
1b57646d-bc9c-4a26-9f47-d58813350824	Remo en Polea Baja	espalda	principiante	Movimiento de tracción horizontal en máquina que trabaja la espalda media con tensión constante.	{"Dorsal ancho",Romboides,"Trapecio medio","Bíceps braquial"}	{"Siéntate en la máquina con los pies en los apoyos y rodillas levemente flexionadas.","Agarra el accesorio y tira hacia el abdomen manteniendo la espalda erguida.","Retrae los omóplatos al final y mantén 1 segundo.","Vuelve extendiendo los brazos sin redondear la espalda."}	No te eches hacia atrás para tomar impulso. El torso queda casi estático.	{"Remo con barra en polea baja","Remo unilateral en polea"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1b57646d-bc9c-4a26-9f47-d58813350824/04b6b742-f274-4f47-a2e7-eaf7aaec7822.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1b57646d-bc9c-4a26-9f47-d58813350824/b752115f-6b82-45da-85aa-e4205abf1940.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1b57646d-bc9c-4a26-9f47-d58813350824/8ae47afe-d318-46fe-9a51-b71cd6e45dc4.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1b57646d-bc9c-4a26-9f47-d58813350824/e882f84c-58b6-4c19-91f0-a6eef13a920f.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1b57646d-bc9c-4a26-9f47-d58813350824/181b89dd-e7d6-43eb-9258-aecbe1aa0904.jpg}	Máquina de polea baja	3	12-15	60	\N	t	2026-07-05 18:27:29.24281+00	dinamico	f
85036f56-eecc-4b25-934d-40566ee34216	Curl con Barra EZ	brazos	principiante	Curl bilateral con barra zigzag que reduce el estrés en muñecas y permite mayor carga que mancuernas.	{"Bíceps braquial",Braquial,Braquiorradial}	{"Agarra la barra EZ por los segmentos inclinados interiores.","Codos pegados al cuerpo.","Sube la barra hasta que los antebrazos queden verticales.","Baja en 3-4 segundos."}	La barra EZ reduce el estrés en muñecas. Preferible sobre barra recta si hay molestia.	{"Curl con barra recta","Curl 21s (7+7+7)"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/85036f56-eecc-4b25-934d-40566ee34216/8750070a-b999-4b95-b371-093c47761895.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/85036f56-eecc-4b25-934d-40566ee34216/a0e5a18c-e196-4249-95c5-6621b4b08c95.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/85036f56-eecc-4b25-934d-40566ee34216/a9805e44-171a-4a15-98be-e8cc75127a65.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/85036f56-eecc-4b25-934d-40566ee34216/6884f1f5-27f7-4d2d-b86f-25f295719e48.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/85036f56-eecc-4b25-934d-40566ee34216/184196ea-2b5f-49c6-ac1f-dd28382633f0.jpg}	Barra EZ	3	10-12	60	\N	t	2026-07-05 18:27:29.311623+00	dinamico	f
f9a52a0d-977e-494a-8327-3c0ce368d92c	Remo con Barra	espalda	intermedio	Ejercicio compuesto fundamental para el grosor de la espalda media y baja.	{"Dorsal ancho",Romboides,"Trapecio medio","Bíceps braquial","Erector espinal"}	{"Inclínate hacia adelante a ~45° con rodillas ligeramente flexionadas.","Agarra la barra con agarre prono ligeramente más ancho que los hombros.","Tira de la barra hacia el abdomen apretando los codos cerca del cuerpo.","Aprieta los omóplatos al final del recorrido y baja lentamente."}	Nunca redondees la espalda. La cabeza va en extensión neutral del cuello.	{"Remo Pendlay","Remo con mancuernas","Remo en polea baja","Remo en máquina"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f9a52a0d-977e-494a-8327-3c0ce368d92c/4a2e1c91-bb1e-465c-9a60-287f935ac1a6.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f9a52a0d-977e-494a-8327-3c0ce368d92c/2cba4b70-9cbb-4cb0-8870-d3dd42e341ad.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f9a52a0d-977e-494a-8327-3c0ce368d92c/bdcd4752-1bac-46aa-8d93-f621bdad8899.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f9a52a0d-977e-494a-8327-3c0ce368d92c/0e8f040f-0145-484e-b9c5-8fdd41f77c26.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f9a52a0d-977e-494a-8327-3c0ce368d92c/1893397e-7660-4201-a07c-bb45fbae6816.jpg}	Barra	4	8-10	90	\N	t	2026-07-05 18:27:29.23208+00	dinamico	f
389e841d-7890-4481-97ef-a45d2c712d4b	Rueda Abdominal (Ab Wheel)	core	avanzado	Uno de los ejercicios de core más efectivos y desafiantes. Activa el abdomen en su máxima elongación.	{"Recto abdominal",Oblicuos,"Dorsal ancho","Serrato anterior"}	{"Arrodíllado con la rueda delante, manos en las empuñaduras.","Rueda hacia adelante extendiendo los brazos lo máximo posible.","Mantén la espalda recta (no la arquees).","Vuelve contrayendo el abdomen, no usando los brazos."}	Ejercicio avanzado: comienza rodando solo hasta donde puedas mantener la forma. Puede causar dolor lumbar si se hace incorrectamente.	{"Ab wheel de rodillas","Ab wheel de pie (dragon flag)","Ab wheel con pausa"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/389e841d-7890-4481-97ef-a45d2c712d4b/ef7c6abf-6ace-47d9-a78b-514e59509794.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/389e841d-7890-4481-97ef-a45d2c712d4b/01c0022b-4d0e-416a-8fda-b9bf59b7745e.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/389e841d-7890-4481-97ef-a45d2c712d4b/70b1523d-cadb-41ff-b1eb-cf7979d6c4aa.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/389e841d-7890-4481-97ef-a45d2c712d4b/26ff1d27-edb5-47a1-a8d3-1398851b47d7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/389e841d-7890-4481-97ef-a45d2c712d4b/c69eb1b4-46f7-4fe4-87f9-d00321f1e9f6.jpg}	Rueda abdominal	3	8-12	60	\N	t	2026-07-05 18:27:29.348812+00	dinamico	f
6a024179-6bad-474c-beed-6fdc47c3a62e	Press Inclinado con Mancuernas	pecho	intermedio	Variante inclinada que enfatiza el pectoral superior y mejora la forma del escote.	{"Pectoral mayor (clavicular)","Tríceps braquial","Deltoides anterior"}	{"Ajusta el banco a 30-45°.","Sujeta una mancuerna en cada mano a la altura de los hombros.","Empuja hacia arriba y ligeramente hacia el centro.","Baja controladamente hasta que los codos queden en línea con el banco."}	No subas la inclinación más de 45°; trabajarías más hombros que pecho.	{"Press inclinado con barra","Aperturas inclinadas","Press en máquina inclinada"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6a024179-6bad-474c-beed-6fdc47c3a62e/d60e2738-37fc-4bd7-b3ce-6762143f7720.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6a024179-6bad-474c-beed-6fdc47c3a62e/9e88d377-0fb4-4f2b-8b40-3cadbeefd288.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6a024179-6bad-474c-beed-6fdc47c3a62e/fca2ab47-e26d-44a1-af6a-2be7b24d9f58.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6a024179-6bad-474c-beed-6fdc47c3a62e/2bb4fb6c-4f01-40e7-9a52-6dce9cf69a76.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6a024179-6bad-474c-beed-6fdc47c3a62e/b8a1036d-080b-4156-b533-192e9f4ac65f.jpg}	Mancuernas + Banco inclinado	3	10-12	90	\N	t	2026-07-05 18:27:29.201314+00	dinamico	f
dfb46c45-9dc0-4700-8e1d-d89768fcb0a0	Elevaciones Frontales	hombros	principiante	Aislamiento del deltoides anterior, complementario al press de pecho que ya lo trabaja indirectamente.	{"Deltoides anterior","Pectoral mayor (porción clavicular)"}	{"De pie con mancuernas delante de los muslos, agarre prono.","Sube un brazo hacia adelante hasta la altura de los hombros.","Baja controladamente y alterna con el otro brazo."}	No uses impulso del torso. Si entrenas mucho press de pecho, este ejercicio puede ser redundante.	{"Elevaciones con barra","Elevaciones con disco","Elevaciones en cable"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/dfb46c45-9dc0-4700-8e1d-d89768fcb0a0/5f8a48c3-c0f9-4037-9885-beda912af04c.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/dfb46c45-9dc0-4700-8e1d-d89768fcb0a0/66ee66c2-4f33-4157-afb9-e36d98a846f7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/dfb46c45-9dc0-4700-8e1d-d89768fcb0a0/e2dcea76-86b1-42fc-8dde-b2c34580bdef.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/dfb46c45-9dc0-4700-8e1d-d89768fcb0a0/a1a8db52-f82c-4dba-a6c0-84e760a15152.jpg}	Mancuernas	3	12-15	60	\N	t	2026-07-05 18:27:29.294733+00	dinamico	f
d9a3a552-8f36-4d7e-9044-ed97ea4a2eac	Abducción de Cadera con Banda	gluteos	principiante	Ejercicio de aislamiento para glúteo medio, clave para la estabilidad pélvica y rodillas sanas.	{"Glúteo medio","Glúteo menor","Tensor de la fascia lata"}	{"De pie o tumbado, con banda alrededor de los muslos o tobillos.","De pie: separa lateralmente una pierna manteniendo el tronco estático.","Aprieta el glúteo medio en el punto máximo.","Vuelve lentamente y repite."}	No inclines el torso hacia el lado. El movimiento viene solo de la cadera.	{"Abducción tumbada","Clamshell (almeja)","Monster walk"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d9a3a552-8f36-4d7e-9044-ed97ea4a2eac/275e415f-54a8-404b-a14e-8f39bf420540.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d9a3a552-8f36-4d7e-9044-ed97ea4a2eac/cf152b37-99a1-4492-bef4-6319ed9a1b70.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d9a3a552-8f36-4d7e-9044-ed97ea4a2eac/9d4eea6b-9e94-4043-9f24-887c27ce7053.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d9a3a552-8f36-4d7e-9044-ed97ea4a2eac/d947113c-435a-4237-81b9-74647918329a.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/d9a3a552-8f36-4d7e-9044-ed97ea4a2eac/3c5106d6-3cf5-4a81-bbb5-55ebde0d6120.jpg}	Banda elástica	3	15-20 por lado	45	\N	t	2026-07-05 18:27:29.373813+00	dinamico	f
b8abdd2b-b424-45de-9e27-98c486ba1619	Aperturas en Cables (Crossover)	pecho	principiante	Ejercicio de aislamiento con tensión constante en el pectoral gracias al cable.	{"Pectoral mayor","Deltoides anterior"}	{"Coloca las poleas en la posición alta y pon un peso ligero-moderado.","Párate en el centro con un pie adelantado para estabilidad.","Tira de los cables hacia adelante y hacia abajo cruzándolos frente al pecho.","Vuelve lentamente controlando la tensión en cada repetición."}	Mantén ligera flexión en codos durante todo el movimiento.	{"Aperturas con mancuernas",Pec-deck,"Cable crossover bajo"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b8abdd2b-b424-45de-9e27-98c486ba1619/e2052f1a-282e-41c3-8227-45df5188efee.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b8abdd2b-b424-45de-9e27-98c486ba1619/59a447fd-0b75-45f2-b395-02620b9ad455.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b8abdd2b-b424-45de-9e27-98c486ba1619/5884e1a5-ae02-413b-a98d-e7cce0103ab8.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b8abdd2b-b424-45de-9e27-98c486ba1619/637539a5-3734-4a27-b373-c0c86cdca486.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/b8abdd2b-b424-45de-9e27-98c486ba1619/abd6e74a-4351-485c-8103-690ecf933b5f.jpg}	Máquina de cables	3	12-15	60	\N	t	2026-07-05 18:27:29.205136+00	dinamico	f
40724e21-cd68-4f48-ba27-c88523a708b0	Zancadas con Mancuernas	piernas	principiante	Ejercicio unilateral funcional para cuádriceps y glúteos con gran transferencia a movimientos cotidianos.	{Cuádriceps,"Glúteo mayor",Isquiotibiales}	{"De pie con mancuernas a los costados.","Da un paso largo hacia adelante.","Baja la rodilla trasera casi hasta el suelo manteniendo el torso erguido.","Empuja con el pie delantero para volver a la posición inicial."}	La rodilla delantera no debe superar la punta del pie. Mantén el torso vertical.	{"Zancadas caminando","Zancadas inversas","Zancadas laterales"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/40724e21-cd68-4f48-ba27-c88523a708b0/a6181e18-6f6d-456f-b422-5009f9dbf830.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/40724e21-cd68-4f48-ba27-c88523a708b0/67532a44-b315-49fc-bfd6-12377fd129b0.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/40724e21-cd68-4f48-ba27-c88523a708b0/0e85a5d2-b5ad-45f1-bd5b-2041832fa0ae.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/40724e21-cd68-4f48-ba27-c88523a708b0/65011cdd-8440-443c-bbe5-2dd3dbe6b535.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/40724e21-cd68-4f48-ba27-c88523a708b0/93ad24a6-44f7-49bf-a87d-55f46bc17ec4.jpg}	Mancuernas	3	10-12 por pierna	60	\N	t	2026-07-05 18:27:29.274383+00	dinamico	f
af2404f4-3336-4efd-a026-8f4c8d2ebb33	Burpees	gluteos	intermedio	Ejercicio de cuerpo completo de alta intensidad. Combina fuerza, potencia y cardiovascular en un solo movimiento.	{"Glúteo mayor",Cuádriceps,Pectoral,Deltoides,Tríceps,Core}	{"De pie, agáchate y apoya las manos en el suelo.","Lanza los pies hacia atrás a posición de plancha.","Realiza una flexión (opcional).","Regresa los pies hacia las manos de un salto.","Impulsate hacia arriba saltando con los brazos al techo."}	Para un nivel menor de intensidad, omite el salto y la flexión. No recomendado con lesiones de rodilla o hombro activas.	{"Burpee sin salto","Burpee con push-up","Burpee con box jump"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/af2404f4-3336-4efd-a026-8f4c8d2ebb33/9beb8751-8d6d-4246-a4db-a3f639af5a38.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/af2404f4-3336-4efd-a026-8f4c8d2ebb33/13b1912b-5fd4-4cf6-98fc-0adb6069048b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/af2404f4-3336-4efd-a026-8f4c8d2ebb33/2c9ea0c4-1007-4693-b2f0-0fa90bde1b24.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/af2404f4-3336-4efd-a026-8f4c8d2ebb33/95134fbc-348d-4785-a231-bd7c555e10a0.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/af2404f4-3336-4efd-a026-8f4c8d2ebb33/964ac621-2950-4841-b4db-937957fb1d51.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/af2404f4-3336-4efd-a026-8f4c8d2ebb33/dbfcdcd1-8278-4c78-b945-9c5f526f7a70.jpg}	Sin equipamiento	4	8-15	45	\N	t	2026-07-05 18:27:29.390555+00	calistenia	f
55b3d152-315e-4dec-b7a8-1d3c48cc3e23	Crunch Abdominal	core	principiante	Ejercicio básico para el recto abdominal con flexión de columna controlada.	{"Recto abdominal",Oblicuos}	{"Tumbado boca arriba, rodillas flexionadas a 90°, pies en el suelo.","Manos detrás de la cabeza sin tirar del cuello.","Eleva los hombros del suelo contrayendo el abdomen.","Vuelve sin apoyar completamente los hombros."}	El movimiento es corto. No te sientes completamente: eso trabaja más el psoas.	{"Crunch con giro (oblicuos)","Crunch en cable","Crunch en fitball"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/55b3d152-315e-4dec-b7a8-1d3c48cc3e23/323c6c96-e6a7-48cf-9c2a-8c1e4d5add72.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/55b3d152-315e-4dec-b7a8-1d3c48cc3e23/16222562-35dc-4583-be98-d7549b069b30.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/55b3d152-315e-4dec-b7a8-1d3c48cc3e23/d31aae59-f67d-4764-9d0a-c48e185b0bfd.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/55b3d152-315e-4dec-b7a8-1d3c48cc3e23/eaa4ba2f-ddc0-4e22-b530-db22780ff7f2.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/55b3d152-315e-4dec-b7a8-1d3c48cc3e23/3aefef97-1ef3-4d4c-8910-520192124fe2.jpg}	Sin equipamiento	3	15-20	45	\N	t	2026-07-05 18:27:29.341243+00	dinamico	f
908425ba-a6a0-461d-b3c0-da0d2b3e9d7d	Crunch Inverso	core	principiante	Variante que trabaja la porción inferior del recto abdominal elevando la pelvis en lugar del torso.	{"Recto abdominal (porción inferior)","Transverso abdominal"}	{"Tumbado boca arriba, manos apoyadas a los lados o bajo los glúteos.","Eleva las piernas a 90° con rodillas ligeramente flexionadas.","Curva la pelvis hacia el pecho elevando los glúteos del suelo.","Baja controladamente sin que las piernas toquen el suelo."}	No balancees las piernas. El movimiento viene de la contracción abdominal.	{"Crunch inverso en banco declinado","Leg raise","Hanging leg raise"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/908425ba-a6a0-461d-b3c0-da0d2b3e9d7d/472cb7ae-4116-4155-8b1a-158c483edfbe.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/908425ba-a6a0-461d-b3c0-da0d2b3e9d7d/7e27ec90-9a2b-47c6-8652-3e190185fb6a.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/908425ba-a6a0-461d-b3c0-da0d2b3e9d7d/8472e015-5118-4772-80fc-e18ba41cbb43.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/908425ba-a6a0-461d-b3c0-da0d2b3e9d7d/7b240b2d-4674-4027-b2e6-4a1c7e5bcf87.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/908425ba-a6a0-461d-b3c0-da0d2b3e9d7d/ee35980e-3440-4d93-a1df-f014af656f4d.jpg}	Sin equipamiento	3	15-20	45	\N	t	2026-07-05 18:27:29.344548+00	dinamico	f
4c654a6e-6701-4700-bf79-97cd1af93c13	Sentadilla Búlgara	piernas	avanzado	Sentadilla unilateral con pie trasero elevado: máxima activación de cuádriceps y glúteo con desafío de equilibrio.	{Cuádriceps,"Glúteo mayor",Isquiotibiales,Core}	{"Coloca el empeine del pie trasero en un banco a ~50 cm.","El pie delantero adelantado un paso largo del banco.","Baja el cuerpo flexionando la rodilla delantera a 90°.","La rodilla trasera desciende casi hasta el suelo.","Empuja desde el talón delantero para volver."}	Empieza sin peso hasta dominar el equilibrio. La rodilla delantera no debe sobrepasar los dedos del pie.	{"Con mancuernas","Con barra","Con goblet","Zancada inversa elevada"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/4c654a6e-6701-4700-bf79-97cd1af93c13/d00e0490-aa59-4c0a-82f2-2af12b35abd8.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/4c654a6e-6701-4700-bf79-97cd1af93c13/97d20622-4b04-47eb-88b5-c6327d4ea60d.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/4c654a6e-6701-4700-bf79-97cd1af93c13/11789168-7184-489c-9915-83467b9c8aa1.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/4c654a6e-6701-4700-bf79-97cd1af93c13/6222af3e-95bb-4fc7-8db8-ba9408ec52fb.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/4c654a6e-6701-4700-bf79-97cd1af93c13/1de83c4c-81fc-4d7a-9101-e2e493ee52fd.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/4c654a6e-6701-4700-bf79-97cd1af93c13/ae32fc59-6866-480f-9d8b-ddbc6cdd5d03.jpg}	Banco + Mancuernas o Barra	3	8-10 por pierna	90	\N	t	2026-07-05 18:27:29.263337+00	dinamico	f
26cbcf72-378b-45d7-8a76-eefdaa0fbf41	Curl de Bíceps con Mancuernas	brazos	principiante	Ejercicio de aislamiento clásico para el bíceps con rango completo de movimiento.	{"Bíceps braquial",Braquial,Braquiorradial}	{"De pie, mancuernas a los costados con agarre supino.","Codos pegados al cuerpo, sin moverlos durante el ejercicio.","Sube contrayendo el bíceps hasta que el antebrazo quede vertical.","Baja controladamente en 3 segundos."}	No balancees el torso para levantar más peso. Codos fijos.	{"Curl alterno","Curl simultáneo","Curl con barra","Curl en predicador"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26cbcf72-378b-45d7-8a76-eefdaa0fbf41/98a06909-5dd5-4391-9ad5-c0d3fbe2d3bf.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26cbcf72-378b-45d7-8a76-eefdaa0fbf41/b9f5c506-5805-4929-abfe-bc866e85cd72.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26cbcf72-378b-45d7-8a76-eefdaa0fbf41/b749c166-8351-4094-b7b1-eda25969e4e7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26cbcf72-378b-45d7-8a76-eefdaa0fbf41/5ce4f518-f5b0-43ae-b450-4e9ad5fe8498.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26cbcf72-378b-45d7-8a76-eefdaa0fbf41/c123dfc0-a53c-486e-afab-e7e4865879fd.jpg}	Mancuernas	3	10-15	60	\N	t	2026-07-05 18:27:29.305149+00	dinamico	f
273a1db1-497c-4598-8c97-b4bc295adad2	Curl Femoral	piernas	principiante	Aislamiento de isquiotibiales en máquina, imprescindible para equilibrar el desarrollo cuádriceps/isquios.	{Isquiotibiales,Gastrocnemio}	{"Tumbado boca arriba o boca abajo según la máquina, con el eje a la altura de las rodillas.","Flexiona las rodillas trayendo los talones hacia los glúteos.","Aprieta los isquiotibiales en el punto máximo.","Extiende lentamente durante 3-4 segundos."}	No uses inercia. El movimiento excéntrico lento es clave para prevenir lesiones.	{"Curl nórdico","Curl femoral de pie","Glute-ham raise"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/273a1db1-497c-4598-8c97-b4bc295adad2/206e48bc-68e1-4eb1-923e-c957d901bc0b.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/273a1db1-497c-4598-8c97-b4bc295adad2/c619267c-1a4b-44b4-9d85-721041baf3a5.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/273a1db1-497c-4598-8c97-b4bc295adad2/077278bc-920f-4f53-8466-05291a8c94d5.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/273a1db1-497c-4598-8c97-b4bc295adad2/24ad99ed-c2bc-4bca-b5ed-cd1ac28455b5.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/273a1db1-497c-4598-8c97-b4bc295adad2/8312fb58-f75b-44e4-b203-a77433bcdde7.jpg}	Máquina curl femoral	3	12-15	60	\N	t	2026-07-05 18:27:29.26672+00	dinamico	f
ae937948-fd2b-4327-8915-2375259c6f12	Curl Inclinado con Mancuernas	brazos	intermedio	Variante en banco inclinado que proporciona el mayor estiramiento del bíceps para máxima hipertrofia.	{"Bíceps braquial (porción larga)",Braquial}	{"Siéntate en un banco inclinado a 45-60° con mancuernas colgando.","Los brazos cuelgan completamente extendidos detrás del cuerpo.","Sube las mancuernas alternando o simultáneamente.","Baja lentamente aprovechando el estiramiento máximo."}	No uses pesos pesados. El estiramiento extremo aumenta el riesgo de desgarro si hay demasiada carga.	{"Curl en predicador","Curl con cable en polea baja"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/ae937948-fd2b-4327-8915-2375259c6f12/754404cb-ccf2-47b8-a3db-df62f502ea51.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/ae937948-fd2b-4327-8915-2375259c6f12/0ff065bd-6b9c-4252-ad94-617ef8ba646b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/ae937948-fd2b-4327-8915-2375259c6f12/f2924a46-c739-446d-8cb4-560c2c401eef.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/ae937948-fd2b-4327-8915-2375259c6f12/d3a62089-3c67-4fcc-9cf8-56d692a54638.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/ae937948-fd2b-4327-8915-2375259c6f12/74992230-6362-4a23-803a-a596d9484dfa.jpg}	Mancuernas + Banco inclinado	3	10-12	60	\N	t	2026-07-05 18:27:29.3272+00	dinamico	f
6856b5d8-db6e-4e52-891a-f9fd473201b6	Dead Hang (Colgada Estática)	espalda	principiante	Ejercicio isométrico que descomprime la columna, fortalece el agarre y activa los estabilizadores del hombro.	{"Dorsal ancho","Manguito rotador",Antebrazos,Core}	{"Cuelga de la barra con agarre prono, brazos completamente extendidos.","Relaja los hombros dejando que suban hacia las orejas (descompresión pasiva).","Mantén la posición respirando con normalidad.","Incrementa el tiempo progresivamente: 20s → 30s → 60s."}	Si tienes lesión de hombro activa, consulta antes de realizar este ejercicio.	{"Dead hang activo (escápulas bajas)","Dead hang unilateral"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6856b5d8-db6e-4e52-891a-f9fd473201b6/a27d01c0-ac82-40d4-8997-2d716400b9aa.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6856b5d8-db6e-4e52-891a-f9fd473201b6/10fafbec-52c6-4ce3-aea4-a9180cc7e3a5.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6856b5d8-db6e-4e52-891a-f9fd473201b6/8584b32c-cd59-452d-8294-7d9fa1ccda27.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6856b5d8-db6e-4e52-891a-f9fd473201b6/aa707698-3eb9-4f0a-a583-8f592e471a0f.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6856b5d8-db6e-4e52-891a-f9fd473201b6/021c478b-33cf-4c8b-adb6-c332c605e7d7.jpg}	Barra de dominadas	3	30-60 seg	60	\N	t	2026-07-05 18:27:29.246663+00	isometrico	f
c0baa7f4-ea5b-4463-84f8-777d2f12c8b0	Dominadas	espalda	intermedio	El mejor ejercicio de peso corporal para construir un dorsal ancho y una espalda fuerte.	{"Dorsal ancho","Bíceps braquial",Romboides,"Trapecio inferior"}	{"Cuelga de la barra con agarre prono, manos algo más anchas que los hombros.","Activa el core y retrae las escápulas antes de subir.","Tira hacia arriba hasta que la barbilla supere la barra.","Baja completamente de forma controlada."}	No balancees. Si no puedes hacer ninguna, usa banda elástica como asistencia.	{"Chin-ups (agarre supino)","Dominadas con lastre","Dominadas neutras","Archer pull-up"}	https://www.youtube.com/embed/eGo4IYlbE5g	https://img.youtube.com/vi/eGo4IYlbE5g/hqdefault.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c0baa7f4-ea5b-4463-84f8-777d2f12c8b0/fbe0680d-63c8-41ca-bd7d-4f1703829f5a.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c0baa7f4-ea5b-4463-84f8-777d2f12c8b0/fe0e2832-ed17-4e79-b1e9-933198b5cf55.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c0baa7f4-ea5b-4463-84f8-777d2f12c8b0/d7f4dd3e-0643-4ab5-a208-926a50e69154.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c0baa7f4-ea5b-4463-84f8-777d2f12c8b0/65f73d5c-0290-4778-b7c7-5981d4b3cb50.jpg}	Barra de dominadas	4	6-10	90	\N	t	2026-07-05 18:27:29.228398+00	calistenia	f
10d1000c-30b7-4ffe-bbb3-7a1d7744b218	Encogimientos de Hombros (Shrugs)	hombros	principiante	Ejercicio de aislamiento para el trapecio superior, que define el perfil del cuello y hombros.	{"Trapecio superior","Trapecio medio","Elevador de la escápula"}	{"De pie con mancuernas a los costados o barra delante.","Encoge los hombros hacia las orejas en movimiento vertical.","Mantén la contracción arriba 1-2 segundos.","Baja completamente y repite."}	No hagas círculos con los hombros: puede lesionar la articulación AC.	{"Encogimientos con barra","Encogimientos en máquina","Encogimientos tras nuca"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10d1000c-30b7-4ffe-bbb3-7a1d7744b218/06f0b5f9-e40b-44bc-aed6-8bb3812da4d5.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10d1000c-30b7-4ffe-bbb3-7a1d7744b218/813c0643-c76c-4e68-83e4-1c1ebea2e507.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10d1000c-30b7-4ffe-bbb3-7a1d7744b218/29bbf8de-c3cd-4c10-857c-e69cee7a2707.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10d1000c-30b7-4ffe-bbb3-7a1d7744b218/1f2134e7-4ff5-4b08-8764-c116ef110d5c.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10d1000c-30b7-4ffe-bbb3-7a1d7744b218/e3e687c5-e356-417d-a140-720a08a1160f.jpg}	Mancuernas o Barra	3	12-15	60	\N	t	2026-07-05 18:27:29.301932+00	dinamico	f
2cf30c21-fc62-4d28-a775-09f53fb73e09	Sentadilla con Salto	piernas	intermedio	Variante pliométrica de la sentadilla que desarrolla potencia explosiva en piernas y eleva el ritmo cardíaco.	{Cuádriceps,"Glúteo mayor",Isquiotibiales,Gemelos}	{"De pie con pies al ancho de hombros.","Realiza una sentadilla hasta 90° de rodilla.","Impulsate explosivamente hacia arriba hasta despegar del suelo.","Aterriza suavemente con rodillas ligeramente flexionadas.","Amortigua el aterrizaje y enlaza directamente con la siguiente repetición."}	Aterriza siempre con rodillas flexionadas, nunca con piernas rectas. No recomendado con lesiones de rodilla activas.	{"Box jump","Split squat jump","Broad jump"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2cf30c21-fc62-4d28-a775-09f53fb73e09/5b300d9d-c913-4cf0-bbad-4e77883350b5.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2cf30c21-fc62-4d28-a775-09f53fb73e09/6bba8696-7fc8-4d92-8b51-3ef5b0c5f592.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2cf30c21-fc62-4d28-a775-09f53fb73e09/9014b2c6-06a1-4718-a852-f5233a6dd4f8.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2cf30c21-fc62-4d28-a775-09f53fb73e09/6c728e01-a15b-4526-a3d4-d17d59b80f4d.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2cf30c21-fc62-4d28-a775-09f53fb73e09/e9f3ac41-ae6a-48a0-87cd-5faaa653d759.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2cf30c21-fc62-4d28-a775-09f53fb73e09/1c0e97cd-99f5-4057-bd12-67383637152f.jpg}	Sin equipamiento	4	10-15	60	\N	t	2026-07-05 18:27:29.280918+00	calistenia	f
5116a6d3-9ebf-4ae0-bf3b-4e16f92dce43	Extensiones de Cuádriceps	piernas	principiante	Aislamiento de cuádriceps en máquina, útil para reforzar la rodilla y trabajo de finalización.	{"Cuádriceps (4 cabezas)"}	{"Siéntate con la espalda apoyada y el eje de la máquina alineado con la rodilla.","Extiende las piernas hasta casi rectas contrayendo el cuádriceps.","Mantén la contracción 1 segundo en la parte alta.","Baja lentamente durante 3-4 segundos."}	Personas con dolor femoropatelar deben evitar el rango 0-30° de extensión.	{"Extensión unilateral","Extensión en rango terminal (TKE)"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5116a6d3-9ebf-4ae0-bf3b-4e16f92dce43/b9c54fae-dda6-4abb-86d2-fd852d2f93df.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5116a6d3-9ebf-4ae0-bf3b-4e16f92dce43/46e63632-652e-43d2-9f9d-e226ece43cdc.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5116a6d3-9ebf-4ae0-bf3b-4e16f92dce43/cf10b8a4-1cb7-4484-b228-3928aaba2325.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5116a6d3-9ebf-4ae0-bf3b-4e16f92dce43/4982c1b9-7f6c-4f78-a3b8-5d518266adb9.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/5116a6d3-9ebf-4ae0-bf3b-4e16f92dce43/1d9e84a9-dfb7-44d7-b5a8-9ec5d79516b5.jpg}	Máquina de extensión	3	12-15	60	\N	t	2026-07-05 18:27:29.27055+00	dinamico	f
7c950d5f-dcec-4bbc-aeb7-c0f857903a73	Face Pull	hombros	principiante	Ejercicio preventivo fundamental para la salud del hombro. Contrarresta el exceso de trabajo en empuje.	{"Deltoides posterior","Rotadores externos",Romboides,"Trapecio medio"}	{"Polea alta con cuerda, agarra los extremos con agarre neutro.","Tira hacia la cara separando los extremos al final del recorrido.","Los codos quedan por encima de los hombros al llegar al punto final.","Vuelve lentamente manteniendo tensión."}	Ejercicio de salud articular, no de fuerza máxima. Prioriza la técnica sobre el peso.	{"Face pull con banda","YWT en banco inclinado","Remo al cuello"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7c950d5f-dcec-4bbc-aeb7-c0f857903a73/d6aca166-88f4-46a4-abe1-57d6f345d6c0.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7c950d5f-dcec-4bbc-aeb7-c0f857903a73/ed58aef9-697a-4ac3-a729-7c413ee66a88.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7c950d5f-dcec-4bbc-aeb7-c0f857903a73/83933151-acda-416f-a480-4b528cbbd09b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7c950d5f-dcec-4bbc-aeb7-c0f857903a73/9731d286-9211-4c4b-a8a0-ae03cfb0dd5d.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7c950d5f-dcec-4bbc-aeb7-c0f857903a73/53a9f165-a36c-4393-b4b4-1f65fe2590a5.jpg}	Polea con cuerda	3	15-20	45	\N	t	2026-07-05 18:27:29.298283+00	dinamico	f
618a7c94-6544-4fa1-a549-b18b40934454	Fondos en Banco (Triceps Dips)	brazos	principiante	Ejercicio de peso corporal efectivo para tríceps y pecho inferior, accesible para todos los niveles.	{"Tríceps braquial","Pectoral mayor (inferior)","Deltoides anterior"}	{"Apoya las manos en el borde de un banco detrás de ti, dedos hacia adelante.","Las piernas extendidas al frente o rodillas flexionadas para mayor facilidad.","Baja flexionando los codos hasta 90°.","Empuja hasta extender los brazos."}	No bajes más de 90° para proteger el hombro anterior.	{"Fondos en banco con lastre","Fondos en paralelas","Dips asistidos en máquina"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/618a7c94-6544-4fa1-a549-b18b40934454/f0b2a8f0-0f61-4c36-abca-e85e3e7f15c5.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/618a7c94-6544-4fa1-a549-b18b40934454/19893ff2-e847-4515-ad45-f1f9558af95d.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/618a7c94-6544-4fa1-a549-b18b40934454/6aa474da-e979-4fe5-8cec-800ab6f2696a.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/618a7c94-6544-4fa1-a549-b18b40934454/15e9df45-2a88-4c00-919a-4a2bb04a1c28.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/618a7c94-6544-4fa1-a549-b18b40934454/88299878-62aa-4ddf-b005-435e2d1232df.jpg}	Banco o silla	3	12-15	60	\N	t	2026-07-05 18:27:29.323162+00	calistenia	f
f6400afd-b109-46cd-8bcf-782f81de6e1d	Fondos en Paralelas	pecho	intermedio	Ejercicio compuesto de peso corporal que carga fuertemente pecho inferior, tríceps y hombros.	{"Pectoral mayor (esternal)","Tríceps braquial","Deltoides anterior"}	{"Sujétate en las barras con los brazos extendidos.","Inclina el torso 20-30° hacia adelante para enfatizar el pecho.","Baja flexionando codos hasta que los hombros queden al nivel de los codos (90°).","Empuja hacia arriba volviendo a la posición inicial."}	No bajes más de 90° si tienes historial de lesiones de hombro.	{"Fondos con lastre","Fondos asistidos con banda","Dips en banco"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f6400afd-b109-46cd-8bcf-782f81de6e1d/f79f5b8f-5cea-45fa-97ed-30c955e52170.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f6400afd-b109-46cd-8bcf-782f81de6e1d/0b91dd98-5cb1-4750-8cae-ecc057f68371.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f6400afd-b109-46cd-8bcf-782f81de6e1d/5ef4ee7b-2911-48d0-9730-5d121b146aa3.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f6400afd-b109-46cd-8bcf-782f81de6e1d/77de83bc-9e0f-4232-8562-fb106970dde8.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/f6400afd-b109-46cd-8bcf-782f81de6e1d/93d398a3-a257-42cf-a5df-cb3a95c092a2.jpg}	Barras paralelas	3	8-12	90	\N	t	2026-07-05 18:27:29.220317+00	calistenia	f
26474d23-b534-479f-bb60-c0fa0daa6d18	Hollow Body Hold	core	intermedio	Posición isométrica fundamental en calistenia que construye una tensión corporal total y un core a prueba de balas.	{"Transverso abdominal","Recto abdominal","Psoas ilíaco",Serratos}	{"Tumbado boca arriba, extiende brazos por encima de la cabeza.","Eleva hombros y pies del suelo manteniendo la zona lumbar pegada al suelo.","Los brazos y piernas quedan a unos 15-30 cm del suelo.","Mantén la posición apretando el abdomen."}	La zona lumbar DEBE estar pegada al suelo. Si no puedes, sube los pies más.	{"Hollow body rock","Hollow body con piernas más altas (más fácil)","Dragon flag"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26474d23-b534-479f-bb60-c0fa0daa6d18/6db9e1f5-6121-46e9-90b1-bb8a4b408b1f.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26474d23-b534-479f-bb60-c0fa0daa6d18/0a5b7d00-9bfd-413a-83da-1eaf81feb624.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26474d23-b534-479f-bb60-c0fa0daa6d18/338edb59-dd3f-4c98-88ac-c3413df183d8.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26474d23-b534-479f-bb60-c0fa0daa6d18/99014eee-b394-4bdc-917e-45c7033d5013.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/26474d23-b534-479f-bb60-c0fa0daa6d18/004ca5b6-b8f2-406f-9c85-746ea5503a28.jpg}	Sin equipamiento	3	20-40 seg	45	\N	t	2026-07-05 18:27:29.337368+00	isometrico	f
2bbdd547-1776-4112-af7c-7696f5f5cd05	Hip Thrust con Barra	gluteos	principiante	El ejercicio más efectivo para hipertrofia de glúteo mayor. Mayor activación EMG que sentadilla o peso muerto.	{"Glúteo mayor","Glúteo medio",Isquiotibiales}	{"Apoya la espalda alta en un banco, barra sobre las caderas con almohadilla.","Pies al ancho de caderas, rodillas a 90° en la posición más alta.","Empuja las caderas hacia arriba apretando fuertemente los glúteos.","Mantén la contracción 1 segundo arriba y baja controladamente."}	Usa siempre almohadilla protectora. No hiperextiendas la zona lumbar en la parte alta.	{"Puente de glúteos","Hip thrust unilateral","Hip thrust con banda","Hip thrust en máquina"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbdd547-1776-4112-af7c-7696f5f5cd05/218c91de-3a74-4077-adbe-8de49ca699d4.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbdd547-1776-4112-af7c-7696f5f5cd05/1c269990-cd92-47f6-835a-03ca7ed2f11e.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbdd547-1776-4112-af7c-7696f5f5cd05/62982083-2a1f-4ef9-8934-314f6c1ad8b7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbdd547-1776-4112-af7c-7696f5f5cd05/27ea7932-4225-4799-a1e4-c3e9076346ac.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/2bbdd547-1776-4112-af7c-7696f5f5cd05/afb5d4d9-018c-4a81-a368-c09a96d16346.jpg}	Barra + Banco + Almohadilla	4	10-15	90	\N	t	2026-07-05 18:27:29.361522+00	dinamico	f
bc9041b6-ea9b-458e-95cd-d12f64a9a148	Sentadilla Sumo con Mancuerna	gluteos	principiante	Variante de sentadilla con apertura amplia que enfatiza la cara interna del muslo y glúteos.	{"Glúteo mayor",Aductores,Cuádriceps,Isquiotibiales}	{"Pies más anchos que los hombros, puntas a 45°.","Sujeta una mancuerna vertical con ambas manos colgando entre las piernas.","Baja profundamente manteniendo el torso erguido.","Empuja desde los talones volviendo a la posición de pie."}	Asegúrate de que las rodillas sigan la dirección de las puntas del pie.	{"Sentadilla sumo con barra","Sumo deadlift","Goblet squat sumo"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc9041b6-ea9b-458e-95cd-d12f64a9a148/cafb39ec-3bdd-4677-bb54-6bd347cc848d.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc9041b6-ea9b-458e-95cd-d12f64a9a148/61efb08c-5d20-4699-998f-eafdc27b8186.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc9041b6-ea9b-458e-95cd-d12f64a9a148/8fa7b145-f34c-4c20-b830-da935a774a28.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc9041b6-ea9b-458e-95cd-d12f64a9a148/8dac374b-c036-4089-a92a-7d7774a0fcb0.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bc9041b6-ea9b-458e-95cd-d12f64a9a148/ee2ccf48-cae3-47e8-994b-3fbeb511ff66.jpg}	Mancuerna	3	12-15	60	\N	t	2026-07-05 18:27:29.377899+00	dinamico	f
c961072f-e86c-4164-9980-d53f22436f38	Jalón al Pecho	espalda	principiante	Alternativa a las dominadas en polea, ideal para principiantes o para acumular volumen.	{"Dorsal ancho","Bíceps braquial",Romboides,"Trapecio inferior"}	{"Siéntate en la máquina con los muslos bien sujetos bajo el rodillo.","Agarra la barra con agarre amplio prono.","Inclínate ligeramente hacia atrás y tira de la barra hacia el pecho superior.","Vuelve lentamente a la posición inicial sin soltarte."}	NUNCA jales detrás de la nuca: aumenta el riesgo de lesión cervical.	{"Jalón agarre neutro","Jalón agarre cerrado","Jalón unilateral"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c961072f-e86c-4164-9980-d53f22436f38/1335e732-83ab-48c7-9992-30fce128ae82.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c961072f-e86c-4164-9980-d53f22436f38/289cd663-496e-4319-bf8f-7602e496324b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c961072f-e86c-4164-9980-d53f22436f38/059d1a63-7a6f-412f-812c-0fd691b053be.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c961072f-e86c-4164-9980-d53f22436f38/3557252f-ffcc-4e0f-a92a-38bca7c6bab0.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/c961072f-e86c-4164-9980-d53f22436f38/13134c36-4024-42c7-9e89-7438f9b0841d.jpg}	Máquina de polea	3	10-12	75	\N	t	2026-07-05 18:27:29.236285+00	dinamico	f
0b7b591c-6054-4440-a935-e70c31107b5f	Step Up con Mancuernas	gluteos	principiante	Ejercicio funcional unilateral que trabaja glúteos, cuádriceps y mejora el equilibrio.	{"Glúteo mayor",Cuádriceps,Isquiotibiales}	{"Párate frente a un banco o cajón con mancuernas a los lados.","Coloca el pie derecho completamente en el banco.","Empuja desde el talón derecho subiendo el cuerpo.","Baja controladamente con el pie izquierdo primero."}	El pie completo debe estar en la superficie. No te impulses con el pie de abajo.	{"Step up con rotación","Step up lateral","Deficit step up"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0b7b591c-6054-4440-a935-e70c31107b5f/23dce14b-7cf9-4577-a0aa-67531ba3a1dc.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0b7b591c-6054-4440-a935-e70c31107b5f/79168bd6-dd96-4b0c-903e-9723b063362d.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0b7b591c-6054-4440-a935-e70c31107b5f/5995e7f5-9e21-40b7-b5dc-4c398f44c4e9.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0b7b591c-6054-4440-a935-e70c31107b5f/26187e69-e7cc-46ef-a8a2-191911e1d919.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0b7b591c-6054-4440-a935-e70c31107b5f/9fb8bef7-5ae0-4af2-b537-079da081f409.jpg}	Mancuernas + Banco o cajón	3	10-12 por pierna	60	\N	t	2026-07-05 18:27:29.381663+00	dinamico	f
1c7d957c-5ef1-4d37-8748-4e727bfe2808	Zancadas Caminando	gluteos	principiante	Variante dinámica de la zancada que desarrolla glúteos, cuádriceps y coordinación en un solo movimiento continuo.	{"Glúteo mayor",Cuádriceps,Isquiotibiales,Core}	{"De pie, da un paso largo hacia adelante.","Baja la rodilla trasera casi hasta el suelo.","Sin volver al punto de inicio, da el siguiente paso con la otra pierna.","Continúa avanzando de forma rítmica."}	Mantén el torso erguido durante todo el recorrido. Si hay limitaciones de espacio, usa zancadas estáticas.	{"Zancadas caminando con mancuernas","Zancadas con barra en espalda","Zancadas en sentido inverso"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1c7d957c-5ef1-4d37-8748-4e727bfe2808/cf6d347a-6152-41c5-b6b0-a98832b6cb94.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1c7d957c-5ef1-4d37-8748-4e727bfe2808/01e788a4-4788-46a9-8056-52a4bb82d055.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1c7d957c-5ef1-4d37-8748-4e727bfe2808/3289b6f0-2a7e-4ab3-9856-a49e2c299dd2.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1c7d957c-5ef1-4d37-8748-4e727bfe2808/fe6bc7bc-e4b4-4504-8208-4e4a41df2966.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/1c7d957c-5ef1-4d37-8748-4e727bfe2808/f19d77a5-ab27-4777-b729-6c5ee713e6c5.jpg}	Sin equipamiento	3	20 (10 por pierna)	60	\N	t	2026-07-05 18:27:29.386533+00	calistenia	f
7f10aaca-67f9-47db-8e5e-05b2e98d2a83	Leg Press	piernas	principiante	Ejercicio en máquina para cuádriceps con menor riesgo técnico que la sentadilla libre.	{Cuádriceps,"Glúteo mayor",Isquiotibiales}	{"Siéntate con la espalda bien pegada al respaldo.","Coloca los pies a la anchura de la cadera en la mitad de la plataforma.","Libera los seguros y baja la plataforma hasta ~90° de rodilla.","Empuja hasta casi extender (no bloquees las rodillas).","Vuelve a poner los seguros antes de bajar del aparato."}	No bloquees las rodillas. No despegues la zona baja de la espalda del respaldo.	{"Leg press con pies altos (isquios/glúteos)","Leg press unilateral","Prensa 45°"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7f10aaca-67f9-47db-8e5e-05b2e98d2a83/60d78f82-94e5-4a28-aae2-1b22a5772316.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7f10aaca-67f9-47db-8e5e-05b2e98d2a83/6dc5944e-6d07-4328-a282-f1add4f2e4bb.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7f10aaca-67f9-47db-8e5e-05b2e98d2a83/dfbe016b-69e8-4053-965b-f26cf3d0f235.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7f10aaca-67f9-47db-8e5e-05b2e98d2a83/20eb658e-bf99-4013-b30d-e3661be5610b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7f10aaca-67f9-47db-8e5e-05b2e98d2a83/af3b8efb-62e2-490b-9edb-d0adc011ca3e.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7f10aaca-67f9-47db-8e5e-05b2e98d2a83/211a6410-1c37-485e-b69c-4afeadcf56d0.jpg}	Máquina Leg Press	4	10-15	90	\N	t	2026-07-05 18:27:29.257745+00	dinamico	f
67d8e8a5-bda5-458f-b5b6-0c075aff6f65	Patada de Glúteo en Cuadrupedia	gluteos	principiante	Ejercicio de aislamiento para glúteo mayor que trabaja la extensión de cadera en su rango más efectivo.	{"Glúteo mayor",Isquiotibiales}	{"A cuatro patas, muñecas bajo los hombros, rodillas bajo las caderas.","Extiende una pierna hacia atrás y arriba, manteniendo la rodilla a 90°.","Aprieta el glúteo en el punto máximo.","Vuelve sin tocar el suelo con la rodilla y repite."}	No gires la pelvis. El movimiento es solo extensión de cadera.	{"Con banda de resistencia","Con mancuerna detrás de la rodilla","En máquina cable"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/67d8e8a5-bda5-458f-b5b6-0c075aff6f65/252011e3-b787-4ca4-ad4e-00aa3ccc9368.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/67d8e8a5-bda5-458f-b5b6-0c075aff6f65/5fcd6ba6-3bea-471d-b120-667d585a8137.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/67d8e8a5-bda5-458f-b5b6-0c075aff6f65/d972a8a0-5610-4545-9d65-4cbe26c03bda.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/67d8e8a5-bda5-458f-b5b6-0c075aff6f65/e8af869e-41ae-44ef-8e70-ea000d539802.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/67d8e8a5-bda5-458f-b5b6-0c075aff6f65/37636453-bb4c-4255-a048-290089768b1e.jpg}	Sin equipamiento o Banda elástica	3	15-20 por pierna	45	\N	t	2026-07-05 18:27:29.369863+00	dinamico	f
7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	Peso Muerto	espalda	avanzado	El ejercicio más completo del gimnasio. Activa más de 20 grupos musculares en un solo movimiento.	{Isquiotibiales,"Glúteo mayor","Erector espinal",Trapecios,Core,Dorsales}	{"Para frente a la barra, pies al ancho de caderas, barra sobre el mediopié.","Agáchate y agarra la barra con agarre prono o mixto.","Espalda recta, pecho elevado, caderas más altas que rodillas.","Empuja el suelo con los pies y extiende caderas y rodillas simultáneamente.","Bloquea arriba apretando glúteos. Baja controladamente."}	CRÍTICO: nunca redondees la zona lumbar. Empieza con pesos ligeros para aprender la técnica.	{"Peso muerto rumano","Peso muerto sumo","Peso muerto con trampa hexagonal"}	https://www.youtube.com/embed/op9kVnSso6Q	https://img.youtube.com/vi/op9kVnSso6Q/hqdefault.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3/e83fcd93-f605-45f4-9ee9-dfa28a2f3eed.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3/99f929f6-657c-4570-9aa2-055e1ec878f6.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3/c2dc0c6f-4107-4a1c-b09e-d2f8fed1bee6.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3/ab483b16-93a8-49ca-a2eb-ade5f7d4f5c1.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3/9befda13-0726-40b4-8d5c-6c017bff6c71.jpg}	Barra	3	3-5	180	\N	t	2026-07-05 18:27:29.224991+00	dinamico	t
90503c85-c069-4aa2-a4f3-a0177f46c56c	Peso Muerto Rumano	piernas	intermedio	Variante del peso muerto que aísla isquiotibiales y glúteos con énfasis en el estiramiento.	{Isquiotibiales,"Glúteo mayor","Erector espinal"}	{"De pie con la barra en agarre prono, piernas casi extendidas.","Empuja las caderas hacia atrás inclinando el torso hacia adelante.","Desliza la barra por las piernas manteniendo espalda recta.","Baja hasta sentir estiramiento intenso en isquiotibiales.","Vuelve contrayendo glúteos y extendiendo caderas."}	No redondees la espalda baja. La profundidad la limita tu flexibilidad.	{"PDR con mancuernas","PDR unilateral (single-leg)","Good morning"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/90503c85-c069-4aa2-a4f3-a0177f46c56c/39742411-f911-43e4-92be-8099930a192a.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/90503c85-c069-4aa2-a4f3-a0177f46c56c/bc6feba7-c962-462d-853f-1328a4d04f70.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/90503c85-c069-4aa2-a4f3-a0177f46c56c/b1861403-1e58-4a02-94c4-c8944ae5d8dd.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/90503c85-c069-4aa2-a4f3-a0177f46c56c/56b9cad6-568c-46ae-b452-b5416ed363c2.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/90503c85-c069-4aa2-a4f3-a0177f46c56c/fe3f6fdf-7577-470a-b05f-2fa1d789ca0c.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/90503c85-c069-4aa2-a4f3-a0177f46c56c/40b925eb-7b42-489f-9d2a-443e1ee51326.jpg}	Barra o Mancuernas	3	10-12	90	\N	t	2026-07-05 18:27:29.253667+00	dinamico	f
bfb1fef1-777a-48ce-9ca7-1c76701eb381	Plancha Lateral	core	intermedio	Versión lateral de la plancha que aísla los oblicuos y trabaja la estabilidad lateral del tronco.	{"Oblicuo externo","Oblicuo interno","Cuadrado lumbar","Glúteo medio"}	{"Apoya el antebrazo y el pie lateral en el suelo.","Eleva las caderas formando una línea recta con el cuerpo.","El cuerpo no debe rotar ni hacia adelante ni hacia atrás.","Mantén la posición y repite en el otro lado."}	Asegúrate de que el antebrazo esté perpendicular al cuerpo, no en diagonal.	{"Plancha lateral alta (brazo extendido)","Plancha lateral con elevación de cadera","Plancha lateral con apertura de pierna"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bfb1fef1-777a-48ce-9ca7-1c76701eb381/3112d3ab-cf0b-4e15-8d17-477025f7692f.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bfb1fef1-777a-48ce-9ca7-1c76701eb381/5f210a52-bcc3-416f-9c79-92fb6aa8c928.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bfb1fef1-777a-48ce-9ca7-1c76701eb381/488d719b-9e7a-4b33-9bdc-527b1fabf5a7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bfb1fef1-777a-48ce-9ca7-1c76701eb381/e6410b4c-cf94-4164-9353-79c5ddfdff17.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/bfb1fef1-777a-48ce-9ca7-1c76701eb381/2701b14d-4367-467e-af47-f5205b64e657.jpg}	Sin equipamiento	3	20-40 seg por lado	45	\N	t	2026-07-05 18:27:29.334159+00	isometrico	f
10ba34b5-3570-4dde-a02e-4a36178ebfdf	Press Arnold	hombros	intermedio	Variante del press de hombros con rotación que activa las tres cabezas del deltoides.	{"Deltoides (3 cabezas)","Tríceps braquial","Trapecio superior"}	{"Sentado, sujeta mancuernas frente a ti con agarre supino a la altura del pecho.","Al empujar hacia arriba, rota las muñecas para que las palmas miren hacia adelante.","Extiende los brazos completamente arriba.","Invierte el movimiento al bajar: rota hacia supino volviendo a la posición inicial."}	Usa pesos moderados. La rotación aumenta el ROM pero también el estrés en el manguito.	{"Press de hombros con mancuernas","Press militar"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10ba34b5-3570-4dde-a02e-4a36178ebfdf/61120561-2658-46c2-9302-bdae928e60ba.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10ba34b5-3570-4dde-a02e-4a36178ebfdf/34f9c476-7122-4c3d-9b76-ad3608bfb56b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10ba34b5-3570-4dde-a02e-4a36178ebfdf/b3997392-7f19-4d33-931a-84ea8d224148.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10ba34b5-3570-4dde-a02e-4a36178ebfdf/2066b99a-6bfe-4915-b5cf-ec3461e3b9c7.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/10ba34b5-3570-4dde-a02e-4a36178ebfdf/5e0fcf1e-3a77-41b2-80bb-4f282d4b2c49.jpg}	Mancuernas + Banco con respaldo	3	10-12	90	\N	t	2026-07-05 18:27:29.288+00	dinamico	f
0c7fcd82-c2ee-4ac5-b886-916468f6e801	Press de Pecho en Máquina	pecho	principiante	Opción segura y guiada ideal para principiantes o para acumular volumen al final del entrenamiento.	{"Pectoral mayor","Tríceps braquial","Deltoides anterior"}	{"Ajusta el asiento para que las manijas queden a la altura del pecho.","Siéntate con la espalda completamente apoyada en el respaldo.","Empuja las manijas hasta extender casi los brazos.","Vuelve lentamente sin dejar que el peso toque el stack."}	No bloquees los codos al extender. Mantén los pies en el suelo.	{"Press de pecho con banda","Press declinado en máquina"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0c7fcd82-c2ee-4ac5-b886-916468f6e801/3770ead6-3e93-49be-b9b4-77477a214808.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0c7fcd82-c2ee-4ac5-b886-916468f6e801/8f64cd91-19a0-4cb0-9c69-63aad014340a.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0c7fcd82-c2ee-4ac5-b886-916468f6e801/52008c1c-2369-479d-b05a-19a6445ca9c4.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0c7fcd82-c2ee-4ac5-b886-916468f6e801/ff0c2ca6-2470-4892-a4f8-e860193bf1f3.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/0c7fcd82-c2ee-4ac5-b886-916468f6e801/f403d869-0757-4e26-a8f6-75615af331c5.jpg}	Máquina de press de pecho	3	12-15	60	\N	t	2026-07-05 18:27:29.208954+00	dinamico	f
6dc9cf9c-30cf-4c55-9d92-f9d5207f0819	Press Francés (Skull Crusher)	brazos	intermedio	Ejercicio de aislamiento para las tres cabezas del tríceps con máximo estiramiento muscular.	{"Tríceps braquial (3 cabezas)","Codo: ligamento lateral"}	{"Tumbado en banco, sujeta barra EZ o mancuernas sobre el pecho, brazos verticales.","Dobla los codos bajando el peso hacia la frente (o detrás de la cabeza).","Los codos permanecen fijos apuntando al techo.","Extiende los brazos volviendo a la posición inicial."}	Comienza con pesos ligeros. El nombre "skull crusher" describe el riesgo de mala técnica.	{"Press francés con mancuernas","JM press","Press francés en polea"}	\N	https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6dc9cf9c-30cf-4c55-9d92-f9d5207f0819/f3da4fd1-2f8c-4a68-9975-28efaf0d552d.jpg	{https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6dc9cf9c-30cf-4c55-9d92-f9d5207f0819/6a218e17-f1dc-4714-8064-7e99fe922f0b.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6dc9cf9c-30cf-4c55-9d92-f9d5207f0819/241782bd-74c0-4c16-8687-3f2805aa4fcf.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6dc9cf9c-30cf-4c55-9d92-f9d5207f0819/049999fc-b49f-43c6-8efa-21d5b86568c4.jpg,https://pub-7cae207863224329910f656c9ccdcc1f.r2.dev/exercises/6dc9cf9c-30cf-4c55-9d92-f9d5207f0819/4e7f315d-0a6f-4e1f-9d57-6dd6e22a3eb2.jpg}	Barra EZ o Mancuernas + Banco	3	10-12	60	\N	t	2026-07-05 18:27:29.315371+00	dinamico	f
\.


--
-- Data for Name: hiit_lists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hiit_lists (id, user_id, name, exercises, created_at, is_active) FROM stdin;
\.


--
-- Data for Name: hiit_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hiit_sessions (id, user_id, hiit_workout_id, name, mode, config, total_duration_seconds, rounds_completed, started_at, ended_at, created_at) FROM stdin;
\.


--
-- Data for Name: hiit_workouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hiit_workouts (id, user_id, name, mode, config, is_public, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: joint_exercises; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.joint_exercises (id, name, type, joint_family, instructions, benefits, when_to_use, created_by, is_active, created_at) FROM stdin;
38b129ea-28d3-40f0-abc6-8629b458cfee	Rotación interna y externa de hombro con banda	movilidad	shoulder	{"Ancla una banda elástica a la altura del codo.","Mantén el codo flexionado a 90° pegado al costado.","Rota el antebrazo hacia afuera (rotación externa) lentamente.","Vuelve al centro y luego rota hacia adentro (rotación interna).","Realiza 10 repeticiones en cada dirección."}	Mejora el rango de movimiento glenohumeral, previene el síndrome de impingement y equilibra los rotadores del manguito.	Ideal como calentamiento previo a entrenamientos de empuje/tirón, o como trabajo preventivo 3 veces por semana.	\N	t	2026-07-05 18:27:29.570978+00
a49c8940-6e6f-40bb-a4f4-b4deaa984211	Círculos de hombro con bastón	movilidad	shoulder	{"Sostén un bastón con ambas manos al frente.","Realiza círculos amplios pasando el bastón por encima de la cabeza.","Mantén los codos ligeramente flexionados.","Realiza 5 círculos hacia adelante y 5 hacia atrás."}	Aumenta la movilidad de toda la cápsula glenohumeral y mejora la conciencia propioceptiva del hombro.	Calentamiento antes de entrenar hombros, pecho o espalda.	\N	t	2026-07-05 18:27:29.574956+00
108ab4ca-b7c1-412c-baf1-1281ce51ab3d	Press con mancuerna rotador	fortalecimiento	shoulder	{"De pie o sentado, sostén una mancuerna ligera en una mano.","Eleva el brazo lateralmente a 90° con el codo flexionado.","Rota el antebrazo hacia arriba.","Baja lentamente y repite 12-15 veces por lado."}	Fortalece los rotadores externos del manguito rotador, reduciendo el riesgo de lesión en press de pecho.	En la rutina de hombros o como trabajo preventivo.	\N	t	2026-07-05 18:27:29.57798+00
fa309d87-77c3-4df4-812f-75c0bfa19d74	Face Pull con cuerda (salud del hombro)	fortalecimiento	shoulder	{"Coloca la polea a la altura de los ojos con cuerda.","Agarra los extremos con ambas manos.","Tira hacia la cara separando los extremos.","Los codos quedan por encima de los hombros. 15-20 reps."}	Fortalece deltoides posterior, rotadores externos y romboides. Corrige hombros caídos.	Al final de sesiones de empuje. También 2-3 veces por semana como trabajo postural.	\N	t	2026-07-05 18:27:29.581729+00
01bd7193-8b28-4c8f-b3f3-4c282cef0ab7	Pronación y supinación de antebrazo	movilidad	elbow	{"Siéntate con el codo apoyado en mesa, flexionado a 90°.","Sostén un martillo o mancuerna ligera.","Rota el antebrazo hacia abajo (pronación) lentamente.","Vuelve y rota hacia arriba (supinación).","10-12 reps lentas por lado."}	Mantiene el rango de pronación/supinación, previene rigidez post-entrenamiento.	Calentamiento para entrenamientos de brazos.	\N	t	2026-07-05 18:27:29.584801+00
344f58b3-9bc7-4a6e-b2c3-b75e3d68bdca	Curl excéntrico de bíceps	fortalecimiento	elbow	{"Sostén una mancuerna con el codo completamente flexionado.","Baja el peso en 4-5 segundos hasta extender el codo.","Usa la otra mano para subir (fase concéntrica asistida).","8-10 reps enfocándose en la bajada."}	Fortalece el tendón bicipital y tejidos del codo. Previene el codo de tenista.	En días de brazos como trabajo de prevención de lesiones.	\N	t	2026-07-05 18:27:29.588031+00
b77e4334-d166-436b-afb7-8d7d057c21a7	Extensión de tríceps en polea (olécranon)	fortalecimiento	elbow	{"Polea alta con cuerda o barra recta.","Codos pegados al cuerpo.","Extiende completamente los codos hacia abajo.","Vuelve lentamente. 12-15 reps."}	Fortalece el tríceps y estabiliza el codo, protegiéndolo en movimientos de press.	Al final de sesión de brazos o pecho.	\N	t	2026-07-05 18:27:29.591409+00
5a374dc5-90ca-4780-a367-51f1e0b17641	Flexión y extensión de muñeca con mancuerna	movilidad	wrist	{"Antebrazo apoyado en el muslo, mano hacia afuera.","Sostén mancuerna ligera (1-2 kg).","Baja la mano hacia el suelo (extensión).","Sube la mano hacia arriba (flexión). 15 reps."}	Mantiene el rango de flexión/extensión de la muñeca, previene el síndrome del túnel carpiano.	Calentamiento antes de entrenamientos de pecho o brazos.	\N	t	2026-07-05 18:27:29.594325+00
744d7ba4-f8a3-4d04-b6cd-7af73302228c	Círculos de muñeca	movilidad	wrist	{"Extiende los brazos o apoya los codos.","Realiza círculos lentos con las muñecas.","10 círculos en cada sentido por muñeca."}	Lubrica la articulación carpiana y reduce tensión acumulada.	Calentamiento antes de entrenar o tras trabajo prolongado con teclado.	\N	t	2026-07-05 18:27:29.597836+00
7fc7a141-74b8-4e0b-bce7-bf8cdedf257b	Curl de muñeca con mancuerna	fortalecimiento	wrist	{"Antebrazo apoyado en el muslo, mano hacia arriba.","Sostén mancuerna ligera.","Flexiona la muñeca subiendo el peso.","Baja lentamente al máximo de extensión. 15-20 reps."}	Fortalece los flexores del carpo y la fuerza de agarre.	Al final de la sesión de brazos.	\N	t	2026-07-05 18:27:29.601552+00
7121bae7-c8ed-473a-9d51-88f0302f1fc4	Apertura de cadera en 90/90	movilidad	hip	{"Siéntate en el suelo con ambas piernas dobladas a 90°.","Pierna delantera 90° con torso; trasera también.","Inclínate sobre la pierna delantera con espalda recta.","Mantén 30-60 segundos y cambia."}	Mejora rotación interna y externa de cadera, prepara para sentadillas profundas.	Calentamiento antes de piernas o en días de recuperación.	\N	t	2026-07-05 18:27:29.605189+00
cb2c7606-18e7-47b9-9010-05f3f63d5fbb	Estiramiento del psoas (hip flexor)	movilidad	hip	{"Arrodíllate con una rodilla en el suelo.","Pie delantero plano en el suelo.","Empuja la cadera hacia adelante y abajo.","Mantén 30-45 segundos por lado."}	Alarga el psoas acortado por sedentarismo, mejora la extensión de cadera.	Calentamiento antes de piernas o tras trabajo de escritorio prolongado.	\N	t	2026-07-05 18:27:29.609109+00
780b8876-6928-430a-b983-6a9922fb361b	Monster Walk con banda	fortalecimiento	hip	{"Banda elástica alrededor de los tobillos.","Posición atlética con rodillas semiflexionadas.","Da pasos laterales manteniendo tensión de la banda.","10-15 pasos en cada dirección."}	Fortalece glúteo medio y abductores. Previene colapso de rodilla en valgus.	Calentamiento antes de piernas.	\N	t	2026-07-05 18:27:29.612611+00
0c08349a-41e1-46cf-a7e2-bdd57fe25edb	Puente de glúteos activación (cadera)	fortalecimiento	hip	{"Tumbado boca arriba, rodillas flexionadas, pies en el suelo.","Empuja las caderas hacia arriba contrayendo glúteos.","Mantén 2 segundos arriba.","Baja sin tocar completamente el suelo. 15-20 reps."}	Activa glúteo mayor, estabiliza la coxofemoral y reduce carga lumbar.	Calentamiento de glúteos antes de sentadillas o hip thrust.	\N	t	2026-07-05 18:27:29.615997+00
335544c2-c59c-4d1d-9299-11f60e6894b3	Sentadilla parcial controlada (0°-60°)	movilidad	knee	{"De pie con pies al ancho de hombros.","Baja lentamente hasta 60° de flexión.","Mantén 2 segundos abajo.","Sube lentamente. 10-15 reps."}	Lubrica la rodilla, mejora propiocepción y fortalece cuádriceps en rango seguro.	Calentamiento antes de piernas, especialmente con historial de dolor de rodilla.	\N	t	2026-07-05 18:27:29.619707+00
e9937761-27c4-4e75-bf6f-bbd7c8a1e5a8	Estiramiento de isquiotibiales en decúbito	movilidad	knee	{"Tumbado boca arriba, lleva una pierna al pecho.","Extiende la rodilla lentamente hasta sentir estiramiento.","Mantén 30 segundos sin rebotar.","Cambia de pierna."}	Mejora extensión de rodilla y alivia tensión en tendones isquiotibiales.	Después de piernas o en días de recuperación.	\N	t	2026-07-05 18:27:29.62308+00
4cf2d201-2059-4f96-84ab-5683b6487b36	Nordic Curl (curl nórdico)	fortalecimiento	knee	{"Arrodíllate con pies sujetos por compañero o superficie fija.","Baja el torso hacia adelante controlando con los isquiotibiales.","Al perder control, apoya las manos y empuja para volver.","3-6 repeticiones."}	Reduce en hasta un 50% el riesgo de rotura de isquiotibiales.	Al final de piernas como prevención.	\N	t	2026-07-05 18:27:29.626909+00
af25c309-9bb5-425b-81cd-8a70b9f43a71	Rotaciones de tobillo	movilidad	ankle	{"Levanta un pie del suelo.","Realiza círculos amplios con el pie.","10 círculos en cada sentido por tobillo."}	Mejora la movilidad del tobillo en todos los planos y reduce rigidez.	Calentamiento antes de piernas o deportes de salto.	\N	t	2026-07-05 18:27:29.631052+00
be238527-0b26-4de3-898b-4b760f6f16c6	Dorsiflexión de tobillo en pared	movilidad	ankle	{"Pie a 5 cm de la pared.","Deja caer la rodilla hacia adelante intentando tocar la pared sin levantar el talón.","Mueve el pie más atrás si tocas la pared.","3-5 segundos por rep. 10 reps por tobillo."}	Mejora la dorsiflexión, fundamental para sentadillas profundas.	Calentamiento antes de sentadillas.	\N	t	2026-07-05 18:27:29.634773+00
1275aa75-04a4-4c97-8923-90ed5faf09e7	Elevaciones de talón (calf raises)	fortalecimiento	ankle	{"De pie en el borde de un escalón.","Baja los talones por debajo del escalón.","Sube elevando los talones al máximo.","Pausa 1 segundo arriba. 15-20 reps."}	Fortalece el tríceps sural y el tendón de Aquiles.	Al final de piernas o como trabajo preventivo diario.	\N	t	2026-07-05 18:27:29.63799+00
89425d2f-89c0-4910-b968-c7ebaaf2561b	Rotación cervical activa	movilidad	cervical	{"Sentado erguido con la mirada al frente.","Gira lentamente la cabeza hacia un lado hasta el límite cómodo.","Mantén 2-3 segundos y vuelve al centro.","8-10 repeticiones por lado."}	Mantiene el rango de rotación cervical y reduce rigidez por postura.	Calentamiento antes de dominadas o en pausas de trabajo.	\N	t	2026-07-05 18:27:29.641811+00
b368454e-185d-4f9e-9084-830d9477bdf5	Chin tuck (retracción cervical)	fortalecimiento	cervical	{"Sentado o de pie con mirada al frente.","Mete el mentón hacia atrás creando doble papada.","Mantén 5-10 segundos.","10-15 repeticiones."}	Fortalece flexores profundos del cuello, corrige "text neck" y previene dolor cervical.	Diariamente como ejercicio postural.	\N	t	2026-07-05 18:27:29.644834+00
aa4e2678-e10e-41b2-a85f-0b0f05f2265c	Cat-Cow (flexión y extensión lumbar)	movilidad	lumbar	{"A cuatro patas con manos bajo hombros y rodillas bajo caderas.","Exhala y arquea la espalda hacia arriba (cat).","Inhala y baja el abdomen dejando espalda cóncava (cow).","10-15 repeticiones coordinando con respiración."}	Mejora movilidad lumbar y torácica, lubrica los discos intervertebrales.	Al levantarse, antes de peso muerto o sentadillas.	\N	t	2026-07-05 18:27:29.648385+00
86c37f80-e761-4c92-8b9f-d73398ed9fe8	Bird-Dog (estabilidad lumbar)	fortalecimiento	lumbar	{"A cuatro patas con espalda neutral.","Extiende brazo derecho al frente y pierna izquierda atrás simultáneamente.","Cadera nivelada y core activo durante 3-5 segundos.","10 repeticiones por lado."}	Fortalece extensores lumbares y core profundo de forma segura.	Calentamiento antes de peso muerto. También en programas de prevención lumbar.	\N	t	2026-07-05 18:27:29.651351+00
ba6ead7a-e62c-49f6-90c8-0d817e3fce8c	Dead Bug (estabilidad lumbar)	fortalecimiento	lumbar	{"Tumbado boca arriba, brazos al techo, rodillas a 90° elevadas.","Baja brazo derecho atrás y pierna izquierda al suelo exhalando.","Zona lumbar pegada al suelo todo el tiempo.","8-10 repeticiones por lado."}	Fortalece transverso abdominal y estabilizadores lumbares. Previene dolor lumbar.	Calentamiento de core antes de sentadillas. También en rehabilitación lumbar.	\N	t	2026-07-05 18:27:29.65421+00
\.


--
-- Data for Name: lift_submission_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lift_submission_images (id, submission_id, image_url, sort_order, uploaded_at) FROM stdin;
\.


--
-- Data for Name: lift_submissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lift_submissions (id, user_id, exercise_id, weight_kg, reps, location_name, location_lat, location_lng, description, was_witnessed, witness_name, video_url, status, reviewed_by, review_comment, reviewed_at, is_record_breaking, created_at, updated_at) FROM stdin;
78f2a4dd-460f-42bf-89b9-26660088c258	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	90.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 21:58:18.638351+00	t	2026-07-05 21:58:18.568807+00	2026-07-05 21:58:18.638351+00
55aa8016-d698-4b6a-baad-8cf16ca1c645	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	140.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 21:58:18.653599+00	t	2026-07-05 21:58:18.580929+00	2026-07-05 21:58:18.653599+00
73483d75-ba5c-49b1-bf15-75579d7eebab	7b44888c-e917-4b70-9479-c0525d156dca	7917a8e6-6d39-4151-af70-7a4f24b5ce94	150.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 21:58:18.66659+00	t	2026-07-05 21:58:18.591262+00	2026-07-05 21:58:18.66659+00
c65cef44-c957-485e-ad80-2b44e27df41a	9f959d01-ad53-4931-a98b-4e0461f736b4	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	60.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 21:58:18.679941+00	f	2026-07-05 21:58:18.614894+00	2026-07-05 21:58:18.679941+00
72b77ac2-a860-4ed8-b5e7-7c8b50a7073a	9f959d01-ad53-4931-a98b-4e0461f736b4	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	90.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 21:58:18.690558+00	f	2026-07-05 21:58:18.626789+00	2026-07-05 21:58:18.690558+00
0ef1ccb6-60de-42a4-85d6-11ec80bc0bfd	7b44888c-e917-4b70-9479-c0525d156dca	b76fc300-143d-4f4e-b71a-6692489a7bc3	70.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	rejected	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	El video no muestra el descenso completo del movimiento.	2026-07-05 21:58:18.700631+00	f	2026-07-05 21:58:18.602541+00	2026-07-05 21:58:18.700631+00
47f275eb-c0c6-4894-ab03-c10818464d00	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	90.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:08:02.230638+00	f	2026-07-05 22:08:02.157257+00	2026-07-05 22:08:02.230638+00
43ecfe99-9b36-4221-bb9d-6a0780998ffe	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	140.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:08:02.242602+00	f	2026-07-05 22:08:02.171095+00	2026-07-05 22:08:02.242602+00
ff1f40f8-460b-403a-aeb7-e892e01bb1e6	7b44888c-e917-4b70-9479-c0525d156dca	7917a8e6-6d39-4151-af70-7a4f24b5ce94	150.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:08:02.255601+00	f	2026-07-05 22:08:02.183386+00	2026-07-05 22:08:02.255601+00
bdfc524b-4fb2-4c6d-93c1-4271ef731426	9f959d01-ad53-4931-a98b-4e0461f736b4	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	60.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:08:02.269489+00	f	2026-07-05 22:08:02.206856+00	2026-07-05 22:08:02.269489+00
bf1bbbb9-3563-4659-8967-14dae4613ba0	9f959d01-ad53-4931-a98b-4e0461f736b4	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	90.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:08:02.282336+00	f	2026-07-05 22:08:02.219127+00	2026-07-05 22:08:02.282336+00
8cfc42b5-fd07-426f-a5f3-51a720380a97	7b44888c-e917-4b70-9479-c0525d156dca	b76fc300-143d-4f4e-b71a-6692489a7bc3	70.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	rejected	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	El video no muestra el descenso completo del movimiento.	2026-07-05 22:08:02.29314+00	f	2026-07-05 22:08:02.195153+00	2026-07-05 22:08:02.29314+00
846a153c-95cd-4c44-9da5-567f9c8443d0	03455fe8-05e0-4138-a7ed-df01b34314f2	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	105.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:17:34.947653+00	t	2026-07-05 22:17:34.86157+00	2026-07-05 22:17:34.947653+00
cb629ebd-c390-400d-97a0-9e33552518f3	03455fe8-05e0-4138-a7ed-df01b34314f2	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	160.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:17:34.964372+00	t	2026-07-05 22:17:34.875044+00	2026-07-05 22:17:34.964372+00
3aba9028-2274-4852-a3f3-34f82ab37831	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	210.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:17:34.979981+00	t	2026-07-05 22:17:34.897745+00	2026-07-05 22:17:34.979981+00
4c78a421-a982-4a96-9345-032f6315ea26	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	b76fc300-143d-4f4e-b71a-6692489a7bc3	85.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:17:34.996265+00	t	2026-07-05 22:17:34.913033+00	2026-07-05 22:17:34.996265+00
a29c06fe-3faf-4fbe-9987-d46f7a6e2bc6	666ff6f7-7e31-4281-91dc-20d7b6925912	b76fc300-143d-4f4e-b71a-6692489a7bc3	32.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:32:34.487085+00	f	2026-07-05 22:17:34.936476+00	2026-07-05 22:32:34.487085+00
da73fe6a-d03f-4a1b-a657-b15f4ff7a19c	666ff6f7-7e31-4281-91dc-20d7b6925912	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	48.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:54:10.342525+00	f	2026-07-05 22:17:34.92549+00	2026-07-05 22:54:10.342525+00
16c97b8f-c149-4ecb-8157-25255508d503	30c0413b-4439-4215-b063-6b0ae5976e00	7917a8e6-6d39-4151-af70-7a4f24b5ce94	55.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:54:13.326808+00	f	2026-07-05 22:17:34.885952+00	2026-07-05 22:54:13.326808+00
7c198533-f6eb-440b-bc12-069627e8d359	4fb46b65-f43a-4765-97f2-ff887468cf41	7917a8e6-6d39-4151-af70-7a4f24b5ce94	75.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:54:15.48451+00	f	2026-07-05 22:17:34.848056+00	2026-07-05 22:54:15.48451+00
aabfb022-99cf-4c15-874c-d1ef2ad8719f	4fb46b65-f43a-4765-97f2-ff887468cf41	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	42.00	1	Gimnasio UBB	\N	\N	\N	t	Compañero de entrenamiento	https://www.youtube.com/watch?v=dQw4w9WgXcQ	approved	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	2026-07-05 22:54:17.53146+00	f	2026-07-05 22:17:34.835319+00	2026-07-05 22:54:17.53146+00
\.


--
-- Data for Name: notification_reads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notification_reads (user_id, notif_type, reference_id, read_at) FROM stdin;
1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	event	bc21c4cd-b593-4c01-9901-afdda9bbe28c	2026-07-05 21:41:28.639317+00
\.


--
-- Data for Name: personal_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personal_records (id, user_id, exercise_id, weight_kg, reps, achieved_at, session_id, is_validated, duration_seconds) FROM stdin;
97c7af3f-9986-44e2-9053-5c95e80f6dbb	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	af2404f4-3336-4efd-a026-8f4c8d2ebb33	27.00	8	2026-07-05 22:07:54.572017+00	8aaefde6-b0c0-4666-9dea-a3afa1664332	f	\N
a6e181be-bbbd-4ab2-9122-cb1e9b81d2c7	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	b76fc300-143d-4f4e-b71a-6692489a7bc3	54.50	6	2026-07-05 22:07:55.081639+00	da61ab26-62ff-47bb-af2d-fa931ba98b51	f	\N
6b5735d5-ef4f-40d8-ba1a-baac122d67f3	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	b76fc300-143d-4f4e-b71a-6692489a7bc3	54.00	4	2026-07-05 22:07:55.102919+00	da61ab26-62ff-47bb-af2d-fa931ba98b51	f	\N
5b7bcce5-c0da-464e-9eea-e6f92ebfb132	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	134.50	5	2026-07-05 22:07:55.822301+00	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	f	\N
75e072ad-7572-4bc6-84bb-b624358f56be	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	af2404f4-3336-4efd-a026-8f4c8d2ebb33	27.50	9	2026-07-05 22:07:55.453002+00	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	f	\N
3743d6dd-9e90-4b0a-992a-4ebd9080d6c9	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	84.00	6	2026-07-05 22:07:56.747902+00	d72ed32d-3d09-4224-8924-b53501fabdb7	f	\N
4cff2731-0859-4800-8a23-68954195640e	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	107.00	5	2026-07-05 22:07:55.848483+00	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	f	\N
5aa36567-46ea-4e82-a2e9-fc4e32cad665	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7917a8e6-6d39-4151-af70-7a4f24b5ce94	126.00	6	2026-07-05 22:07:57.757165+00	45330506-b3cc-4c84-b718-16b3cea21342	f	\N
5a3bd3f9-5277-4bb9-9776-254e3f4a5592	7b44888c-e917-4b70-9479-c0525d156dca	7917a8e6-6d39-4151-af70-7a4f24b5ce94	201.50	6	2026-07-05 22:07:59.655165+00	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	t	\N
81a02dd4-adf7-4ab0-b7c4-07fc26c5ce45	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	b76fc300-143d-4f4e-b71a-6692489a7bc3	42.00	4	2026-07-05 22:07:57.161336+00	90cdee4d-d2d5-445c-a178-820fc713ea63	f	\N
d4bc05e9-c999-4026-823b-163151566c9a	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	b76fc300-143d-4f4e-b71a-6692489a7bc3	56.50	6	2026-07-05 22:07:57.828995+00	45330506-b3cc-4c84-b718-16b3cea21342	f	\N
2b98b857-1773-4524-a1d2-6ead0f9cc97a	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	84.50	7	2026-07-05 22:07:57.385307+00	485d5d3d-3a3a-478c-9b66-e4531f48c18f	f	\N
72d2bdd4-4704-42db-a9da-2100e3bd78b8	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	af2404f4-3336-4efd-a026-8f4c8d2ebb33	27.00	9	2026-07-05 22:07:57.465587+00	485d5d3d-3a3a-478c-9b66-e4531f48c18f	f	\N
580a41a7-a794-4371-a4b9-4f3acbf35883	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	146.00	5	2026-07-05 22:07:57.714761+00	45330506-b3cc-4c84-b718-16b3cea21342	f	\N
9d16a508-1a62-4af3-a35a-78516cbdafa7	7b44888c-e917-4b70-9479-c0525d156dca	af2404f4-3336-4efd-a026-8f4c8d2ebb33	27.50	8	2026-07-05 22:07:58.685039+00	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	f	\N
85bf84d8-4b8e-40fe-be8e-1a45e95c233e	7b44888c-e917-4b70-9479-c0525d156dca	b76fc300-143d-4f4e-b71a-6692489a7bc3	77.00	6	2026-07-05 22:07:59.684335+00	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	f	\N
339b828c-47bb-4754-b9aa-b98882836ebd	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	b76fc300-143d-4f4e-b71a-6692489a7bc3	56.00	7	2026-07-05 22:07:57.848912+00	45330506-b3cc-4c84-b718-16b3cea21342	f	\N
3115639b-d298-4394-bb56-be8a8b93e745	7b44888c-e917-4b70-9479-c0525d156dca	b76fc300-143d-4f4e-b71a-6692489a7bc3	79.00	5	2026-07-05 22:07:59.036768+00	c7df5426-38ce-4192-9182-c7fd54a1fc55	f	\N
45522dc0-c573-4ee4-a4a6-e47419a9997c	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 21:58:12.486699+00	\N	f	36
6e6e707f-9b89-4c92-9afb-c114cd254065	9f959d01-ad53-4931-a98b-4e0461f736b4	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	42.00	6	2026-07-05 22:08:00.474291+00	5f1ee935-e9d3-40c1-8a75-945e12ce9597	f	\N
a082c54f-fc6a-487a-9e29-15a04ee0acab	4fb46b65-f43a-4765-97f2-ff887468cf41	7917a8e6-6d39-4151-af70-7a4f24b5ce94	86.50	5	2026-07-05 22:17:22.657798+00	b55effa7-0a5d-4dd6-a72d-d7c168afff01	f	\N
c6603c62-4e4e-4a32-8464-667b22fe730c	7b44888c-e917-4b70-9479-c0525d156dca	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	212.00	4	2026-07-05 22:07:59.609884+00	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	f	\N
fcda61e9-e8e3-4b6c-9f36-aa96801573f8	7b44888c-e917-4b70-9479-c0525d156dca	af2404f4-3336-4efd-a026-8f4c8d2ebb33	27.00	9	2026-07-05 22:07:59.319182+00	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	f	\N
1f540997-6f50-4fdc-87de-8ac5ab49cfd7	9f959d01-ad53-4931-a98b-4e0461f736b4	af2404f4-3336-4efd-a026-8f4c8d2ebb33	24.50	8	2026-07-05 22:08:00.487874+00	5f1ee935-e9d3-40c1-8a75-945e12ce9597	f	\N
e794dbf2-b107-463d-b2b0-686fc5edd43b	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	114.50	6	2026-07-05 22:07:55.872712+00	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	f	\N
42f0f662-7297-482f-adf6-d8b52e76bc1a	9f959d01-ad53-4931-a98b-4e0461f736b4	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	89.50	4	2026-07-05 22:08:00.757043+00	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	f	\N
24c57d9b-a167-40c4-be08-a0a422fbe35b	7b44888c-e917-4b70-9479-c0525d156dca	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	119.00	7	2026-07-05 22:07:58.626161+00	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	t	\N
021e61ca-e794-4685-860d-0831634778a9	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	133.00	3	2026-07-05 22:07:54.952539+00	da61ab26-62ff-47bb-af2d-fa931ba98b51	f	\N
6821bdf7-c2a2-4fc7-8c7d-bfc3f07826b9	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 21:58:13.550154+00	\N	f	33
8faae922-fd16-453f-936b-0554d30caad9	9f959d01-ad53-4931-a98b-4e0461f736b4	7917a8e6-6d39-4151-af70-7a4f24b5ce94	68.50	4	2026-07-05 22:08:00.798759+00	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	f	\N
cf9b9b0d-b370-4b31-8ab9-033584ba4240	9f959d01-ad53-4931-a98b-4e0461f736b4	7917a8e6-6d39-4151-af70-7a4f24b5ce94	67.00	6	2026-07-05 22:08:00.826325+00	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	f	\N
d53d030b-1093-4e84-abfe-2fd7f9d7bf3e	4fb46b65-f43a-4765-97f2-ff887468cf41	af2404f4-3336-4efd-a026-8f4c8d2ebb33	22.00	8	2026-07-05 22:17:21.450274+00	a5881daa-3959-4259-93c4-ad5995eb5e70	f	\N
3280f565-dab6-4512-9e7b-89d21fe81bed	9f959d01-ad53-4931-a98b-4e0461f736b4	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	44.00	7	2026-07-05 22:08:01.088987+00	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	f	\N
85ddf7c5-c1c9-462e-917b-5a65c5fcc0c1	7b44888c-e917-4b70-9479-c0525d156dca	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 21:58:15.834948+00	\N	f	36
70ac2fb2-a1db-451b-8824-affe70f5d0a6	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	b76fc300-143d-4f4e-b71a-6692489a7bc3	53.50	7	2026-07-05 22:07:55.910046+00	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	f	\N
ffc6fdf9-fdf5-453b-867c-716cb2246462	9f959d01-ad53-4931-a98b-4e0461f736b4	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	90.50	5	2026-07-05 22:08:01.391971+00	8999a2ac-efc1-4012-8f18-9168edf654a3	f	\N
a6946b6b-6340-4074-a50c-3b6d133a5de2	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	74.50	6	2026-07-05 22:07:54.513196+00	8aaefde6-b0c0-4666-9dea-a3afa1664332	f	\N
ee5a3eaa-c207-4960-8095-22d10ce5741a	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	75.00	7	2026-07-05 22:07:54.555093+00	8aaefde6-b0c0-4666-9dea-a3afa1664332	f	\N
0ffb7b53-6ee4-4cc1-b7b5-de333b8f3fec	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	108.50	3	2026-07-05 22:07:55.004435+00	da61ab26-62ff-47bb-af2d-fa931ba98b51	f	\N
23e6bf6e-39d0-49c4-9f82-e2178ef8ce3f	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	151.50	4	2026-07-05 22:07:57.087211+00	90cdee4d-d2d5-445c-a178-820fc713ea63	f	\N
a869a7b4-3e8f-4bca-b077-2f8b0050e156	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	138.00	4	2026-07-05 22:07:55.783307+00	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	f	\N
e3f12c2c-704f-4c02-ad9b-70868c2aa7e5	7b44888c-e917-4b70-9479-c0525d156dca	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	202.00	5	2026-07-05 22:07:58.977505+00	c7df5426-38ce-4192-9182-c7fd54a1fc55	f	\N
4b8fe979-f9fa-4f4d-a2e2-584fb91a3309	7b44888c-e917-4b70-9479-c0525d156dca	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	121.00	6	2026-07-05 22:07:58.640786+00	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	t	\N
f91e22e2-28eb-4912-b8dd-afa083b987ec	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7917a8e6-6d39-4151-af70-7a4f24b5ce94	125.50	5	2026-07-05 22:07:57.132462+00	90cdee4d-d2d5-445c-a178-820fc713ea63	f	\N
1bdf0c3f-bbe7-445b-8d13-d952d294e0b2	7b44888c-e917-4b70-9479-c0525d156dca	b76fc300-143d-4f4e-b71a-6692489a7bc3	82.50	7	2026-07-05 22:07:59.669785+00	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	f	\N
606567b7-4e0b-484a-95d1-ad05936d64fa	9f959d01-ad53-4931-a98b-4e0461f736b4	b76fc300-143d-4f4e-b71a-6692489a7bc3	30.00	5	2026-07-05 22:08:00.852395+00	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	f	\N
36a83b97-7cd1-46cd-b2a8-3be10bb0f0db	9f959d01-ad53-4931-a98b-4e0461f736b4	b76fc300-143d-4f4e-b71a-6692489a7bc3	30.00	7	2026-07-05 22:08:00.866559+00	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	f	\N
9654f97d-6381-4d03-b4e3-81803eb8c572	9f959d01-ad53-4931-a98b-4e0461f736b4	7917a8e6-6d39-4151-af70-7a4f24b5ce94	64.00	5	2026-07-05 22:08:01.446583+00	8999a2ac-efc1-4012-8f18-9168edf654a3	f	\N
163b929f-32e9-405a-bd21-912b15515e01	9f959d01-ad53-4931-a98b-4e0461f736b4	b76fc300-143d-4f4e-b71a-6692489a7bc3	30.50	6	2026-07-05 22:08:01.460893+00	8999a2ac-efc1-4012-8f18-9168edf654a3	f	\N
75ab9594-a81e-4192-8849-25627dddbfd2	9f959d01-ad53-4931-a98b-4e0461f736b4	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 21:58:16.921962+00	\N	f	37
9dc3909c-7396-4a0a-b1c1-96c8a7e1d459	9f959d01-ad53-4931-a98b-4e0461f736b4	af2404f4-3336-4efd-a026-8f4c8d2ebb33	23.50	9	2026-07-05 21:58:17.52952+00	\N	f	\N
2a2a6b6d-55cb-407e-8eb3-21780888c3ad	4fb46b65-f43a-4765-97f2-ff887468cf41	af2404f4-3336-4efd-a026-8f4c8d2ebb33	24.50	9	2026-07-05 22:17:22.292309+00	85fbbcb9-45ec-4977-840b-f47418bed227	f	\N
e53be716-b10f-49c5-85af-b1fab27c6c80	4fb46b65-f43a-4765-97f2-ff887468cf41	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	101.50	4	2026-07-05 22:17:21.779718+00	37d8bb24-9f1a-4324-89d3-96a41cf12401	f	\N
667788fe-0b6b-4618-bc1a-2ac9461e361d	4fb46b65-f43a-4765-97f2-ff887468cf41	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 22:17:21.554736+00	a5881daa-3959-4259-93c4-ad5995eb5e70	f	37
a485a8e4-c973-4924-a6b9-1e064b811607	4fb46b65-f43a-4765-97f2-ff887468cf41	7917a8e6-6d39-4151-af70-7a4f24b5ce94	78.00	3	2026-07-05 22:17:21.840961+00	37d8bb24-9f1a-4324-89d3-96a41cf12401	f	\N
26be3311-e827-46ed-bab4-14fdf3fbd135	4fb46b65-f43a-4765-97f2-ff887468cf41	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	60.00	7	2026-07-05 22:17:22.219302+00	85fbbcb9-45ec-4977-840b-f47418bed227	f	\N
0f588ced-68e0-4010-83a5-b1a105cd14eb	4fb46b65-f43a-4765-97f2-ff887468cf41	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	109.00	5	2026-07-05 22:17:22.637112+00	b55effa7-0a5d-4dd6-a72d-d7c168afff01	f	\N
71642a14-ae42-4fe8-bc6c-da6a7ecf6b58	4fb46b65-f43a-4765-97f2-ff887468cf41	7917a8e6-6d39-4151-af70-7a4f24b5ce94	83.00	6	2026-07-05 22:17:22.675925+00	b55effa7-0a5d-4dd6-a72d-d7c168afff01	f	\N
ae8e0983-901c-4ee0-b0ad-088020c12774	4fb46b65-f43a-4765-97f2-ff887468cf41	b76fc300-143d-4f4e-b71a-6692489a7bc3	36.00	7	2026-07-05 22:17:22.729802+00	b55effa7-0a5d-4dd6-a72d-d7c168afff01	f	\N
ec957fb6-4f5e-4c63-b75d-99231b72561a	7b44888c-e917-4b70-9479-c0525d156dca	7917a8e6-6d39-4151-af70-7a4f24b5ce94	203.50	5	2026-07-05 22:07:59.005846+00	c7df5426-38ce-4192-9182-c7fd54a1fc55	t	\N
e802aa37-3d70-4d6c-a1a3-8a899603b9a2	4fb46b65-f43a-4765-97f2-ff887468cf41	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	60.50	6	2026-07-05 22:17:22.246128+00	85fbbcb9-45ec-4977-840b-f47418bed227	f	\N
ec7e7fcf-cd19-4839-aab1-612e8b3edec1	4fb46b65-f43a-4765-97f2-ff887468cf41	b76fc300-143d-4f4e-b71a-6692489a7bc3	36.50	6	2026-07-05 22:17:22.713947+00	b55effa7-0a5d-4dd6-a72d-d7c168afff01	f	\N
2a763a51-cae0-4f67-aa66-6d9a5b4e9b4b	03455fe8-05e0-4138-a7ed-df01b34314f2	af2404f4-3336-4efd-a026-8f4c8d2ebb33	21.00	8	2026-07-05 22:17:24.508311+00	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	f	\N
ecdb2e99-5c56-45a4-a3c5-09a7f1f0db91	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	af2404f4-3336-4efd-a026-8f4c8d2ebb33	21.00	9	2026-07-05 22:17:30.092923+00	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	f	\N
8a121447-b749-4480-9bd1-5f6d82a3b670	03455fe8-05e0-4138-a7ed-df01b34314f2	b76fc300-143d-4f4e-b71a-6692489a7bc3	63.00	5	2026-07-05 22:17:24.863529+00	613ad69a-1c00-4d47-b2b9-33d0b817be58	f	\N
891b4522-3581-458a-a875-81b9ecbebe71	03455fe8-05e0-4138-a7ed-df01b34314f2	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	99.50	7	2026-07-05 22:17:25.096406+00	3f924539-69ff-433f-b69b-fa8820966223	f	\N
06397ad3-bdb3-4520-9b94-c4109a5aab74	03455fe8-05e0-4138-a7ed-df01b34314f2	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	99.50	6	2026-07-05 22:17:25.107816+00	3f924539-69ff-433f-b69b-fa8820966223	f	\N
b4144c79-b22d-4f3e-885e-7483e557b1fe	03455fe8-05e0-4138-a7ed-df01b34314f2	af2404f4-3336-4efd-a026-8f4c8d2ebb33	24.50	9	2026-07-05 22:17:25.132381+00	3f924539-69ff-433f-b69b-fa8820966223	f	\N
c47e0926-3ca2-4c83-a6ce-fbed998b459e	03455fe8-05e0-4138-a7ed-df01b34314f2	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 22:17:25.158245+00	3f924539-69ff-433f-b69b-fa8820966223	f	35
0de6ac65-99e1-4106-8fb2-dda0fcc6ac3a	03455fe8-05e0-4138-a7ed-df01b34314f2	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	177.00	5	2026-07-05 22:17:25.397541+00	94fcdec8-8caf-442a-8718-e3398035988b	f	\N
bdfe75a7-a9bf-4853-aa08-e5888d55378c	03455fe8-05e0-4138-a7ed-df01b34314f2	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	178.00	4	2026-07-05 22:17:25.409858+00	94fcdec8-8caf-442a-8718-e3398035988b	f	\N
ac4b4910-577f-412a-9c08-867f5916b5b4	03455fe8-05e0-4138-a7ed-df01b34314f2	7917a8e6-6d39-4151-af70-7a4f24b5ce94	155.00	6	2026-07-05 22:17:25.435669+00	94fcdec8-8caf-442a-8718-e3398035988b	f	\N
7d096a6d-0f0e-46be-875a-9fa018c630f6	03455fe8-05e0-4138-a7ed-df01b34314f2	7917a8e6-6d39-4151-af70-7a4f24b5ce94	164.50	5	2026-07-05 22:17:25.462758+00	94fcdec8-8caf-442a-8718-e3398035988b	f	\N
df790ce4-7ad1-42cd-9030-3fbd8385593c	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	197.00	3	2026-07-05 22:17:30.343798+00	fc65f5f9-55c7-47de-89bd-a6b33356ab70	f	\N
4f4b31b3-dc16-4a8f-8270-557726921fb9	03455fe8-05e0-4138-a7ed-df01b34314f2	b76fc300-143d-4f4e-b71a-6692489a7bc3	70.50	7	2026-07-05 22:17:25.502359+00	94fcdec8-8caf-442a-8718-e3398035988b	f	\N
2f3437a4-8ee1-4a43-af12-c1acb6dc95db	30c0413b-4439-4215-b063-6b0ae5976e00	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	30.50	6	2026-07-05 22:17:27.266317+00	fa76f805-56b5-4397-8add-a6c18f772d74	f	\N
f1b964ad-e0aa-4a8d-8a98-be42620a2e77	30c0413b-4439-4215-b063-6b0ae5976e00	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	62.00	5	2026-07-05 22:17:27.591134+00	365d203f-545c-4fea-83f1-91a5a67dcbad	f	\N
8d38e33b-e832-426f-8035-87000e957a58	30c0413b-4439-4215-b063-6b0ae5976e00	7917a8e6-6d39-4151-af70-7a4f24b5ce94	43.00	4	2026-07-05 22:17:27.602847+00	365d203f-545c-4fea-83f1-91a5a67dcbad	f	\N
ec99bdaa-3cdc-4c45-b5eb-5edf70a5973d	30c0413b-4439-4215-b063-6b0ae5976e00	b76fc300-143d-4f4e-b71a-6692489a7bc3	22.00	3	2026-07-05 22:17:27.655728+00	365d203f-545c-4fea-83f1-91a5a67dcbad	f	\N
347a12af-4632-45e5-8f52-43ddada852db	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	199.50	2	2026-07-05 22:17:30.372777+00	fc65f5f9-55c7-47de-89bd-a6b33356ab70	f	\N
0c61b89d-2256-44e4-b4e3-f58aa25849ff	30c0413b-4439-4215-b063-6b0ae5976e00	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	35.00	7	2026-07-05 22:17:27.911441+00	d2a54043-b875-4b1e-a60d-1cd6bff35fde	f	\N
65e2fc97-d150-491e-9025-590724b8e02c	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7917a8e6-6d39-4151-af70-7a4f24b5ce94	164.00	3	2026-07-05 22:17:30.385323+00	fc65f5f9-55c7-47de-89bd-a6b33356ab70	f	\N
002a273e-8e1b-4be2-9006-5b4a427b63d2	30c0413b-4439-4215-b063-6b0ae5976e00	af2404f4-3336-4efd-a026-8f4c8d2ebb33	24.50	9	2026-07-05 22:17:27.93971+00	d2a54043-b875-4b1e-a60d-1cd6bff35fde	f	\N
78c1eb5d-d630-43c7-aea0-f92486e995df	30c0413b-4439-4215-b063-6b0ae5976e00	af2404f4-3336-4efd-a026-8f4c8d2ebb33	24.50	10	2026-07-05 22:17:27.953164+00	d2a54043-b875-4b1e-a60d-1cd6bff35fde	f	\N
90173b5b-7dea-47da-b571-a96d2af758fc	30c0413b-4439-4215-b063-6b0ae5976e00	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 22:17:27.990899+00	d2a54043-b875-4b1e-a60d-1cd6bff35fde	f	37
8c6fec74-1f80-4324-81db-c9f5812857f1	30c0413b-4439-4215-b063-6b0ae5976e00	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	65.50	4	2026-07-05 22:17:28.207241+00	39e76321-62b2-4f8d-8caf-5fb06a427653	f	\N
6a2762b0-3c17-45a3-b2b7-49ec52e7813f	30c0413b-4439-4215-b063-6b0ae5976e00	7917a8e6-6d39-4151-af70-7a4f24b5ce94	48.00	6	2026-07-05 22:17:28.230165+00	39e76321-62b2-4f8d-8caf-5fb06a427653	f	\N
c9d7c99b-2ffa-475b-bc37-6777b83ebee2	30c0413b-4439-4215-b063-6b0ae5976e00	7917a8e6-6d39-4151-af70-7a4f24b5ce94	49.00	5	2026-07-05 22:17:28.242627+00	39e76321-62b2-4f8d-8caf-5fb06a427653	f	\N
11f2672d-44f4-4dc7-88fe-215d3d50eeae	30c0413b-4439-4215-b063-6b0ae5976e00	b76fc300-143d-4f4e-b71a-6692489a7bc3	22.50	7	2026-07-05 22:17:28.26755+00	39e76321-62b2-4f8d-8caf-5fb06a427653	f	\N
5461b609-600d-45f6-97ec-ce2aa24de09c	30c0413b-4439-4215-b063-6b0ae5976e00	b76fc300-143d-4f4e-b71a-6692489a7bc3	24.00	6	2026-07-05 22:17:28.280883+00	39e76321-62b2-4f8d-8caf-5fb06a427653	f	\N
c0233552-a16c-49be-9aa5-362053414b8d	666ff6f7-7e31-4281-91dc-20d7b6925912	af2404f4-3336-4efd-a026-8f4c8d2ebb33	24.50	8	2026-07-05 22:17:33.608074+00	0d492916-a40a-4d72-b4b5-1d0191c57479	f	\N
101c0ab7-74fa-4908-a0e1-3c0e6dccf90b	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	b76fc300-143d-4f4e-b71a-6692489a7bc3	68.00	3	2026-07-05 22:17:30.424771+00	fc65f5f9-55c7-47de-89bd-a6b33356ab70	f	\N
9d040ae7-f404-4705-a198-ede7aebbc540	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	b76fc300-143d-4f4e-b71a-6692489a7bc3	71.50	4	2026-07-05 22:17:30.436375+00	fc65f5f9-55c7-47de-89bd-a6b33356ab70	f	\N
65963b5c-46f7-46c4-bcd7-335080b8bf84	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	113.50	7	2026-07-05 22:17:30.677284+00	fdb60073-3884-4707-bbe8-2448231250d1	f	\N
292d4fa6-0490-48d6-93ab-f68f4782cfcf	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	118.00	6	2026-07-05 22:17:30.693289+00	fdb60073-3884-4707-bbe8-2448231250d1	f	\N
687c5dd7-0025-4edb-aff0-607a18b2d722	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	af2404f4-3336-4efd-a026-8f4c8d2ebb33	21.50	8	2026-07-05 22:17:30.730448+00	fdb60073-3884-4707-bbe8-2448231250d1	f	\N
9d12f2e1-991a-428b-b0ee-54e54d5e1f9e	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	af2404f4-3336-4efd-a026-8f4c8d2ebb33	22.00	10	2026-07-05 22:17:30.743764+00	fdb60073-3884-4707-bbe8-2448231250d1	f	\N
05d3799d-b5ce-4d20-9d73-918720a720e5	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 22:17:30.757494+00	fdb60073-3884-4707-bbe8-2448231250d1	f	36
2d4216b0-8bb5-4b4d-a3a1-57b17e54bbf7	666ff6f7-7e31-4281-91dc-20d7b6925912	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	115.00	4	2026-07-05 22:17:33.928895+00	a0fa267e-582b-423e-98d3-1516265202f7	f	\N
fb6c0c72-4664-4d5d-95ac-04a63628714b	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	213.50	4	2026-07-05 22:17:31.02249+00	5a045481-62b1-4d69-a44d-f950f0019e64	f	\N
4ebb73ae-1a93-4051-a015-a3cee6f2fa99	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7917a8e6-6d39-4151-af70-7a4f24b5ce94	175.00	6	2026-07-05 22:17:31.049588+00	5a045481-62b1-4d69-a44d-f950f0019e64	f	\N
b695e28a-078c-4afd-8903-7213b50cd882	666ff6f7-7e31-4281-91dc-20d7b6925912	6856b5d8-db6e-4e52-891a-f9fd473201b6	0.00	1	2026-07-05 22:17:32.996008+00	eb566f1f-1062-4c8d-be07-fcfe9e126044	f	36
d9012e46-cf7f-4db5-b2e9-ad0f42fbfb95	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7917a8e6-6d39-4151-af70-7a4f24b5ce94	169.50	5	2026-07-05 22:17:31.076563+00	5a045481-62b1-4d69-a44d-f950f0019e64	f	\N
58dae9e5-31ec-4b87-8066-907b018943dc	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	b76fc300-143d-4f4e-b71a-6692489a7bc3	79.00	6	2026-07-05 22:17:31.103344+00	5a045481-62b1-4d69-a44d-f950f0019e64	f	\N
8ba0177d-5f39-4062-b3d2-92a0cb4599c2	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	b76fc300-143d-4f4e-b71a-6692489a7bc3	72.00	7	2026-07-05 22:17:31.115627+00	5a045481-62b1-4d69-a44d-f950f0019e64	f	\N
0b200764-99ff-40a6-a315-1a3cd2a92cf9	666ff6f7-7e31-4281-91dc-20d7b6925912	7917a8e6-6d39-4151-af70-7a4f24b5ce94	86.50	4	2026-07-05 22:17:33.286908+00	c536128d-c41d-4a44-9ae6-4b6b46de277d	f	\N
f4524d9f-c689-41e9-b78b-4ca25ee8692e	666ff6f7-7e31-4281-91dc-20d7b6925912	7917a8e6-6d39-4151-af70-7a4f24b5ce94	75.00	3	2026-07-05 22:17:33.31322+00	c536128d-c41d-4a44-9ae6-4b6b46de277d	f	\N
a1f7a6bd-af2c-46ad-aa16-0b9a66eea66a	666ff6f7-7e31-4281-91dc-20d7b6925912	b76fc300-143d-4f4e-b71a-6692489a7bc3	32.50	5	2026-07-05 22:17:33.324655+00	c536128d-c41d-4a44-9ae6-4b6b46de277d	f	\N
0f01e475-48f0-4949-91a5-3da47cb48296	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	210.00	5	2026-07-05 22:17:31.036996+00	5a045481-62b1-4d69-a44d-f950f0019e64	t	\N
5b470d09-fdd9-4f0f-accd-49a6bf6d2943	666ff6f7-7e31-4281-91dc-20d7b6925912	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	61.00	6	2026-07-05 22:17:33.553218+00	0d492916-a40a-4d72-b4b5-1d0191c57479	f	\N
7ef59b32-c4da-4127-ad36-602a1ea64b74	666ff6f7-7e31-4281-91dc-20d7b6925912	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	61.00	7	2026-07-05 22:17:33.567676+00	0d492916-a40a-4d72-b4b5-1d0191c57479	f	\N
fa9ee6fc-48d1-4a5d-8709-f08bbd4e5553	666ff6f7-7e31-4281-91dc-20d7b6925912	af2404f4-3336-4efd-a026-8f4c8d2ebb33	23.50	9	2026-07-05 22:17:33.59418+00	0d492916-a40a-4d72-b4b5-1d0191c57479	f	\N
102d54d5-3652-4ace-afda-3a2448402a86	666ff6f7-7e31-4281-91dc-20d7b6925912	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	107.00	5	2026-07-05 22:17:33.912467+00	a0fa267e-582b-423e-98d3-1516265202f7	f	\N
4b21b88e-8a12-4b82-8450-e95d9d626d05	666ff6f7-7e31-4281-91dc-20d7b6925912	7917a8e6-6d39-4151-af70-7a4f24b5ce94	91.50	6	2026-07-05 22:17:33.942704+00	a0fa267e-582b-423e-98d3-1516265202f7	f	\N
e487a86d-0313-48d3-8b2e-9d932839a010	666ff6f7-7e31-4281-91dc-20d7b6925912	7917a8e6-6d39-4151-af70-7a4f24b5ce94	96.00	5	2026-07-05 22:17:33.957953+00	a0fa267e-582b-423e-98d3-1516265202f7	f	\N
0c3d0b91-1aee-406d-899a-11b4f13e77e0	666ff6f7-7e31-4281-91dc-20d7b6925912	b76fc300-143d-4f4e-b71a-6692489a7bc3	44.00	6	2026-07-05 22:17:33.986353+00	a0fa267e-582b-423e-98d3-1516265202f7	f	\N
84ddd71e-8726-4ab7-881c-a6b976ad51c0	666ff6f7-7e31-4281-91dc-20d7b6925912	b76fc300-143d-4f4e-b71a-6692489a7bc3	42.00	7	2026-07-05 22:17:34.02284+00	a0fa267e-582b-423e-98d3-1516265202f7	f	\N
12c29194-ce28-4107-988c-1cd350658212	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	155.00	1	2026-07-05 22:57:45.876388+00	379bab3f-f672-4261-8347-56e04e88edc7	f	\N
e6d9d88c-d0d3-4ef0-b130-b4e04bddab71	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	90.00	1	2026-07-05 22:57:45.889105+00	379bab3f-f672-4261-8347-56e04e88edc7	f	\N
8921bebe-0227-4727-814f-1b5949c12994	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	b76fc300-143d-4f4e-b71a-6692489a7bc3	65.00	1	2026-07-05 22:57:45.901015+00	379bab3f-f672-4261-8347-56e04e88edc7	f	\N
d287dbd6-df40-4fc3-8d5d-58c314f2dd59	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	135.00	1	2026-07-05 22:57:45.911772+00	379bab3f-f672-4261-8347-56e04e88edc7	f	\N
323719f3-9189-41ff-bfd8-83f4e815f77b	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	167.50	1	2026-07-05 22:57:46.260307+00	bc1077cc-c411-4693-8be3-981c511a06ae	f	\N
f9d3cd77-877d-4f6c-a881-4092840a0a2d	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	102.50	1	2026-07-05 22:57:46.283373+00	bc1077cc-c411-4693-8be3-981c511a06ae	f	\N
cd9034a2-8c31-4ea5-84a4-421b29331ec2	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	b76fc300-143d-4f4e-b71a-6692489a7bc3	67.50	1	2026-07-05 22:57:46.301983+00	bc1077cc-c411-4693-8be3-981c511a06ae	f	\N
761dec96-65cc-463c-b574-c5646de20af9	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	7917a8e6-6d39-4151-af70-7a4f24b5ce94	147.50	1	2026-07-05 22:57:46.317134+00	bc1077cc-c411-4693-8be3-981c511a06ae	f	\N
658bf50f-881e-4f39-8a34-6068aeaac6b4	7b44888c-e917-4b70-9479-c0525d156dca	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	235.00	1	2026-07-05 22:57:46.659631+00	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	f	\N
fc1aa6a9-8942-4124-b340-f80fdfb2954c	7b44888c-e917-4b70-9479-c0525d156dca	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	145.00	1	2026-07-05 22:57:46.671316+00	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	f	\N
b63a46db-0aef-4acd-be73-42c915490cbc	7b44888c-e917-4b70-9479-c0525d156dca	b76fc300-143d-4f4e-b71a-6692489a7bc3	100.00	1	2026-07-05 22:57:46.681596+00	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	f	\N
be2fa988-5b62-416a-a351-9e87d6609f54	7b44888c-e917-4b70-9479-c0525d156dca	7917a8e6-6d39-4151-af70-7a4f24b5ce94	237.50	1	2026-07-05 22:57:46.69235+00	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	f	\N
a50d79c1-d42c-4675-9542-93918b9e9037	9f959d01-ad53-4931-a98b-4e0461f736b4	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	102.50	1	2026-07-05 22:57:47.064353+00	ddde86ff-1675-4a35-b25a-68a816b98bdb	f	\N
c6f5e463-766d-444c-91d4-9b8f0aadca64	9f959d01-ad53-4931-a98b-4e0461f736b4	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	52.50	1	2026-07-05 22:57:47.079724+00	ddde86ff-1675-4a35-b25a-68a816b98bdb	f	\N
3efa89e1-7f1b-4036-9570-6e87e48668b7	9f959d01-ad53-4931-a98b-4e0461f736b4	b76fc300-143d-4f4e-b71a-6692489a7bc3	37.50	1	2026-07-05 22:57:47.093007+00	ddde86ff-1675-4a35-b25a-68a816b98bdb	f	\N
a34cf6d8-db85-4e13-98fc-d2e4a72aacb7	9f959d01-ad53-4931-a98b-4e0461f736b4	7917a8e6-6d39-4151-af70-7a4f24b5ce94	80.00	1	2026-07-05 22:57:47.104111+00	ddde86ff-1675-4a35-b25a-68a816b98bdb	f	\N
d92fc6f9-ad69-464a-bcea-424730d7bef7	4fb46b65-f43a-4765-97f2-ff887468cf41	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	125.00	1	2026-07-05 22:57:47.434745+00	a51b1111-c7a2-469e-95a2-a4be71318990	f	\N
034b3398-5cc3-43cf-bdb6-96dc41195147	4fb46b65-f43a-4765-97f2-ff887468cf41	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	72.50	1	2026-07-05 22:57:47.44486+00	a51b1111-c7a2-469e-95a2-a4be71318990	f	\N
7068b85d-4418-403f-9731-fa50074beb3a	4fb46b65-f43a-4765-97f2-ff887468cf41	b76fc300-143d-4f4e-b71a-6692489a7bc3	42.50	1	2026-07-05 22:57:47.456695+00	a51b1111-c7a2-469e-95a2-a4be71318990	f	\N
e37e787d-e959-48f4-9730-f5d948d5624c	4fb46b65-f43a-4765-97f2-ff887468cf41	7917a8e6-6d39-4151-af70-7a4f24b5ce94	100.00	1	2026-07-05 22:57:47.468545+00	a51b1111-c7a2-469e-95a2-a4be71318990	f	\N
491a46b3-cbba-41ba-b60d-361f0c5169bc	03455fe8-05e0-4138-a7ed-df01b34314f2	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	202.50	1	2026-07-05 22:57:47.80364+00	e27e688f-296a-49b9-b917-77becdc03b3e	f	\N
3acb6f2e-f902-43d0-827f-a7eb3275a44c	03455fe8-05e0-4138-a7ed-df01b34314f2	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	120.00	1	2026-07-05 22:57:47.81461+00	e27e688f-296a-49b9-b917-77becdc03b3e	f	\N
8bc36662-a5cc-46e6-806a-3774684a891c	03455fe8-05e0-4138-a7ed-df01b34314f2	b76fc300-143d-4f4e-b71a-6692489a7bc3	85.00	1	2026-07-05 22:57:47.82653+00	e27e688f-296a-49b9-b917-77becdc03b3e	f	\N
ed756aad-a0b6-43ad-a4c2-da0e5b16d635	03455fe8-05e0-4138-a7ed-df01b34314f2	7917a8e6-6d39-4151-af70-7a4f24b5ce94	187.50	1	2026-07-05 22:57:47.839361+00	e27e688f-296a-49b9-b917-77becdc03b3e	f	\N
1bab93f8-5f9f-487e-9807-d4b2dc2a8c0f	30c0413b-4439-4215-b063-6b0ae5976e00	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	72.50	1	2026-07-05 22:57:48.18333+00	f0911d89-b963-420c-ae05-54f51ae210b3	f	\N
5ce14676-f056-4fa1-9b4e-da06b03dc4f7	30c0413b-4439-4215-b063-6b0ae5976e00	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	42.50	1	2026-07-05 22:57:48.194207+00	f0911d89-b963-420c-ae05-54f51ae210b3	f	\N
cd17c4f6-93ec-424d-ac5e-ffb823254c0d	30c0413b-4439-4215-b063-6b0ae5976e00	b76fc300-143d-4f4e-b71a-6692489a7bc3	27.50	1	2026-07-05 22:57:48.205079+00	f0911d89-b963-420c-ae05-54f51ae210b3	f	\N
4b8f75cb-b088-4488-a803-787133cf1a77	30c0413b-4439-4215-b063-6b0ae5976e00	7917a8e6-6d39-4151-af70-7a4f24b5ce94	57.50	1	2026-07-05 22:57:48.21747+00	f0911d89-b963-420c-ae05-54f51ae210b3	f	\N
0b327543-0188-4d67-ba7e-b057366f40c9	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	240.00	1	2026-07-05 22:57:48.550491+00	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	f	\N
f1eeebf0-0274-46f5-a877-52f526c31557	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	140.00	1	2026-07-05 22:57:48.56147+00	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	f	\N
cd993338-7031-479f-a14e-de1ecaf5521e	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	b76fc300-143d-4f4e-b71a-6692489a7bc3	92.50	1	2026-07-05 22:57:48.574147+00	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	f	\N
95ff47f2-ef88-44cf-9246-16b2864604a4	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	7917a8e6-6d39-4151-af70-7a4f24b5ce94	205.00	1	2026-07-05 22:57:48.585828+00	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	f	\N
bc8b8380-d37d-471a-8332-4bf47cbfa0c8	666ff6f7-7e31-4281-91dc-20d7b6925912	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	127.50	1	2026-07-05 22:57:48.917441+00	078bd115-bd60-4448-9e90-92fb667f3e9a	f	\N
f1a27a27-06f6-4661-8030-d2536fb6de2e	666ff6f7-7e31-4281-91dc-20d7b6925912	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	72.50	1	2026-07-05 22:57:48.930023+00	078bd115-bd60-4448-9e90-92fb667f3e9a	f	\N
ad2cc4b2-67dd-4949-8964-8918c4e99004	666ff6f7-7e31-4281-91dc-20d7b6925912	b76fc300-143d-4f4e-b71a-6692489a7bc3	52.50	1	2026-07-05 22:57:48.94177+00	078bd115-bd60-4448-9e90-92fb667f3e9a	f	\N
ac4b6396-e9a6-4c39-be7e-faf63182dace	666ff6f7-7e31-4281-91dc-20d7b6925912	7917a8e6-6d39-4151-af70-7a4f24b5ce94	110.00	1	2026-07-05 22:57:48.953176+00	078bd115-bd60-4448-9e90-92fb667f3e9a	f	\N
\.


--
-- Data for Name: role_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_requests (id, user_id, justification, status, reviewed_by, review_comment, created_at, reviewed_at) FROM stdin;
\.


--
-- Data for Name: routine_day_exercises; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.routine_day_exercises (id, routine_day_id, exercise_id, sets, reps, rest_seconds, order_index, rir, duration_seconds, target_weight_kg) FROM stdin;
babc885c-ae1f-4618-be8b-dade5f4bafdc	c75c350d-0f96-4898-841d-665f02152204	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	8-10	90	0	\N	\N	\N
11f1ad87-7af2-4bcd-9d42-cf6c11ae574d	c75c350d-0f96-4898-841d-665f02152204	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	6-10	90	1	\N	\N	\N
d8d39237-2d81-4d43-8fa4-b6f5dca5df03	c75c350d-0f96-4898-841d-665f02152204	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
5d9c6317-dcbc-4e8f-b272-eb3fa8585a47	78acd96e-2db9-45b6-972f-bf9da33108aa	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	8-10	90	0	\N	\N	\N
aa323e79-24b5-4741-9669-fad539c386e6	78acd96e-2db9-45b6-972f-bf9da33108aa	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	6-10	90	1	\N	\N	\N
593d38fa-afca-4918-b2dd-68d736f1d967	78acd96e-2db9-45b6-972f-bf9da33108aa	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
3051664d-5918-4a91-a99c-4d28fe0325ee	9eaf7540-c252-425c-9b6d-c38891de7384	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	8-10	90	0	\N	\N	\N
c4f4db51-161d-477b-aa3d-39f0ee226e84	9eaf7540-c252-425c-9b6d-c38891de7384	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	6-10	90	1	\N	\N	\N
56f417b8-90a8-4bd6-98d1-0b9320db0cc6	9eaf7540-c252-425c-9b6d-c38891de7384	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
e6433aef-c954-45a1-8186-fa1cff4303a8	a2be792c-6b0a-44ca-8afb-21f0b4d20883	af2404f4-3336-4efd-a026-8f4c8d2ebb33	4	8-12	90	0	\N	\N	\N
40f73336-0e7d-409d-ad4b-b4451ec8d09b	a2be792c-6b0a-44ca-8afb-21f0b4d20883	55b3d152-315e-4dec-b7a8-1d3c48cc3e23	4	8-12	90	1	\N	\N	\N
13618777-a5fb-491c-8486-b1d96b759f79	a2be792c-6b0a-44ca-8afb-21f0b4d20883	273a1db1-497c-4598-8c97-b4bc295adad2	4	8-12	90	2	\N	\N	\N
21a1e22e-dcfd-4888-a01c-0f71cc05b198	e0bc3d63-5346-4dd8-890c-3a46965b41bd	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	8-10	90	0	\N	\N	\N
580a1255-5669-4569-a6ae-54629be12040	e0bc3d63-5346-4dd8-890c-3a46965b41bd	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	6-10	90	1	\N	\N	\N
04459c9f-eaef-4f5f-9af9-4fa34bd1e3dc	e0bc3d63-5346-4dd8-890c-3a46965b41bd	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
6e9b71de-9d6b-4c00-a086-0d14d74219f9	cfe6fb22-8838-429a-9318-e42e56ed34c0	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
df79714a-6efd-4100-9dc6-1853a088092a	cfe6fb22-8838-429a-9318-e42e56ed34c0	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
d2d7e0c2-f591-40fc-b1f7-fcd4ee5be0c7	cfe6fb22-8838-429a-9318-e42e56ed34c0	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
b7ae8731-d97e-43ca-ad87-d20d50c69223	34e7e5a7-5f01-443f-93f1-9467879e7af0	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
adee5f69-773c-43e7-9913-9a7382fba887	34e7e5a7-5f01-443f-93f1-9467879e7af0	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
30ea014d-9295-4de0-a17d-3c1e64206ca5	34e7e5a7-5f01-443f-93f1-9467879e7af0	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
2f284586-aa86-4259-9089-a65139ea06fd	c5b13aae-56d3-4519-ab0f-0efdf3925962	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
f678dd9f-0dcb-4db7-a201-6ffd309ead0a	c5b13aae-56d3-4519-ab0f-0efdf3925962	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
2f670f99-4e48-401c-875a-3a270a4588f2	c5b13aae-56d3-4519-ab0f-0efdf3925962	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
7a35ba7b-fd76-46dd-81a6-7e20356e89a0	2da5db85-0180-4329-bc73-ab183c96ecad	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
513f80fc-76a3-43cc-bf7a-352b0b5629a2	2da5db85-0180-4329-bc73-ab183c96ecad	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
a1004e66-82b7-4f6e-8fac-7c1c1025aa57	2da5db85-0180-4329-bc73-ab183c96ecad	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
6b6348e2-f181-4f5f-ae30-2d31532637e8	cce28a7a-d625-4d5c-87c7-0865e4476828	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
d5f79a8b-05e4-4841-b858-0c4c5c877f44	cce28a7a-d625-4d5c-87c7-0865e4476828	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
c250270b-5e1b-4f11-8375-ee35bd8f4fbb	cce28a7a-d625-4d5c-87c7-0865e4476828	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
b4ee432a-6c8c-4fe7-ae2a-bfaba398fffc	cb7c6f1b-c4db-48aa-abeb-f06492caf6f3	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
9910ba31-b8e5-41a5-8479-311bd301cdb9	cb7c6f1b-c4db-48aa-abeb-f06492caf6f3	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
54768c52-bae9-4d45-9f1d-250c3425968b	cb7c6f1b-c4db-48aa-abeb-f06492caf6f3	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
3a320c8f-b035-4eb1-addc-f74625122ccd	e0236d6a-11cc-4249-9993-56ffd25a7aad	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
79f26d48-119b-49ea-ab7c-e93725ce733a	e0236d6a-11cc-4249-9993-56ffd25a7aad	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
7032f8f3-df38-4f02-8ec3-db3b419eb0dc	e0236d6a-11cc-4249-9993-56ffd25a7aad	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
d952e9e1-b043-4adc-a565-07cfb2143bfb	aa380685-8323-4a9d-8ccd-69ef99d62f5e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
2c2729a9-ed78-43cd-9a9e-377b5c4aafaf	aa380685-8323-4a9d-8ccd-69ef99d62f5e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
970344bf-b0c8-4f3a-b6f1-605303a66e27	aa380685-8323-4a9d-8ccd-69ef99d62f5e	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
1e6fa237-61dd-41f6-8523-f89d147156ad	da161ab6-ba40-4fff-9b2a-2cf327cb8b88	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
5f320e82-0e3d-4a7f-bcd5-ca0b903a8a4c	da161ab6-ba40-4fff-9b2a-2cf327cb8b88	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
807566f4-efa2-4121-bb19-b7254f4af50f	da161ab6-ba40-4fff-9b2a-2cf327cb8b88	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
28e666a0-b5fa-450c-b2fa-c7e7cc6df55d	784a5de9-a4c5-4b52-93ca-485bddbfc58a	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
d1cb6acb-c0c6-4981-b58a-3df9139f5457	784a5de9-a4c5-4b52-93ca-485bddbfc58a	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
2f1c3d4b-0294-484e-af53-94c87028e4c4	784a5de9-a4c5-4b52-93ca-485bddbfc58a	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
fbe753b8-4599-4aa4-9146-ff2aee8eecf6	6c92fdbc-46a8-4557-b39e-4987431e0f72	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
6d3d501a-61ad-4479-8bef-cb5e2f39b5ac	6c92fdbc-46a8-4557-b39e-4987431e0f72	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
c5b0651e-2c73-4fb3-aabe-bd63269e6133	6c92fdbc-46a8-4557-b39e-4987431e0f72	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
b5871e6b-76e1-44de-9b77-d6046aa5bf29	b66f582f-1222-4a13-88b8-3f4bd59f6bdc	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
9dc78bde-c8cc-411d-bde7-b674066e9497	b66f582f-1222-4a13-88b8-3f4bd59f6bdc	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
e7302167-93e5-4a25-9d2d-cf4ea51246bd	b66f582f-1222-4a13-88b8-3f4bd59f6bdc	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
be643f51-5f33-4f6b-b8df-256dce183337	613dd2b4-be2e-4b65-8786-063b7f0e5d09	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
928f8210-a4eb-48ff-bdf2-ab6432120fc3	613dd2b4-be2e-4b65-8786-063b7f0e5d09	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
ff4f4392-1a94-47ed-89d5-457ab1e808f7	613dd2b4-be2e-4b65-8786-063b7f0e5d09	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
18df89ff-4033-4780-8201-1838de64f283	0691b90d-1215-4438-a2e4-1ad103916fa7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
7661dca1-d1b4-42cd-a897-e53720f6d9ee	0691b90d-1215-4438-a2e4-1ad103916fa7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
7972a4cb-0a1a-4bb1-bd33-617268098021	0691b90d-1215-4438-a2e4-1ad103916fa7	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
7ceb39f3-5637-4727-98bb-c97dd120d03d	7ca08b44-10d8-45ba-bf16-bf7fd181c274	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
115ac841-bd25-4bc2-a646-c4e207c5e2f8	7ca08b44-10d8-45ba-bf16-bf7fd181c274	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
02f58b4e-7a4c-489b-a6fe-dafd893123be	7ca08b44-10d8-45ba-bf16-bf7fd181c274	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
75e0a808-12d6-4cde-a06f-2d8c6ecfed7c	4a9cba0c-2683-41f2-9158-1422cc1d5b2c	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
108d0c1d-d21e-4741-8caf-1b1f3b34beb9	4a9cba0c-2683-41f2-9158-1422cc1d5b2c	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
e6520f66-9df3-4fcd-8fc5-df37db17fe78	4a9cba0c-2683-41f2-9158-1422cc1d5b2c	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
739bdc26-8b67-4688-b7c1-2f2e6251b774	4d0de000-a3c5-4f1b-8a44-5b27090e1438	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	6-8	120	0	\N	\N	\N
1a14f27e-1106-4c27-9ab0-a94d1f8be22d	4d0de000-a3c5-4f1b-8a44-5b27090e1438	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	8-12	90	1	\N	\N	\N
e5b66a10-895a-4928-af7d-60572fad4d1c	4d0de000-a3c5-4f1b-8a44-5b27090e1438	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	1	45	2	\N	30	\N
19483475-aff4-4147-95aa-3162069a1558	27a1794a-0761-4935-a662-3c50608430d3	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	4-6	150	0	\N	\N	\N
8461cfa5-a64d-4590-ae3a-35d93fc0ee67	27a1794a-0761-4935-a662-3c50608430d3	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	5-8	120	1	\N	\N	\N
2b25c1f6-9f93-4d60-9471-f2193d0c3b36	27a1794a-0761-4935-a662-3c50608430d3	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	6-10	90	2	\N	\N	\N
\.


--
-- Data for Name: routine_days; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.routine_days (id, routine_id, day_name, label, order_index) FROM stdin;
c75c350d-0f96-4898-841d-665f02152204	74910c85-17b5-4689-84a2-75f544f4d356	Dia QA	Dia QA	0
78acd96e-2db9-45b6-972f-bf9da33108aa	acb1a442-6d42-4ba4-a6f3-57cbb90d3ce7	Dia QA	Dia QA	0
9eaf7540-c252-425c-9b6d-c38891de7384	e3de71e1-85b0-40da-ae6e-45086ab2b65e	Dia QA	Dia QA	0
a2be792c-6b0a-44ca-8afb-21f0b4d20883	9ca48928-80e5-4e80-9614-b13d278ae010	Lunes	Lunes	0
c1cbb469-19c7-4c17-b194-a0bf8149d2c0	9ca48928-80e5-4e80-9614-b13d278ae010	Martes	Martes	1
89a991c7-4631-4532-b5e7-b060f0bd2891	9ca48928-80e5-4e80-9614-b13d278ae010	Viernes	Viernes	2
6b308598-cc89-49eb-80e4-608bae95ce79	9ca48928-80e5-4e80-9614-b13d278ae010	Sábado	Sábado	3
e0bc3d63-5346-4dd8-890c-3a46965b41bd	5d058f96-e40a-4e5b-8b69-a532d7852f38	Dia QA	Dia QA	0
cfe6fb22-8838-429a-9318-e42e56ed34c0	0f2c14fc-080a-47fe-8144-d7f905329d60	Dia A - Push	Dia A - Push	0
34e7e5a7-5f01-443f-93f1-9467879e7af0	0f2c14fc-080a-47fe-8144-d7f905329d60	Dia B - Piernas	Dia B - Pierna/Fuerza	1
c5b13aae-56d3-4519-ab0f-0efdf3925962	0084bb79-7ea4-4724-8426-01adfc915b89	Dia A - Push	Dia A - Push	0
2da5db85-0180-4329-bc73-ab183c96ecad	0084bb79-7ea4-4724-8426-01adfc915b89	Dia B - Piernas	Dia B - Pierna/Fuerza	1
cce28a7a-d625-4d5c-87c7-0865e4476828	4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	Dia A - Push	Dia A - Push	0
cb7c6f1b-c4db-48aa-abeb-f06492caf6f3	4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	Dia B - Piernas	Dia B - Pierna/Fuerza	1
e0236d6a-11cc-4249-9993-56ffd25a7aad	f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	Dia A - Push	Dia A - Push	0
aa380685-8323-4a9d-8ccd-69ef99d62f5e	f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	Dia B - Piernas	Dia B - Pierna/Fuerza	1
da161ab6-ba40-4fff-9b2a-2cf327cb8b88	d649dc2d-2fff-45ae-be2f-8abba64e8157	Dia A - Push	Dia A - Push	0
784a5de9-a4c5-4b52-93ca-485bddbfc58a	d649dc2d-2fff-45ae-be2f-8abba64e8157	Dia B - Piernas	Dia B - Pierna/Fuerza	1
6c92fdbc-46a8-4557-b39e-4987431e0f72	ae2faaec-3654-4f73-af2c-52ac013a4372	Dia A - Push	Dia A - Push	0
b66f582f-1222-4a13-88b8-3f4bd59f6bdc	ae2faaec-3654-4f73-af2c-52ac013a4372	Dia B - Piernas	Dia B - Pierna/Fuerza	1
613dd2b4-be2e-4b65-8786-063b7f0e5d09	31df5179-8d53-4a13-92dc-18f2732ca097	Dia A - Push	Dia A - Push	0
0691b90d-1215-4438-a2e4-1ad103916fa7	31df5179-8d53-4a13-92dc-18f2732ca097	Dia B - Piernas	Dia B - Pierna/Fuerza	1
7ca08b44-10d8-45ba-bf16-bf7fd181c274	96022afd-ee29-4bbf-ba7f-ec7ace16354e	Dia A - Push	Dia A - Push	0
4a9cba0c-2683-41f2-9158-1422cc1d5b2c	96022afd-ee29-4bbf-ba7f-ec7ace16354e	Dia B - Piernas	Dia B - Pierna/Fuerza	1
4d0de000-a3c5-4f1b-8a44-5b27090e1438	5e023a95-a9fc-439b-89b9-e04f10cb45f5	Dia A - Push	Dia A - Push	0
27a1794a-0761-4935-a662-3c50608430d3	5e023a95-a9fc-439b-89b9-e04f10cb45f5	Dia B - Piernas	Dia B - Pierna/Fuerza	1
\.


--
-- Data for Name: routines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.routines (id, user_id, name, description, goal, frequency_days, is_public, created_by, is_active, created_at, updated_at, is_default) FROM stdin;
74910c85-17b5-4689-84a2-75f544f4d356	5014e791-de85-402a-8cc2-6a99c0726c7d	QA Recomendaciones Mixta	Rutina de prueba para validar recomendaciones dinamico/calistenia/isometrico	hipertrofia	1	f	5014e791-de85-402a-8cc2-6a99c0726c7d	t	2026-07-05 21:15:34.61837+00	2026-07-05 21:15:34.61837+00	f
acb1a442-6d42-4ba4-a6f3-57cbb90d3ce7	91d44e7a-2224-410a-b969-edf87a91510a	QA Recomendaciones Mixta	Rutina de prueba para validar recomendaciones dinamico/calistenia/isometrico	hipertrofia	1	f	91d44e7a-2224-410a-b969-edf87a91510a	t	2026-07-05 21:24:30.950144+00	2026-07-05 21:24:30.950144+00	f
e3de71e1-85b0-40da-ae6e-45086ab2b65e	a127e44e-8a23-401d-9c52-52d16c6a3282	QA Recomendaciones Mixta	Rutina de prueba para validar recomendaciones dinamico/calistenia/isometrico	hipertrofia	1	f	a127e44e-8a23-401d-9c52-52d16c6a3282	t	2026-07-05 21:27:40.314316+00	2026-07-05 21:27:40.314316+00	f
5d058f96-e40a-4e5b-8b69-a532d7852f38	7f95c4cb-b6eb-4414-92e9-bfb7be2fab56	QA Recomendaciones Mixta	Rutina de prueba para validar recomendaciones dinamico/calistenia/isometrico	hipertrofia	1	f	7f95c4cb-b6eb-4414-92e9-bfb7be2fab56	t	2026-07-05 21:38:07.897438+00	2026-07-05 21:38:07.897438+00	f
5e023a95-a9fc-439b-89b9-e04f10cb45f5	666ff6f7-7e31-4281-91dc-20d7b6925912	Rutina QA Camila	Rutina de datos de prueba (QA)	hipertrofia	2	f	666ff6f7-7e31-4281-91dc-20d7b6925912	t	2026-07-05 22:17:32.837773+00	2026-07-05 22:17:32.879529+00	t
0084bb79-7ea4-4724-8426-01adfc915b89	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	Rutina QA Ivan	Rutina de datos de prueba (QA)	hipertrofia	2	f	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	t	2026-07-05 22:07:56.631215+00	2026-07-05 22:07:56.669982+00	t
4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	7b44888c-e917-4b70-9479-c0525d156dca	Rutina QA Profesor	Rutina de datos de prueba (QA)	hipertrofia	2	f	7b44888c-e917-4b70-9479-c0525d156dca	t	2026-07-05 22:07:58.552942+00	2026-07-05 22:07:58.587853+00	t
f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	9f959d01-ad53-4931-a98b-4e0461f736b4	Rutina QA Staff	Rutina de datos de prueba (QA)	hipertrofia	2	f	9f959d01-ad53-4931-a98b-4e0461f736b4	t	2026-07-05 22:08:00.374395+00	2026-07-05 22:08:00.406945+00	t
d649dc2d-2fff-45ae-be2f-8abba64e8157	4fb46b65-f43a-4765-97f2-ff887468cf41	Rutina QA Maria	Rutina de datos de prueba (QA)	hipertrofia	2	f	4fb46b65-f43a-4765-97f2-ff887468cf41	t	2026-07-05 22:17:21.286802+00	2026-07-05 22:17:21.328202+00	t
9ca48928-80e5-4e80-9614-b13d278ae010	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	asdasdd	asdad	hipertrofia	4	f	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 21:32:11.756053+00	2026-07-05 22:07:54.439313+00	f
0f2c14fc-080a-47fe-8144-d7f905329d60	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	Rutina QA Admin	Rutina de datos de prueba (QA)	hipertrofia	2	f	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	t	2026-07-05 22:07:54.38668+00	2026-07-05 22:07:54.443817+00	t
ae2faaec-3654-4f73-af2c-52ac013a4372	03455fe8-05e0-4138-a7ed-df01b34314f2	Rutina QA Pedro	Rutina de datos de prueba (QA)	hipertrofia	2	f	03455fe8-05e0-4138-a7ed-df01b34314f2	t	2026-07-05 22:17:24.373449+00	2026-07-05 22:17:24.404933+00	t
31df5179-8d53-4a13-92dc-18f2732ca097	30c0413b-4439-4215-b063-6b0ae5976e00	Rutina QA Valentina	Rutina de datos de prueba (QA)	hipertrofia	2	f	30c0413b-4439-4215-b063-6b0ae5976e00	t	2026-07-05 22:17:27.176437+00	2026-07-05 22:17:27.206905+00	t
96022afd-ee29-4bbf-ba7f-ec7ace16354e	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	Rutina QA Diego	Rutina de datos de prueba (QA)	hipertrofia	2	f	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	t	2026-07-05 22:17:29.981821+00	2026-07-05 22:17:30.010367+00	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password_hash, name, career, role, weight_kg, height_cm, body_fat_pct, units, notifications_enabled, private_profile, is_active, member_since, last_login_at, created_at, updated_at, faculty, fitness_level) FROM stdin;
1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	admin@ubiobio.cl	$2a$12$7IFoQQu0LZmsfhuIndbZ9efZoWQRkKv5xDgx2jsAbv6p5wVlllyJa	Administrador GymUBB	\N	admin	75.00	170	\N	kg	t	f	t	2026-07-05	2026-07-05 22:58:05.610008+00	2026-07-05 18:27:29.160048+00	2026-07-05 22:58:05.610008+00	\N	intermedio
5014e791-de85-402a-8cc2-6a99c0726c7d	qa.recomendacion+2c66ad9e@alumnos.ubiobio.cl	$2a$12$nZVzwJ2pHpHQqKXz0JYtsuuaPPAR5WOzWyPuRgrpGPFFFkpIWwvY.	QA Recomendaciones	\N	student	78.00	\N	\N	kg	t	f	t	2026-07-05	2026-07-05 21:15:34.538939+00	2026-07-05 21:15:34.199936+00	2026-07-05 21:15:34.564897+00	\N	intermedio
91d44e7a-2224-410a-b969-edf87a91510a	qa.recomendacion+72064e99@alumnos.ubiobio.cl	$2a$12$o9PWjWpHTTqZVs.8C.dB7u4ha.7sajzzt1gWIGoo7rGi3PZQSAUQe	QA Recomendaciones	\N	student	78.00	\N	\N	kg	t	f	t	2026-07-05	2026-07-05 21:24:30.862365+00	2026-07-05 21:24:30.542102+00	2026-07-05 21:24:30.900303+00	\N	intermedio
a127e44e-8a23-401d-9c52-52d16c6a3282	qa.recomendacion+ce6a5a1a@alumnos.ubiobio.cl	$2a$12$lVbdUSHFecckuJNlk6GG0eSN7wI.erSOCiLQtoE4YBqDudnsSvxIG	QA Recomendaciones	\N	student	78.00	\N	\N	kg	t	f	t	2026-07-05	2026-07-05 21:27:40.244353+00	2026-07-05 21:27:39.924705+00	2026-07-05 21:27:40.263882+00	\N	intermedio
7f95c4cb-b6eb-4414-92e9-bfb7be2fab56	qa.recomendacion+ae5f4c81@alumnos.ubiobio.cl	$2a$12$COoWImMGCpaR1IZBFRJlB.mLnG7GYqLU0SXN4WD5obVloIRKyg1YG	QA Recomendaciones	\N	student	78.00	\N	\N	kg	t	f	t	2026-07-05	2026-07-05 21:38:07.823362+00	2026-07-05 21:38:07.511366+00	2026-07-05 21:38:07.857055+00	\N	intermedio
b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	ivan.salas2001@alumnos.ubiobio.cl	$2a$12$l0HqxUFJsS.YcRQfO8kiUehTgYBntCc7oOeofwTcKmuiYfrTgb3sG	Ivan Salas	Arquitectura	student	82.00	178	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:46.223414+00	2026-07-05 21:43:47.148438+00	2026-07-05 22:57:46.223414+00	\N	intermedio
7b44888c-e917-4b70-9479-c0525d156dca	profesor.qa@ubiobio.cl	$2a$12$IiOuQBvP8QkAwT3vE//5w.wbQxqWU3xtcq4x./Xsrv727rvTKl8.e	Profesor QA Martinez	Bachillerato en Ciencias (Chillán)	professor	88.00	180	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:46.633212+00	2026-07-05 21:43:48.066809+00	2026-07-05 22:57:46.633212+00	\N	avanzado
9f959d01-ad53-4931-a98b-4e0461f736b4	funcionario.qa@ubiobio.cl	$2a$12$VtKSHShIhbNl/TrE8HsP9.Vu0jerY.XY2w2qTXqa6XA.zmyz2lfBW	Funcionario QA Rojas	Bachillerato en Ciencias (Concepción)	staff	70.00	165	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:47.024013+00	2026-07-05 21:43:48.967847+00	2026-07-05 22:57:47.024013+00	\N	principiante
4fb46b65-f43a-4765-97f2-ff887468cf41	maria.gonzalez@alumnos.ubiobio.cl	$2a$12$GIS4wDh59Le4R2DdKmgAS.8QYjqwXg.t.9JXdKPWWC9wAbM54u.hm	Maria Gonzalez	Ingeniería de Ejecución en Administración de Empresas	student	62.00	163	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:47.406191+00	2026-07-05 22:17:20.92761+00	2026-07-05 22:57:47.406191+00	\N	intermedio
03455fe8-05e0-4138-a7ed-df01b34314f2	pedro.munoz@alumnos.ubiobio.cl	$2a$12$V8/Xyss6E8TbW.XquPlCSeF4NQW2BoVbCX3k7V/IioZjcCTldYwca	Pedro Munoz	Enfermería	student	79.00	175	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:47.771047+00	2026-07-05 22:17:24.032877+00	2026-07-05 22:57:47.771047+00	\N	avanzado
30c0413b-4439-4215-b063-6b0ae5976e00	valentina.rojas@alumnos.ubiobio.cl	$2a$12$m4389wT11c0yNS0tdB.Rg.raIUkUrnueyt.vcz4L9W5g6Q.W0znVW	Valentina Rojas	Pedagogía en Educación Matemática	student	58.00	160	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:48.152152+00	2026-07-05 22:17:26.814258+00	2026-07-05 22:57:48.152152+00	\N	principiante
66d0fb6c-003b-41cc-a788-a42c8fd55bdf	diego.contreras@alumnos.ubiobio.cl	$2a$12$xFRb0WLoWQI5cCemtahFduP7e94sC2llAfLuX7J9SNLSHhWqlJcRi	Diego Contreras	Ingeniería Civil Eléctrica	student	91.00	183	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:48.521389+00	2026-07-05 22:17:29.631023+00	2026-07-05 22:57:48.521389+00	\N	avanzado
666ff6f7-7e31-4281-91dc-20d7b6925912	camila.soto@alumnos.ubiobio.cl	$2a$12$C7FmrskjC29F1fgMGVnYZeyMHN9pf0CE68tdwuRkqqUEIzraZi0Ne	Camila Soto	Fonoaudiología	student	65.00	167	\N	kg	t	f	t	2026-07-05	2026-07-05 22:57:48.888112+00	2026-07-05 22:17:32.474349+00	2026-07-05 22:57:48.888112+00	\N	intermedio
\.


--
-- Data for Name: workout_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workout_sessions (id, user_id, routine_id, routine_day_id, started_at, ended_at, duration_minutes, total_volume_kg, notes, created_at, status, early_finish_reason) FROM stdin;
430ac291-0c73-49ed-8c66-f483e44ee8d8	5014e791-de85-402a-8cc2-6a99c0726c7d	74910c85-17b5-4689-84a2-75f544f4d356	c75c350d-0f96-4898-841d-665f02152204	2026-07-05 21:16:30.832212+00	2026-07-05 21:16:31.067324+00	0	2977.00	\N	2026-07-05 21:16:30.832212+00	completed	\N
e08d1d64-d885-49e9-86cd-fc4ce2664262	91d44e7a-2224-410a-b969-edf87a91510a	acb1a442-6d42-4ba4-a6f3-57cbb90d3ce7	78acd96e-2db9-45b6-972f-bf9da33108aa	2026-07-05 21:24:31.120558+00	2026-07-05 21:24:31.372521+00	0	2977.00	\N	2026-07-05 21:24:31.120558+00	completed	\N
b417d3eb-f8ca-4b9a-a28b-a8f1afb48abd	a127e44e-8a23-401d-9c52-52d16c6a3282	e3de71e1-85b0-40da-ae6e-45086ab2b65e	9eaf7540-c252-425c-9b6d-c38891de7384	2026-07-05 21:27:40.510962+00	2026-07-05 21:27:40.727537+00	0	2977.00	\N	2026-07-05 21:27:40.510962+00	completed	\N
a5881daa-3959-4259-93c4-ad5995eb5e70	4fb46b65-f43a-4765-97f2-ff887468cf41	d649dc2d-2fff-45ae-be2f-8abba64e8157	da161ab6-ba40-4fff-9b2a-2cf327cb8b88	2026-06-23 21:22:21.713803+00	2026-06-23 22:17:21.713803+00	55	3183.00	\N	2026-07-05 22:17:21.338853+00	completed	\N
d2a54043-b875-4b1e-a60d-1cd6bff35fde	30c0413b-4439-4215-b063-6b0ae5976e00	31df5179-8d53-4a13-92dc-18f2732ca097	613dd2b4-be2e-4b65-8786-063b7f0e5d09	2026-06-30 21:28:28.131754+00	2026-06-30 22:17:28.131754+00	49	3022.00	\N	2026-07-05 22:17:27.853494+00	completed	\N
37d8bb24-9f1a-4324-89d3-96a41cf12401	4fb46b65-f43a-4765-97f2-ff887468cf41	d649dc2d-2fff-45ae-be2f-8abba64e8157	784a5de9-a4c5-4b52-93ca-485bddbfc58a	2026-06-26 21:29:22.063832+00	2026-06-26 22:17:22.063832+00	48	2885.50	\N	2026-07-05 22:17:21.751865+00	completed	\N
85fbbcb9-45ec-4977-840b-f47418bed227	4fb46b65-f43a-4765-97f2-ff887468cf41	d649dc2d-2fff-45ae-be2f-8abba64e8157	da161ab6-ba40-4fff-9b2a-2cf327cb8b88	2026-06-30 21:34:22.514022+00	2026-06-30 22:17:22.514022+00	43	3441.00	\N	2026-07-05 22:17:22.114627+00	completed	\N
b55effa7-0a5d-4dd6-a72d-d7c168afff01	4fb46b65-f43a-4765-97f2-ff887468cf41	d649dc2d-2fff-45ae-be2f-8abba64e8157	784a5de9-a4c5-4b52-93ca-485bddbfc58a	2026-07-04 21:30:22.883164+00	2026-07-04 22:17:22.883164+00	47	3618.00	\N	2026-07-05 22:17:22.558965+00	completed	\N
39e76321-62b2-4f8d-8caf-5fb06a427653	30c0413b-4439-4215-b063-6b0ae5976e00	31df5179-8d53-4a13-92dc-18f2732ca097	0691b90d-1215-4438-a2e4-1ad103916fa7	2026-07-04 21:27:28.43896+00	2026-07-04 22:17:28.43896+00	50	2038.50	\N	2026-07-05 22:17:28.167788+00	completed	\N
0d936cbd-15aa-4f9b-b987-aaaf035c2b07	03455fe8-05e0-4138-a7ed-df01b34314f2	ae2faaec-3654-4f73-af2c-52ac013a4372	6c92fdbc-46a8-4557-b39e-4987431e0f72	2026-06-23 21:36:24.724309+00	2026-06-23 22:17:24.724309+00	41	4530.50	\N	2026-07-05 22:17:24.414767+00	completed	\N
613ad69a-1c00-4d47-b2b9-33d0b817be58	03455fe8-05e0-4138-a7ed-df01b34314f2	ae2faaec-3654-4f73-af2c-52ac013a4372	b66f582f-1222-4a13-88b8-3f4bd59f6bdc	2026-06-26 21:26:25.034286+00	2026-06-26 22:17:25.034286+00	51	5100.50	\N	2026-07-05 22:17:24.759843+00	completed	\N
c536128d-c41d-4a44-9ae6-4b6b46de277d	666ff6f7-7e31-4281-91dc-20d7b6925912	5e023a95-a9fc-439b-89b9-e04f10cb45f5	27a1794a-0761-4935-a662-3c50608430d3	2026-06-26 21:40:33.503888+00	2026-06-26 22:17:33.503888+00	37	3042.50	\N	2026-07-05 22:17:33.224049+00	completed	\N
3f924539-69ff-433f-b69b-fa8820966223	03455fe8-05e0-4138-a7ed-df01b34314f2	ae2faaec-3654-4f73-af2c-52ac013a4372	6c92fdbc-46a8-4557-b39e-4987431e0f72	2026-06-30 21:31:25.333667+00	2026-06-30 22:17:25.333667+00	46	4650.50	\N	2026-07-05 22:17:25.058629+00	completed	\N
2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	96022afd-ee29-4bbf-ba7f-ec7ace16354e	7ca08b44-10d8-45ba-bf16-bf7fd181c274	2026-06-23 21:42:30.279764+00	2026-06-23 22:17:30.279764+00	35	4890.50	\N	2026-07-05 22:17:30.018448+00	completed	\N
94fcdec8-8caf-442a-8718-e3398035988b	03455fe8-05e0-4138-a7ed-df01b34314f2	ae2faaec-3654-4f73-af2c-52ac013a4372	b66f582f-1222-4a13-88b8-3f4bd59f6bdc	2026-07-04 21:42:25.650736+00	2026-07-04 22:17:25.650736+00	35	6233.50	\N	2026-07-05 22:17:25.3695+00	completed	\N
fa76f805-56b5-4397-8add-a6c18f772d74	30c0413b-4439-4215-b063-6b0ae5976e00	31df5179-8d53-4a13-92dc-18f2732ca097	613dd2b4-be2e-4b65-8786-063b7f0e5d09	2026-06-23 21:33:27.474046+00	2026-06-23 22:17:27.474046+00	44	2773.00	\N	2026-07-05 22:17:27.216263+00	completed	\N
365d203f-545c-4fea-83f1-91a5a67dcbad	30c0413b-4439-4215-b063-6b0ae5976e00	31df5179-8d53-4a13-92dc-18f2732ca097	0691b90d-1215-4438-a2e4-1ad103916fa7	2026-06-26 21:40:27.827982+00	2026-06-26 22:17:27.827982+00	37	1762.00	\N	2026-07-05 22:17:27.522443+00	completed	\N
fc65f5f9-55c7-47de-89bd-a6b33356ab70	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	96022afd-ee29-4bbf-ba7f-ec7ace16354e	4a9cba0c-2683-41f2-9158-1422cc1d5b2c	2026-06-26 21:27:30.603873+00	2026-06-26 22:17:30.603873+00	50	4617.00	\N	2026-07-05 22:17:30.318363+00	completed	\N
ddde86ff-1675-4a35-b25a-68a816b98bdb	9f959d01-ad53-4931-a98b-4e0461f736b4	\N	\N	2026-07-05 22:57:47.046078+00	2026-07-05 22:57:47.111913+00	0	272.50	\N	2026-07-05 22:57:47.046078+00	completed	\N
fdb60073-3884-4707-bbe8-2448231250d1	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	96022afd-ee29-4bbf-ba7f-ec7ace16354e	7ca08b44-10d8-45ba-bf16-bf7fd181c274	2026-06-30 21:34:30.944582+00	2026-06-30 22:17:30.944582+00	43	5196.00	\N	2026-07-05 22:17:30.642755+00	completed	\N
0d492916-a40a-4d72-b4b5-1d0191c57479	666ff6f7-7e31-4281-91dc-20d7b6925912	5e023a95-a9fc-439b-89b9-e04f10cb45f5	4d0de000-a3c5-4f1b-8a44-5b27090e1438	2026-06-30 21:18:33.82397+00	2026-06-30 22:17:33.82397+00	59	3463.50	\N	2026-07-05 22:17:33.524232+00	completed	\N
5a045481-62b1-4d69-a44d-f950f0019e64	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	96022afd-ee29-4bbf-ba7f-ec7ace16354e	4a9cba0c-2683-41f2-9158-1422cc1d5b2c	2026-07-04 21:36:31.294781+00	2026-07-04 22:17:31.294781+00	41	6888.00	\N	2026-07-05 22:17:30.980068+00	completed	\N
90cdee4d-d2d5-445c-a178-820fc713ea63	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	0084bb79-7ea4-4724-8426-01adfc915b89	2da5db85-0180-4329-bc73-ab183c96ecad	2026-06-25 21:27:57.326655+00	2026-06-25 22:07:57.326655+00	40	4431.50	\N	2026-07-05 22:07:57.031886+00	completed	\N
eb566f1f-1062-4c8d-be07-fcfe9e126044	666ff6f7-7e31-4281-91dc-20d7b6925912	5e023a95-a9fc-439b-89b9-e04f10cb45f5	4d0de000-a3c5-4f1b-8a44-5b27090e1438	2026-06-23 21:17:33.18742+00	2026-06-23 22:17:33.18742+00	60	3474.50	\N	2026-07-05 22:17:32.889269+00	completed	\N
a0fa267e-582b-423e-98d3-1516265202f7	666ff6f7-7e31-4281-91dc-20d7b6925912	5e023a95-a9fc-439b-89b9-e04f10cb45f5	27a1794a-0761-4935-a662-3c50608430d3	2026-07-04 21:38:34.211451+00	2026-07-04 22:17:34.211451+00	39	3817.00	\N	2026-07-05 22:17:33.864209+00	completed	\N
379bab3f-f672-4261-8347-56e04e88edc7	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	\N	\N	2026-07-05 22:57:45.859193+00	2026-07-05 22:57:45.921394+00	0	445.00	\N	2026-07-05 22:57:45.859193+00	completed	\N
bc1077cc-c411-4693-8be3-981c511a06ae	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	\N	\N	2026-07-05 22:57:46.239409+00	2026-07-05 22:57:46.328306+00	0	485.00	\N	2026-07-05 22:57:46.239409+00	completed	\N
7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	7b44888c-e917-4b70-9479-c0525d156dca	\N	\N	2026-07-05 22:57:46.645939+00	2026-07-05 22:57:46.700219+00	0	717.50	\N	2026-07-05 22:57:46.645939+00	completed	\N
a51b1111-c7a2-469e-95a2-a4be71318990	4fb46b65-f43a-4765-97f2-ff887468cf41	\N	\N	2026-07-05 22:57:47.421659+00	2026-07-05 22:57:47.47692+00	0	340.00	\N	2026-07-05 22:57:47.421659+00	completed	\N
e27e688f-296a-49b9-b917-77becdc03b3e	03455fe8-05e0-4138-a7ed-df01b34314f2	\N	\N	2026-07-05 22:57:47.789755+00	2026-07-05 22:57:47.847524+00	0	595.00	\N	2026-07-05 22:57:47.789755+00	completed	\N
da61ab26-62ff-47bb-af2d-fa931ba98b51	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	0f2c14fc-080a-47fe-8144-d7f905329d60	34e7e5a7-5f01-443f-93f1-9467879e7af0	2026-06-25 21:08:55.301647+00	2026-06-25 22:07:55.301647+00	59	3421.00	\N	2026-07-05 22:07:54.904987+00	completed	\N
f0911d89-b963-420c-ae05-54f51ae210b3	30c0413b-4439-4215-b063-6b0ae5976e00	\N	\N	2026-07-05 22:57:48.169863+00	2026-07-05 22:57:48.225289+00	0	200.00	\N	2026-07-05 22:57:48.169863+00	completed	\N
71b407fc-ddf5-4a79-9eab-c50ac88df2c8	66d0fb6c-003b-41cc-a788-a42c8fd55bdf	\N	\N	2026-07-05 22:57:48.537726+00	2026-07-05 22:57:48.593973+00	0	677.50	\N	2026-07-05 22:57:48.537726+00	completed	\N
078bd115-bd60-4448-9e90-92fb667f3e9a	666ff6f7-7e31-4281-91dc-20d7b6925912	\N	\N	2026-07-05 22:57:48.904499+00	2026-07-05 22:57:48.962021+00	0	362.50	\N	2026-07-05 22:57:48.904499+00	completed	\N
4b20ebb6-a8f5-455b-820c-97a88fa8e92b	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	0f2c14fc-080a-47fe-8144-d7f905329d60	cfe6fb22-8838-429a-9318-e42e56ed34c0	2026-07-01 21:28:55.698408+00	2026-07-01 22:07:55.698408+00	39	4263.00	\N	2026-07-05 22:07:55.342125+00	completed	\N
8aaefde6-b0c0-4666-9dea-a3afa1664332	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	0f2c14fc-080a-47fe-8144-d7f905329d60	cfe6fb22-8838-429a-9318-e42e56ed34c0	2026-06-21 21:12:54.863913+00	2026-06-21 22:07:54.863913+00	55	3932.50	\N	2026-07-05 22:07:54.457864+00	completed	\N
c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	1f3826ff-2731-428a-b5e1-fd8d1f9d52b7	0f2c14fc-080a-47fe-8144-d7f905329d60	34e7e5a7-5f01-443f-93f1-9467879e7af0	2026-07-03 21:25:56.108891+00	2026-07-03 22:07:56.108891+00	42	4688.50	\N	2026-07-05 22:07:55.736956+00	completed	\N
485d5d3d-3a3a-478c-9b66-e4531f48c18f	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	0084bb79-7ea4-4724-8426-01adfc915b89	c5b13aae-56d3-4519-ab0f-0efdf3925962	2026-07-01 21:16:57.653053+00	2026-07-01 22:07:57.653053+00	51	4479.50	\N	2026-07-05 22:07:57.349133+00	completed	\N
d72ed32d-3d09-4224-8924-b53501fabdb7	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	0084bb79-7ea4-4724-8426-01adfc915b89	c5b13aae-56d3-4519-ab0f-0efdf3925962	2026-06-21 21:29:56.996191+00	2026-06-21 22:07:56.996191+00	38	4534.00	\N	2026-07-05 22:07:56.680663+00	completed	\N
16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	7b44888c-e917-4b70-9479-c0525d156dca	4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	cce28a7a-d625-4d5c-87c7-0865e4476828	2026-06-21 21:11:58.874092+00	2026-06-21 22:07:58.874092+00	56	5257.50	\N	2026-07-05 22:07:58.597339+00	completed	\N
45330506-b3cc-4c84-b718-16b3cea21342	b9a8c45a-8f9a-46b1-b42f-418459a5cf3b	0084bb79-7ea4-4724-8426-01adfc915b89	2da5db85-0180-4329-bc73-ab183c96ecad	2026-07-03 21:26:58.024391+00	2026-07-03 22:07:58.024391+00	41	5104.00	\N	2026-07-05 22:07:57.67756+00	completed	\N
c7df5426-38ce-4192-9182-c7fd54a1fc55	7b44888c-e917-4b70-9479-c0525d156dca	4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	cb7c6f1b-c4db-48aa-abeb-f06492caf6f3	2026-06-25 21:25:59.210672+00	2026-06-25 22:07:59.210672+00	42	6588.00	\N	2026-07-05 22:07:58.921583+00	completed	\N
031d7a59-eab3-4d29-9b85-1f9e750ccdd5	7b44888c-e917-4b70-9479-c0525d156dca	4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	cce28a7a-d625-4d5c-87c7-0865e4476828	2026-07-01 21:28:59.514904+00	2026-07-01 22:07:59.514904+00	39	5310.00	\N	2026-07-05 22:07:59.231555+00	completed	\N
819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7b44888c-e917-4b70-9479-c0525d156dca	4395ebf3-5cd8-4492-95d6-a1a2dd38a5c0	cb7c6f1b-c4db-48aa-abeb-f06492caf6f3	2026-07-03 21:28:59.85425+00	2026-07-03 22:07:59.85425+00	39	7557.50	\N	2026-07-05 22:07:59.553199+00	completed	\N
5f1ee935-e9d3-40c1-8a75-945e12ce9597	9f959d01-ad53-4931-a98b-4e0461f736b4	f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	e0236d6a-11cc-4249-9993-56ffd25a7aad	2026-06-21 21:18:00.689472+00	2026-06-21 22:08:00.689472+00	50	3176.50	\N	2026-07-05 22:08:00.41585+00	completed	\N
e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	9f959d01-ad53-4931-a98b-4e0461f736b4	f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	aa380685-8323-4a9d-8ccd-69ef99d62f5e	2026-06-25 21:13:01.012056+00	2026-06-25 22:08:01.012056+00	55	2655.00	\N	2026-07-05 22:08:00.727956+00	completed	\N
9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	9f959d01-ad53-4931-a98b-4e0461f736b4	f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	e0236d6a-11cc-4249-9993-56ffd25a7aad	2026-07-01 21:24:01.314556+00	2026-07-01 22:08:01.314556+00	44	3314.50	\N	2026-07-05 22:08:01.048764+00	completed	\N
8999a2ac-efc1-4012-8f18-9168edf654a3	9f959d01-ad53-4931-a98b-4e0461f736b4	f36d79be-e9e5-4e8f-ab62-c85ff7fa3a27	aa380685-8323-4a9d-8ccd-69ef99d62f5e	2026-07-03 21:16:01.643687+00	2026-07-03 22:08:01.643687+00	52	2919.50	\N	2026-07-05 22:08:01.35121+00	completed	\N
\.


--
-- Data for Name: workout_sets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workout_sets (id, session_id, exercise_id, set_number, weight_kg, reps, completed, rpe, created_at, duration_seconds, target_weight_kg, target_reps, target_duration_seconds) FROM stdin;
1ebd52c4-52fc-4f4a-ac01-d7b7437ff395	a5881daa-3959-4259-93c4-ad5995eb5e70	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	54.50	6	t	\N	2026-07-05 22:17:21.361871+00	\N	50.00	6	\N
23a174f3-254a-4443-8d18-91a815c909b0	a5881daa-3959-4259-93c4-ad5995eb5e70	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	50.00	7	t	\N	2026-07-05 22:17:21.378939+00	\N	50.00	6	\N
7a7680ce-62e8-495b-a0f3-8afef7182635	a5881daa-3959-4259-93c4-ad5995eb5e70	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	50.50	7	t	\N	2026-07-05 22:17:21.397278+00	\N	50.00	6	\N
d1b33edc-7900-4ca3-9327-8ff102343baf	a5881daa-3959-4259-93c4-ad5995eb5e70	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	22.00	8	t	\N	2026-07-05 22:17:21.430719+00	\N	20.00	8	\N
365d8545-6e5d-4710-9f63-4e2d93720908	a5881daa-3959-4259-93c4-ad5995eb5e70	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	20.00	9	t	\N	2026-07-05 22:17:21.465116+00	\N	20.00	8	\N
955f840d-96ab-4720-8775-8f38089a9953	a5881daa-3959-4259-93c4-ad5995eb5e70	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	20.50	9	t	\N	2026-07-05 22:17:21.489521+00	\N	20.00	8	\N
2fdcc7e6-baa9-4190-a0d3-f4fb1d13b0f3	a5881daa-3959-4259-93c4-ad5995eb5e70	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:21.510746+00	29	\N	\N	30
4903c6c7-d68f-4c6f-b2a9-d48693691d96	a5881daa-3959-4259-93c4-ad5995eb5e70	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:21.530657+00	34	\N	\N	30
529d03fe-268b-41f0-87de-b56d093d69d2	a5881daa-3959-4259-93c4-ad5995eb5e70	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:21.547326+00	37	\N	\N	30
a9ebe042-f256-4a82-a110-c47e2db992e9	37d8bb24-9f1a-4324-89d3-96a41cf12401	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	101.50	4	t	\N	2026-07-05 22:17:21.773688+00	\N	92.50	4	\N
67733432-5c89-43b5-92e5-53cfe78cb63e	37d8bb24-9f1a-4324-89d3-96a41cf12401	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	93.00	4	t	\N	2026-07-05 22:17:21.789324+00	\N	92.50	4	\N
c1cbe91f-5b18-47c3-bddb-e689082932d6	37d8bb24-9f1a-4324-89d3-96a41cf12401	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	75.50	5	t	\N	2026-07-05 22:17:21.802018+00	\N	92.50	4	\N
8a2d756b-da31-437c-868f-8cad4d38fc38	37d8bb24-9f1a-4324-89d3-96a41cf12401	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	69.00	5	t	\N	2026-07-05 22:17:21.816055+00	\N	77.50	5	\N
49a3f4da-2fa7-459c-b8d4-dfa3fd380840	37d8bb24-9f1a-4324-89d3-96a41cf12401	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	78.00	3	t	\N	2026-07-05 22:17:21.834659+00	\N	77.50	5	\N
8e8954b3-2a0a-48bb-8e10-09f9b0b904fb	37d8bb24-9f1a-4324-89d3-96a41cf12401	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	81.00	6	t	\N	2026-07-05 22:17:21.85141+00	\N	77.50	5	\N
0fca21a4-f0e0-4b16-ae5d-ee1fa80b0074	37d8bb24-9f1a-4324-89d3-96a41cf12401	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	35.00	7	t	\N	2026-07-05 22:17:21.865693+00	\N	34.00	6	\N
92236e44-2893-404a-9390-955d96408829	37d8bb24-9f1a-4324-89d3-96a41cf12401	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	30.00	7	t	\N	2026-07-05 22:17:21.879713+00	\N	34.00	6	\N
7d561ae2-ccb1-4311-a818-9ca4cdd9a06d	37d8bb24-9f1a-4324-89d3-96a41cf12401	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	35.00	6	t	\N	2026-07-05 22:17:21.890991+00	\N	34.00	6	\N
84037cbd-9c6a-4c2a-b1de-b440222b866b	85fbbcb9-45ec-4977-840b-f47418bed227	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	56.00	6	t	\N	2026-07-05 22:17:22.185579+00	\N	55.00	6	\N
7b488995-2a4a-4ddd-b9a4-c16a40a601f5	85fbbcb9-45ec-4977-840b-f47418bed227	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	60.00	7	t	\N	2026-07-05 22:17:22.210119+00	\N	55.00	6	\N
29a80d0c-a140-47e9-91c2-76bd866a8599	85fbbcb9-45ec-4977-840b-f47418bed227	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	60.50	6	t	\N	2026-07-05 22:17:22.234328+00	\N	55.00	6	\N
5df5394a-a880-4f85-a723-8d8dd52cb1aa	85fbbcb9-45ec-4977-840b-f47418bed227	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	24.00	9	t	\N	2026-07-05 22:17:22.263029+00	\N	22.50	8	\N
be0c1f69-93f9-4ce2-9449-c16f6467a882	85fbbcb9-45ec-4977-840b-f47418bed227	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	24.50	9	t	\N	2026-07-05 22:17:22.286367+00	\N	22.50	8	\N
89ed6607-925a-4a3b-a332-72e45801a9c6	85fbbcb9-45ec-4977-840b-f47418bed227	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	23.50	9	t	\N	2026-07-05 22:17:22.303232+00	\N	22.50	8	\N
3faaa693-a820-48fe-96ce-2d63508944fd	85fbbcb9-45ec-4977-840b-f47418bed227	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:22.318333+00	36	\N	\N	30
7cd00940-7855-4df1-95f0-072a1c5a906f	85fbbcb9-45ec-4977-840b-f47418bed227	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:22.331125+00	29	\N	\N	30
0e9742d2-aeb6-4fd6-8da4-acd4b4eb7c47	85fbbcb9-45ec-4977-840b-f47418bed227	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:22.342108+00	29	\N	\N	30
c42d2f6e-9652-40a8-933d-69cbc9a4671b	b55effa7-0a5d-4dd6-a72d-d7c168afff01	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	107.50	5	t	\N	2026-07-05 22:17:22.595726+00	\N	102.50	4	\N
f3cf2e15-6f82-4cd2-b6e5-d08599e02b8d	b55effa7-0a5d-4dd6-a72d-d7c168afff01	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	103.00	5	t	\N	2026-07-05 22:17:22.6138+00	\N	102.50	4	\N
16f716e4-6922-4b2c-914d-d23e71386fc9	b55effa7-0a5d-4dd6-a72d-d7c168afff01	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	109.00	5	t	\N	2026-07-05 22:17:22.628678+00	\N	102.50	4	\N
2bd53623-29ea-4303-b428-81d8f5f4d9be	b55effa7-0a5d-4dd6-a72d-d7c168afff01	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	86.50	5	t	\N	2026-07-05 22:17:22.649845+00	\N	80.00	5	\N
be59e385-6119-4f25-8e14-a1a180a79166	b55effa7-0a5d-4dd6-a72d-d7c168afff01	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	83.00	6	t	\N	2026-07-05 22:17:22.668924+00	\N	80.00	5	\N
dee74174-5644-46b9-b41e-e145d935b109	b55effa7-0a5d-4dd6-a72d-d7c168afff01	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	80.00	5	t	\N	2026-07-05 22:17:22.687389+00	\N	80.00	5	\N
4bb397a5-86e9-4866-8aae-a51125d8e516	b55effa7-0a5d-4dd6-a72d-d7c168afff01	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	36.50	6	t	\N	2026-07-05 22:17:22.704941+00	\N	36.00	6	\N
31f2d1fa-5add-4002-95e3-5a33131d52a3	b55effa7-0a5d-4dd6-a72d-d7c168afff01	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	36.00	7	t	\N	2026-07-05 22:17:22.723762+00	\N	36.00	6	\N
5cabd8ef-b5e8-464f-afce-2443e5a74d62	b55effa7-0a5d-4dd6-a72d-d7c168afff01	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	36.50	6	t	\N	2026-07-05 22:17:22.740136+00	\N	36.00	6	\N
78913a36-c205-46a7-8e7d-85de637b626b	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	93.50	7	t	\N	2026-07-05 22:17:24.436699+00	\N	87.50	6	\N
e72bb317-5154-40d8-b188-691f525c8d9d	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	93.00	7	t	\N	2026-07-05 22:17:24.45158+00	\N	87.50	6	\N
846b81c9-4c9f-4b2e-82b1-a96e676ec774	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	88.00	7	t	\N	2026-07-05 22:17:24.463992+00	\N	87.50	6	\N
e934bbe7-2b47-4ded-8446-083845f4e748	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	21.50	9	t	\N	2026-07-05 22:17:24.4758+00	\N	20.00	8	\N
bc36335f-5c33-43ce-8bbc-27acd4cdedb1	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	21.50	9	t	\N	2026-07-05 22:17:24.489883+00	\N	20.00	8	\N
5f3d93e2-a85e-4b72-82a6-225895334f7b	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	21.00	8	t	\N	2026-07-05 22:17:24.502352+00	\N	20.00	8	\N
3cdb3260-cb55-4a2b-8f13-7e4ed6eddb32	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:24.518123+00	34	\N	\N	30
cc88a9ea-ef34-448e-8e5e-459a16d09df9	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:24.538335+00	29	\N	\N	30
63d0a2a5-fe5d-4a95-8db3-c717946078a7	0d936cbd-15aa-4f9b-b987-aaaf035c2b07	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:24.554645+00	29	\N	\N	30
4aca4882-0beb-4ad0-95aa-b72d7abe3c82	613ad69a-1c00-4d47-b2b9-33d0b817be58	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	159.00	4	t	\N	2026-07-05 22:17:24.779924+00	\N	157.50	4	\N
04e1e155-1598-43c1-89f6-a7b838770030	613ad69a-1c00-4d47-b2b9-33d0b817be58	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	166.00	4	t	\N	2026-07-05 22:17:24.79572+00	\N	157.50	4	\N
287de97a-cf78-4279-982f-15a39f371fc3	613ad69a-1c00-4d47-b2b9-33d0b817be58	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	131.00	5	t	\N	2026-07-05 22:17:24.809053+00	\N	157.50	4	\N
21fc437b-ef41-477d-bf59-8dead632cce3	613ad69a-1c00-4d47-b2b9-33d0b817be58	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	146.00	5	t	\N	2026-07-05 22:17:24.823301+00	\N	137.50	5	\N
93dd3c9f-6993-47bd-9b1d-1a6619f1655f	613ad69a-1c00-4d47-b2b9-33d0b817be58	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	151.00	5	t	\N	2026-07-05 22:17:24.836145+00	\N	137.50	5	\N
aa9f6230-9626-427e-8b24-e92506960201	613ad69a-1c00-4d47-b2b9-33d0b817be58	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	125.50	5	t	\N	2026-07-05 22:17:24.848349+00	\N	137.50	5	\N
f97c4683-4d4c-4ab6-a8fa-00022bf17ab6	613ad69a-1c00-4d47-b2b9-33d0b817be58	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	63.00	5	t	\N	2026-07-05 22:17:24.859084+00	\N	60.00	6	\N
36c7bfe5-75c9-465c-845d-42baec5c92a3	613ad69a-1c00-4d47-b2b9-33d0b817be58	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	64.00	7	t	\N	2026-07-05 22:17:24.872365+00	\N	60.00	6	\N
58267f9c-bf25-495c-a69a-82ebebca8955	613ad69a-1c00-4d47-b2b9-33d0b817be58	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	54.00	5	t	\N	2026-07-05 22:17:24.885084+00	\N	60.00	6	\N
d0ede9cb-6863-4633-a7cf-162be6be4157	3f924539-69ff-433f-b69b-fa8820966223	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	96.00	6	t	\N	2026-07-05 22:17:25.078091+00	\N	92.50	6	\N
ed164d49-a91c-4b32-9626-e21289bc410a	3f924539-69ff-433f-b69b-fa8820966223	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	99.50	7	t	\N	2026-07-05 22:17:25.0921+00	\N	92.50	6	\N
3f4f55ee-41a9-4502-9638-0cfb2cc0fd5e	3f924539-69ff-433f-b69b-fa8820966223	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	99.50	6	t	\N	2026-07-05 22:17:25.103711+00	\N	92.50	6	\N
e5bd38b2-ed02-4089-b9ea-1758f33dfac2	3f924539-69ff-433f-b69b-fa8820966223	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	23.00	9	t	\N	2026-07-05 22:17:25.116687+00	\N	22.50	8	\N
a30761bd-5de4-40c9-ab88-d671edb43e5e	3f924539-69ff-433f-b69b-fa8820966223	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	24.50	9	t	\N	2026-07-05 22:17:25.128653+00	\N	22.50	8	\N
9f73522a-6189-48fd-addc-ca65478d21cd	3f924539-69ff-433f-b69b-fa8820966223	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	24.50	9	t	\N	2026-07-05 22:17:25.141021+00	\N	22.50	8	\N
1e93e7c7-f78c-4779-aa0c-85f7ead735aa	3f924539-69ff-433f-b69b-fa8820966223	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:25.152782+00	35	\N	\N	30
766745ab-1d29-4b9a-8cc6-7071cc0e3a6d	3f924539-69ff-433f-b69b-fa8820966223	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:25.168154+00	31	\N	\N	30
25338ea7-59bb-4fe0-a2d5-a7d2f2e5528c	3f924539-69ff-433f-b69b-fa8820966223	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:25.18057+00	33	\N	\N	30
db2a61ff-3dc0-4320-8fc3-b343da8aa294	94fcdec8-8caf-442a-8718-e3398035988b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	177.00	5	t	\N	2026-07-05 22:17:25.392934+00	\N	165.00	4	\N
91aa5278-9e70-4a20-9859-38b3a8e0759f	94fcdec8-8caf-442a-8718-e3398035988b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	178.00	4	t	\N	2026-07-05 22:17:25.405572+00	\N	165.00	4	\N
0625afd0-e061-448c-8e91-7c383bab80d6	94fcdec8-8caf-442a-8718-e3398035988b	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	168.00	4	t	\N	2026-07-05 22:17:25.418565+00	\N	165.00	4	\N
447e21c7-a797-46cb-9090-7b5787776640	94fcdec8-8caf-442a-8718-e3398035988b	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	155.00	6	t	\N	2026-07-05 22:17:25.430844+00	\N	150.00	5	\N
7d060828-f97f-4df5-8c52-c4bf3946cd55	94fcdec8-8caf-442a-8718-e3398035988b	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	161.00	5	t	\N	2026-07-05 22:17:25.444944+00	\N	150.00	5	\N
b26f2582-73cd-4609-8e47-e9f783abbbcd	94fcdec8-8caf-442a-8718-e3398035988b	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	164.50	5	t	\N	2026-07-05 22:17:25.45802+00	\N	150.00	5	\N
4c0ba371-17e3-460d-a0d1-f1e3beceb790	94fcdec8-8caf-442a-8718-e3398035988b	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	64.50	7	t	\N	2026-07-05 22:17:25.470263+00	\N	64.00	6	\N
03628411-8661-46b6-892b-4aa85a93917c	94fcdec8-8caf-442a-8718-e3398035988b	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	66.00	7	t	\N	2026-07-05 22:17:25.484086+00	\N	64.00	6	\N
899299bf-54d3-4460-9ec3-3092700729c4	94fcdec8-8caf-442a-8718-e3398035988b	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	70.50	7	t	\N	2026-07-05 22:17:25.497639+00	\N	64.00	6	\N
ddbe28c6-669e-433f-a508-02ce804a3495	fa76f805-56b5-4397-8add-a6c18f772d74	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	33.00	7	t	\N	2026-07-05 22:17:27.23553+00	\N	30.00	6	\N
b2636568-efef-472b-832d-94ab104ededc	fa76f805-56b5-4397-8add-a6c18f772d74	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	31.00	7	t	\N	2026-07-05 22:17:27.24987+00	\N	30.00	6	\N
df349bd2-aa5b-43f1-a5e5-fe0d31d836a9	fa76f805-56b5-4397-8add-a6c18f772d74	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	30.50	6	t	\N	2026-07-05 22:17:27.261415+00	\N	30.00	6	\N
a67341a9-247f-4ef7-b3e0-ee25ff21f4ae	fa76f805-56b5-4397-8add-a6c18f772d74	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	22.00	9	t	\N	2026-07-05 22:17:27.274676+00	\N	20.00	8	\N
e47726de-b4cb-47e0-8ce0-860f2a96ed3d	fa76f805-56b5-4397-8add-a6c18f772d74	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	21.00	9	t	\N	2026-07-05 22:17:27.28761+00	\N	20.00	8	\N
c14506fb-1a2d-4a01-ae26-ae77648f9a4c	fa76f805-56b5-4397-8add-a6c18f772d74	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	21.00	9	t	\N	2026-07-05 22:17:27.29947+00	\N	20.00	8	\N
e15f2c2f-ba6e-4313-967f-394e25243595	fa76f805-56b5-4397-8add-a6c18f772d74	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:27.31339+00	36	\N	\N	30
a67dc7a1-63e1-4874-9fba-045e8bea90e8	fa76f805-56b5-4397-8add-a6c18f772d74	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:27.327929+00	30	\N	\N	30
8b2c4ed2-4580-4bda-ae1e-1fbea08135d2	fa76f805-56b5-4397-8add-a6c18f772d74	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:27.339451+00	31	\N	\N	30
9de243fc-aae2-457b-b1d0-1e64db100730	365d203f-545c-4fea-83f1-91a5a67dcbad	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	62.00	4	t	\N	2026-07-05 22:17:27.552929+00	\N	57.50	4	\N
fe933eeb-8bda-4a65-8141-7e639e1f1d2e	365d203f-545c-4fea-83f1-91a5a67dcbad	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	58.00	5	t	\N	2026-07-05 22:17:27.570969+00	\N	57.50	4	\N
1e9bd12c-254e-4bbb-bd3c-0134f65cca0c	365d203f-545c-4fea-83f1-91a5a67dcbad	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	62.00	5	t	\N	2026-07-05 22:17:27.58557+00	\N	57.50	4	\N
a6d59023-e1ee-46bb-b303-eb3dbf316231	365d203f-545c-4fea-83f1-91a5a67dcbad	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	43.00	4	t	\N	2026-07-05 22:17:27.599432+00	\N	42.50	5	\N
548a4e9a-2e1b-40a6-888f-f16bf4e3a1e9	365d203f-545c-4fea-83f1-91a5a67dcbad	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	46.00	6	t	\N	2026-07-05 22:17:27.611883+00	\N	42.50	5	\N
1185e7e1-0bba-4ebe-9b77-d2c00d953500	365d203f-545c-4fea-83f1-91a5a67dcbad	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	35.00	5	t	\N	2026-07-05 22:17:27.624371+00	\N	42.50	5	\N
7bd7cf16-6628-43a9-854d-340b573cc455	365d203f-545c-4fea-83f1-91a5a67dcbad	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	18.00	7	t	\N	2026-07-05 22:17:27.637513+00	\N	20.00	6	\N
64d4db90-e118-4e2f-a756-b1d80e163f6a	365d203f-545c-4fea-83f1-91a5a67dcbad	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	22.00	3	t	\N	2026-07-05 22:17:27.651202+00	\N	20.00	6	\N
5eb4e65f-7f28-4dfb-ae58-021449896304	365d203f-545c-4fea-83f1-91a5a67dcbad	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	16.50	6	t	\N	2026-07-05 22:17:27.663723+00	\N	20.00	6	\N
e9319d46-f59f-4f49-b383-0eb457ab19e9	d2a54043-b875-4b1e-a60d-1cd6bff35fde	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	34.00	7	t	\N	2026-07-05 22:17:27.880252+00	\N	32.50	6	\N
0311fa06-d280-485d-8c2f-0ee2f412e71a	d2a54043-b875-4b1e-a60d-1cd6bff35fde	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	34.00	7	t	\N	2026-07-05 22:17:27.895684+00	\N	32.50	6	\N
8def9883-7cb6-457e-ad9d-db14465c9be0	d2a54043-b875-4b1e-a60d-1cd6bff35fde	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	35.00	7	t	\N	2026-07-05 22:17:27.907171+00	\N	32.50	6	\N
a1721622-05ed-44ea-bf26-5c51f7e65b28	d2a54043-b875-4b1e-a60d-1cd6bff35fde	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	23.50	9	t	\N	2026-07-05 22:17:27.921507+00	\N	22.50	8	\N
6c4917dc-5879-4800-92b1-f6b63c8c9914	d2a54043-b875-4b1e-a60d-1cd6bff35fde	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	24.50	9	t	\N	2026-07-05 22:17:27.934531+00	\N	22.50	8	\N
9eea5c04-29fb-461b-989d-8b9d56e0d8a6	d2a54043-b875-4b1e-a60d-1cd6bff35fde	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	24.50	10	t	\N	2026-07-05 22:17:27.948139+00	\N	22.50	8	\N
30a4383e-23e4-4c44-97ad-430d935eb4db	d2a54043-b875-4b1e-a60d-1cd6bff35fde	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:27.961449+00	31	\N	\N	30
696e0437-31f6-4436-a07e-10dcadce8c7c	d2a54043-b875-4b1e-a60d-1cd6bff35fde	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:27.973325+00	34	\N	\N	30
783b5444-e646-43b1-b9e0-3c77b9eb55ad	d2a54043-b875-4b1e-a60d-1cd6bff35fde	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:27.985729+00	37	\N	\N	30
654ce014-2905-4b35-ac42-f99106f72aad	39e76321-62b2-4f8d-8caf-5fb06a427653	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	63.50	4	t	\N	2026-07-05 22:17:28.189077+00	\N	62.50	4	\N
9db767bd-2d59-4ab4-8a59-90a06547e974	39e76321-62b2-4f8d-8caf-5fb06a427653	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	65.50	4	t	\N	2026-07-05 22:17:28.202468+00	\N	62.50	4	\N
dc5eca5e-c948-448b-aa0e-701977ae7026	39e76321-62b2-4f8d-8caf-5fb06a427653	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	64.00	4	t	\N	2026-07-05 22:17:28.214779+00	\N	62.50	4	\N
8b702bf8-b475-4003-818d-bd49021cc6b1	39e76321-62b2-4f8d-8caf-5fb06a427653	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	48.00	6	t	\N	2026-07-05 22:17:28.225865+00	\N	45.00	5	\N
ac0c2898-e387-42b8-b843-e8b7fa46608c	39e76321-62b2-4f8d-8caf-5fb06a427653	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	49.00	5	t	\N	2026-07-05 22:17:28.238801+00	\N	45.00	5	\N
4b0802c0-5868-477a-885d-e5c75d6d0a8e	39e76321-62b2-4f8d-8caf-5fb06a427653	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	48.00	6	t	\N	2026-07-05 22:17:28.251397+00	\N	45.00	5	\N
1dd8e0c6-7082-4bd3-9c06-df9bdc15e4e1	39e76321-62b2-4f8d-8caf-5fb06a427653	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	22.50	7	t	\N	2026-07-05 22:17:28.262176+00	\N	22.00	6	\N
649d3144-0e7d-4435-bf0b-6ccb3f498e38	39e76321-62b2-4f8d-8caf-5fb06a427653	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	24.00	6	t	\N	2026-07-05 22:17:28.276321+00	\N	22.00	6	\N
a25a26d0-c835-4733-a941-af68cda51a82	39e76321-62b2-4f8d-8caf-5fb06a427653	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	24.00	6	t	\N	2026-07-05 22:17:28.289866+00	\N	22.00	6	\N
9cc736d6-7104-4530-b916-38f9dc3df877	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	102.50	6	t	\N	2026-07-05 22:17:30.035461+00	\N	100.00	6	\N
915d8192-183f-4b66-9045-03b6799db8ef	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	104.00	7	t	\N	2026-07-05 22:17:30.049532+00	\N	100.00	6	\N
15f706a2-3baf-431c-871f-2d360f135c60	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	108.00	6	t	\N	2026-07-05 22:17:30.062508+00	\N	100.00	6	\N
713ee036-9523-4905-8783-98ce231b1909	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	20.50	9	t	\N	2026-07-05 22:17:30.07607+00	\N	20.00	8	\N
78719b5e-1b1d-419b-8ed5-cb2d54ffea7e	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	21.00	9	t	\N	2026-07-05 22:17:30.088769+00	\N	20.00	8	\N
c0622feb-a784-4aff-a357-4904f8698242	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	20.00	8	t	\N	2026-07-05 22:17:30.101078+00	\N	20.00	8	\N
2777d5d0-eecc-471b-9f2d-ac928d1b7dd1	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:30.113849+00	35	\N	\N	30
46015a4e-7708-4924-9e8b-09a16524ca6e	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:30.127297+00	32	\N	\N	30
e2a11761-e347-437b-a0ef-d220de6067e5	2c38a4f9-6109-4fb3-bf72-c1e58c1989bb	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:30.138195+00	29	\N	\N	30
535e81b9-3962-4dcb-9658-075c338081d6	fc65f5f9-55c7-47de-89bd-a6b33356ab70	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	197.00	3	t	\N	2026-07-05 22:17:30.337828+00	\N	182.50	4	\N
a46a9963-6b15-4e0a-8461-6c287c1d1507	fc65f5f9-55c7-47de-89bd-a6b33356ab70	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	169.50	4	t	\N	2026-07-05 22:17:30.353337+00	\N	182.50	4	\N
5736b0e2-3e0e-45e8-a11e-555dc1e50882	fc65f5f9-55c7-47de-89bd-a6b33356ab70	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	199.50	2	t	\N	2026-07-05 22:17:30.368231+00	\N	182.50	4	\N
aac90ccb-cf95-4f7d-aba8-e0dabcd50b9c	fc65f5f9-55c7-47de-89bd-a6b33356ab70	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	164.00	3	t	\N	2026-07-05 22:17:30.380038+00	\N	160.00	5	\N
e86781ae-33e9-4819-b5ba-2622c280af33	fc65f5f9-55c7-47de-89bd-a6b33356ab70	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	133.00	5	t	\N	2026-07-05 22:17:30.393913+00	\N	160.00	5	\N
29969c87-f1e0-4fc3-9811-75410a6f7856	fc65f5f9-55c7-47de-89bd-a6b33356ab70	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	164.50	5	t	\N	2026-07-05 22:17:30.407138+00	\N	160.00	5	\N
05a1b46d-83bb-4740-bea6-6a025026e85a	fc65f5f9-55c7-47de-89bd-a6b33356ab70	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	68.00	3	t	\N	2026-07-05 22:17:30.420507+00	\N	68.00	6	\N
8d37d577-f41a-4276-91c6-39ec010e7a46	fc65f5f9-55c7-47de-89bd-a6b33356ab70	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	71.50	4	t	\N	2026-07-05 22:17:30.433165+00	\N	68.00	6	\N
a9d4e1cc-9f5f-4f66-8f28-dfa0a817b70f	fc65f5f9-55c7-47de-89bd-a6b33356ab70	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	68.50	7	t	\N	2026-07-05 22:17:30.445222+00	\N	68.00	6	\N
36846a33-bf74-4b74-913c-bd6f006fdd15	fdb60073-3884-4707-bbe8-2448231250d1	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	113.50	7	t	\N	2026-07-05 22:17:30.669724+00	\N	107.50	6	\N
a9c596b6-1784-44fd-bf75-7b74da1b8605	fdb60073-3884-4707-bbe8-2448231250d1	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	118.00	6	t	\N	2026-07-05 22:17:30.68735+00	\N	107.50	6	\N
75eba342-8c2f-4aac-84f5-b57175519721	fdb60073-3884-4707-bbe8-2448231250d1	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	110.00	6	t	\N	2026-07-05 22:17:30.702982+00	\N	107.50	6	\N
d62888e7-6cae-47f7-9ade-f3d5a60ae36d	fdb60073-3884-4707-bbe8-2448231250d1	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	20.50	9	t	\N	2026-07-05 22:17:30.714778+00	\N	20.00	8	\N
41e870fd-8ade-4a27-bdb0-b4d5f51c4b75	fdb60073-3884-4707-bbe8-2448231250d1	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	21.50	8	t	\N	2026-07-05 22:17:30.726276+00	\N	20.00	8	\N
e37065e4-e6af-4ec9-a3d1-e027b2cfbc86	fdb60073-3884-4707-bbe8-2448231250d1	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	22.00	10	t	\N	2026-07-05 22:17:30.739678+00	\N	20.00	8	\N
a008a111-82fd-4a6b-b768-dc6d32eef222	fdb60073-3884-4707-bbe8-2448231250d1	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:30.752325+00	36	\N	\N	30
6c1828ae-4d01-40b7-a187-5769cb45bff3	fdb60073-3884-4707-bbe8-2448231250d1	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:30.765992+00	29	\N	\N	30
796f3623-fc54-4eae-9867-132934ea0835	fdb60073-3884-4707-bbe8-2448231250d1	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:30.776554+00	34	\N	\N	30
d58cb366-1233-4ada-a766-85198ad9d8bf	5a045481-62b1-4d69-a44d-f950f0019e64	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	208.50	4	t	\N	2026-07-05 22:17:30.99934+00	\N	200.00	4	\N
fc4e6090-39f2-4532-a548-477390f7b6c3	5a045481-62b1-4d69-a44d-f950f0019e64	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	213.50	4	t	\N	2026-07-05 22:17:31.017531+00	\N	200.00	4	\N
209db92f-cec2-42e1-af89-817522ba583d	5a045481-62b1-4d69-a44d-f950f0019e64	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	210.00	5	t	\N	2026-07-05 22:17:31.033228+00	\N	200.00	4	\N
d1d54a15-2059-4893-9652-7fb87aa325bc	5a045481-62b1-4d69-a44d-f950f0019e64	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	175.00	6	t	\N	2026-07-05 22:17:31.045778+00	\N	165.00	5	\N
17f50e58-dcd2-4b20-b30d-22adfc30f5b9	5a045481-62b1-4d69-a44d-f950f0019e64	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	165.50	5	t	\N	2026-07-05 22:17:31.058513+00	\N	165.00	5	\N
962dc5ab-4e30-46d1-ae87-354aba9a8cfc	5a045481-62b1-4d69-a44d-f950f0019e64	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	169.50	5	t	\N	2026-07-05 22:17:31.07194+00	\N	165.00	5	\N
716bf0fe-cfcb-4d86-ab57-71fad914e0d1	5a045481-62b1-4d69-a44d-f950f0019e64	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	74.50	6	t	\N	2026-07-05 22:17:31.084863+00	\N	72.00	6	\N
16b2d330-6bee-4ba3-8847-d33cb6794394	5a045481-62b1-4d69-a44d-f950f0019e64	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	79.00	6	t	\N	2026-07-05 22:17:31.098556+00	\N	72.00	6	\N
8ea5de7f-4c85-4255-bcad-90da541ab688	5a045481-62b1-4d69-a44d-f950f0019e64	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	72.00	7	t	\N	2026-07-05 22:17:31.111881+00	\N	72.00	6	\N
88ed8952-3138-4ad8-967e-4706ea089338	8aaefde6-b0c0-4666-9dea-a3afa1664332	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	74.50	6	t	\N	2026-07-05 22:07:54.503894+00	\N	70.00	6	\N
e8e436fa-3e76-41db-8c37-4dee1ca7ef37	8aaefde6-b0c0-4666-9dea-a3afa1664332	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	72.00	6	t	\N	2026-07-05 22:07:54.526273+00	\N	70.00	6	\N
017a5ae8-598c-4def-80c4-3dd6343ee6f5	8aaefde6-b0c0-4666-9dea-a3afa1664332	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	75.00	7	t	\N	2026-07-05 22:07:54.547299+00	\N	70.00	6	\N
60775d2e-9303-475d-9093-c605c4911226	8aaefde6-b0c0-4666-9dea-a3afa1664332	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	27.00	8	t	\N	2026-07-05 22:07:54.565882+00	\N	25.00	8	\N
9fbbd26c-27e9-4fc7-b3a5-70d729d92612	8aaefde6-b0c0-4666-9dea-a3afa1664332	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	26.00	8	t	\N	2026-07-05 22:07:54.584601+00	\N	25.00	8	\N
3789f916-9940-480a-befa-d260b65495ec	8aaefde6-b0c0-4666-9dea-a3afa1664332	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	25.50	9	t	\N	2026-07-05 22:07:54.604357+00	\N	25.00	8	\N
dc131761-34c8-4379-bb3e-cd0006bf986c	8aaefde6-b0c0-4666-9dea-a3afa1664332	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:07:54.625977+00	29	\N	\N	30
ee4cdda5-f84d-4a15-bb82-d4e6cb5999ee	8aaefde6-b0c0-4666-9dea-a3afa1664332	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:07:54.645674+00	30	\N	\N	30
79dee630-8535-4ee4-ae15-941a2cc60138	8aaefde6-b0c0-4666-9dea-a3afa1664332	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:07:54.667907+00	34	\N	\N	30
8841c07a-14bc-4d6d-a010-f872200b042e	da61ab26-62ff-47bb-af2d-fa931ba98b51	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	133.00	3	t	\N	2026-07-05 22:07:54.942762+00	\N	127.50	4	\N
32a3ff34-0479-4b12-9eb5-411b617a68b7	da61ab26-62ff-47bb-af2d-fa931ba98b51	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	129.50	4	t	\N	2026-07-05 22:07:54.964605+00	\N	127.50	4	\N
886eb039-bc08-4465-ae56-6708ddd7818c	da61ab26-62ff-47bb-af2d-fa931ba98b51	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	116.50	3	t	\N	2026-07-05 22:07:54.981996+00	\N	127.50	4	\N
2bec12c7-8706-4c2c-83de-dbd5da73ed05	da61ab26-62ff-47bb-af2d-fa931ba98b51	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	108.50	3	t	\N	2026-07-05 22:07:54.996993+00	\N	105.00	5	\N
ea4d7839-f93a-4e40-bb51-bcdd01bc88da	da61ab26-62ff-47bb-af2d-fa931ba98b51	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	106.50	5	t	\N	2026-07-05 22:07:55.015958+00	\N	105.00	5	\N
032f888d-d93e-4858-83f1-6cee0beb1108	da61ab26-62ff-47bb-af2d-fa931ba98b51	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	94.00	5	t	\N	2026-07-05 22:07:55.03579+00	\N	105.00	5	\N
cf571408-624f-4346-a612-081923818f49	da61ab26-62ff-47bb-af2d-fa931ba98b51	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	40.50	7	t	\N	2026-07-05 22:07:55.052205+00	\N	50.00	6	\N
4aa153ce-a29b-4494-afe0-6c9ec13c8585	da61ab26-62ff-47bb-af2d-fa931ba98b51	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	54.50	6	t	\N	2026-07-05 22:07:55.070477+00	\N	50.00	6	\N
8c986862-1925-4abb-aeb6-66654aeaeadf	da61ab26-62ff-47bb-af2d-fa931ba98b51	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	54.00	4	t	\N	2026-07-05 22:07:55.09434+00	\N	50.00	6	\N
b40b2d7f-3b43-454c-b7f1-2feb3f1b0648	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	72.00	7	t	\N	2026-07-05 22:07:55.374267+00	\N	70.00	6	\N
deb80954-a0b0-4eb4-9d85-944d930409c1	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	74.50	7	t	\N	2026-07-05 22:07:55.391878+00	\N	70.00	6	\N
a74ee1f9-f9d5-4123-88b7-201573b2f4ed	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	71.00	7	t	\N	2026-07-05 22:07:55.407468+00	\N	70.00	6	\N
17a7770a-bdef-4c32-8f31-f116748fbbe1	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	25.50	9	t	\N	2026-07-05 22:07:55.425646+00	\N	25.00	8	\N
bf92311c-f5ad-47da-ade2-af79100a51b0	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	27.50	9	t	\N	2026-07-05 22:07:55.442889+00	\N	25.00	8	\N
1cb5e822-ea62-4b11-9324-b960a6ca526a	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	26.50	9	t	\N	2026-07-05 22:07:55.466253+00	\N	25.00	8	\N
ce412d7a-4efd-4d4e-aa58-0b398f274bc3	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:07:55.483052+00	36	\N	\N	30
64d19c76-20cf-4df4-a6bc-8117e7692ebf	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:07:55.498275+00	35	\N	\N	30
47823851-7516-4861-9372-c7aa5271ffe6	4b20ebb6-a8f5-455b-820c-97a88fa8e92b	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:07:55.514218+00	31	\N	\N	30
9d82021e-ec14-463b-8a79-3abf40b63547	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	138.00	4	t	\N	2026-07-05 22:07:55.77455+00	\N	127.50	4	\N
b79d6202-86d6-4bce-a9b0-77f2cd936b0c	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	128.50	5	t	\N	2026-07-05 22:07:55.795983+00	\N	127.50	4	\N
bf27efe6-5399-40c6-80dd-043f01c5af26	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	134.50	5	t	\N	2026-07-05 22:07:55.816428+00	\N	127.50	4	\N
573e9e71-eb75-461e-be42-a28c97a292ad	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	107.00	5	t	\N	2026-07-05 22:07:55.835226+00	\N	105.00	5	\N
e2603e6c-c3ac-42aa-a999-385877fd90d3	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	114.50	6	t	\N	2026-07-05 22:07:55.864887+00	\N	105.00	5	\N
3f0c7e9e-f3c0-4595-9c73-ef3761640085	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	106.50	5	t	\N	2026-07-05 22:07:55.885278+00	\N	105.00	5	\N
a1190c77-840e-48d6-8708-33b41901f113	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	53.50	7	t	\N	2026-07-05 22:07:55.901931+00	\N	50.00	6	\N
716308f7-95c6-4ce0-ac03-f86cff00d93e	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	53.50	7	t	\N	2026-07-05 22:07:55.923593+00	\N	50.00	6	\N
41d64d0a-925d-4cda-9c4b-11853f9ad49f	c8d7f6f0-f90b-4367-abcf-2d7d7c93601e	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	53.00	6	t	\N	2026-07-05 22:07:55.941942+00	\N	50.00	6	\N
31b242ad-85f2-43ef-b53b-ab81d1218098	d72ed32d-3d09-4224-8924-b53501fabdb7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	79.50	7	t	\N	2026-07-05 22:07:56.708711+00	\N	77.50	6	\N
94aaf948-d4f8-4963-81a0-a338d5d58e3a	d72ed32d-3d09-4224-8924-b53501fabdb7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	79.00	7	t	\N	2026-07-05 22:07:56.72613+00	\N	77.50	6	\N
2fb46c8a-465d-4c8b-9b53-8570daa9f76a	d72ed32d-3d09-4224-8924-b53501fabdb7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	84.00	6	t	\N	2026-07-05 22:07:56.73918+00	\N	77.50	6	\N
a0928a69-2aa5-4d1e-81d8-af5cfaeec4d3	d72ed32d-3d09-4224-8924-b53501fabdb7	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	26.50	9	t	\N	2026-07-05 22:07:56.761603+00	\N	25.00	8	\N
3aa51a28-7648-417c-b52e-b5a64c35d97b	d72ed32d-3d09-4224-8924-b53501fabdb7	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	25.50	9	t	\N	2026-07-05 22:07:56.781404+00	\N	25.00	8	\N
b888c32d-18bc-43b5-8f75-bc4b6464d858	d72ed32d-3d09-4224-8924-b53501fabdb7	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	26.50	9	t	\N	2026-07-05 22:07:56.79782+00	\N	25.00	8	\N
1bd9d976-8b24-470b-8c54-a5d56f814a11	d72ed32d-3d09-4224-8924-b53501fabdb7	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:07:56.812722+00	33	\N	\N	30
6220ced8-c9f3-4546-827e-5519de46c4f3	d72ed32d-3d09-4224-8924-b53501fabdb7	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:07:56.824916+00	29	\N	\N	30
112a9776-5a59-4295-a527-6888f8817240	d72ed32d-3d09-4224-8924-b53501fabdb7	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:07:56.838827+00	31	\N	\N	30
ce6c4f08-1a5a-41ff-aea9-64987d609b13	90cdee4d-d2d5-445c-a178-820fc713ea63	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	119.50	5	t	\N	2026-07-05 22:07:57.055377+00	\N	140.00	4	\N
6e7a9e28-eeae-425b-a7c3-5e95fdb84e1f	90cdee4d-d2d5-445c-a178-820fc713ea63	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	117.00	4	t	\N	2026-07-05 22:07:57.069645+00	\N	140.00	4	\N
f6b77bfb-c92d-4d36-bfdd-70ceb554e00a	90cdee4d-d2d5-445c-a178-820fc713ea63	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	151.50	4	t	\N	2026-07-05 22:07:57.081885+00	\N	140.00	4	\N
54f2f156-7f91-4774-a367-011cb6fc8c02	90cdee4d-d2d5-445c-a178-820fc713ea63	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	105.50	5	t	\N	2026-07-05 22:07:57.097208+00	\N	117.50	5	\N
6daea4df-68fd-4571-8949-9163cb9e9ecc	90cdee4d-d2d5-445c-a178-820fc713ea63	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	124.50	6	t	\N	2026-07-05 22:07:57.111633+00	\N	117.50	5	\N
5c796815-08d7-409d-bee7-655d9ce6d9bc	90cdee4d-d2d5-445c-a178-820fc713ea63	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	125.50	5	t	\N	2026-07-05 22:07:57.128199+00	\N	117.50	5	\N
d91a4074-2b1d-4146-bf13-e8cbfc4ab68c	90cdee4d-d2d5-445c-a178-820fc713ea63	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	54.00	7	t	\N	2026-07-05 22:07:57.141279+00	\N	52.00	6	\N
ad3f77ed-03fc-4d87-8d86-d681c6bbabe0	90cdee4d-d2d5-445c-a178-820fc713ea63	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	42.00	4	t	\N	2026-07-05 22:07:57.15597+00	\N	52.00	6	\N
47167059-a4ee-4483-b68b-8a9ff7cca7b7	90cdee4d-d2d5-445c-a178-820fc713ea63	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	52.00	6	t	\N	2026-07-05 22:07:57.170382+00	\N	52.00	6	\N
689df6c9-e5ac-4a52-a67d-477729e7b265	485d5d3d-3a3a-478c-9b66-e4531f48c18f	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	84.50	7	t	\N	2026-07-05 22:07:57.378216+00	\N	77.50	6	\N
618788ac-a185-4d0c-a176-13b684f3f5e2	485d5d3d-3a3a-478c-9b66-e4531f48c18f	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	78.00	6	t	\N	2026-07-05 22:07:57.394694+00	\N	77.50	6	\N
64099dfb-ce0d-4c96-85bd-28bedafc7775	485d5d3d-3a3a-478c-9b66-e4531f48c18f	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	82.50	6	t	\N	2026-07-05 22:07:57.411183+00	\N	77.50	6	\N
43db0048-e7ea-48ba-a429-574cb0b13168	485d5d3d-3a3a-478c-9b66-e4531f48c18f	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	25.50	9	t	\N	2026-07-05 22:07:57.428935+00	\N	25.00	8	\N
d77572a4-b697-495b-b4dc-8dc8e4fc2f8e	485d5d3d-3a3a-478c-9b66-e4531f48c18f	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	26.50	9	t	\N	2026-07-05 22:07:57.446995+00	\N	25.00	8	\N
d37c324b-d893-411d-9962-3cbd85aeb530	485d5d3d-3a3a-478c-9b66-e4531f48c18f	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	27.00	9	t	\N	2026-07-05 22:07:57.460587+00	\N	25.00	8	\N
524261f0-ad30-4a05-bcdc-749ceaa8ecc3	485d5d3d-3a3a-478c-9b66-e4531f48c18f	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:07:57.477206+00	30	\N	\N	30
82c16ead-5e6d-4ed3-a946-07ef7d2fabe5	485d5d3d-3a3a-478c-9b66-e4531f48c18f	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:07:57.492385+00	29	\N	\N	30
b489b892-4b10-41a4-8dc7-ccad4d1b45a1	485d5d3d-3a3a-478c-9b66-e4531f48c18f	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:07:57.507124+00	32	\N	\N	30
72fd6dca-1cd8-44ee-89c9-0884406b4b8d	45330506-b3cc-4c84-b718-16b3cea21342	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	146.00	5	t	\N	2026-07-05 22:07:57.707196+00	\N	140.00	4	\N
89af79e2-e25d-428f-a76c-8c33e024f530	45330506-b3cc-4c84-b718-16b3cea21342	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	141.00	5	t	\N	2026-07-05 22:07:57.724769+00	\N	140.00	4	\N
15080905-a12b-48ed-9c75-b90b74f20ffc	45330506-b3cc-4c84-b718-16b3cea21342	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	149.00	4	t	\N	2026-07-05 22:07:57.737617+00	\N	140.00	4	\N
89253c48-557b-430e-8e7e-57beff2a110b	45330506-b3cc-4c84-b718-16b3cea21342	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	126.00	6	t	\N	2026-07-05 22:07:57.751947+00	\N	117.50	5	\N
7580bb6a-e1c6-41b5-b485-a6ffbe13c0c4	45330506-b3cc-4c84-b718-16b3cea21342	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	119.00	5	t	\N	2026-07-05 22:07:57.767561+00	\N	117.50	5	\N
9e2ac18f-3563-4d6b-b8f4-a3058bcbbb37	45330506-b3cc-4c84-b718-16b3cea21342	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	124.00	5	t	\N	2026-07-05 22:07:57.784963+00	\N	117.50	5	\N
1e49f2a0-296d-4735-922e-0449832deee9	45330506-b3cc-4c84-b718-16b3cea21342	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	53.00	7	t	\N	2026-07-05 22:07:57.805133+00	\N	52.00	6	\N
cb4afbb9-f238-48da-b3b1-41845d2b2bc0	45330506-b3cc-4c84-b718-16b3cea21342	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	56.50	6	t	\N	2026-07-05 22:07:57.820762+00	\N	52.00	6	\N
134ec876-ee71-4f1c-bac1-8090e47e0e14	45330506-b3cc-4c84-b718-16b3cea21342	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	56.00	7	t	\N	2026-07-05 22:07:57.842448+00	\N	52.00	6	\N
2397d285-a27a-48f0-961a-7338668c9e91	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	119.00	7	t	\N	2026-07-05 22:07:58.621713+00	\N	112.50	6	\N
318d489b-f49f-46ca-ab62-0be4cf506bdf	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	121.00	6	t	\N	2026-07-05 22:07:58.635645+00	\N	112.50	6	\N
48977149-febb-4704-a65a-d023cd673017	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	119.00	7	t	\N	2026-07-05 22:07:58.650046+00	\N	112.50	6	\N
fd5e06b5-df04-4f23-9b1b-920ae367342f	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	27.00	8	t	\N	2026-07-05 22:07:58.662943+00	\N	25.00	8	\N
65f8795a-a9c1-4290-b568-03f1d3960265	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	27.50	8	t	\N	2026-07-05 22:07:58.67815+00	\N	25.00	8	\N
c8200995-87eb-4602-b34b-01030462d978	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	25.50	9	t	\N	2026-07-05 22:07:58.694782+00	\N	25.00	8	\N
e03024d2-2d58-467e-bc5b-cf00f97c7af4	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:07:58.709474+00	35	\N	\N	30
34ffcd9b-4b7e-49d4-87b0-4ef764fe88eb	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:07:58.722003+00	31	\N	\N	30
e345c5c0-198d-413c-b97e-57031f2598c4	16b8f644-f57b-4c76-bdeb-4e0c85aeb3cd	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:07:58.734368+00	30	\N	\N	30
46418854-131f-48ba-98f2-ec6153f77290	c7df5426-38ce-4192-9182-c7fd54a1fc55	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	175.50	4	t	\N	2026-07-05 22:07:58.946061+00	\N	197.50	4	\N
9f27fd40-ecdb-45cb-b354-9b8a8695e13a	c7df5426-38ce-4192-9182-c7fd54a1fc55	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	208.00	4	t	\N	2026-07-05 22:07:58.958937+00	\N	197.50	4	\N
64f18a84-849c-40c8-b0d8-5fad00fa7d25	c7df5426-38ce-4192-9182-c7fd54a1fc55	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	202.00	5	t	\N	2026-07-05 22:07:58.973253+00	\N	197.50	4	\N
5801bdd5-3f3c-4b48-ac1e-24a50d461017	c7df5426-38ce-4192-9182-c7fd54a1fc55	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	157.00	5	t	\N	2026-07-05 22:07:58.986696+00	\N	185.00	5	\N
a7179d43-2339-43f3-95d4-a867b4a543a7	c7df5426-38ce-4192-9182-c7fd54a1fc55	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	203.50	5	t	\N	2026-07-05 22:07:58.999132+00	\N	185.00	5	\N
123bc30b-051a-46c9-9778-99f3e391d49f	c7df5426-38ce-4192-9182-c7fd54a1fc55	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	155.50	6	t	\N	2026-07-05 22:07:59.017166+00	\N	185.00	5	\N
0dbd1939-c8d1-43a8-97ec-5d28a85c5b67	c7df5426-38ce-4192-9182-c7fd54a1fc55	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	79.00	5	t	\N	2026-07-05 22:07:59.029827+00	\N	76.00	6	\N
2fa45132-7525-43fe-872a-96c540fe5b95	c7df5426-38ce-4192-9182-c7fd54a1fc55	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	80.50	7	t	\N	2026-07-05 22:07:59.046136+00	\N	76.00	6	\N
eaeb1d8c-1eb7-4f74-891c-76eb123095da	c7df5426-38ce-4192-9182-c7fd54a1fc55	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	70.00	5	t	\N	2026-07-05 22:07:59.059635+00	\N	76.00	6	\N
3424f005-3f6c-41dc-b4cc-96aa572dc73b	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	115.50	7	t	\N	2026-07-05 22:07:59.255802+00	\N	112.50	6	\N
0c2aa838-6b25-4a0b-9e76-d9287ae005d2	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	121.00	6	t	\N	2026-07-05 22:07:59.27034+00	\N	112.50	6	\N
c710ddfb-2905-4391-88a8-275b7482f43e	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	115.50	6	t	\N	2026-07-05 22:07:59.284847+00	\N	112.50	6	\N
96ee18b0-5b4f-467a-bc9d-33d53c0881eb	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	26.00	9	t	\N	2026-07-05 22:07:59.297637+00	\N	25.00	8	\N
e435655b-36d8-439a-b3a9-92dec1111645	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	27.00	9	t	\N	2026-07-05 22:07:59.31293+00	\N	25.00	8	\N
423ec4fc-6544-43f5-a6f5-028de967cb5d	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	25.50	9	t	\N	2026-07-05 22:07:59.328606+00	\N	25.00	8	\N
d0f41ce4-a47e-4e11-ab85-a0989496f962	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:07:59.340502+00	29	\N	\N	30
5df3531e-71bc-43bd-a088-679d0ac47675	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:07:59.353453+00	34	\N	\N	30
97308c19-fbad-4573-8812-e558f6ca53ef	031d7a59-eab3-4d29-9b85-1f9e750ccdd5	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:07:59.367687+00	36	\N	\N	30
f00d68be-751e-4222-94df-3f677b15b4a6	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	197.50	5	t	\N	2026-07-05 22:07:59.575908+00	\N	197.50	4	\N
d566f608-5140-47d0-adbc-ea47d38ea48c	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	210.00	4	t	\N	2026-07-05 22:07:59.589802+00	\N	197.50	4	\N
4de37707-5ce7-486b-861f-de5ea19ebe39	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	212.00	4	t	\N	2026-07-05 22:07:59.604368+00	\N	197.50	4	\N
8c10c3d2-a353-4a67-b8a7-cacda7ae03f3	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	193.00	5	t	\N	2026-07-05 22:07:59.620412+00	\N	185.00	5	\N
0d212a1f-ba33-40d0-90bb-17d37ae3db02	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	186.50	6	t	\N	2026-07-05 22:07:59.633884+00	\N	185.00	5	\N
57b9a41e-c742-4d6e-be7f-35a18117751b	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	201.50	6	t	\N	2026-07-05 22:07:59.650185+00	\N	185.00	5	\N
3f2455c2-9c62-46bc-8cba-8f705861db24	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	82.50	7	t	\N	2026-07-05 22:07:59.664116+00	\N	76.00	6	\N
eb73f7e6-11ce-4330-97fc-41f191ed3afe	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	77.00	6	t	\N	2026-07-05 22:07:59.67941+00	\N	76.00	6	\N
514403d7-594d-4588-b18c-a814cb88111d	819b0fcf-3cb8-4b3b-a64f-c57a3433495e	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	78.50	7	t	\N	2026-07-05 22:07:59.693181+00	\N	76.00	6	\N
98cbc480-4a2a-414f-bf88-b1c7450696a2	5f1ee935-e9d3-40c1-8a75-945e12ce9597	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	43.50	7	t	\N	2026-07-05 22:08:00.44051+00	\N	40.00	6	\N
36860428-a856-4350-9578-92754f5d98c4	5f1ee935-e9d3-40c1-8a75-945e12ce9597	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	41.00	7	t	\N	2026-07-05 22:08:00.455956+00	\N	40.00	6	\N
6be46989-dca6-4b69-9bc8-c9aa7083f053	5f1ee935-e9d3-40c1-8a75-945e12ce9597	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	42.00	6	t	\N	2026-07-05 22:08:00.468166+00	\N	40.00	6	\N
2efcb304-1fe4-4259-b079-4ab498273040	5f1ee935-e9d3-40c1-8a75-945e12ce9597	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	24.50	8	t	\N	2026-07-05 22:08:00.483601+00	\N	22.50	8	\N
10c64a49-2081-4978-9223-43e808bbe976	5f1ee935-e9d3-40c1-8a75-945e12ce9597	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	22.50	8	t	\N	2026-07-05 22:08:00.497488+00	\N	22.50	8	\N
e846eeb6-e147-46b7-8a0c-9967ea43a242	5f1ee935-e9d3-40c1-8a75-945e12ce9597	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	23.00	9	t	\N	2026-07-05 22:08:00.509159+00	\N	22.50	8	\N
b4e669d5-6a9c-46d4-b8c5-94ba8957a672	5f1ee935-e9d3-40c1-8a75-945e12ce9597	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:08:00.522188+00	37	\N	\N	30
2fbe772f-1e60-4a20-bf09-674b3d127a38	5f1ee935-e9d3-40c1-8a75-945e12ce9597	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:08:00.536438+00	31	\N	\N	30
45e44e05-4947-42ff-a705-3012d602f503	5f1ee935-e9d3-40c1-8a75-945e12ce9597	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:08:00.548721+00	34	\N	\N	30
1b1b532e-ffaa-4253-8607-b4e956267d51	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	89.50	4	t	\N	2026-07-05 22:08:00.751475+00	\N	82.50	4	\N
7b4fd7ac-6a88-4ee5-9da4-68365d97cd2d	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	84.50	5	t	\N	2026-07-05 22:08:00.765705+00	\N	82.50	4	\N
10d4241d-eb94-4bcd-82a4-051389d5e9ae	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	73.50	5	t	\N	2026-07-05 22:08:00.781371+00	\N	82.50	4	\N
3c9b6724-3da4-42fa-a212-41e678e7c124	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	68.50	4	t	\N	2026-07-05 22:08:00.792682+00	\N	62.50	5	\N
a2bba5f3-436b-490a-b0f8-40b85dbba1cd	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	50.50	6	t	\N	2026-07-05 22:08:00.808175+00	\N	62.50	5	\N
b2453dcc-c2cc-4b47-9979-b02bbdb94639	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	67.00	6	t	\N	2026-07-05 22:08:00.821341+00	\N	62.50	5	\N
71fc2d95-f02a-4b11-b808-21f8cab8bb1b	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	24.00	7	t	\N	2026-07-05 22:08:00.835797+00	\N	28.00	6	\N
06316a3d-0da2-4be8-b801-74a57351caf4	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	30.00	5	t	\N	2026-07-05 22:08:00.847361+00	\N	28.00	6	\N
94ed2f32-8835-4190-a528-d227054b9b42	e934eaa8-12bf-4d05-b8a6-2d50ed9cbb71	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	30.00	7	t	\N	2026-07-05 22:08:00.861331+00	\N	28.00	6	\N
dfdb32ab-a9a9-4648-a0b7-68ace8498fcc	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	40.50	7	t	\N	2026-07-05 22:08:01.070389+00	\N	40.00	6	\N
d036024c-18b0-4d6c-a78c-0476fba66439	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	44.00	7	t	\N	2026-07-05 22:08:01.083568+00	\N	40.00	6	\N
ce73dedb-9961-4d44-a35c-08a34f080958	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	43.50	7	t	\N	2026-07-05 22:08:01.097908+00	\N	40.00	6	\N
4e557f3a-f8d4-4041-a1b6-da9192258e4d	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	23.00	9	t	\N	2026-07-05 22:08:01.108658+00	\N	22.50	8	\N
92a10ba1-5e4f-4fb5-a70b-9d370f073e98	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	22.50	8	t	\N	2026-07-05 22:08:01.120754+00	\N	22.50	8	\N
94d64222-59d4-4e65-8dbe-0e2b20fca4c9	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	23.50	9	t	\N	2026-07-05 22:08:01.134084+00	\N	22.50	8	\N
cabf1d67-b408-440a-aaac-d75e475c31e5	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:08:01.144289+00	34	\N	\N	30
43899895-b060-4386-8631-b0b1a2476114	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:08:01.156445+00	33	\N	\N	30
ad5af765-49b7-4362-afe6-f66754a20869	9d94fb2c-ab58-4ce5-8aa7-06f82cadcd10	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:08:01.169287+00	32	\N	\N	30
28f435df-5158-412c-bd50-f3575d3781e5	8999a2ac-efc1-4012-8f18-9168edf654a3	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	86.50	5	t	\N	2026-07-05 22:08:01.372796+00	\N	82.50	4	\N
340804ad-688a-4a8f-94af-39392b10a79a	8999a2ac-efc1-4012-8f18-9168edf654a3	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	90.50	5	t	\N	2026-07-05 22:08:01.387272+00	\N	82.50	4	\N
81aed5c4-1510-420d-a493-2d7b6d4153ea	8999a2ac-efc1-4012-8f18-9168edf654a3	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	88.00	4	t	\N	2026-07-05 22:08:01.401598+00	\N	82.50	4	\N
db5c96a3-9077-463c-a069-5247c97154b8	8999a2ac-efc1-4012-8f18-9168edf654a3	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	66.50	6	t	\N	2026-07-05 22:08:01.413873+00	\N	62.50	5	\N
54280d77-f134-458c-a9b9-5a28d14dbaca	8999a2ac-efc1-4012-8f18-9168edf654a3	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	63.00	6	t	\N	2026-07-05 22:08:01.425154+00	\N	62.50	5	\N
02e063a3-e2c5-4e6b-a67c-6ec403b12216	8999a2ac-efc1-4012-8f18-9168edf654a3	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	64.00	5	t	\N	2026-07-05 22:08:01.439112+00	\N	62.50	5	\N
be7f4283-cec4-4c1c-a332-37bc755742e6	8999a2ac-efc1-4012-8f18-9168edf654a3	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	30.50	6	t	\N	2026-07-05 22:08:01.455342+00	\N	28.00	6	\N
d6cbf7a6-b308-4e56-906c-d303109648e3	8999a2ac-efc1-4012-8f18-9168edf654a3	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	28.00	7	t	\N	2026-07-05 22:08:01.470248+00	\N	28.00	6	\N
a78e369b-0641-495f-b497-43cddb8942fb	8999a2ac-efc1-4012-8f18-9168edf654a3	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	29.50	7	t	\N	2026-07-05 22:08:01.48201+00	\N	28.00	6	\N
b86496b7-ffd2-4a79-bedf-f9714cccc432	eb566f1f-1062-4c8d-be07-fcfe9e126044	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	54.00	7	t	\N	2026-07-05 22:17:32.908632+00	\N	52.50	6	\N
0ed0d4bd-a6af-471a-9935-1e1cdec33e4d	eb566f1f-1062-4c8d-be07-fcfe9e126044	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	53.50	7	t	\N	2026-07-05 22:17:32.923165+00	\N	52.50	6	\N
ed29a816-cb6d-469b-9e1b-ec5de02a0321	eb566f1f-1062-4c8d-be07-fcfe9e126044	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	56.50	7	t	\N	2026-07-05 22:17:32.935297+00	\N	52.50	6	\N
d37aba7c-0d53-437e-bbc5-501118932b00	eb566f1f-1062-4c8d-be07-fcfe9e126044	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	21.00	9	t	\N	2026-07-05 22:17:32.951015+00	\N	20.00	8	\N
4d27cf01-f3c2-4cd2-b2b6-51a8a24cb99a	eb566f1f-1062-4c8d-be07-fcfe9e126044	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	21.00	9	t	\N	2026-07-05 22:17:32.963895+00	\N	20.00	8	\N
c99e8278-bb65-409f-8564-138527aa3c1a	eb566f1f-1062-4c8d-be07-fcfe9e126044	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	21.50	9	t	\N	2026-07-05 22:17:32.975563+00	\N	20.00	8	\N
86b3bdd0-f775-47e3-b12d-4bc4ba468f32	eb566f1f-1062-4c8d-be07-fcfe9e126044	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:32.991126+00	36	\N	\N	30
4325c00a-92ef-4e35-b261-bd2f533c6253	eb566f1f-1062-4c8d-be07-fcfe9e126044	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:33.0058+00	29	\N	\N	30
7fd148ff-6554-44d4-bb8e-19b3770c887b	eb566f1f-1062-4c8d-be07-fcfe9e126044	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:33.017648+00	35	\N	\N	30
2d154757-bbfc-4ff8-a589-7791db9c3302	c536128d-c41d-4a44-9ae6-4b6b46de277d	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	104.00	4	t	\N	2026-07-05 22:17:33.244786+00	\N	97.50	4	\N
d66df7d5-753d-45e6-b020-0a918fab9439	c536128d-c41d-4a44-9ae6-4b6b46de277d	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	80.00	4	t	\N	2026-07-05 22:17:33.257956+00	\N	97.50	4	\N
a92127b4-7b93-4c00-b638-8cc76b952b3b	c536128d-c41d-4a44-9ae6-4b6b46de277d	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	103.00	5	t	\N	2026-07-05 22:17:33.268616+00	\N	97.50	4	\N
3d93451b-8035-4066-ac4c-ec79a206ddca	c536128d-c41d-4a44-9ae6-4b6b46de277d	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	86.50	4	t	\N	2026-07-05 22:17:33.281971+00	\N	82.50	5	\N
6c9bfc03-9402-4eb4-8829-f09d7defb91a	c536128d-c41d-4a44-9ae6-4b6b46de277d	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	86.50	6	t	\N	2026-07-05 22:17:33.29598+00	\N	82.50	5	\N
7c343d42-7902-4429-9418-da2c6fcf2793	c536128d-c41d-4a44-9ae6-4b6b46de277d	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	75.00	3	t	\N	2026-07-05 22:17:33.309428+00	\N	82.50	5	\N
08ae3e1b-1490-415b-b703-e72c076e8ee7	c536128d-c41d-4a44-9ae6-4b6b46de277d	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	32.50	5	t	\N	2026-07-05 22:17:33.321371+00	\N	36.00	6	\N
3e48f1a0-d1ca-4185-9f51-641efc6a79fd	c536128d-c41d-4a44-9ae6-4b6b46de277d	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	38.00	7	t	\N	2026-07-05 22:17:33.33326+00	\N	36.00	6	\N
350e16a5-77d5-40ad-b8e4-99fc95a80f15	c536128d-c41d-4a44-9ae6-4b6b46de277d	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	39.00	7	t	\N	2026-07-05 22:17:33.346078+00	\N	36.00	6	\N
7153b0dc-e416-45ad-bbe5-1a6ea4b41279	0d492916-a40a-4d72-b4b5-1d0191c57479	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	1	61.00	6	t	\N	2026-07-05 22:17:33.545439+00	\N	57.50	6	\N
fd9e0175-e576-45c4-9f0d-ea811aabaaaf	0d492916-a40a-4d72-b4b5-1d0191c57479	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	61.00	7	t	\N	2026-07-05 22:17:33.56204+00	\N	57.50	6	\N
1e451c58-1cc8-4f0f-803d-3df0091b32bf	0d492916-a40a-4d72-b4b5-1d0191c57479	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	3	61.00	6	t	\N	2026-07-05 22:17:33.576293+00	\N	57.50	6	\N
3cee2dc9-bcdf-4e44-9825-d11a63f06798	0d492916-a40a-4d72-b4b5-1d0191c57479	af2404f4-3336-4efd-a026-8f4c8d2ebb33	1	23.50	9	t	\N	2026-07-05 22:17:33.588999+00	\N	22.50	8	\N
2526996f-7240-46ae-a788-49ff5aa97b0b	0d492916-a40a-4d72-b4b5-1d0191c57479	af2404f4-3336-4efd-a026-8f4c8d2ebb33	2	24.50	8	t	\N	2026-07-05 22:17:33.604092+00	\N	22.50	8	\N
56884a8d-bf47-473e-b2f2-a14b873b4b95	0d492916-a40a-4d72-b4b5-1d0191c57479	af2404f4-3336-4efd-a026-8f4c8d2ebb33	3	23.00	9	t	\N	2026-07-05 22:17:33.616957+00	\N	22.50	8	\N
4ad089dd-c9f1-4204-b17d-1998e43ab1f2	0d492916-a40a-4d72-b4b5-1d0191c57479	6856b5d8-db6e-4e52-891a-f9fd473201b6	1	\N	\N	t	\N	2026-07-05 22:17:33.62823+00	35	\N	\N	30
74d83c7a-841b-4a5b-9bae-3b39e480d9da	0d492916-a40a-4d72-b4b5-1d0191c57479	6856b5d8-db6e-4e52-891a-f9fd473201b6	2	\N	\N	t	\N	2026-07-05 22:17:33.641354+00	31	\N	\N	30
bc000785-f717-4e08-80e5-a2132be3a73c	0d492916-a40a-4d72-b4b5-1d0191c57479	6856b5d8-db6e-4e52-891a-f9fd473201b6	3	\N	\N	t	\N	2026-07-05 22:17:33.654645+00	33	\N	\N	30
c3a7c79a-de3d-45ac-86ec-d5e9081867ea	a0fa267e-582b-423e-98d3-1516265202f7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	106.00	5	t	\N	2026-07-05 22:17:33.88732+00	\N	105.00	4	\N
aecae010-321c-4625-b192-f3131f55335e	a0fa267e-582b-423e-98d3-1516265202f7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	2	107.00	5	t	\N	2026-07-05 22:17:33.906754+00	\N	105.00	4	\N
2abe6351-569c-45d8-8323-bb35d1a220b8	a0fa267e-582b-423e-98d3-1516265202f7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	3	115.00	4	t	\N	2026-07-05 22:17:33.922804+00	\N	105.00	4	\N
444a4ac7-b719-4a3e-ab5f-15fc8a16db5b	a0fa267e-582b-423e-98d3-1516265202f7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	1	91.50	6	t	\N	2026-07-05 22:17:33.937839+00	\N	87.50	5	\N
85f1cea0-07cb-421f-84cf-f556b8bc70e5	a0fa267e-582b-423e-98d3-1516265202f7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	2	96.00	5	t	\N	2026-07-05 22:17:33.952273+00	\N	87.50	5	\N
7e7865af-e21f-4e1b-ad88-5ef918c45fba	a0fa267e-582b-423e-98d3-1516265202f7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	3	90.00	5	t	\N	2026-07-05 22:17:33.967958+00	\N	87.50	5	\N
e5bae19a-cf79-4d16-a5fc-e8f88cf31b53	a0fa267e-582b-423e-98d3-1516265202f7	b76fc300-143d-4f4e-b71a-6692489a7bc3	1	44.00	6	t	\N	2026-07-05 22:17:33.980964+00	\N	40.00	6	\N
5a318a2e-0342-46de-bcde-86b0d23bbb3c	a0fa267e-582b-423e-98d3-1516265202f7	b76fc300-143d-4f4e-b71a-6692489a7bc3	2	42.50	6	t	\N	2026-07-05 22:17:33.997552+00	\N	40.00	6	\N
92edcb61-04df-4650-b568-77f0909d98b5	a0fa267e-582b-423e-98d3-1516265202f7	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	42.00	7	t	\N	2026-07-05 22:17:34.012832+00	\N	40.00	6	\N
61ccfdde-6cee-4adf-8df1-69809c39c4a6	379bab3f-f672-4261-8347-56e04e88edc7	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	155.00	1	t	\N	2026-07-05 22:57:45.87002+00	\N	\N	\N	\N
e148b8b4-5370-4cd9-9985-b93624013d37	379bab3f-f672-4261-8347-56e04e88edc7	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	90.00	1	t	\N	2026-07-05 22:57:45.884643+00	\N	\N	\N	\N
e5f3964d-0c60-4f06-9f97-1d4d3cc1d42b	379bab3f-f672-4261-8347-56e04e88edc7	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	65.00	1	t	\N	2026-07-05 22:57:45.896673+00	\N	\N	\N	\N
9b608069-9a2c-4c20-8966-27fc4abcd236	379bab3f-f672-4261-8347-56e04e88edc7	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	135.00	1	t	\N	2026-07-05 22:57:45.908253+00	\N	\N	\N	\N
8cf9df9a-b365-4b5c-a1c1-b8119be9a046	bc1077cc-c411-4693-8be3-981c511a06ae	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	167.50	1	t	\N	2026-07-05 22:57:46.252451+00	\N	\N	\N	\N
154f2190-9d26-4bbf-8623-980f9bc9001a	bc1077cc-c411-4693-8be3-981c511a06ae	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	102.50	1	t	\N	2026-07-05 22:57:46.274258+00	\N	\N	\N	\N
cbb861fd-a464-4a77-8b9f-183c2bcf4aec	bc1077cc-c411-4693-8be3-981c511a06ae	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	67.50	1	t	\N	2026-07-05 22:57:46.293735+00	\N	\N	\N	\N
333a41cd-2a32-4a76-b1d0-ecf4f1ba25eb	bc1077cc-c411-4693-8be3-981c511a06ae	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	147.50	1	t	\N	2026-07-05 22:57:46.31124+00	\N	\N	\N	\N
d04595d4-bdad-47df-a381-fd5ab3764df1	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	235.00	1	t	\N	2026-07-05 22:57:46.655495+00	\N	\N	\N	\N
5b067951-7b1d-4cef-9a5a-d46cfefd3c2e	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	145.00	1	t	\N	2026-07-05 22:57:46.668172+00	\N	\N	\N	\N
7c8545a6-e7f8-40e4-8747-f562655583fe	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	100.00	1	t	\N	2026-07-05 22:57:46.677689+00	\N	\N	\N	\N
b3fc419c-c3c3-402c-9dfb-d0594c577a58	7ee252ce-5ecb-4ce4-b51e-9ce5a3019c5f	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	237.50	1	t	\N	2026-07-05 22:57:46.689062+00	\N	\N	\N	\N
cbbd61a1-84f6-4be6-9354-b450a66eee26	ddde86ff-1675-4a35-b25a-68a816b98bdb	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	102.50	1	t	\N	2026-07-05 22:57:47.058332+00	\N	\N	\N	\N
43b52dc2-4a84-4cf8-a314-5e7dbabde3d7	ddde86ff-1675-4a35-b25a-68a816b98bdb	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	52.50	1	t	\N	2026-07-05 22:57:47.075669+00	\N	\N	\N	\N
85018463-3956-4d12-a2ea-2cee1a28b994	ddde86ff-1675-4a35-b25a-68a816b98bdb	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	37.50	1	t	\N	2026-07-05 22:57:47.088515+00	\N	\N	\N	\N
aacfb207-386e-41bd-b52c-7c8a01be310d	ddde86ff-1675-4a35-b25a-68a816b98bdb	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	80.00	1	t	\N	2026-07-05 22:57:47.099943+00	\N	\N	\N	\N
47a8db5b-df02-47b5-9660-0373a4bc8a47	a51b1111-c7a2-469e-95a2-a4be71318990	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	125.00	1	t	\N	2026-07-05 22:57:47.431272+00	\N	\N	\N	\N
90eec04b-a2a3-422a-a748-51bf215b6a73	a51b1111-c7a2-469e-95a2-a4be71318990	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	72.50	1	t	\N	2026-07-05 22:57:47.441448+00	\N	\N	\N	\N
d0b81077-2f2a-4224-ba2d-6661b9cdba8e	a51b1111-c7a2-469e-95a2-a4be71318990	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	42.50	1	t	\N	2026-07-05 22:57:47.452773+00	\N	\N	\N	\N
8aeb8861-1fb1-433d-9c0a-1beccdd8a856	a51b1111-c7a2-469e-95a2-a4be71318990	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	100.00	1	t	\N	2026-07-05 22:57:47.464467+00	\N	\N	\N	\N
9f9edf6b-db9e-41aa-9a36-c77c0ce2ed5b	e27e688f-296a-49b9-b917-77becdc03b3e	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	202.50	1	t	\N	2026-07-05 22:57:47.798916+00	\N	\N	\N	\N
2e5b239b-fe7c-408f-a15d-74ed35787c31	e27e688f-296a-49b9-b917-77becdc03b3e	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	120.00	1	t	\N	2026-07-05 22:57:47.811178+00	\N	\N	\N	\N
60975845-cee8-46c9-8ef1-c0dc0e35f98a	e27e688f-296a-49b9-b917-77becdc03b3e	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	85.00	1	t	\N	2026-07-05 22:57:47.822458+00	\N	\N	\N	\N
33072e0d-fddb-4240-a975-409c662760a7	e27e688f-296a-49b9-b917-77becdc03b3e	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	187.50	1	t	\N	2026-07-05 22:57:47.834275+00	\N	\N	\N	\N
2c44d270-3b11-43f8-95db-e9a4111b00a0	f0911d89-b963-420c-ae05-54f51ae210b3	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	72.50	1	t	\N	2026-07-05 22:57:48.180082+00	\N	\N	\N	\N
6247d00c-6ba6-40c1-ae0d-577ee239fea1	f0911d89-b963-420c-ae05-54f51ae210b3	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	42.50	1	t	\N	2026-07-05 22:57:48.191169+00	\N	\N	\N	\N
09bc0056-b9d6-4497-9df5-99a7913ed13d	f0911d89-b963-420c-ae05-54f51ae210b3	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	27.50	1	t	\N	2026-07-05 22:57:48.201938+00	\N	\N	\N	\N
1e056162-558f-48e5-847e-7e279de33c62	f0911d89-b963-420c-ae05-54f51ae210b3	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	57.50	1	t	\N	2026-07-05 22:57:48.213896+00	\N	\N	\N	\N
59eddc7b-3b94-4792-b995-41b0c40c1153	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	240.00	1	t	\N	2026-07-05 22:57:48.547424+00	\N	\N	\N	\N
9ebcc9a1-9487-47db-8e3b-8d714302341d	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	140.00	1	t	\N	2026-07-05 22:57:48.557933+00	\N	\N	\N	\N
824919a7-9878-433a-9695-9033b92763cd	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	92.50	1	t	\N	2026-07-05 22:57:48.569694+00	\N	\N	\N	\N
3a455c9f-0646-49af-9b38-16f2974a6945	71b407fc-ddf5-4a79-9eab-c50ac88df2c8	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	205.00	1	t	\N	2026-07-05 22:57:48.581842+00	\N	\N	\N	\N
a23aa814-4473-412c-93d3-f13dee6d1fcb	078bd115-bd60-4448-9e90-92fb667f3e9a	7ec23ed3-c99d-4611-9a0a-06dd1e92c4c3	1	127.50	1	t	\N	2026-07-05 22:57:48.91396+00	\N	\N	\N	\N
be3c9a51-2f04-44ee-8ab1-ab22d83e961e	078bd115-bd60-4448-9e90-92fb667f3e9a	5ed2c3d4-2c6a-4e71-813c-c29a4add5f98	2	72.50	1	t	\N	2026-07-05 22:57:48.926152+00	\N	\N	\N	\N
e41f59bb-26d5-4b19-8fcd-d1e97cfa3fd4	078bd115-bd60-4448-9e90-92fb667f3e9a	b76fc300-143d-4f4e-b71a-6692489a7bc3	3	52.50	1	t	\N	2026-07-05 22:57:48.937572+00	\N	\N	\N	\N
361d7bc1-1367-48fb-9654-43222e019327	078bd115-bd60-4448-9e90-92fb667f3e9a	7917a8e6-6d39-4151-af70-7a4f24b5ce94	4	110.00	1	t	\N	2026-07-05 22:57:48.949462+00	\N	\N	\N	\N
\.


--
-- Name: app_notifications app_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_notifications
    ADD CONSTRAINT app_notifications_pkey PRIMARY KEY (id);


--
-- Name: article_favorites article_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_favorites
    ADD CONSTRAINT article_favorites_pkey PRIMARY KEY (user_id, article_id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: body_measurements body_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.body_measurements
    ADD CONSTRAINT body_measurements_pkey PRIMARY KEY (id);


--
-- Name: careers careers_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.careers
    ADD CONSTRAINT careers_name_key UNIQUE (name);


--
-- Name: careers careers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.careers
    ADD CONSTRAINT careers_pkey PRIMARY KEY (id);


--
-- Name: event_interests event_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_pkey PRIMARY KEY (user_id, event_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: hiit_lists hiit_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_lists
    ADD CONSTRAINT hiit_lists_pkey PRIMARY KEY (id);


--
-- Name: hiit_sessions hiit_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_sessions
    ADD CONSTRAINT hiit_sessions_pkey PRIMARY KEY (id);


--
-- Name: hiit_workouts hiit_workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_workouts
    ADD CONSTRAINT hiit_workouts_pkey PRIMARY KEY (id);


--
-- Name: joint_exercises joint_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.joint_exercises
    ADD CONSTRAINT joint_exercises_pkey PRIMARY KEY (id);


--
-- Name: lift_submission_images lift_submission_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lift_submission_images
    ADD CONSTRAINT lift_submission_images_pkey PRIMARY KEY (id);


--
-- Name: lift_submissions lift_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lift_submissions
    ADD CONSTRAINT lift_submissions_pkey PRIMARY KEY (id);


--
-- Name: notification_reads notification_reads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_reads
    ADD CONSTRAINT notification_reads_pkey PRIMARY KEY (user_id, notif_type, reference_id);


--
-- Name: personal_records personal_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_records
    ADD CONSTRAINT personal_records_pkey PRIMARY KEY (id);


--
-- Name: personal_records personal_records_user_id_exercise_id_reps_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_records
    ADD CONSTRAINT personal_records_user_id_exercise_id_reps_key UNIQUE (user_id, exercise_id, reps);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: role_requests role_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_requests
    ADD CONSTRAINT role_requests_pkey PRIMARY KEY (id);


--
-- Name: routine_day_exercises routine_day_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routine_day_exercises
    ADD CONSTRAINT routine_day_exercises_pkey PRIMARY KEY (id);


--
-- Name: routine_days routine_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routine_days
    ADD CONSTRAINT routine_days_pkey PRIMARY KEY (id);


--
-- Name: routines routines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routines
    ADD CONSTRAINT routines_pkey PRIMARY KEY (id);


--
-- Name: security_audit_log security_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_audit_log
    ADD CONSTRAINT security_audit_log_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workout_sessions workout_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sessions
    ADD CONSTRAINT workout_sessions_pkey PRIMARY KEY (id);


--
-- Name: workout_sets workout_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sets
    ADD CONSTRAINT workout_sets_pkey PRIMARY KEY (id);


--
-- Name: idx_articles_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_articles_category ON public.articles USING btree (category);


--
-- Name: idx_articles_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_articles_published ON public.articles USING btree (published_at DESC) WHERE (is_published = true);


--
-- Name: idx_audit_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_created ON public.security_audit_log USING btree (created_at DESC);


--
-- Name: idx_audit_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_user_id ON public.security_audit_log USING btree (user_id);


--
-- Name: idx_careers_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_careers_active ON public.careers USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_event_interests_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_event_interests_event ON public.event_interests USING btree (event_id);


--
-- Name: idx_events_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_active ON public.events USING btree (is_active, event_date) WHERE (is_active = true);


--
-- Name: idx_events_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_events_date ON public.events USING btree (event_date);


--
-- Name: idx_exercises_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exercises_active ON public.exercises USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_exercises_difficulty; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exercises_difficulty ON public.exercises USING btree (difficulty);


--
-- Name: idx_exercises_muscle_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_exercises_muscle_group ON public.exercises USING btree (muscle_group);


--
-- Name: idx_hiit_lists_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hiit_lists_user ON public.hiit_lists USING btree (user_id);


--
-- Name: idx_hiit_sessions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hiit_sessions_user ON public.hiit_sessions USING btree (user_id, started_at DESC);


--
-- Name: idx_hiit_workouts_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hiit_workouts_user ON public.hiit_workouts USING btree (user_id);


--
-- Name: idx_joint_exercises_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_joint_exercises_active ON public.joint_exercises USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_joint_exercises_family; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_joint_exercises_family ON public.joint_exercises USING btree (joint_family);


--
-- Name: idx_lift_submission_images; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lift_submission_images ON public.lift_submission_images USING btree (submission_id);


--
-- Name: idx_lift_submissions_exercise; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lift_submissions_exercise ON public.lift_submissions USING btree (exercise_id, weight_kg DESC) WHERE (status = 'approved'::public.lift_submission_status);


--
-- Name: idx_lift_submissions_pending; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lift_submissions_pending ON public.lift_submissions USING btree (status) WHERE (status = 'pending'::public.lift_submission_status);


--
-- Name: idx_lift_submissions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lift_submissions_user ON public.lift_submissions USING btree (user_id);


--
-- Name: idx_measurements_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_measurements_date ON public.body_measurements USING btree (user_id, measured_at DESC);


--
-- Name: idx_measurements_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_measurements_user_id ON public.body_measurements USING btree (user_id);


--
-- Name: idx_notif_reads_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_reads_user ON public.notification_reads USING btree (user_id);


--
-- Name: idx_pr_exercise_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pr_exercise_id ON public.personal_records USING btree (exercise_id);


--
-- Name: idx_pr_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pr_user_id ON public.personal_records USING btree (user_id);


--
-- Name: idx_pr_validated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pr_validated ON public.personal_records USING btree (is_validated, exercise_id) WHERE (is_validated = true);


--
-- Name: idx_rde_routine_day_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rde_routine_day_id ON public.routine_day_exercises USING btree (routine_day_id);


--
-- Name: idx_refresh_tokens_expires; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_tokens_expires ON public.refresh_tokens USING btree (expires_at);


--
-- Name: idx_refresh_tokens_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_tokens_hash ON public.refresh_tokens USING btree (token_hash);


--
-- Name: idx_refresh_tokens_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_tokens_user_id ON public.refresh_tokens USING btree (user_id);


--
-- Name: idx_role_requests_pending; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_requests_pending ON public.role_requests USING btree (status) WHERE (status = 'pending'::text);


--
-- Name: idx_role_requests_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_requests_user ON public.role_requests USING btree (user_id);


--
-- Name: idx_routine_days_routine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_routine_days_routine_id ON public.routine_days USING btree (routine_id);


--
-- Name: idx_routines_public; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_routines_public ON public.routines USING btree (is_public) WHERE (is_public = true);


--
-- Name: idx_routines_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_routines_user_id ON public.routines USING btree (user_id);


--
-- Name: idx_sessions_started_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_started_at ON public.workout_sessions USING btree (started_at DESC);


--
-- Name: idx_sessions_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_user_id ON public.workout_sessions USING btree (user_id);


--
-- Name: idx_sessions_user_started; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_user_started ON public.workout_sessions USING btree (user_id, started_at DESC);


--
-- Name: idx_sets_exercise_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sets_exercise_id ON public.workout_sets USING btree (exercise_id);


--
-- Name: idx_sets_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sets_session_id ON public.workout_sets USING btree (session_id);


--
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_active ON public.users USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: articles articles_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER articles_updated_at BEFORE UPDATE ON public.articles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: events events_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER events_updated_at BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: routines routines_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER routines_updated_at BEFORE UPDATE ON public.routines FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users users_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: app_notifications app_notifications_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_notifications
    ADD CONSTRAINT app_notifications_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: article_favorites article_favorites_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_favorites
    ADD CONSTRAINT article_favorites_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(id) ON DELETE CASCADE;


--
-- Name: article_favorites article_favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_favorites
    ADD CONSTRAINT article_favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: articles articles_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: body_measurements body_measurements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.body_measurements
    ADD CONSTRAINT body_measurements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: event_interests event_interests_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_interests event_interests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_interests
    ADD CONSTRAINT event_interests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: events events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: exercises exercises_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: hiit_lists hiit_lists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_lists
    ADD CONSTRAINT hiit_lists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hiit_sessions hiit_sessions_hiit_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_sessions
    ADD CONSTRAINT hiit_sessions_hiit_workout_id_fkey FOREIGN KEY (hiit_workout_id) REFERENCES public.hiit_workouts(id) ON DELETE SET NULL;


--
-- Name: hiit_sessions hiit_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_sessions
    ADD CONSTRAINT hiit_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hiit_workouts hiit_workouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiit_workouts
    ADD CONSTRAINT hiit_workouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: joint_exercises joint_exercises_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.joint_exercises
    ADD CONSTRAINT joint_exercises_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: lift_submission_images lift_submission_images_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lift_submission_images
    ADD CONSTRAINT lift_submission_images_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.lift_submissions(id) ON DELETE CASCADE;


--
-- Name: lift_submissions lift_submissions_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lift_submissions
    ADD CONSTRAINT lift_submissions_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: lift_submissions lift_submissions_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lift_submissions
    ADD CONSTRAINT lift_submissions_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lift_submissions lift_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lift_submissions
    ADD CONSTRAINT lift_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notification_reads notification_reads_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_reads
    ADD CONSTRAINT notification_reads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: personal_records personal_records_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_records
    ADD CONSTRAINT personal_records_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id);


--
-- Name: personal_records personal_records_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_records
    ADD CONSTRAINT personal_records_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.workout_sessions(id);


--
-- Name: personal_records personal_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_records
    ADD CONSTRAINT personal_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_replaced_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_replaced_by_fkey FOREIGN KEY (replaced_by) REFERENCES public.refresh_tokens(id);


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: role_requests role_requests_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_requests
    ADD CONSTRAINT role_requests_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: role_requests role_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_requests
    ADD CONSTRAINT role_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: routine_day_exercises routine_day_exercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routine_day_exercises
    ADD CONSTRAINT routine_day_exercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id);


--
-- Name: routine_day_exercises routine_day_exercises_routine_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routine_day_exercises
    ADD CONSTRAINT routine_day_exercises_routine_day_id_fkey FOREIGN KEY (routine_day_id) REFERENCES public.routine_days(id) ON DELETE CASCADE;


--
-- Name: routine_days routine_days_routine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routine_days
    ADD CONSTRAINT routine_days_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES public.routines(id) ON DELETE CASCADE;


--
-- Name: routines routines_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routines
    ADD CONSTRAINT routines_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: routines routines_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routines
    ADD CONSTRAINT routines_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: security_audit_log security_audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_audit_log
    ADD CONSTRAINT security_audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: workout_sessions workout_sessions_routine_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sessions
    ADD CONSTRAINT workout_sessions_routine_day_id_fkey FOREIGN KEY (routine_day_id) REFERENCES public.routine_days(id);


--
-- Name: workout_sessions workout_sessions_routine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sessions
    ADD CONSTRAINT workout_sessions_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES public.routines(id);


--
-- Name: workout_sessions workout_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sessions
    ADD CONSTRAINT workout_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: workout_sets workout_sets_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sets
    ADD CONSTRAINT workout_sets_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id);


--
-- Name: workout_sets workout_sets_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_sets
    ADD CONSTRAINT workout_sets_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.workout_sessions(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


