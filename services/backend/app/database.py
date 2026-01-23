"""
Connexion simple à PostgreSQL
"""
import psycopg
import os 
from dotenv import load_dotenv


# Paramètres de connexion (identiques au docker-compose.yml)
DB_CONFIG = {
    "host": os.getenv("POSTGRES_DB", "localhost"),
    "port": int(os.getenv("DB_PORT", 5432)),
    "dbname": os.getenv("POSTGRES_DB", "postgres"),
    "user": os.getenv("POSTGRES_USER", "postgres"),
    "password": os.getenv("POSTGRES_PASSWORD", "password")
}

def get_connection():
    """
    Retourne une connexion à la base de données
    À utiliser avec 'with' pour fermer automatiquement
    """
    return psycopg.connect(**DB_CONFIG)



def execute_query(query, params=None):
    """
    Exécute une requête SQL et retourne les résultats
    
    Args:
        query: La requête SQL à exécuter
        params: Les paramètres de la requête (optionnel)
    
    Returns:
        Liste de dictionnaires représentant les résultats
    """
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
            
            # Si la requête retourne des résultats
            if cur.description:
                columns = [desc[0] for desc in cur.description]
                results = cur.fetchall()
                return [dict(zip(columns, row)) for row in results]
            
            # Si c'est un INSERT/UPDATE/DELETE
            conn.commit()
            return {"success": True}