--
-- Sign in count for users of organisation 1
--
SELECT  username, email, sign_in_count, last_sign_in_at
FROM    users
        INNER JOIN organisation_users on users.id = organisation_users.user_id
WHERE   organisation_users.organisation_id = 1
ORDER BY sign_in_count DESC;
