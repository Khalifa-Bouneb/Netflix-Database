-- Calcule le total des paiements pour chaque moyen de paiement
SELECT moyen_paiement, SUM(montant) AS total_paiement
FROM PAIEMENT
GROUP BY moyen_paiement
ORDER BY total_paiement DESC;

-- Compte le nombre de contenus pour chaque langue originale
SELECT langue_original, COUNT(*) AS nb_contenus
FROM CONTENU
GROUP BY langue_original
ORDER BY nb_contenus DESC;

--Calcule la somme des montants des abonnements commencés en juillet
SELECT SUM(PRIX) AS total_july_revenue
FROM ABONNEMENT
WHERE EXTRACT(MONTH FROM DATE_DÉBUT) = 7;


--Afficher films ou series d'action ou romantiques
SELECT CONT.TITRE 
FROM CONTENU CONT, CATEGORIE CAT, CLASSE_DANS_CATEGORIE CDC
WHERE CDC.ID_CATEGORIE = CAT.ID_CATEGORIE 
  AND CDC.ID_CONTENU = CONT.ID_CONTENU 
  AND (NOM_CAT = 'Action' OR NOM_CAT = 'Romance');


-- Cette requête affiche les films les mieux notés avec leur note moyenne
SELECT c.titre, AVG(da.nbr_etoile) AS note_moyenne, COUNT(da.id_evaluation) AS nombre_avis
FROM CONTENU c
JOIN FILM f ON c.id_contenu = f.id_contenu
JOIN DONNE_AVIS da ON c.id_contenu = da.id_contenu
GROUP BY c.titre
ORDER BY note_moyenne DESC, nombre_avis DESC;


-- Cette requête identifie les séries les plus populaires en fonction du nombre de visionnages
SELECT c.titre, COUNT(hv.id_historique_visionnage) AS nombre_visionnages
FROM CONTENU c
JOIN SERIE s ON c.id_contenu = s.id_contenu
JOIN HISTORIQUE_VISIONNAGE hv ON c.id_contenu = hv.id_contenu
GROUP BY c.titre
ORDER BY nombre_visionnages DESC;


-- Cette requête montre la distribution des contenus selon leur catégorie
SELECT cat.nom_cat,COUNT(cdc.id_contenu) AS nombre_contenus
FROM CATEGORIE cat
JOIN CLASSE_DANS_CATEGORIE cdc ON cat.id_categorie = cdc.id_categorie
GROUP BY cat.nom_cat
ORDER BY nombre_contenus DESC;


-- Cette requête liste les utilisateurs qui ont créé au moins un profil enfant
SELECT DISTINCT u.id_utilisateur, u.nom_user, u.prenom_user, COUNT(pe.id_profil) AS nombre_profils_enfants
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN PROFIL_ADULTE pa ON p.id_profil = pa.id_profil
JOIN PROFIL_ENFANT pe ON pa.id_profil = pe.parent_id
GROUP BY u.id_utilisateur, u.nom_user, u.prenom_user
ORDER BY nombre_profils_enfants DESC;


-- Cette requête calcule les revenus mensuels générés par type de paiement
SELECT 
    TO_CHAR(date_paiement, 'YYYY-MM') AS Mois,
    moyen_paiement,
    SUM(montant) AS montant_total
FROM PAIEMENT
GROUP BY TO_CHAR(date_paiement, 'YYYY-MM'), moyen_paiement
ORDER BY Mois, moyen_paiement;



-- Cette requête calcule la durée moyenne de visionnage pour chaque profil
SELECT p.nom_profil, AVG(hv.temps_ecoulé/60) AS duree_moyenne_minutes
FROM PROFIL p
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
GROUP BY p.nom_profil
ORDER BY duree_moyenne_minutes DESC;

-- Cette requête identifie les abonnements qui vont expirer dans les 30 prochains jours
SELECT u.nom_user, u.prenom_user, u.email_user, a.date_fin
FROM UTILISATEUR u
JOIN ABONNEMENT a ON u.id_abonnement = a.id_abonnement
WHERE a.date_fin BETWEEN SYSDATE AND SYSDATE + 30
ORDER BY a.date_fin;


-- Cette requête analyse l'évolution du nombre d'inscriptions par mois
SELECT TO_CHAR(date_inscri, 'YYYY-MM') AS mois_inscription, COUNT(*) AS nombre_inscriptions
FROM UTILISATEUR
GROUP BY TO_CHAR(date_inscri, 'YYYY-MM')
ORDER BY mois_inscription;

-- Cette requête identifie les contenus ayant reçu le plus grand nombre d'avis
SELECT c.titre, COUNT(da.id_evaluation) AS nombre_avis, 
       ROUND(AVG(da.nbr_etoile), 1) AS note_moyenne
FROM CONTENU c
JOIN DONNE_AVIS da ON c.id_contenu = da.id_contenu
GROUP BY c.titre
ORDER BY nombre_avis DESC;

