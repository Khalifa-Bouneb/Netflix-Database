# Netflix-Database
# 🎬 Système de Gestion Netflix avec Oracle

## 📋 Description du Projet

Ce projet implémente une base de données Oracle complète pour la gestion d'un service de streaming similaire à Netflix. Le système gère tous les aspects essentiels de la plateforme : utilisateurs, abonnements, contenu et interactions.

## 💽 Architecture de la Base de Données Oracle

### 👥 Gestion des Utilisateurs
- **👤 UTILISATEUR**: Informations des clients (identité, contacts, authentification)
- **👨‍👩‍👧‍👦 PROFIL**: Profils multiples sur un même compte
- **👨‍👩‍👧 PROFIL_ADULTE**: Profils principaux
- **👶 PROFIL_ENFANT**: Profils avec restrictions d'âge

### 💳 Gestion des Abonnements
- **📱 ABONNEMENT**: Dates et prix des forfaits
- **✨ ABONNEMENT_PREMIUM**: Multi-écrans, qualité Ultra HD
- **🎓 ABONNEMENT_ETUDIANT**: Tarifs réduits avec justificatifs
- **📊 ABONNEMENT_STANDARD**: Offre de base
- **💰 PAIEMENT**: Transactions financières

### 🎞️ Catalogue de Contenu
- **🎬 CONTENU**: Films et séries disponibles
- **📺 SERIE**: Nombre d'épisodes et saisons
- **🍿 FILM**: Long-métrages et leurs durées
- **🏷️ CATEGORIE**: Genres et classification
- **🌎 TRADUIT_EN_LANGUE**: Options de langue et sous-titres

### 📊 Expérience Utilisateur
- **⭐ DONNE_AVIS**: Évaluations et commentaires
- **📈 HISTORIQUE_VISIONNAGE**: Suivi des visionnages

## 🔍 Spécifications Techniques Oracle

- **💾 Tables relationnelles** avec contraintes d'intégrité référentielle
- **🔑 Clés primaires et étrangères** pour garantir la cohérence des données
- **📅 Types de données Oracle** adaptés (NUMBER, VARCHAR2, DATE)
- **🔄 Héritage de tables** via clés primaires/étrangères communes
- **🧩 Tables associatives** pour les relations many-to-many

## 🛠️ Fonctionnalités Implémentées

- Gestion des abonnements avec différents niveaux de service
- Système de profils multi-utilisateurs avec contrôle parental
- Suivi complet des paiements et transactions
- Catalogue de contenu multiniveaux et multilingue
- Système de recommandation basé sur l'historique

## 🚀 Environnement Technique

- **🔶 Oracle Database**: Moteur de base de données relationnel
- **📜 SQL DDL**: Scripts de définition de structure
- **📊 SQL DML**: Manipulation des données et opérations CRUD
- **🧪 Données de test**: Jeu de données complet pour simulation

---

⚠️ *Projet académique à des fins d'apprentissage des bases de données Oracle.*

---

🔗 *© 2025 - Système de Gestion Netflix Oracle*
