-- Création de la base Customer 360

IF DB_ID('Customer360_DB') IS NULL
BEGIN
    CREATE DATABASE Customer360_DB;
END;
GO

-- Sélectionner la base de données
USE Customer360_DB;
GO

-- Vérifier la création
SELECT
    name AS Nom_Base_Donnees,
    state_desc AS Statut
FROM sys.databases
WHERE name = 'Customer360_DB';

-- CRÉATION DES TABLES CUSTOMER 360

-- 1. TABLE DES GOLDEN RECORDS

CREATE TABLE dbo.Golden_Records (

    golden_record_id NVARCHAR(50) NOT NULL PRIMARY KEY,
    crm_customer_id NVARCHAR(50),
    prenom NVARCHAR(100),
    nom NVARCHAR(100),
    email NVARCHAR(255),
    phone NVARCHAR(30),
    address NVARCHAR(255),
    city NVARCHAR(100),
    province NVARCHAR(100),
    postal_code NVARCHAR(20),
    date_creation DATE,

    prenom_normalise NVARCHAR(100),
    nom_normalise NVARCHAR(100),
    email_normalise NVARCHAR(255),
    phone_normalise NVARCHAR(30),

    email_valide BIT,
    phone_valide BIT,
    postal_code_normalise NVARCHAR(20),
    postal_code_valide BIT,

    email_corrige NVARCHAR(255),
    email_corrige_valide BIT,
    doublon_tres_fort BIT,

    score_qualite INT,
    date_creation_fiable DATE,
    rang_fiche INT,
    candidate_principale BIT,
    score_max_groupe INT,
    score_maximal BIT,

    crm_id_principal NVARCHAR(50),
    type_fiche NVARCHAR(30),
    statut_consolidation NVARCHAR(100),

    verification_requise BIT,
    statut_validation NVARCHAR(100)

);
GO

-- 2. TABLE DES CORRESPONDANCES CRM

CREATE TABLE dbo.Correspondances_CRM (

    crm_customer_id NVARCHAR(50) NOT NULL PRIMARY KEY,
    golden_record_id NVARCHAR(50) NOT NULL,
    type_fiche NVARCHAR(30),
    score_qualite INT,

    CONSTRAINT FK_Correspondances_Golden
    FOREIGN KEY (golden_record_id)
    REFERENCES dbo.Golden_Records(golden_record_id)

);
GO

-- 3. TABLE DU BILAN DE DÉDOUBLONNAGE

CREATE TABLE dbo.Bilan_Dedoublonnage (

    Indicateur NVARCHAR(255) NOT NULL PRIMARY KEY,
    Valeur FLOAT

);
GO

-- 4. VÉRIFIER LA CRÉATION DES TABLES

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Identifier le serveur et la base de données

SELECT
    @@SERVERNAME AS Nom_Serveur,
    DB_NAME() AS Base_Donnees;

    -- ANALYSE DES FICHES CRM

-- Analyser la répartition des fiches CRM

SELECT
    type_fiche AS Type_Fiche,
    COUNT(*) AS Nombre_Fiches,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS Pourcentage

FROM dbo.Correspondances_CRM

GROUP BY type_fiche

ORDER BY Nombre_Fiches DESC;
GO

-- INDICATEURS DE PERFORMANCE CRM

-- Calcul des principaux KPI du dédoublonnage

SELECT
    -- Nombre total de fiches CRM
    (SELECT COUNT(*)
     FROM dbo.Correspondances_CRM)
     AS Total_Fiches_CRM,

    -- Nombre de Golden Records
    (SELECT COUNT(*)
     FROM dbo.Golden_Records)
     AS Total_Golden_Records,

    -- Nombre de fiches secondaires
    (SELECT COUNT(*)
     FROM dbo.Correspondances_CRM
     WHERE type_fiche = 'Secondaire')
     AS Fiches_Secondaires,

    -- Taux de réduction des fiches redondantes
    CAST(
        100.0 *
        (
            (SELECT COUNT(*)
             FROM dbo.Correspondances_CRM)
            -
            (SELECT COUNT(*)
             FROM dbo.Golden_Records)
        )
        /
        NULLIF(
            (SELECT COUNT(*)
             FROM dbo.Correspondances_CRM), 0
        )
        AS DECIMAL(5,2)
    ) AS Taux_Reduction_Pct,

    -- Taux de Golden Records sans anomalie détectée
    CAST(
        100.0 *
        (
            SELECT COUNT(*)
            FROM dbo.Golden_Records
            WHERE statut_validation = N'Sans anomalie détectée'
        )
        /
        NULLIF(
            (SELECT COUNT(*)
             FROM dbo.Golden_Records), 0
        )
        AS DECIMAL(5,2)
    ) AS Taux_Sans_Anomalie_Pct;

