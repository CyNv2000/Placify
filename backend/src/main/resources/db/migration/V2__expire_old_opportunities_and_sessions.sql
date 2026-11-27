-- Keep displayed status labels consistent with the dates already stored.
DO $$
BEGIN
    IF to_regclass('public.internships') IS NOT NULL THEN
        UPDATE public.internships
        SET status = 'CLOSED'
        WHERE deadline < CURRENT_DATE
          AND UPPER(status) IN ('ACTIVE', 'OPEN', 'OPEN FOR APPLICATIONS');
    END IF;

    IF to_regclass('public.sessions') IS NOT NULL THEN
        UPDATE public.sessions
        SET status = 'COMPLETED'
        WHERE session_datetime < CURRENT_TIMESTAMP
          AND UPPER(status) IN ('SCHEDULED', 'UPCOMING');
    END IF;
END
$$;
