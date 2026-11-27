-- The deployed Render schema retains a legacy non-null id and type alongside
-- notification_id, message, and category. The JPA entity uses notification_id
-- as its generated key and message as the content field.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'notifications'
          AND column_name = 'id'
          AND is_nullable = 'NO'
    ) AND NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON kcu.constraint_catalog = tc.constraint_catalog
         AND kcu.constraint_schema = tc.constraint_schema
         AND kcu.constraint_name = tc.constraint_name
        WHERE tc.table_schema = 'public'
          AND tc.table_name = 'notifications'
          AND tc.constraint_type = 'PRIMARY KEY'
          AND kcu.column_name = 'id'
    ) THEN
        ALTER TABLE public.notifications ALTER COLUMN id DROP NOT NULL;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = 'notifications'
          AND column_name = 'type'
    ) THEN
        ALTER TABLE public.notifications
            ALTER COLUMN type SET DEFAULT 'GENERAL';
    END IF;
END
$$;
