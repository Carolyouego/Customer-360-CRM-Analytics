# Customer 360 | CRM Data Quality & Customer Analytics

### Projet d'intelligence d'affaires | Python • SQL Server • Power BI

![Python](https://img.shields.io/badge/Python-Data%20Preparation-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Data%20Management-CC2927?style=for-the-badge)
![Power BI](https://img.shields.io/badge/Power%20BI-Business%20Intelligence-F2C811?style=for-the-badge)
![DAX](https://img.shields.io/badge/DAX-Data%20Analysis-0078D4?style=for-the-badge)

## Présentation du projet

**Customer 360 – CRM Analytics** est un projet d'analyse de données et d'intelligence d'affaires consacré à la consolidation, à la fiabilisation et à l'exploitation des données clients issues d'un système CRM.

L'objectif est de transformer des données clients potentiellement redondantes ou incohérentes en informations fiables, exploitables et accessibles aux décideurs.

Le projet couvre trois dimensions principales :

- La consolidation des fiches clients et l'analyse du dédoublonnage.
- L'évaluation de la qualité et de la fiabilité des données CRM.
- L'analyse géographique et la répartition des clients.

Les résultats sont présentés dans trois pages de tableaux de bord Power BI.

---

## Contexte métier

Dans une organisation, les informations clients constituent une ressource stratégique.

Cependant, les systèmes CRM peuvent contenir :

- Plusieurs fiches correspondant à un même client.
- Des coordonnées incomplètes ou incorrectes.
- Des codes postaux invalides.
- Des dates incohérentes.
- Des informations géographiques difficiles à exploiter.

Ces problèmes peuvent affecter la connaissance client, la qualité des analyses et la prise de décision.

Le projet Customer 360 s'inscrit dans une démarche d'amélioration de la qualité des données et de construction d'une vision consolidée de la clientèle.

---

## Problématique

**Comment consolider et fiabiliser les données clients d'un système CRM afin de réduire les risques liés aux doublons, d'identifier les anomalies et de produire une vision géographique fiable de la clientèle ?**

Cette problématique se décline en quatre questions :

1. Comment identifier les fiches clients potentiellement redondantes ?
2. Comment mesurer la qualité des données CRM ?
3. Comment repérer les dossiers nécessitant une vérification ?
4. Comment analyser la répartition géographique des clients consolidés ?

---

## Objectifs du projet

### Objectif général

Améliorer la fiabilité et l'exploitation des données CRM afin de faciliter les analyses et la prise de décision.

### Objectifs spécifiques

- Analyser les fiches clients et leur consolidation.
- Évaluer la qualité des informations clients.
- Identifier les anomalies et les dossiers nécessitant une intervention.
- Produire des indicateurs de performance pertinents.
- Visualiser la répartition géographique des clients.
- Mettre à disposition des tableaux de bord interactifs.

### Objectifs SMART proposés

Les objectifs suivants constituent des cibles d'amélioration pouvant être utilisées dans un contexte opérationnel.

| Dimension | Objectif SMART | Horizon de suivi |
|---|---|---|
| Dédoublonnage | Réduire de 90 % les doublons détectés par rapport à une situation initiale mesurée | 3 mois |
| Qualité CRM | Maintenir un score moyen de qualité supérieur ou égal à 99/100 | Mensuel |
| Anomalies | Corriger au moins 95 % des anomalies détectées | 3 mois |
| Vérification | Examiner 100 % des dossiers signalés comme nécessitant une vérification | Mensuel |
| Reporting | Mettre à disposition trois tableaux de bord pour le suivi des données clients | À la livraison du projet |

**Remarque :** ces cibles sont proposées à titre de pilotage. Leur atteinte opérationnelle nécessiterait un suivi dans le temps.

---

## Technologies et outils

| Technologie | Utilisation dans le projet |
|---|---|
| Python | Préparation et traitement des données |
| SQL Server | Gestion et interrogation des données CRM |
| SQL | Extraction et analyse des données |
| Power BI | Conception des tableaux de bord |
| DAX | Calcul des indicateurs et mesures analytiques |
| Power Query | Préparation et transformation des données dans Power BI |
| GitHub | Documentation et présentation du projet |

---

## Démarche analytique

Le projet repose sur une démarche structurée.

### 1 — Compréhension des données

- Identification des informations clients disponibles.
- Analyse des champs nécessaires à la consolidation.
- Identification des critères de qualité.
- Définition des indicateurs de suivi.

### 2 — Préparation des données

- Vérification des types de données.
- Analyse des valeurs manquantes.
- Contrôle des coordonnées clients.
- Identification des incohérences.
- Préparation des données pour l'analyse.

### 3 — Consolidation et dédoublonnage

- Analyse des fiches clients potentiellement redondantes.
- Exploitation des correspondances CRM.
- Consolidation des enregistrements clients.
- Suivi des résultats du dédoublonnage.

### 4 — Contrôle qualité

- Contrôle des codes postaux.
- Vérification des adresses électroniques.
- Contrôle de la fiabilité des dates.
- Identification des dossiers nécessitant une vérification.
- Calcul d'indicateurs de qualité.

### 5 — Analyse géographique

- Regroupement des clients par ville.
- Calcul des effectifs par territoire.
- Calcul de la part de chaque ville.
- Comparaison des scores de qualité.
- Analyse de la concentration géographique de la clientèle.

### 6 — Visualisation

Conception de trois pages Power BI destinées à faciliter l'interprétation des résultats.

---

## Indicateurs clés de performance

### Indicateurs de qualité CRM

| Indicateur | Résultat |
|---|---:|
| Clients consolidés | 1 693 |
| Score moyen de qualité | 99,95/100 |
| Codes postaux invalides | 3 |
| Courriels invalides | 0 |
| Dates non fiables | 1 |
| Clients nécessitant une vérification | 1 |

### Indicateurs géographiques

| Indicateur | Résultat |
|---|---:|
| Clients consolidés | 1 693 |
| Villes couvertes | 10 |
| Clients dans la ville principale | 209 |
| Part de la ville principale | 12,34 % |

La ville de Lévis présente le plus grand nombre de clients dans les données analysées.

---

## Tableaux de bord Power BI

### Dashboard 1 — Vue d'ensemble et performance du dédoublonnage

Cette page présente une vision synthétique des résultats de consolidation des données clients.

Elle permet notamment :

- D'analyser les indicateurs de dédoublonnage.
- De suivre les fiches clients avant et après consolidation.
- D'évaluer les résultats du processus de rapprochement.
- De faciliter l'interprétation des résultats globaux.

### Dashboard 2 — Qualité et fiabilité des données CRM

Cette page permet d'évaluer la fiabilité des informations clients.

**Principaux indicateurs :**

- 1 693 clients.
- Score moyen de qualité : 99,95/100.
- 3 codes postaux invalides.
- 0 courriel invalide.
- 1 date non fiable.
- 1 client nécessitant une vérification.

**Visualisations :**

- Score moyen de qualité par ville.
- Répartition des anomalies par catégorie.
- Tableau des dossiers nécessitant une vérification.
- Filtrage interactif par ville.

### Dashboard 3 — Analyse géographique et répartition des clients

Cette page présente la distribution géographique de la clientèle.

**Principaux indicateurs :**

- 1 693 clients consolidés.
- 10 villes couvertes.
- 209 clients dans la ville principale.

**Visualisations :**

- Répartition des clients consolidés par ville.
- Part des clients par ville (%).
- Synthèse géographique des clients.
- Score moyen de qualité par ville.
- Filtrage interactif par ville.

---

## Résultats de l'analyse géographique

| Ville | Nombre de clients | Part des clients |
|---|---:|---:|
| Lévis | 209 | 12,34 % |
| Longueuil | 187 | 11,05 % |
| Saguenay | 175 | 10,34 % |
| Québec | 170 | 10,04 % |
| Montréal | 169 | 9,98 % |
| Sherbrooke | 169 | 9,98 % |
| Trois-Rivières | 164 | 9,69 % |
| Gatineau | 157 | 9,27 % |
| Drummondville | 156 | 9,21 % |
| Laval | 137 | 8,09 % |
| **Total** | **1 693** | **100 %** |

### Principaux constats

**1. Une clientèle répartie dans dix villes**

Les données consolidées couvrent dix villes du Québec.

**2. Lévis représente la principale concentration**

Avec 209 clients, Lévis représente 12,34 % de la clientèle consolidée.

**3. Une répartition relativement équilibrée**

Aucune ville ne concentre à elle seule une part majoritaire des clients.

**4. Une qualité globale élevée**

Le score moyen de qualité CRM atteint 99,95/100.

**5. Des anomalies résiduelles subsistent**

Malgré ce score élevé, certains enregistrements nécessitent encore des contrôles ciblés.

---

## Recommandations métier

### Renforcer les contrôles à la saisie

Mettre en place des règles de validation pour les codes postaux, les courriels et les dates.

### Prévenir les doublons

Intégrer des contrôles de correspondance avant la création de nouvelles fiches clients.

### Mettre en place un suivi régulier

Suivre périodiquement les anomalies et les dossiers nécessitant une vérification.

### Exploiter les résultats géographiques

Utiliser la répartition territoriale pour orienter les analyses commerciales et la planification des activités.

### Automatiser les contrôles

Envisager l'automatisation des vérifications récurrentes afin de limiter les erreurs et de faciliter le suivi.

---

## Valeur ajoutée du projet

Customer 360 illustre comment une démarche de qualité des données peut contribuer à :

- Améliorer la fiabilité des informations clients.
- Faciliter l'identification des anomalies.
- Renforcer la connaissance de la clientèle.
- Produire des indicateurs exploitables.
- Soutenir les décisions grâce à des tableaux de bord interactifs.

---

## Compétences démontrées

**Analyse et préparation des données**

- Compréhension des données métier.
- Contrôle de qualité.
- Analyse des anomalies.
- Consolidation des données.

**Intelligence d'affaires**

- Définition d'indicateurs de performance.
- Création de mesures DAX.
- Conception de tableaux de bord Power BI.
- Visualisation et interprétation des résultats.

**Analyse métier**

- Formulation d'une problématique.
- Définition d'objectifs SMART.
- Identification de constats.
- Élaboration de recommandations.

---

## À propos

**Caroline Youego**

Analyste de données | Intelligence d'affaires (BI)

Compétences : SQL Server, Python, Power BI, DAX, Power Query, Tableau et Excel.

Basée à Québec, Canada.

Ce projet fait partie de mon portfolio en analyse de données et intelligence d'affaires.

**Objectif professionnel :** contribuer à des projets de valorisation des données, d'amélioration de la qualité de l'information et d'aide à la décision.
