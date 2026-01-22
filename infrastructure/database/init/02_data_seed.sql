-- ===========================================================
-- SCRIPT D'INSERTION DE DONNÉES - POUR TABLES VIDES
-- ===========================================================

-- ===========================================================
-- INSERTION DANS CUSTOMER (1500 clients)
-- ===========================================================
INSERT INTO customer (first_name, last_name, email, phone, address, registration_date) VALUES
('Jean', 'Martin', 'jean.martin@email.com', '0612345678', '12 rue de la Paix, 75001 Paris', '2022-01-15 09:30:00'),
('Marie', 'Dubois', 'marie.dubois@email.com', '0623456789', '25 avenue des Champs, 75008 Paris', '2022-01-20 14:15:00'),
('Pierre', 'Durand', 'pierre.durand@email.com', '0634567890', '8 rue du Commerce, 69001 Lyon', '2022-02-05 11:00:00'),
('Sophie', 'Moreau', 'sophie.moreau@email.com', '0645678901', '15 boulevard Haussmann, 13001 Marseille', '2022-02-10 16:45:00'),
('Thomas', 'Lefebvre', 'thomas.lefebvre@email.com', '0656789012', '42 rue de la République, 31000 Toulouse', '2022-02-28 10:20:00'),
('Laura', 'Garcia', 'laura.garcia@email.com', '0667890123', '7 place Bellecour, 69002 Lyon', '2022-03-12 13:10:00'),
('Nicolas', 'Roux', 'nicolas.roux@email.com', '0678901234', '33 cours Gambetta, 33000 Bordeaux', '2022-03-18 15:30:00'),
('Emma', 'Fournier', 'emma.fournier@email.com', '0689012345', '19 rue Nationale, 59000 Lille', '2022-04-02 09:45:00'),
('Lucas', 'Mercier', 'lucas.mercier@email.com', '0690123456', '5 rue de la Soif, 35000 Rennes', '2022-04-15 17:20:00'),
('Chloé', 'Blanc', 'chloe.blanc@email.com', '0601234567', '28 avenue Foch, 67000 Strasbourg', '2022-05-01 12:00:00');

-- Insertion des 1490 clients restants
DO $$
DECLARE
    i INT;
    first_names TEXT[] := ARRAY['Alice', 'Paul', 'Julie', 'Antoine', 'Sarah', 'Maxime', 'Camille', 'Alexandre', 'Manon', 'Quentin', 'Clara', 'Baptiste', 'Inès', 'Romain', 'Lisa'];
    last_names TEXT[] := ARRAY['Petit', 'Girard', 'Caron', 'Chevalier', 'Renard', 'Bertrand', 'Rousseau', 'Masson', 'Berger', 'Dumont', 'Lemaire', 'Colin', 'Garnier', 'Gauthier', 'Perrot'];
    cities TEXT[] := ARRAY['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Nantes', 'Montpellier', 'Strasbourg', 'Bordeaux', 'Lille'];
BEGIN
    FOR i IN 11..1500 LOOP
        INSERT INTO customer (first_name, last_name, email, phone, address, registration_date)
        VALUES (
            first_names[1 + (i % array_length(first_names, 1))],
            last_names[1 + ((i * 2) % array_length(last_names, 1))],
            'client' || i || '@domain.com',
            '06' || lpad(((10000000 + ((i * 1234567) % 90000000)))::text, 8, '0'),
            (10 + (i % 90)) || ' rue de Test, ' || 
            (10000 + ((i * 47) % 90000)) || ' ' || 
            cities[1 + (i % array_length(cities, 1))],
            NOW() - (random() * 730 || ' days')::interval
        );
    END LOOP;
    
    RAISE NOTICE 'Insertion de % clients terminée', (SELECT COUNT(*) FROM customer);
END $$;

