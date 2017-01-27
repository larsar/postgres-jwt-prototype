CREATE ROLE app LOGIN;
CREATE ROLE limited; -- Group
GRANT limited TO app; -- Add app user to group

GRANT USAGE ON SCHEMA sensitive TO limited;
GRANT EXECUTE ON FUNCTION sensitive.get_data(TEXT) TO limited;

INSERT INTO sensitive.token_secret (shared_secret) VALUES ('sharedSecretBetweenIdpAndPostgres');
INSERT INTO sensitive.data (org_no, secret) VALUES ('1234', 'Secret information');
