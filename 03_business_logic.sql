USE OFML_ProductDB;
GO

-- Stworzenie okna 
CREATE OR ALTER VIEW katalogmebli AS
SELECT 
    p.product_id AS Kod_Produktu,
    p.product_name AS Nazwa_Mebla,
    p.base_price AS Cena_Bazowa,
    f.features_name AS Nazwa_Cechy,
    o.option_name AS Wariant_Wyboru,
    o.sku_code AS Kod_SKU,
    o.price_delta AS Doplata,
    (p.base_price + o.price_delta) AS Cena_Z_Wariantem
FROM Products p  
INNER JOIN Product_Features f ON p.product_id = f.product_id 
INNER JOIN Feature_options o ON f.features_id = o.features_id;
GO

SELECT * FROM katalogmebli WHERE Kod_Produktu = 'SAHARA';

-- Szukanie pustych cech
SELECT p.product_name as mebel, f.features_name as pusta_cecha
FROM Product_Features f  
LEFT JOIN Products p ON f.product_id = p.product_id
LEFT JOIN Feature_options o ON f.features_id = o.features_id
WHERE o.option_id IS NULL;
GO

-- Szukanie mebli które nie są aktywne
SELECT p.product_id as kod_produktu, p.product_name as mebel, p.is_active as status_aktywności
FROM Products p  
WHERE p.is_active = 0;

-- Tłumaczenie braku kompatybilności dwóch cech
SELECT
    r.reason as problem, 
    opt1.option_name as opcja_pierwsza,
    opt2.option_name as opcja_druga
FROM Incompatibility_Rules r
INNER JOIN Feature_options opt1 ON r.option_id_1 = opt1.option_id -- żeby wyświetliła się nazwa cechy,
INNER JOIN Feature_options opt2 ON r.option_id_2 = opt2.option_id; -- a nie jej kod
GO