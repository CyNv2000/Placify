-- Keep displayed status labels consistent with the dates already stored.
UPDATE public.internships
SET status = 'CLOSED'
WHERE deadline < CURRENT_DATE
  AND UPPER(status) IN ('ACTIVE', 'OPEN', 'OPEN FOR APPLICATIONS');

UPDATE public.sessions
SET status = 'COMPLETED'
WHERE session_datetime < CURRENT_TIMESTAMP
  AND UPPER(status) IN ('SCHEDULED', 'UPCOMING');