-- Cette requête calcule le chiffre d'affaires total par mois en 2024
SELECT TO_CHAR(date_paiement, 'YYYY-MM') AS mois, SUM(montant) AS chiffre_affaires
FROM PAIEMENT
WHERE EXTRACT(YEAR FROM date_paiement) = 2024
GROUP BY TO_CHAR(date_paiement, 'YYYY-MM')
ORDER BY mois;


-- Cette requête calcule la proportion de films vs séries dans le catalogue
SELECT 
    COUNT(f.id_contenu) AS nombre_films,
    COUNT(s.id_contenu) AS nombre_series,
    ROUND(COUNT(f.id_contenu) / (COUNT(f.id_contenu) + COUNT(s.id_contenu)) * 100, 2) AS pourcentage_films,
    ROUND(COUNT(s.id_contenu) / (COUNT(f.id_contenu) + COUNT(s.id_contenu)) * 100, 2) AS pourcentage_series
FROM CONTENU c
LEFT JOIN FILM f ON c.id_contenu = f.id_contenu
LEFT JOIN SERIE s ON c.id_contenu = s.id_contenu;


-- Cette requête trouve la dernière activité de chaque utilisateur
SELECT u.nom_user, u.prenom_user, MAX(hv.date_visionnage) AS derniere_activite,
    TRUNC(SYSDATE - MAX(hv.date_visionnage)) AS jours_depuis_derniere_activite
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
GROUP BY u.nom_user, u.prenom_user
ORDER BY derniere_activite DESC;

-- Cette requête identifie les langues les plus fréquemment disponibles pour les contenus
SELECT langue, nombre_contenus 
FROM (
    SELECT tl.langue, COUNT(*) AS nombre_contenus
    FROM TRADUIT_EN_LANGUE tl
    GROUP BY tl.langue
) 
WHERE nombre_contenus = (
    SELECT MAX(nombre_contenus) 
    FROM (
        SELECT COUNT(*) AS nombre_contenus 
        FROM TRADUIT_EN_LANGUE 
        GROUP BY langue
    )
);

-- Cette requête identifie les 5 films les plus longs du catalogue
SELECT c.titre, f.durée, c.date_sortie
FROM CONTENU c
JOIN FILM f ON c.id_contenu = f.id_contenu
ORDER BY f.durée DESC
FETCH FIRST 5 ROWS ONLY;


-- Cette requête classe les séries par nombre de saisons, de la plus longue à la plus courte
SELECT c.titre, s.nbre_saison, s.nbre_episode
FROM CONTENU c
JOIN SERIE s ON c.id_contenu = s.id_contenu
ORDER BY s.nbre_saison DESC, s.nbre_episode DESC;

-- Cette requête identifie les profils qui explorent le plus de contenus différents
SELECT p.nom_profil, u.nom_user, u.prenom_user,
       COUNT(DISTINCT hv.id_contenu) AS diversite_contenus
FROM PROFIL p
JOIN UTILISATEUR u ON p.id_utilisateur = u.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
GROUP BY p.nom_profil, u.nom_user, u.prenom_user
ORDER BY diversite_contenus DESC;


-- Cette requête analyse les préférences de catégories selon l'âge des utilisateurs
SELECT 
    CASE 
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) < 25 THEN 'Moins de 25 ans'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) BETWEEN 25 AND 40 THEN '25-40 ans'
        ELSE 'Plus de 40 ans'
    END AS tranche_age,
    cat.nom_cat,
    COUNT(DISTINCT hv.id_historique_visionnage) AS nombre_visionnages
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
JOIN CLASSE_DANS_CATEGORIE cdc ON hv.id_contenu = cdc.id_contenu
JOIN CATEGORIE cat ON cdc.id_categorie = cat.id_categorie
GROUP BY 
    CASE 
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) < 25 THEN 'Moins de 25 ans'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) BETWEEN 25 AND 40 THEN '25-40 ans'
        ELSE 'Plus de 40 ans'
    END,
    cat.nom_cat
ORDER BY tranche_age, nombre_visionnages DESC;

-- Cette requête identifie les contenus visionnés exclusivement par des profils adultes
-- et non visionnés par des profils enfants
SELECT DISTINCT c.titre
FROM CONTENU c
JOIN HISTORIQUE_VISIONNAGE hv ON c.id_contenu = hv.id_contenu
JOIN PROFIL_ADULTE pa ON hv.id_profil = pa.id_profil
WHERE c.id_contenu NOT IN (
    SELECT hv2.id_contenu
    FROM HISTORIQUE_VISIONNAGE hv2
    JOIN PROFIL_ENFANT pe ON hv2.id_profil = pe.id_profil
)
ORDER BY c.titre;

--Durée totale de visionnage par utilisateur
SELECT u.nom_user, u.prenom_user,
       ROUND(SUM(hv.temps_ecoulé)/3600, 2) AS heures_visionnage
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
GROUP BY u.nom_user, u.prenom_user
ORDER BY heures_visionnage DESC;