-- ANALYSE DES SCORES DE QUALITÉ

-- Calcul des indicateurs de qualité

SELECT
    COUNT(*) AS Total_Golden_Records,

    CAST(
        AVG(CAST(score_qualite AS FLOAT))
        AS DECIMAL(5,2)
    ) AS Score_Moyen,

    MIN(score_qualite) AS Score_Minimum,

    MAX(score_qualite) AS Score_Maximum,

    SUM(
        CASE
            WHEN score_qualite < 90 THEN 1
            ELSE 0
        END
    ) AS Scores_Inferieurs_90,

    SUM(
        CASE
            WHEN verification_requise = 1 THEN 1
            ELSE 0
        END
    ) AS Fiches_A_Verifier

FROM dbo.Golden_Records;
GO

-- RÉPARTITION GÉOGRAPHIQUE DES CLIENTS

-- Analyser les clients par province et par ville

SELECT
    province AS Province,
    city AS Ville,

    -- Nombre de clients consolidés
    COUNT(*) AS Nombre_Clients,

    -- Pourcentage des clients par ville
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS Pourcentage_Clients

FROM dbo.Golden_Records

GROUP BY
    province,
    city

ORDER BY
    Nombre_Clients DESC,
    Province,
    Ville;
    GO

-- CONTRÔLE DES NOMS DES VILLES

SELECT
    city AS Ville,
    COUNT(*) AS Nombre_Clients

FROM dbo.Golden_Records

GROUP BY
    city

ORDER BY
    city;
GO

-- NORMALISATION DES NOMS DES VILLES

-- Ajouter une colonne pour les villes normalisées

IF COL_LENGTH('dbo.Golden_Records', 'ville_normalisee') IS NULL
BEGIN
    ALTER TABLE dbo.Golden_Records
    ADD ville_normalisee NVARCHAR(100) NULL;
END;
GO

-- Normaliser les noms des villes
-- Sans modifier la colonne originale city

UPDATE dbo.Golden_Records

SET ville_normalisee =
    CASE
        WHEN city IN (N'Levis', N'Lévis')
            THEN N'Lévis'

        WHEN city IN (N'Montreal', N'Montréal')
            THEN N'Montréal'

        WHEN city IN (N'Quebec', N'Québec')
            THEN N'Québec'

        WHEN city IN (N'Trois-Rivieres', N'Trois-Rivières')
            THEN N'Trois-Rivières'

        ELSE city
    END;
GO

-- Vérifier la répartition après normalisation

SELECT
    ville_normalisee AS Ville,
    COUNT(*) AS Nombre_Clients,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS Pourcentage_Clients

FROM dbo.Golden_Records

GROUP BY ville_normalisee

ORDER BY Nombre_Clients DESC;
GO

-- ANALYSE DE LA QUALITÉ DES DONNÉES PAR VILLE

SELECT
    ville_normalisee AS Ville,

    -- Nombre de clients
    COUNT(*) AS Nombre_Clients,

    -- Score moyen de qualité
    CAST(
        AVG(CAST(score_qualite AS FLOAT))
        AS DECIMAL(5,2)
    ) AS Score_Moyen,

    -- Nombre de fiches avec un score inférieur à 90
    SUM(
        CASE
            WHEN score_qualite < 90 THEN 1
            ELSE 0
        END
    ) AS Scores_Inferieurs_90,

    -- Nombre de fiches nécessitant une vérification
    SUM(
        CASE
            WHEN verification_requise = 1 THEN 1
            ELSE 0
        END
    ) AS Fiches_A_Verifier

