-- =============================================================
-- GymUBB — Schema inicial
-- PostgreSQL 16
-- Equivalente al DDL en server/lib/src/database/schema.dart
-- Para aplicar manualmente: psql -U gym_ubb_user -d gym_ubb < 001_init.sql
-- =============================================================

-- ── Enums ──────────────────────────────────────────────────────────────────

CREATE TYPE user_role AS ENUM ('student', 'professor', 'staff', 'admin');
CREATE TYPE muscle_group AS ENUM ('pecho', 'espalda', 'piernas', 'hombros', 'brazos', 'core', 'gluteos');
CREATE TYPE difficulty_level AS ENUM ('principiante', 'intermedio', 'avanzado');
CREATE TYPE workout_goal AS ENUM ('fuerza', 'hipertrofia', 'resistencia', 'perdida_de_peso');
CREATE TYPE audit_action AS ENUM (
  'login', 'logout', 'login_failed',
  'role_changed', 'password_changed',
  'account_created', 'account_deactivated'
);

-- ── Tabla: users ───────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
  id                    UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  email                 VARCHAR(255) NOT NULL UNIQUE,
  password_hash         VARCHAR(255) NOT NULL,
  name                  VARCHAR(255) NOT NULL,
  career                VARCHAR(255),
  role                  user_role    NOT NULL DEFAULT 'student',
  weight_kg             NUMERIC(5,2),
  height_cm             INTEGER,
  body_fat_pct          NUMERIC(4,1),
  units                 VARCHAR(3)   NOT NULL DEFAULT 'kg'
                          CHECK (units IN ('kg', 'lbs')),
  notifications_enabled BOOLEAN      NOT NULL DEFAULT true,
  private_profile       BOOLEAN      NOT NULL DEFAULT false,
  is_active             BOOLEAN      NOT NULL DEFAULT true,
  member_since          DATE         NOT NULL DEFAULT CURRENT_DATE,
  last_login_at         TIMESTAMPTZ,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Tabla: refresh_tokens ──────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS refresh_tokens (
  id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash  VARCHAR(255) NOT NULL UNIQUE,
  expires_at  TIMESTAMPTZ  NOT NULL,
  is_revoked  BOOLEAN      NOT NULL DEFAULT false,
  replaced_by UUID         REFERENCES refresh_tokens(id),
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Tabla: exercises ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS exercises (
  id                   UUID             PRIMARY KEY DEFAULT gen_random_uuid(),
  name                 VARCHAR(255)     NOT NULL,
  muscle_group         muscle_group     NOT NULL,
  difficulty           difficulty_level NOT NULL,
  description          TEXT,
  muscles              TEXT[]           NOT NULL DEFAULT '{}',
  instructions         TEXT[]           NOT NULL DEFAULT '{}',
  safety_notes         TEXT,
  variations           TEXT[]           NOT NULL DEFAULT '{}',
  video_url            VARCHAR(500),
  equipment            VARCHAR(255),
  default_sets         INTEGER          NOT NULL DEFAULT 3,
  default_reps         VARCHAR(20)      NOT NULL DEFAULT '8-12',
  default_rest_seconds INTEGER          NOT NULL DEFAULT 90,
  created_by           UUID             REFERENCES users(id),
  is_active            BOOLEAN          NOT NULL DEFAULT true,
  created_at           TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

-- ── Tabla: routines ────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS routines (
  id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID         REFERENCES users(id) ON DELETE CASCADE,
  name           VARCHAR(255) NOT NULL,
  goal           workout_goal NOT NULL DEFAULT 'hipertrofia',
  frequency_days INTEGER      NOT NULL DEFAULT 3,
  is_public      BOOLEAN      NOT NULL DEFAULT false,
  created_by     UUID         NOT NULL REFERENCES users(id),
  is_active      BOOLEAN      NOT NULL DEFAULT true,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Tabla: routine_days ────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS routine_days (
  id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_id  UUID         NOT NULL REFERENCES routines(id) ON DELETE CASCADE,
  day_name    VARCHAR(20)  NOT NULL,
  label       VARCHAR(255) NOT NULL,
  order_index INTEGER      NOT NULL DEFAULT 0
);

-- ── Tabla: routine_day_exercises ───────────────────────────────────────────

CREATE TABLE IF NOT EXISTS routine_day_exercises (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  routine_day_id UUID        NOT NULL REFERENCES routine_days(id) ON DELETE CASCADE,
  exercise_id    UUID        NOT NULL REFERENCES exercises(id),
  sets           INTEGER     NOT NULL DEFAULT 3,
  reps           VARCHAR(20) NOT NULL DEFAULT '8-12',
  rest_seconds   INTEGER     NOT NULL DEFAULT 90,
  order_index    INTEGER     NOT NULL DEFAULT 0
);

-- ── Tabla: workout_sessions ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS workout_sessions (
  id               UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  routine_id       UUID         REFERENCES routines(id),
  routine_day_id   UUID         REFERENCES routine_days(id),
  started_at       TIMESTAMPTZ  NOT NULL,
  ended_at         TIMESTAMPTZ,
  duration_minutes INTEGER,
  total_volume_kg  NUMERIC(10,2),
  notes            TEXT,
  created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Tabla: workout_sets ────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS workout_sets (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id  UUID        NOT NULL REFERENCES workout_sessions(id) ON DELETE CASCADE,
  exercise_id UUID        NOT NULL REFERENCES exercises(id),
  set_number  INTEGER     NOT NULL,
  weight_kg   NUMERIC(6,2),
  reps        INTEGER,
  completed   BOOLEAN     NOT NULL DEFAULT false,
  rpe         SMALLINT    CHECK (rpe BETWEEN 1 AND 10),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Tabla: personal_records ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS personal_records (
  id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  exercise_id  UUID         NOT NULL REFERENCES exercises(id),
  weight_kg    NUMERIC(6,2) NOT NULL,
  reps         INTEGER      NOT NULL DEFAULT 1,
  achieved_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  session_id   UUID         REFERENCES workout_sessions(id),
  is_validated BOOLEAN      NOT NULL DEFAULT false,
  UNIQUE (user_id, exercise_id, reps)
);

-- ── Tabla: body_measurements ───────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS body_measurements (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  measured_at  DATE        NOT NULL DEFAULT CURRENT_DATE,
  weight_kg    NUMERIC(5,2),
  body_fat_pct NUMERIC(4,1),
  chest_cm     NUMERIC(5,1),
  waist_cm     NUMERIC(5,1),
  hip_cm       NUMERIC(5,1),
  arm_cm       NUMERIC(5,1),
  leg_cm       NUMERIC(5,1),
  notes        TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Tabla: articles ────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS articles (
  id                UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  title             VARCHAR(255) NOT NULL,
  category          VARCHAR(100) NOT NULL,
  read_time_minutes INTEGER      NOT NULL DEFAULT 5,
  excerpt           TEXT,
  content           TEXT         NOT NULL,
  tags              TEXT[]       NOT NULL DEFAULT '{}',
  author_id         UUID         REFERENCES users(id),
  is_published      BOOLEAN      NOT NULL DEFAULT false,
  published_at      TIMESTAMPTZ,
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Tabla: article_favorites ───────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS article_favorites (
  user_id    UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  article_id UUID        NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  saved_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, article_id)
);

-- ── Tabla: events ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS events (
  id               UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  title            VARCHAR(255) NOT NULL,
  type             VARCHAR(100) NOT NULL,
  event_date       DATE         NOT NULL,
  event_time       TIME,
  location         VARCHAR(255),
  description      TEXT,
  max_participants INTEGER,
  registration_url VARCHAR(500),
  created_by       UUID         REFERENCES users(id),
  is_active        BOOLEAN      NOT NULL DEFAULT true,
  created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Tabla: security_audit_log ──────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS security_audit_log (
  id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID         REFERENCES users(id) ON DELETE SET NULL,
  action     audit_action NOT NULL,
  ip_address INET,
  user_agent TEXT,
  details    JSONB,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Índices ────────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_users_email       ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role        ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_active      ON users(is_active) WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_rt_user_id        ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_rt_hash           ON refresh_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_rt_expires        ON refresh_tokens(expires_at);

CREATE INDEX IF NOT EXISTS idx_ex_muscle_group   ON exercises(muscle_group);
CREATE INDEX IF NOT EXISTS idx_ex_difficulty     ON exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_ex_active         ON exercises(is_active) WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_routines_user     ON routines(user_id);
CREATE INDEX IF NOT EXISTS idx_routines_public   ON routines(is_public) WHERE is_public = true;

CREATE INDEX IF NOT EXISTS idx_rd_routine        ON routine_days(routine_id);
CREATE INDEX IF NOT EXISTS idx_rde_day           ON routine_day_exercises(routine_day_id);

CREATE INDEX IF NOT EXISTS idx_ws_user           ON workout_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_ws_started        ON workout_sessions(started_at DESC);
CREATE INDEX IF NOT EXISTS idx_ws_user_started   ON workout_sessions(user_id, started_at DESC);

CREATE INDEX IF NOT EXISTS idx_wset_session      ON workout_sets(session_id);
CREATE INDEX IF NOT EXISTS idx_wset_exercise     ON workout_sets(exercise_id);

CREATE INDEX IF NOT EXISTS idx_pr_user           ON personal_records(user_id);
CREATE INDEX IF NOT EXISTS idx_pr_exercise       ON personal_records(exercise_id);
CREATE INDEX IF NOT EXISTS idx_pr_validated      ON personal_records(is_validated, exercise_id) WHERE is_validated = true;

CREATE INDEX IF NOT EXISTS idx_bm_user           ON body_measurements(user_id);
CREATE INDEX IF NOT EXISTS idx_bm_user_date      ON body_measurements(user_id, measured_at DESC);

CREATE INDEX IF NOT EXISTS idx_art_category      ON articles(category);
CREATE INDEX IF NOT EXISTS idx_art_published     ON articles(published_at DESC) WHERE is_published = true;

CREATE INDEX IF NOT EXISTS idx_ev_date           ON events(event_date);
CREATE INDEX IF NOT EXISTS idx_ev_active_date    ON events(is_active, event_date) WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_audit_user        ON security_audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_created     ON security_audit_log(created_at DESC);

-- ── Función trigger: updated_at automático ─────────────────────────────────

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ── Triggers ───────────────────────────────────────────────────────────────

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'users_updated_at') THEN
    CREATE TRIGGER users_updated_at
      BEFORE UPDATE ON users
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'routines_updated_at') THEN
    CREATE TRIGGER routines_updated_at
      BEFORE UPDATE ON routines
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'articles_updated_at') THEN
    CREATE TRIGGER articles_updated_at
      BEFORE UPDATE ON articles
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'events_updated_at') THEN
    CREATE TRIGGER events_updated_at
      BEFORE UPDATE ON events
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;
