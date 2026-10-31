USE OFML_ProductDB;
GO

DELETE FROM Incompatibility_Rules;
DELETE FROM Feature_options;
DELETE FROM Product_Features;
DELETE FROM Products;
GO

BULK INSERT Products
FROM 'C:\Users\Kuba0\Desktop\Projekty\OFML_Product\Produkty.csv'
WITH (
    FIRSTROW = 2,               -- pomijamy wiersz z nagłówkami
    FIELDTERMINATOR = ';',      -- polski Excel rozdziela kolumny średnikiem
    ROWTERMINATOR = '\n',       -- koniec wiersza
    CODEPAGE = '65001'          -- kodowanie UTF-8 (dla polskich znaków)
);
GO

BULK INSERT Product_Features
FROM 'C:\Users\Kuba0\Desktop\Projekty\OFML_Product\Cechy.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ';',      
    ROWTERMINATOR = '\n',       
    CODEPAGE = '65001'      
);    
GO

BULK INSERT Feature_options
FROM 'C:\Users\Kuba0\Desktop\Projekty\OFML_Product\Opcje.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ';',      
    ROWTERMINATOR = '\n',      
    CODEPAGE = '65001'         
);
GO

BULK INSERT Incompatibility_Rules
FROM 'C:\Users\Kuba0\Desktop\Projekty\OFML_Product\Wykluczenia.csv'
WITH (
    FIRSTROW = 2,            
    FIELDTERMINATOR = ';',   
    ROWTERMINATOR = '\n',      
    CODEPAGE = '65001'        
);
GO