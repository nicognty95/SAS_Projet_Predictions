# Projet : Analyse Économétrique du MODÈLE MEDAF  
*Application de méthodes statistiques et de mathématiques appliquées pour évaluer la relation rendement‐risque des titres français*

---

## Introduction  
Ce projet vise à étudier, d’un point de vue **statistique** et **mathématiques appliquées**, le Modèle d’Évaluation des Actifs Financiers (MEDAF / CAPM) sur un échantillon de titres français. L’objectif est de comprendre quantitativement la relation linéaire entre le rendement excédentaire d’un actif et celui du marché, et d’interpréter les coefficients issus des régressions.

---

## Objectifs  
1. **Choix et préparation** des données financières (`CAC40`, 8 actions du CAC40, OAT 2 ans).  
2. **Modélisation & tests** :  
   - Régression linéaire simple (rendement net titre vs. rendement net marché)  
   - Estimation et interprétation de β (sensibilité au marché)  
   - Calcul du coefficient de détermination R² (qualité d’ajustement)  
   - Construction de la Security Market Line (SML) et extraction de α (efficience)  
3. **Validation et extension** :  
   - Création d’un portefeuille équipondéré  
   - Évaluation YTD 2023  
   - Analyse de facteurs externes (inflation, chiffres de ventes)

---

## Choix des données  
- **Période étudiée** : mai 2018 – mai 2023 (≈ 1280 observations journalières)  
- **Marché de référence** : Indice CAC 40 (proxy du marché)  
- **Actif sans risque** : OAT France à 2 ans (rendements annualisés)  
- **Titres analysés** (secteurs divers) :  
  - LVMH, Danone, Orange, Sanofi, Vinci, Crédit Agricole, Carrefour, Airbus  

---

## Préparation des données  
1. **Import des CSV** (Yahoo Finance) → conversion en tables SAS / DataFrame pandas  
2. **Synchronisation** des dates (jointure interne)  
3. **Calcul des rendements journaliers** :  
   \[
   r_{t,i} = 365 \times \frac{P_{t,i} - P_{t-1,i}}{P_{t-1,i}}
   \]
4. **Rendement excédentaire** :  
   \[
   R_{t,i}^{\mathrm{net}} = r_{t,i} - r_{t,\text{OAT}}
   \]

---

## Modélisation : régression linéaire simple  
Pour chaque titre \(i\) :
\[
R_{t,i}^{\mathrm{net}} = \alpha_i + \beta_i \, R_{t,\text{CAC40}}^{\mathrm{net}} + \varepsilon_{t,i}
\]  

- **β** : sensibilité systématique (risque de marché)  
- **R²** : proportion de variance expliquée (qualité du fit)  
- **α** : performance anormale (« rendement supplémentaire »)

---

## Résultats et interprétation  
| Titre              | α      | β    | R²   | Moy. Rend. Net |
|--------------------|--------|------|------|----------------|
| Danone             | –0,067 | 0,53 | 0,27 | –0,006         |
| Crédit Agricole    | –0,083 | 1,26 | 0,59 |  0,062         |
| LVMH               |  0,217 | 1,17 | 0,69 |  0,351         |
| Orange             | –0,120 | 0,47 | 0,24 | –0,066         |
| Carrefour          |  0,009 | 0,51 | 0,14 |  0,055         |
| Vinci              |  0,010 | 1,21 | 0,65 |  0,145         |
| Airbus             |  0,030 | 1,54 | 0,56 |  0,214         |
| Sanofi             |  0,090 | 0,47 | 0,20 |  0,140         |
| **Portefeuille EQ**|  0,010 | 0,89 | 0,86 |  0,111         |

- **Analyse de β** :  
  - β > 1 (Crédit Agricole, LVMH, Vinci, Airbus) → titres plus volatils que le marché  
  - β < 1 (Danone, Orange, Carrefour, Sanofi) → titres défensifs  
- **Analyse de R²** :  
  - R² élevé (> 0,6) → bon ajustement (LVMH, Vinci, etc.)  
  - R² faible (< 0,3) → influences externes non captées  
- **SML & α** :  
  - Titres au-dessus de la SML (α > 0) sur-performants (LVMH, Airbus, Sanofi)  
  - Titres en dessous de la SML (α < 0) sous-performants (Danone, Orange, etc.)

---

## Évaluation YTD 2023  
Régression appliquée aux rendements Year-To-Date (01/01/2023 – 31/05/2023) :  
| Titre           | Rend. Net YTD | Rend. Eff. SML | Diff. | Recommandation |
|-----------------|---------------|----------------|-------|----------------|
| Danone          | 11,86 %       | 6,10 %         | +5,76 | Vente          |
| Crédit Agricole |  7,05 %       | 14,50 %        | –7,45 | Achat          |
| LVMH            | 18,90 %       | 13,40 %        | +5,50 | Vente          |
| Orange          | 19,70 %       | 5,40 %         | +14,30| Vente          |
| …               | …             | …              | …     | …              |

---

## Analyse de facteurs externes  
- **Inflation (IPC mensuel)** vs. rendement Carrefour → R² = 0,0145 (non significatif)  
- **Chiffre d’affaires commerce de gros (annuel)** vs. rendement Carrefour → R² = 0,0375  
> Les variables macro externes étudiées n’expliquent pas la variabilité de Carrefour sur la période.

