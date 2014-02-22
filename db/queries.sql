--
-- Sign in count for users of organisation 1
--
SELECT  username, email, sign_in_count, last_sign_in_at
FROM    users
        INNER JOIN organisation_users on users.id = organisation_users.user_id
WHERE   organisation_users.organisation_id = 1
ORDER BY sign_in_count DESC;


--
-- Create organisation
--
INSERT INTO organisations (name, description, website, created_at, updated_at)
VALUES      ('', '', '', now(), now());


--
-- Add admin to the organisation
--
INSERT INTO organisation_users (organisation_id, user_id, admin, created_at, updated_at)
VALUES      (x, 1, 1, now(), now())