FROM dbo.Golden_Records

GROUP BY ville_normalisee

ORDER BY Score_Moyen ASC;
GO

-- ANALYSE DES FICHES DE QUALITÉ INFÉRIEURE

SELECT
    golden_record_id AS Identifiant_Client,

    prenom AS Prenom,

    nom AS Nom,

    ville_normalisee AS Ville,

    score_qualite AS Score_Qualite,

    date_creation AS Date_Creation,

    date_creation_fiable AS Date_Fiable,

    verification_requise AS Verification_Requise,

    statut_validation AS Statut_Validation

FROM dbo.Golden_Records

WHERE
    score_qualite < 90
    OR verification_requise = 1

ORDER BY
    score_qualite ASC,
    ville_normalisee ASC;

GO

-- ANALYSE DES CAUSES DES SCORES FAIBLES

SELECT
    golden_record_id AS Identifiant_Client,

    prenom AS Prenom,

    nom AS Nom,

    ville_normalisee AS Ville,

    score_qualite AS Score_Qualite,

    -- Vérifier la qualité des courriels
    email_valide AS Email_Valide,

    email_corrige_valide AS Email_Corrige_Valide,

    -- Vérifier la qualité des téléphones
    phone_valide AS Telephone_Valide,

    -- Vérifier la qualité des codes postaux
    postal_code_valide AS Code_Postal_Valide,

    -- Vérifier les doublons
    doublon_tres_fort AS Doublon_Tres_Fort,

    -- Vérifier les dates
    date_creation_fiable AS Date_Fiable,

    -- Vérifier le statut
    verification_requise AS Verification_Requise,

    statut_validation AS Statut_Validation

FROM dbo.Golden_Records

WHERE score_qualite < 90

ORDER BY
    score_qualite ASC,
    ville_normalisee ASC;

GO


-- SYNTHÈSE DES ANOMALIES DE QUALITÉ