-- ===========================================================
-- INSERTION DANS CATEGORY (15 catégories)
-- ===========================================================
INSERT INTO category (name, description, slug) VALUES
('Électronique', 'Appareils électroniques et gadgets', 'electronique'),
('Informatique', 'Ordinateurs, périphériques et accessoires', 'informatique'),
('Téléphonie', 'Smartphones et accessoires mobiles', 'telephonie'),
('Mode Homme', 'Vêtements et accessoires pour hommes', 'mode-homme'),
('Mode Femme', 'Vêtements et accessoires pour femmes', 'mode-femme'),
('Maison & Jardin', 'Meubles, décoration et jardinage', 'maison-jardin'),
('Beauté & Santé', 'Produits de beauté et de santé', 'beaute-sante'),
('Sports & Loisirs', 'Équipements sportifs et jeux', 'sports-loisirs'),
('Livres & Médias', 'Livres, films et musique', 'livres-medias'),
('Jouets & Enfants', 'Jouets et produits pour enfants', 'jouets-enfants'),
('Alimentation', 'Produits alimentaires et boissons', 'alimentation'),
('Automobile', 'Pièces et accessoires auto', 'automobile'),
('Bricolage', 'Outils et matériaux de construction', 'bricolage'),
('Électroménager', 'Appareils électroménagers', 'electromenager'),
('Bijoux & Montres', 'Bijoux et montres de qualité', 'bijoux-montres');

-- ===========================================================
-- INSERTION DANS PRODUCT (500 produits)
-- ===========================================================
INSERT INTO product (name, description, price, stock, sku, created_at) VALUES
('iPhone 14 Pro', 'Smartphone Apple 256GB', 1259.99, 150, 'IPH14P256', '2023-01-15'),
('Samsung Galaxy S23', 'Smartphone Android 128GB', 899.99, 200, 'SGS23-128', '2023-02-10'),
('MacBook Pro 14"', 'Ordinateur portable Apple M2', 2249.99, 75, 'MBP14-M2', '2023-01-20'),
('Casque Sony WH-1000XM5', 'Casque audio sans fil', 349.99, 300, 'SONY-XM5', '2023-03-05'),
('TV LG OLED 55"', 'Télévision 4K OLED', 1499.99, 100, 'LG-OLED55', '2023-02-28'),
('Canon EOS R6', 'Appareil photo hybride', 2499.99, 50, 'CANON-R6', '2023-03-15'),
('Nike Air Max 270', 'Chaussures de sport', 129.99, 500, 'NIKE-AM270', '2023-01-10'),
('Chemise en coton', 'Chemise homme qualité premium', 59.99, 800, 'CHM-CTN-PRM', '2023-02-01'),
('Robot aspirateur', 'Aspirateur intelligent', 299.99, 150, 'ROBOT-VAC', '2023-03-20'),
('Montre connectée', 'Montre sport avec GPS', 199.99, 400, 'WATCH-GPS', '2023-02-15');

-- Insertion des 490 produits restants
DO $$
DECLARE
    i INT;
    product_names TEXT[] := ARRAY[
        'Laptop Gaming', 'Tablette Android', 'Écouteurs Bluetooth', 'Clavier Mécanique', 
        'Souris Gaming', 'Moniteur 4K', 'Imprimante Laser', 'Disque Dur Externe', 
        'Console de Jeu', 'T-shirt Basique', 'Jean Slim', 'Veste en Cuir', 
        'Robe Été', 'Sac à Main', 'Chaussures de Ville', 'Mixeur Puissant', 
        'Grille-pain', 'Machine à Café', 'Réfrigérateur', 'Lave-linge', 
        'Vélo de Course', 'Raquette Tennis', 'Ballon Football', 'Tente 4 Places', 
        'Sac de Couchage', 'Roman Policier', 'Livre de Cuisine', 'DVD Film', 
        'Peluche Licorne', 'Lego Classic', 'Chocolat Noir', 'Café en Grain', 
        'Huile Olive', 'Pneus Hiver', 'Batterie Auto', 'Kit Outils', 
        'Perceuse Visseuse', 'Peinture Murale', 'Boucles Oreilles', 'Bracelet Argent'
    ];
BEGIN
    FOR i IN 11..500 LOOP
        INSERT INTO product (name, description, price, stock, sku, created_at)
        VALUES (
            product_names[1 + (i % array_length(product_names, 1))] || ' Modèle ' || i,
            'Description détaillée du produit ' || i || ' avec ses caractéristiques principales.',
            round((random() * 1000 + 10)::numeric, 2),
            floor(random() * 1000)::int,
            'SKU-' || lpad(i::text, 6, '0'),
            NOW() - (random() * 180 || ' days')::interval
        );
    END LOOP;
    
    RAISE NOTICE 'Insertion de % produits terminée', (SELECT COUNT(*) FROM product);
