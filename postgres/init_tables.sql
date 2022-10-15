

-- CREATE TABLE if not exists users(
--     id serial primary key,
--     user_id bigint,
--     UNIQUE(user_id)
-- );


-- CREATE TABLE if not exists states(
--     user_id bigint,
--     state_dump bytea,
--     UNIQUE(user_id),

--     FOREIGN KEY(user_id) 
--         REFERENCES users(user_id)
-- );

--     is_removed BOOLEAN DEFAULT false
--     admin_id bigint NOT NULL,
--     user_credential_id bigint NOT NULL,

--     UNIQUE(admin_id, controller_id),

--     FOREIGN KEY(admin_id) 
-- 	  REFERENCES admins(admin_id),
    
--     FOREIGN KEY(user_credential_id) 
-- 	  REFERENCES user_credentials(user_credential_id)
-- );