SELECT
    COUNT(*) AS Total_Golden_Records,

    SUM(
        CASE
            WHEN score_qualite < 90 THEN 1
            ELSE 0
        END
    ) AS Scores_Inferieurs_90,

    SUM(
        CASE
            WHEN postal_code_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Codes_Postaux_Invalides,

    SUM(
        CASE
            WHEN email_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Emails_Invalides,

    SUM(
        CASE
            WHEN phone_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Telephones_Invalides,

    SUM(
        CASE
            WHEN date_creation_fiable IS NULL THEN 1
            ELSE 0
        END
    ) AS Dates_Non_Fiables,

    SUM(
        CASE
            WHEN verification_requise = 1 THEN 1
            ELSE 0
        END
    ) AS Fiches_A_Verifier

FROM dbo.Golden_Records;

GO


-- CONTRÔLE DES COURRIELS CORRIGÉS

SELECT
    COUNT(*) AS Total_Golden_Records,

    -- Courriels initialement invalides
    SUM(
        CASE
            WHEN email_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Emails_Initialement_Invalides,

    -- Courriels initialement invalides devenus valides
    SUM(
        CASE
            WHEN email_valide = 0
             AND email_corrige_valide = 1
            THEN 1
            ELSE 0
        END
    ) AS Emails_Corriges_Valides,

    -- Courriels toujours invalides
    SUM(
        CASE
            WHEN email_corrige_valide = 0
            THEN 1
            ELSE 0
        END
    ) AS Emails_Toujours_Invalides

FROM dbo.Golden_Records;

GO

-- ANALYSE DES CODES POSTAUX INVALIDES

-- Identifier les codes postaux invalides

SELECT
    golden_record_id AS Identifiant_Client,
    prenom AS Prenom,
    nom AS Nom,
    city AS Ville,
    province AS Province,
    postal_code AS Code_Postal_Initial,
    postal_code_normalise AS Code_Postal_Normalise,
    postal_code_valide AS Code_Postal_Valide,
    score_qualite AS Score_Qualite,
    statut_validation AS Statut_Validation

FROM dbo.Golden_Records

WHERE postal_code_valide = 0

ORDER BY city, nom, prenom;

GO

-- SYNTHÈSE DES ANOMALIES CRM

SELECT
    COUNT(*) AS Total_Golden_Records,

    -- Codes postaux invalides
    SUM(
        CASE
            WHEN postal_code_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Codes_Postaux_Invalides,

    -- Courriels invalides après correction
    SUM(
        CASE
            WHEN email_corrige_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Emails_Invalides,

    -- Téléphones invalides
    SUM(
        CASE
            WHEN phone_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Telephones_Invalides,

    -- Dates non fiables
    SUM(
        CASE
            WHEN date_creation_fiable IS NULL THEN 1
            ELSE 0
        END
    ) AS Dates_Non_Fiables,

    -- Scores de qualité inférieurs à 90
    SUM(
        CASE
            WHEN score_qualite < 90 THEN 1
            ELSE 0
        END
    ) AS Scores_Inferieurs_90,

    -- Fiches nécessitant une vérification
    SUM(
        CASE
            WHEN verification_requise = 1 THEN 1
            ELSE 0
        END
    ) AS Fiches_A_Verifier

FROM dbo.Golden_Records;

GO

-- CRÉATION DE LA VUE CUSTOMER 360

CREATE OR ALTER VIEW dbo.vw_Customer360_Clients
AS

SELECT
    -- Identification du client
    golden_record_id AS Identifiant_Client,
    prenom_normalise AS Prenom,
    nom_normalise AS Nom,

    -- Localisation
    province AS Province,
    city AS Ville,
    postal_code_normalise AS Code_Postal,

    -- Coordonnées
    email_corrige AS Email,
    phone_normalise AS Telephone,

    -- Qualité des données
    score_qualite AS Score_Qualite,
    email_corrige_valide AS Email_Valide,
    phone_valide AS Telephone_Valide,
    postal_code_valide AS Code_Postal_Valide,

    -- Dates
    date_creation AS Date_Creation,
    date_creation_fiable AS Date_Creation_Fiable,

    -- Validation
    verification_requise AS Verification_Requise,
    statut_validation AS Statut_Validation

FROM dbo.Golden_Records;

GO

-- Vérifier la vue créée
SELECT COUNT(*) AS Nombre_Clients
FROM dbo.vw_Customer360_Clients;

GO

-- Afficher les premiers enregistrements
SELECT TOP 10 *
FROM dbo.vw_Customer360_Clients;

GO

-- NORMALISATION DES VILLES

CREATE OR ALTER VIEW dbo.vw_Customer360_Clients
AS

SELECT
    -- Identification du client
    golden_record_id AS Identifiant_Client,
    prenom_normalise AS Prenom,
    nom_normalise AS Nom,

    -- Localisation
    province AS Province,
    city AS Ville_Originale,

    CASE
        WHEN UPPER(LTRIM(RTRIM(city))) IN
            (N'QUEBEC', N'QUÉBEC')
            THEN N'Québec'

        WHEN UPPER(LTRIM(RTRIM(city))) IN
            (N'LEVIS', N'LÉVIS')
            THEN N'Lévis'

        WHEN UPPER(LTRIM(RTRIM(city))) IN
            (N'MONTREAL', N'MONTRÉAL')
            THEN N'Montréal'

        WHEN UPPER(LTRIM(RTRIM(city))) IN
            (N'TROIS-RIVIERES', N'TROIS-RIVIÈRES')
            THEN N'Trois-Rivières'

        ELSE LTRIM(RTRIM(city))
    END AS Ville,

    postal_code_normalise AS Code_Postal,

    -- Coordonnées
    email_corrige AS Email,
    phone_normalise AS Telephone,

    -- Qualité des données
    score_qualite AS Score_Qualite,
    email_corrige_valide AS Email_Valide,
    phone_valide AS Telephone_Valide,
    postal_code_valide AS Code_Postal_Valide,

    -- Dates
    date_creation AS Date_Creation,
    date_creation_fiable AS Date_Creation_Fiable,

    -- Validation
    verification_requise AS Verification_Requise,
    statut_validation AS Statut_Validation

FROM dbo.Golden_Records;

GO

-- Vérifier les villes normalisées

SELECT
    Province,
    Ville,
    COUNT(*) AS Nombre_Clients

FROM dbo.vw_Customer360_Clients

GROUP BY
    Province,
    Ville

ORDER BY Nombre_Clients DESC;

GO

-- VUE DES INDICATEURS DE QUALITÉ CRM

CREATE OR ALTER VIEW dbo.vw_Customer360_Qualite
AS

SELECT
    COUNT(*) AS Total_Golden_Records,

    CAST(
        AVG(CAST(score_qualite AS FLOAT))
        AS DECIMAL(5,2)
    ) AS Score_Moyen,

    SUM(
        CASE
            WHEN postal_code_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Codes_Postaux_Invalides,

    SUM(
        CASE
            WHEN email_corrige_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Emails_Invalides,

    SUM(
        CASE
            WHEN phone_valide = 0 THEN 1
            ELSE 0
        END
    ) AS Telephones_Invalides,

    SUM(
        CASE
            WHEN date_creation_fiable IS NULL THEN 1
            ELSE 0
        END
    ) AS Dates_Non_Fiables,

    SUM(
        CASE
            WHEN score_qualite < 90 THEN 1
            ELSE 0
        END
    ) AS Scores_Inferieurs_90,

    SUM(
        CASE
            WHEN verification_requise = 1 THEN 1
            ELSE 0
        END
    ) AS Fiches_A_Verifier,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN verification_requise = 0 THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS Taux_Sans_Verification_Pct

FROM dbo.Golden_Records;

GO

-- Vérifier les indicateurs
SELECT *
FROM dbo.vw_Customer360_Qualite;

GO

-- QUALITÉ DES DONNÉES PAR VILLE

CREATE OR ALTER VIEW dbo.vw_Customer360_Qualite_Villes
AS

SELECT
    Province,
    Ville,

    -- Nombre de clients consolidés
    COUNT(*) AS Nombre_Clients,

    -- Score moyen de qualité
    CAST(
        AVG(CAST(Score_Qualite AS FLOAT))
        AS DECIMAL(5,2)
    ) AS Score_Moyen,

    -- Codes postaux invalides
    SUM(
        CASE
            WHEN Code_Postal_Valide = 0 THEN 1
            ELSE 0
        END
    ) AS Codes_Postaux_Invalides,

    -- Courriels invalides
    SUM(
        CASE
            WHEN Email_Valide = 0 THEN 1
            ELSE 0
        END
    ) AS Emails_Invalides,

    -- Téléphones invalides
    SUM(
        CASE
            WHEN Telephone_Valide = 0 THEN 1
            ELSE 0
        END
    ) AS Telephones_Invalides,

    -- Dates non fiables
    SUM(
        CASE
            WHEN Date_Creation_Fiable IS NULL THEN 1
            ELSE 0
        END
    ) AS Dates_Non_Fiables,

    -- Fiches nécessitant une vérification
    SUM(
        CASE
            WHEN Verification_Requise = 1 THEN 1
            ELSE 0
        END
    ) AS Fiches_A_Verifier

FROM dbo.vw_Customer360_Clients

GROUP BY
    Province,
    Ville;

GO

-- Vérifier la vue créée
SELECT *
FROM dbo.vw_Customer360_Qualite_Villes
ORDER BY Nombre_Clients DESC;

GO

-- CONTRÔLE FINAL DES VUES CUSTOMER 360

SELECT
    -- Nombre de clients dans la vue principale
    (SELECT COUNT(*)
     FROM dbo.vw_Customer360_Clients)
     AS Total_Clients,

    -- Nombre de clients dans la vue qualité
    (SELECT Total_Golden_Records
     FROM dbo.vw_Customer360_Qualite)
     AS Total_Qualite,

    -- Nombre de clients dans la vue géographique
    (SELECT SUM(Nombre_Clients)
     FROM dbo.vw_Customer360_Qualite_Villes)
     AS Total_Villes,

    -- Nombre de villes
    (SELECT COUNT(*)
     FROM dbo.vw_Customer360_Qualite_Villes)
     AS Nombre_Villes,

    -- Fiches nécessitant une vérification
    (SELECT Fiches_A_Verifier
     FROM dbo.vw_Customer360_Qualite)
     AS Fiches_A_Verifier;

GO