END $$;

-- ===========================================================
-- INSERTION DANS PRODUCT_CATEGORY (liaisons produits-catégories)
-- ===========================================================
INSERT INTO product_category (product_id, category_id) VALUES
(1, 3), (1, 2),  -- iPhone dans Téléphonie et Informatique
(2, 3),          -- Samsung dans Téléphonie
(3, 2),          -- MacBook dans Informatique
(4, 1), (4, 2),  -- Casque Sony dans Électronique et Informatique
(5, 1),          -- TV dans Électronique
(6, 1),          -- Appareil photo dans Électronique
(7, 8), (7, 4),  -- Nike dans Sports et Mode Homme
(8, 4),          -- Chemise dans Mode Homme
(9, 6), (9, 14), -- Robot aspirateur dans Maison et Électroménager
(10, 1), (10, 15);-- Montre dans Électronique et Bijoux

-- Liaisons pour les autres produits
DO $$
DECLARE
    p_id INT;
    num_categories INT;
    cat_id INT;
    attempt INT;
BEGIN
    FOR p_id IN 11..500 LOOP
        num_categories := 1 + floor(random() * 3)::int;
        
        FOR i IN 1..num_categories LOOP
            attempt := 0;
            LOOP
                cat_id := 1 + floor(random() * 15)::int;
                
                BEGIN
                    INSERT INTO product_category (product_id, category_id)
                    VALUES (p_id, cat_id);
                    EXIT;
                EXCEPTION WHEN unique_violation THEN
                    attempt := attempt + 1;
                    IF attempt > 10 THEN
                        EXIT;
                    END IF;
                END;
            END LOOP;
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'Insertion de % liaisons produits-catégories terminée', (SELECT COUNT(*) FROM product_category);
END $$;

-- ===========================================================
-- INSERTION DANS ORDER (800 commandes)
-- ===========================================================
INSERT INTO "order" (order_date, status, payment_method, total_amount, customer_id) VALUES
('2023-03-01 10:30:00', 'delivered', 'credit_card', 1259.99, 1),
('2023-03-02 14:20:00', 'shipped', 'paypal', 899.99, 2),
('2023-03-03 11:15:00', 'processing', 'credit_card', 2249.99, 3),
('2023-03-04 16:45:00', 'delivered', 'bank_transfer', 349.99, 4),
('2023-03-05 09:10:00', 'cancelled', 'credit_card', 1499.99, 5),
('2023-03-06 13:30:00', 'delivered', 'paypal', 2499.99, 6),
('2023-03-07 15:20:00', 'shipped', 'credit_card', 129.99, 7),
('2023-03-08 10:00:00', 'processing', 'bank_transfer', 59.99, 8),
('2023-03-09 17:30:00', 'delivered', 'credit_card', 299.99, 9),
('2023-03-10 12:15:00', 'shipped', 'paypal', 199.99, 10);

