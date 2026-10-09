-- FitSync: Profiles and health logs

CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    date_of_birth DATE,
    height_cm NUMERIC(5, 2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.health_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    weight_kg NUMERIC(5, 2),
    water_intake_ml INTEGER,
    sleep_hours NUMERIC(4, 2),
    steps INTEGER,
    mood TEXT,
    notes TEXT,
    logged_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT health_logs_weight_positive
        CHECK (weight_kg IS NULL OR weight_kg > 0),
    CONSTRAINT health_logs_water_nonnegative
        CHECK (water_intake_ml IS NULL OR water_intake_ml >= 0),
    CONSTRAINT health_logs_sleep_range
        CHECK (sleep_hours IS NULL OR sleep_hours BETWEEN 0 AND 24),
    CONSTRAINT health_logs_steps_nonnegative
        CHECK (steps IS NULL OR steps >= 0),
    CONSTRAINT health_logs_mood_valid
        CHECK (
            mood IS NULL OR
            mood IN ('very_sad', 'sad', 'neutral', 'happy', 'very_happy')
        )
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile"
ON public.profiles FOR SELECT TO authenticated
USING ((SELECT auth.uid()) = id);

CREATE POLICY "Users can update their own profile"
ON public.profiles FOR UPDATE TO authenticated
USING ((SELECT auth.uid()) = id)
WITH CHECK ((SELECT auth.uid()) = id);

CREATE POLICY "Users can view their own health logs"
ON public.health_logs FOR SELECT TO authenticated
USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can insert their own health logs"
ON public.health_logs FOR INSERT TO authenticated
WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can update their own health logs"
ON public.health_logs FOR UPDATE TO authenticated
USING ((SELECT auth.uid()) = user_id)
WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can delete their own health logs"
ON public.health_logs FOR DELETE TO authenticated
USING ((SELECT auth.uid()) = user_id);

CREATE INDEX health_logs_user_logged_at_idx
ON public.health_logs (user_id, logged_at DESC);
