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

![Architecture du Projet](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/davidtino87/docker-tp/tree/main/architecture.puml)

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

## 4. Méthodologie & Transparence IA

### Organisation

La méthodologie de travail suivie consistait à ce que chacun dockerise le projet de A à Z afin de bien comprendre le fonctionnement, l’architecture adoptée et les services utilisés. Ensuite, chacun déployait le projet dans sa propre branche via GitHub.

Après cela, nous avons fait un point pour échanger les acquis et déployer une version finale améliorée sur la branche main.

### Utilisation de l'IA (Copilot, ChatGPT, Cursor...)

* **Outils utilisés :** (Claude , GEMINI, ANTIGRAVITY)
* **Usage :**
    * *Génération de code :Nous avons utilisé Antigravity Agent AI pour générer la partie frontend et consommer les API de la partie backend, qui était déjà prête,     ainsi que pour l’amélioration et la suggestion de nouvelles fonctionnalités.
    * *Débuggage : Le débogage a également été réalisé par Antigravity Agent AI. Les problèmes rencontrés sont présentés ci-dessous.
* **Apprentissage :** 
* L’IA a joué un rôle clé dans l’amélioration et la stabilisation de l’architecture Docker du projet. Elle m’a accompagné dans la conversion des Dockerfiles en Dockerfiles multi-stage, ce qui m’a permis de comprendre comment gérer efficacement tout le cycle de vie de l’application (développement, build et production), optimiser la taille des images et renforcer la sécurité.

* Elle m’a également conseillé de séparer la configuration en deux fichiers Docker Compose, l’un pour le développement et l’autre pour la production, afin d’améliorer la sécurité en évitant l’exposition inutile des ports et de faciliter la maintenance grâce à une meilleure lisibilité de l’architecture.

* Par ailleurs, l’IA m’a aidé à résoudre plusieurs problèmes techniques, notamment le Hot Reload du frontend via l’utilisation correcte des volumes Docker, l’initialisation de PostgreSQL et la gestion des volumes, ainsi que l’orchestration des services à l’aide de depends_on et des health checks. Enfin, elle m’a guidé dans la configuration de Cloudflared et de Cloudflare, me permettant de comprendre le fonctionnement des tunnels, du routage interne et de la gestion DNS.

* Grâce à cet accompagnement, j’ai acquis une meilleure compréhension des principes fondamentaux de Docker, de l’orchestration des services et du déploiement sécurisé d’une application en environnement de production.

## 5. Difficultés rencontrées & Solutions

* Problème 1 : Les modifications du code Frontend ne s'affichaient pas en temps réel dans le conteneur (Hot Reload inactif).

* Solution 1 : Montage d'un volume bind-mount (./services/frontend/ecom:/app) et activation du mode Polling (CHOKIDAR_USEPOLLING=true) pour forcer la détection des changements de fichiers sous Docker.

* Problème 2 : Les scripts SQL placés dans /docker-entrypoint-initdb.d n’étaient pas exécutés.

* Solution 2 : Suppression du volume existant contenant déjà une base initialisée, car PostgreSQL n’exécute les scripts d’initialisation que lors du premier démarrage.

* Problème 3 : Les services démarraient dans le mauvais ordre.

* Solution 3 : Ajout de depends_on avec condition: service_healthy pour garantir que :

    * PostgreSQL démarre avant le backend
    * Backend démarre avant le frontend

* Problème 4 : Le service cloudflared ne démarrait pas automatiquement ou ne trouvait pas ses instructions.

* Solution 4 : Ajout de la commande tunnel run dans le service Docker Compose et utilisation d'une variable d'environnement TUNNEL_TOKEN pour une gestion centralisée via le Dashboard Cloudflare (évitant l'usage d'un fichier config.yml local).    

* Problème 5 : Le tunnel Cloudflare affichait une erreur 522 (Connection Timed Out) lors de l'accès au domaine.

* Solution 5 : Configuration correcte du Public Hostname dans le tableau de bord Cloudflare pour rediriger le trafic vers le service interne http://caddy:80 et suppression des anciens enregistrements DNS (A/CNAME) conflictuels.   

