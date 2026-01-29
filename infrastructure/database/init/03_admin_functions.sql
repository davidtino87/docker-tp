-- Function to add a new admin
CREATE OR REPLACE FUNCTION add_admin(p_email TEXT, p_password_hash TEXT)
RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO "admin" (email, password_hash)
    VALUES (p_email, p_password_hash)
    RETURNING admin_id INTO new_id;
    
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Function to get admin by email
CREATE OR REPLACE FUNCTION get_admin_by_email(p_email TEXT)
RETURNS TABLE(admin_id INT, email VARCHAR, password_hash TEXT, created_at TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT a.admin_id, a.email, a.password_hash, a.created_at
    FROM "admin" a
    WHERE a.email = p_email;
END;
$$ LANGUAGE plpgsql;
