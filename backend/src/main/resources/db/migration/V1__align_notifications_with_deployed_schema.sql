-- The deployed Render schema retains a legacy identity id and non-null type
-- alongside notification_id, message, and category. The JPA entity uses
-- notification_id as its generated key and message as the content field.
-- The legacy id identity column generates its own value on inserts; only type
-- needs a default for new notifications.
DO $$
BEGIN
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
