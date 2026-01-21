# docker-tp

## Membres du groupe
- David CIRAKAZA
- Hamza MAEROF
- Anass HOUDZI


## Objectif du projet
Ce projet a pour objectif de mettre en place une application web complète
en utilisant **Docker** et **Docker Compose**.  
L’application est composée de plusieurs services conteneurisés :
- Backend (API)
- Frontend (React JS)
- Base de données PostgreSQL
- PgAdmin
- Reverse proxy (Caddy)


## Technologies utilisées
- Docker
- Docker Compose
- React JS (Frontend)
- Backend API (FastAPI)
- PostgreSQL
- PgAdmin
- Caddy (Reverse Proxy)


## Architecture du projet

HAMZA METS L'ARCHITECTURE DU PROJET 




## Description des services

### Backend (API)
- Fournit les endpoints de l’application
- Connecté à la base de données PostgreSQL
- Exposé sur le port `8000`

### Frontend (React JS)
- Interface utilisateur de l’application
- Communique avec le backend via une API REST
- Exposé sur le port `3000`

### Base de données (PostgreSQL)
- Stocke les données de l’application
- Données persistées via un volume Docker

### PgAdmin
- Interface graphique pour administrer PostgreSQL
- Accessible via le port `5050`

### Caddy (Reverse Proxy)
- Point d’entrée unique de l’application
- Redirige les requêtes vers le frontend et le backend
- Simplifie la gestion des accès HTTP


## Variables d’environnement et sécurité
Les variables sensibles sont stockées dans un fichier `.env`.
Le mot de passe de la base de données est géré via un **secret Docker**,
ce qui évite de l’exposer directement dans les fichiers Docker Compose.


### NB: 
La gestion du mot de passe PostgreSQL est assurée via un secret Docker (`POSTGRES_PASSWORD_FILE`), conformément aux bonnes pratiques, après correction d’un conflit avec `POSTGRES_PASSWORD`.


## Lancement du projet avec Task

### Démarrer tous les services

Un fichier Taskfile est utilisé afin de simplifier l’exécution des commandes Docker Compose et d’automatiser les actions courantes du projet.

```bash
winget install -e --id Task.Task


```bash
# Lister les tâches
task

# Lancer tout le projet
task up

# Arrêter le projet
task down

# Voir les logs
task logs

# Reset complet (attention)
task clean
```

## Alternative à Task (sans installation supplémentaire)

L’outil Task est utilisé pour automatiser certaines commandes Docker.  
Cependant, si Task n’est pas installé sur la machine, les commandes peuvent être exécutées directement via Docker Compose.

### Démarrer le projet

```bash
docker-compose up -d



