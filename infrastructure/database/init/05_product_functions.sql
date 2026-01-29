
-- ===========================================================
-- Obtenir un produit par son id 
-- ===========================================================
CREATE OR REPLACE FUNCTION get_product_by_id(p_id INT)
RETURNS product AS $$
DECLARE
    result product;
BEGIN
    SELECT *
    INTO result
    FROM product
    WHERE product_id = p_id;   

    RETURN result;
END;
$$ LANGUAGE plpgsql;


-- ===========================================================
-- Chercher un produit par son nom (et optionnellement categorie)
-- ===========================================================
CREATE OR REPLACE FUNCTION search_product(p_name TEXT, p_category_id INT DEFAULT NULL)
RETURNS SETOF product AS $$
BEGIN
    RETURN QUERY
    SELECT p.*
    FROM product p
    LEFT JOIN product_category pc ON p.product_id = pc.product_id
    WHERE p.name ILIKE '%' || p_name || '%'
    AND (p_category_id IS NULL OR pc.category_id = p_category_id);
END;
$$ LANGUAGE plpgsql;


-- ===========================================================
-- Ajouter un produit 
-- ===========================================================
CREATE OR REPLACE FUNCTION add_product(
    p_name VARCHAR,
    p_description TEXT,
    p_price NUMERIC,
    p_stock INT,
    p_sku VARCHAR
)
RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO product (name, description, price, stock, sku)
    VALUES (p_name, p_description, p_price, p_stock, p_sku)
    RETURNING product_id INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;



-- ===========================================================
-- Mettre à jour un produit  
-- ===========================================================
CREATE OR REPLACE FUNCTION update_product(
    p_id INT,
    p_name VARCHAR,
    p_description TEXT,
    p_price NUMERIC,
    p_stock INT,
    p_sku VARCHAR
)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE product
    SET name = p_name,
        description = p_description,
        price = p_price,
        stock = p_stock,
        sku = p_sku
    WHERE product_id = p_id;

    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;



-- ===========================================================
-- Supprimer un produit 
-- ===========================================================
CREATE OR REPLACE FUNCTION delete_product(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    DELETE FROM product
    WHERE product_id = p_id;

    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;



