-- ===========================================================
-- Obtenir une catégorie par son id 
-- ===========================================================
CREATE OR REPLACE FUNCTION get_category_by_id(p_id INT)
RETURNS category AS $$
DECLARE
    result category;
BEGIN
    SELECT *
    INTO result
    FROM category
    WHERE category_id = p_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;


-- ===========================================================
-- Chercher une catégorie par son nom 
-- ===========================================================
CREATE OR REPLACE FUNCTION search_category(p_name TEXT)
RETURNS SETOF category AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM category
    WHERE name ILIKE '%' || p_name || '%';
END;
$$ LANGUAGE plpgsql;


-- ===========================================================
-- Ajouter une catégorie  
-- ===========================================================
CREATE OR REPLACE FUNCTION add_category(
    p_name VARCHAR,
    p_description TEXT,
    p_slug VARCHAR
)
RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO category (name, description, slug)
    VALUES (p_name, p_description, p_slug)
    RETURNING category_id INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;





-- ===========================================================
-- Mettre à jour une catégorie
-- ===========================================================
CREATE OR REPLACE FUNCTION update_category(
    p_id INT,
    p_name VARCHAR,
    p_description TEXT,
    p_slug VARCHAR
)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE category
    SET name = p_name,
        description = p_description,
        slug = p_slug
    WHERE category_id = p_id;

    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;




-- ===========================================================
-- Supprimer une catégorie 
-- ===========================================================
CREATE OR REPLACE FUNCTION delete_category(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM category
    WHERE category_id = p_id;

    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
