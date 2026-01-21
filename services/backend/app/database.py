"""
Connexion simple à PostgreSQL
"""
import psycopg

# Paramètres de connexion (identiques au docker-compose.yml)
DB_CONFIG = {
    "host": "sales_db",
    "port": 5432,
    "dbname": "sales_db",
    "user": "admin",
    "password": "root123"
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