# OFML Relational Product Configurator Engine

Relacyjny model danych dla branży mebli biurowych, wzorowany na architekturze standardu **OFML (Office Furniture Modeling Language)** oraz ekosystemu **pCon**.

---

## 1. Cel projektu

Celem projektu jest zamodelowanie warstwy pośredniej w relacyjnej bazie danych **MS SQL Server**, która:

1. Odzwierciedla logikę komercyjną i parametryczną mebli przed ich kompilacją do struktur OFML i aplikacji graficznych (pCon.planner).
2. Wymusza integralność danych referencyjnych na poziomie relacji bazodanowych.
3. Implementuje mechanizm reguł wykluczeń technologicznych, zapobiegając zamawianiu niewykonalnych produkcyjnie wariantów.

---

## 2. Architektura środowiska

* **Silnik bazodanowy:** Microsoft SQL Server (MS SQL Server Express)
* **Środowisko deweloperskie:** Visual Studio Code
* **Warstwa wejściowa:** Zestawienia produktowe w arkuszach Excel eksportowane do standaryzowanych plików `CSV (UTF-8)`.
* **Analiza wymagań dziedzinowych:** pCon.planner (analiza modeli parametrycznych 3D/OFML pod kątem struktury atrybutów, logiki zamiany geometrii oraz generowania zestawień materiałowych BOM)

---

## 3. Model danych 

Baza `OFML_ProductDB` składa się z 4 powiązanych encji:

### 1. `Products` (Artykuł bazowy)
Reprezentuje główną rodzinę produktową.
* `product_id` (PK) – unikalny kod bazowy artykułu.
* `product_name` – pełna nazwa handlowa.
* `base_price` – cena bazowa konstrukcji.
* `is_active` – dostępność w ofercie handlowej.

### 2. `Product_Features` (Cechy / Wymiary konfiguracji)
Definiuje obszary podlegające modyfikacji w ramach danego produktu.
* `feature_id` (PK) – identyfikator cechy.
* `product_id` (FK) – powiązanie z produktem bazowym.
* `feature_name` – nazwa cechy.
* `is_mandatory` – flaga określająca, czy cecha wymaga dokonania wyboru.

### 3. `Feature_Options` (Warianty i dopłaty)
Zawiera dopuszczalne opcje dla każdej cechy wraz z ich atrybutami handlowymi.
* `option_id` (PK) – jednoznaczny identyfikator wariantu.
* `feature_id` (FK) – przypisanie do określonej cechy produktu.
* `option_name` – opis techniczno-handlowy wariantu.
* `sku_code` – segment kodu dopisywany dynamicznie do bazowego numeru katalogowego.
* `price_delta` – wartość dopłaty do ceny bazowej.

### 4. `Incompatibility_Rules` (Matryca wykluczeń technologicznych)
Tabela asocjacyjna implementująca logikę ograniczeń produkcyjnych mebla.
* `option_id_1` (FK), `option_id_2` (FK) – para opcji, które nie mogą ze sobą współistnieć w jednej konfiguracji.
* `reason` – powód braku kompatybilności.
* **Integralność:** Zastosowano złożony klucz główny oraz więz, co eliminuje dublowanie reguł symetrycznych `(A, B)` i `(B, A)`.

---

## 4. Struktura repozytorium

```text
├── dane/
│   ├── Produkty.csv          # Kartoteka artykułów bazowych
│   ├── Cechy.csv             # Cechy konfiguracyjne
│   ├── Opcje.csv             # Dopuszczalne warianty i dopłaty
│   └── Wykluczenia.csv       # Tabela reguł kolizyjnych
├── 01_schema.sql             # Skrypt tworzący bazę i tabele relacyjne
├── 02_import_csv.sql         # Import danych
├── 03_business_logic.sql     # Widoki biznesowe, audyty spójności danych i reguły OFML
└── README.md                 # Dokumentacja techniczna projektu

---