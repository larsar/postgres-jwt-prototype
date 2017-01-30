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
  _shared_secret TEXT := (SELECT shared_secret
                          FROM sensitive.token_secret
                          LIMIT 1);

BEGIN
  WITH verifiedToken AS (SELECT *
                         FROM jwt.verify(token, _shared_secret)),
      verified_org_no AS ( SELECT payload ->> 'orgNo'
                           FROM verifiedToken
                           WHERE VALID IS TRUE )
  SELECT d.secret
  FROM sensitive.data d
  WHERE org_no = (SELECT *
                  FROM verified_org_no) AND org_no IS NOT NULL
  INTO secret;

END;
$$;