--Utilisateurs ayant visionné le même contenu plusieurs fois
SELECT u.nom_user, u.prenom_user, c.titre, COUNT(*) AS nb_visionnages
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
JOIN CONTENU c ON hv.id_contenu = c.id_contenu
GROUP BY u.nom_user, u.prenom_user, c.titre
HAVING COUNT(*) > 1
ORDER BY nb_visionnages DESC;

-- Utilisateurs à risque de désabonnement (faible activité récente)
-- Identifie les utilisateurs peu actifs pour les campagnes de rétention
SELECT 
    u.id_utilisateur,
    u.nom_user || ' ' || u.prenom_user AS utilisateur,
    u.email_user,
    MAX(hv.date_visionnage) AS derniere_activite,
    TRUNC(SYSDATE - MAX(hv.date_visionnage)) AS jours_inactif,
    TRUNC(a.date_fin - SYSDATE) AS jours_avant_expiration
FROM UTILISATEUR u
JOIN ABONNEMENT a ON u.id_abonnement = a.id_abonnement
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
GROUP BY u.id_utilisateur, u.nom_user, u.prenom_user, u.email_user, a.date_fin
HAVING MAX(hv.date_visionnage) < SYSDATE - 20
   AND a.date_fin > SYSDATE
ORDER BY jours_inactif DESC;

--Utilisation des profils multiples par utilisateur
-- Mesure si les utilisateurs utilisent réellement tous leurs profils
SELECT 
    u.id_utilisateur,
    u.nom_user || ' ' || u.prenom_user AS utilisateur,
    COUNT(DISTINCT p.id_profil) AS nombre_profils_crees,
    COUNT(DISTINCT hv.id_profil) AS nombre_profils_actifs,
    CASE WHEN COUNT(DISTINCT p.id_profil) > 0 
         THEN ROUND(COUNT(DISTINCT hv.id_profil) * 100.0 / COUNT(DISTINCT p.id_profil), 2)
         ELSE 0 
    END AS pourcentage_utilisation
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
LEFT JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
GROUP BY u.id_utilisateur, u.nom_user, u.prenom_user
HAVING COUNT(DISTINCT p.id_profil) > 1
ORDER BY pourcentage_utilisation;

-- Liste les commentaires les plus détaillés
SELECT 
    p.nom_profil, 
    c.titre, 
    da.commentaire, 
    LENGTH(da.commentaire) AS longueur_commentaire,
    da.nbr_etoile 
FROM PROFIL p
JOIN DONNE_AVIS da ON p.id_profil = da.id_profil 
JOIN CONTENU c ON da.id_contenu = c.id_contenu 
WHERE da.commentaire IS NOT NULL 
ORDER BY longueur_commentaire DESC 
FETCH FIRST 10 ROWS ONLY;

-- Identifie les utilisateurs intéressés par les nouveaux contenus
SELECT DISTINCT 
    u.nom_user || ' ' || u.prenom_user AS utilisateur, 
    COUNT(DISTINCT c.id_contenu) AS nombre_contenus_recents 
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur 
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil 
JOIN CONTENU c ON hv.id_contenu = c.id_contenu 
WHERE c.date_sortie >= TO_DATE('01-01-2020', 'DD-MM-YYYY') 
GROUP BY u.nom_user, u.prenom_user 
ORDER BY nombre_contenus_recents DESC; 

-- Analyse la diversité des catégories visionnées par utilisateur
SELECT 
    u.nom_user || ' ' || u.prenom_user AS utilisateur, 
    COUNT(DISTINCT cdc.id_categorie) AS nombre_categories, 
    LISTAGG(cat.nom_cat, ', ') WITHIN GROUP (ORDER BY cat.nom_cat) AS categories 
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur 
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil 
JOIN CLASSE_DANS_CATEGORIE cdc ON hv.id_contenu = cdc.id_contenu 
JOIN CATEGORIE cat ON cdc.id_categorie = cat.id_categorie 
GROUP BY u.nom_user, u.prenom_user 
HAVING COUNT(DISTINCT cdc.id_categorie) >= 3 
ORDER BY nombre_categories DESC; 

--Contenus les plus populaires par tranche d’âge
SELECT 
    CASE 
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) < 25 THEN 'Moins de 25 ans'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) BETWEEN 25 AND 40 THEN '25-40 ans'
        ELSE 'Plus de 40 ans'
    END AS tranche_age,
    c.titre,
    COUNT(hv.id_historique_visionnage) AS nombre_visionnages
FROM UTILISATEUR u
JOIN PROFIL p ON u.id_utilisateur = p.id_utilisateur
JOIN HISTORIQUE_VISIONNAGE hv ON p.id_profil = hv.id_profil
JOIN CONTENU c ON hv.id_contenu = c.id_contenu
GROUP BY 
    CASE 
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) < 25 THEN 'Moins de 25 ans'
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, u.date_de_naissance)/12) BETWEEN 25 AND 40 THEN '25-40 ans'
        ELSE 'Plus de 40 ans'
    END,
    c.titre
ORDER BY tranche_age, nombre_visionnages DESC
FETCH FIRST 5 ROWS WITH TIES;
