
-- ===========================================================
-- Trigger de log sur INSERT / UPDATE de la table Product 
-- ===========================================================

CREATE OR REPLACE FUNCTION log_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO product_log (product_id, action, new_data)
        VALUES (
            NEW.product_id,
            'INSERT',
            row_to_json(NEW)::TEXT
        );

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO product_log (product_id, action, old_data, new_data)
        VALUES (
            NEW.product_id,
            'UPDATE',
            row_to_json(OLD)::TEXT,
            row_to_json(NEW)::TEXT
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_product_log
AFTER INSERT OR UPDATE
ON product
FOR EACH ROW
EXECUTE FUNCTION log_product_changes();


-- ===========================================================
-- Trigger de validation / transformation de la table Product 
-- ===========================================================
CREATE OR REPLACE FUNCTION validate_product()
RETURNS TRIGGER AS $$
BEGIN
    -- Validation
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'Le prix ne peut pas être négatif';
    END IF;

    -- Transformation
    NEW.name := INITCAP(TRIM(NEW.name));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_product_validate
BEFORE INSERT OR UPDATE
ON product
FOR EACH ROW
EXECUTE FUNCTION validate_product();