-- Insertion des 790 commandes restantes
DO $$
DECLARE
    i INT;
    statuses TEXT[] := ARRAY['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    payment_methods TEXT[] := ARRAY['credit_card', 'paypal', 'bank_transfer', 'apple_pay'];
BEGIN
    FOR i IN 11..800 LOOP
        INSERT INTO "order" (order_date, status, payment_method, total_amount, customer_id)
        VALUES (
            NOW() - (random() * 90 || ' days')::interval,
            statuses[1 + floor(random() * 5)::int],
            payment_methods[1 + floor(random() * 4)::int],
            round((random() * 2000 + 20)::numeric, 2),
            1 + floor(random() * 1500)::int
        );
    END LOOP;
    
    RAISE NOTICE 'Insertion de % commandes terminée', (SELECT COUNT(*) FROM "order");
END $$;

-- ===========================================================
-- INSERTION DANS CONTAIN (2000 lignes de commande)
-- ===========================================================
INSERT INTO contain (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1259.99),
(2, 2, 1, 899.99),
(3, 3, 1, 2249.99),
(4, 4, 1, 349.99),
(5, 5, 1, 1499.99),
(6, 6, 1, 2499.99),
(7, 7, 2, 129.99),
(8, 8, 1, 59.99),
(9, 9, 1, 299.99),
(10, 10, 1, 199.99);

-- Générer 1990 lignes supplémentaires
DO $$
DECLARE
    target_count INT := 2000;
    current_count INT;
    order_id_val INT;
    product_id_val INT;
    max_attempts INT := 10000;
    attempts INT := 0;
    product_price NUMERIC(10,2);
BEGIN
    LOOP
        SELECT COUNT(*) INTO current_count FROM contain;
        EXIT WHEN current_count >= target_count OR attempts >= max_attempts;
        
        order_id_val := 1 + floor(random() * 800)::int;
        product_id_val := 1 + floor(random() * 500)::int;
        
        -- Récupérer le prix du produit
        SELECT price INTO product_price FROM product WHERE product_id = product_id_val;
        
        IF product_price IS NOT NULL THEN
            BEGIN
                INSERT INTO contain (order_id, product_id, quantity, unit_price)
                VALUES (
                    order_id_val,
                    product_id_val,
                    1 + floor(random() * 5)::int,
                    product_price
                );
            EXCEPTION WHEN unique_violation THEN
                -- Ignorer les doublons et continuer
            WHEN foreign_key_violation THEN
                -- Ignorer si l'order_id n'existe pas
            END;
        END IF;
        
        attempts := attempts + 1;
    END LOOP;
    
    RAISE NOTICE 'Insertion de % lignes de commande terminée', current_count;
END $$;

-- Mise à jour du total_amount basé sur les vraies données
DO $$
BEGIN
    UPDATE "order" o
    SET total_amount = COALESCE((
        SELECT SUM(c.quantity * c.unit_price)
        FROM contain c
        WHERE c.order_id = o.order_id
    ), 0);
    
    RAISE NOTICE 'Mise à jour des montants totaux terminée';
END $$;

-- ===========================================================
-- VÉRIFICATION FINALE
-- ===========================================================
DO $$
DECLARE
    customer_count INT;
    category_count INT;
    product_count INT;
    order_count INT;
    contain_count INT;
    product_category_count INT;
BEGIN
    SELECT COUNT(*) INTO customer_count FROM customer;
    SELECT COUNT(*) INTO category_count FROM category;
    SELECT COUNT(*) INTO product_count FROM product;
    SELECT COUNT(*) INTO order_count FROM "order";
    SELECT COUNT(*) INTO contain_count FROM contain;
    SELECT COUNT(*) INTO product_category_count FROM product_category;
    
    RAISE NOTICE '========================================';
    RAISE NOTICE '  RÉSUMÉ DES DONNÉES INSÉRÉES';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Clients:                      %', customer_count;
    RAISE NOTICE 'Catégories:                   %', category_count;
    RAISE NOTICE 'Produits:                     %', product_count;
    RAISE NOTICE 'Commandes:                    %', order_count;
    RAISE NOTICE 'Lignes de commande:           %', contain_count;
    RAISE NOTICE 'Liaisons produits-catégories: %', product_category_count;
    RAISE NOTICE '========================================';
    RAISE NOTICE 'TOTAL:                        %', customer_count + category_count + product_count + order_count + contain_count + product_category_count;
    RAISE NOTICE '========================================';
    
    -- Vérifications d'intégrité
    IF customer_count < 1500 THEN
        RAISE WARNING 'Attention: Seulement % clients insérés (attendu: 1500)', customer_count;
    END IF;
    
    IF product_count < 500 THEN
        RAISE WARNING 'Attention: Seulement % produits insérés (attendu: 500)', product_count;
    END IF;
    
    IF order_count < 800 THEN
        RAISE WARNING 'Attention: Seulement % commandes insérées (attendu: 800)', order_count;
    END IF;
    
    IF contain_count < 2000 THEN
        RAISE WARNING 'Attention: Seulement % lignes de commande insérées (attendu: 2000)', contain_count;
    END IF;
END $$;