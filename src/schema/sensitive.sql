CREATE SCHEMA sensitive;
CREATE TABLE sensitive.data (
  org_no TEXT PRIMARY KEY,
  secret TEXT NOT NULL
);

CREATE TABLE sensitive.token_secret (
  shared_secret TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION sensitive.get_data(token TEXT, OUT secret TEXT)
  RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  sharedSecret TEXT := (SELECT shared_secret
                        FROM sensitive.token_secret
                        LIMIT 1);

BEGIN
  -- Validate token
  -- Extract org_no
  -- Run select

  SELECT d.secret
  FROM sensitive.data d
  WHERE org_no = _org_no
  INTO secret;
END;
$$;