# EcomFlow - E-commerce Stack

> **⚠️ MEMBRES DU GROUPE :**
> - **David CIRAKAZA** 
> - **Hamza MAEROF** 
> - **Anass HOUDZI**

---

## 1. Présentation du Projet
*Ce projet est une stack e-commerce complète composée d'un frontend React/Vite, d'un backend FastAPI et d'une base de données PostgreSQL. L'ensemble est orchestré via Docker Compose, servi par un reverse proxy Caddy, et exposé sur internet via un tunnel Cloudflare pour faciliter le partage et la démonstration.*

**Fonctionnalités principales :**
* **Frontend React** : Interface utilisateur moderne pour la navigation produits.
* **Backend FastAPI** : API performante gérant la logique métier.
* **Base de données PostgreSQL** : Persistance robuste des données.
* **Adminer** : Interface web pour administrer la base de données.
* **Reverse Proxy Caddy** : Gestion du routage (Frontend, API, Docs, DB).
* **Tunneling** : Exposition sécurisée via Cloudflare Tunnel.

**Lien accessible (si tunnel actif) :** [https://assect.online](https://assect.online)

**Screenshot de l'application déployée** : ![](screenshot.jpg)

## 2. Architecture Technique

### Schéma d'infrastructure
*Ce schéma est généré dynamiquement à partir du fichier `architecture.puml`.*

![Architecture du Projet](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/davidtino87/docker-tp/branch/hamza/architecture.puml)

### Description des services
| Service | Image Docker | Rôle | Port Interne |
| :--- | :--- | :--- | :--- |
| **Proxy** | `caddy:2-alpine` | Reverse Proxy & Routing | 80, 443 |
| **App (Frontend)** | `vite-react` (Local) | Interface Utilisateur | 5173 (dev) / 80 (prod) |
| **App (Backend)** | `fastapi-backend` (Local) | API & Business Logic | 8000 |
| **DB** | `postgres:16-alpine` | Base de données | 5432 |
| **Adminer** | `adminer:latest` | Administration DB | 8080 |
| **Tunnel** | `cloudflare/cloudflared` | Exposition Internet | N/A |

---

## 3. Guide d'installation

### 📦 Prérequis
- **Docker** & **Docker Compose**
- **Git**

### 1. Cloner le Projet
```bash
git clone https://github.com/davidtino87/docker-tp.git
cd docker-tp
```

### 2. Configuration de l'Environnement
```bash
# Configuration pour le développement
cp .env.dev.example .env.dev 

# Configuration pour la production
cp .env.prod.example .env.prod
```

**Variables importantes (`.env.dev` / `.env.prod`) :**
```env
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin@123
POSTGRES_DB=ecom_db

# Cloudflare (optionnel pour dev local)
CF_TUNNEL_TOKEN=votre_token_cloudflare
DOMAIN=votredomaine.com
```

### 3. Démarrage des Services

#### Mode Developpement

```bash
# Avec logs en temps réel
docker-compose --env-file .env.dev -f docker-compose.dev.yml up --build

# En arrière-plan
docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d --build
```

#### Mode Production
```bash
docker-compose --env-file .env.prod -f docker-compose.prod.yml up -d --build
```

---

## 🌐 Accès aux Services (Local)

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | [http://localhost](http://localhost) | Via Caddy (Recommandé) |
| **API Docs** | [http://localhost/docs](http://localhost/docs) | Swagger UI |
| **Adminer** | [http://localhost/db](http://localhost/db) | Interface DB |

**Identifiants Adminer :**
- **Système** : PostgreSQL
- **Serveur** : `ecom_db`
- **Utilisateur** : `admin`
- **Base de données** : `ecom_db`

---

## 🛠️ Commandes Utiles

**Arrêter les services :**
```bash
# Dev
docker-compose -f docker-compose.dev.yml down

# Prod
docker-compose -f docker-compose.prod.yml down
```

**Voir les logs :**
```bash
docker-compose -f docker-compose.dev.yml logs -f [service_name]
```

**Nettoyage complet (images + volumes) :**
```bash
docker-compose -f docker-compose.prod.yml down -v --rmi all
```
