from fastapi import APIRouter, HTTPException, status , Depends
from app.database import execute_query
from app.auth.admin_guard import admin_required

import logging

router = APIRouter(
    prefix="/categories",
    tags=["Categories"]
)

# ============================================================
# Logger
# ============================================================

logging.basicConfig(level=logging.DEBUG, format='%(message)s')
logger = logging.getLogger(__name__)

# ============================================================
# GET category by ID
# ============================================================

@router.get("/{category_id}", status_code=status.HTTP_200_OK)
def get_category_by_id(category_id: int):
    """
    Récupérer une catégorie par son ID
    """
    try:
        sql = "SELECT * FROM get_category_by_id(%s);"
        result = execute_query(sql, (category_id,))

    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Erreur serveur lors de la récupération de la catégorie"
        )

    if not result or result[0].get("category_id") is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Catégorie avec l'ID {category_id} introuvable"
        )

    return {
        "success": True,
        "data": result
    }


# ============================================================
# SEARCH categories
# ============================================================

@router.get("/", status_code=status.HTTP_200_OK)
def search_categories(name: str = ""):
    """
    Rechercher des catégories par nom
    """
    try:
        sql = "SELECT * FROM search_category(%s);"
        results = execute_query(sql, (name,))

    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Erreur serveur lors de la recherche des catégories"
        )

    if not results:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Aucune catégorie trouvée"
        )

    return {
        "success": True,
        "query": name,
        "count": len(results),
        "data": results
    }


# ============================================================
# ADD category
# ============================================================

@router.post("/", status_code=status.HTTP_201_CREATED , dependencies=[Depends(admin_required)])
def add_category(
    name: str,
    description: str = "",
    slug: str = ""
):
    """
    Ajouter une nouvelle catégorie
    """
    if not name or not slug:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Champs invalides : name et slug sont obligatoires"
        )

    try:
        sql = """
            SELECT add_category(
                %s::varchar,
                %s::text,
                %s::varchar
            );
        """
        logger.debug("params :", name, description, slug)

        result = execute_query(
            sql,
            (name, description, slug)
        )

        return {
            "success": True,
            "message": "Catégorie créée avec succès",
            "category_id": result[0]["add_category"]
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la création de la catégorie : {str(e)}"
        )


# ============================================================
# UPDATE category
# ============================================================

@router.put("/{category_id}", status_code=status.HTTP_200_OK , dependencies=[Depends(admin_required)])
def update_category(
    category_id: int,
    name: str,
    description: str | None,
    slug: str
):
    """
    Mettre à jour une catégorie existante
    """
    if not name or not slug:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Champs invalides : name et slug sont obligatoires"
        )

    try:
        sql = """
            SELECT update_category(
                %s::integer,
                %s::varchar,
                %s::text,
                %s::varchar
            );
        """
        result = execute_query(
            sql,
            (category_id, name, description, slug)
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la mise à jour de la catégorie : {str(e)}"
        )

    if not result[0]["update_category"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Catégorie avec l'ID {category_id} introuvable"
        )

    return {
        "success": True,
        "message": "Catégorie mise à jour avec succès"
    }


# ============================================================
# DELETE category
# ============================================================

@router.delete("/{category_id}", status_code=status.HTTP_200_OK , dependencies=[Depends(admin_required)])
def delete_category(category_id: int):
    """
    Supprimer une catégorie
    """
    try:
        sql = "SELECT delete_category(%s);"
        result = execute_query(sql, (category_id,))

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la suppression de la catégorie : {str(e)}"
        )

    if not result[0]["delete_category"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Catégorie avec l'ID {category_id} introuvable"
        )

    return {
        "success": True,
        "message": "Catégorie supprimée avec succès"
    }
