from fastapi import APIRouter, HTTPException, status , Depends
from app.database import execute_query
from app.auth.admin_guard import admin_required


router = APIRouter(
    prefix="/products",
    tags=["Products"]
)


import logging

# Configurer le logger
logging.basicConfig(level=logging.DEBUG, format='%(message)s')
logger = logging.getLogger(__name__)

# ============================================================
# GET product by ID
# ============================================================

@router.get("/{product_id}", status_code=status.HTTP_200_OK)
def get_product_by_id(product_id: int):
    """
    Récupérer un produit par son ID
    """
    try:
        sql = "SELECT * FROM get_product_by_id(%s);"
        result = execute_query(sql, (product_id,))


    except Exception as e:
        logger.error(f"Error fetching product {product_id}: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la récupération du produit"
        )
    
    if not result or result[0].get('product_id') is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Produit avec l'ID {product_id} introuvable"
        ) 

    return {
        "success": True,
        "data": result
    }


# ============================================================
# SEARCH products
# ============================================================

@router.get("/", status_code=status.HTTP_200_OK)
def search_products(name: str = ""):
    """
    Rechercher des produits par nom
    """
    try:
        sql = "SELECT * FROM search_product(%s);"
        results = execute_query(sql, (name,))
    except Exception :
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la récupération du produit"
        )

        # logger.debug("the results " , results)   

    if not results :
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Aucun produit trouvé"
        )

    return {
        "success": True,
        "query": name,
        "count": len(results),
        "data": results
    }




# ============================================================
# ADD product
# ============================================================

@router.post("/", status_code=status.HTTP_201_CREATED , dependencies=[Depends(admin_required)])
def add_product(
    name: str,
    description: str="",
    price: float = 0.0,
    stock: int = 0,
    sku: str = ""
):
    """
    Ajouter un nouveau produit
    """
    if not name or not sku or price <= 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Champs invalides : name, sku et price (> 0) sont obligatoires"
        )

    try:
        # On force le cast pour correspondre à la signature de la fonction
        sql = """
            SELECT add_product(
                %s::varchar, 
                %s::text, 
                %s::numeric, 
                %s::integer, 
                %s::varchar
            );
        """
        logger.debug("params :" , name , description , price , stock , sku)
        result = execute_query(
            sql,
            (name, description, price, stock, sku)
        )

        return {
            "success": True,
            "message": "Produit créé avec succès",
            "product_id": result[0]["add_product"]
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la création du produit : {str(e)}"
        )


# ============================================================
# UPDATE product
# ============================================================

@router.put("/{product_id}", status_code=status.HTTP_200_OK , dependencies=[Depends(admin_required)])
def update_product(
    product_id: int,
    name: str,
    description: str | None,
    price: float,
    stock: int,
    sku: str
):
    """
    Mettre à jour un produit existant
    """
    if price <= 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Le prix doit être supérieur à 0"
        )

    try:
        sql = """
            SELECT update_product(
                %s::integer,
                %s::varchar, 
                %s::text, 
                %s::numeric, 
                %s::integer,
                %s::varchar
            );
        """
        result = execute_query(
            sql,
            (product_id, name, description, price, stock , sku)
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la mise à jour du produit : {str(e)}"
        )
    
    if not result[0]["update_product"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Produit avec l'ID {product_id} introuvable"
        )

    return {
        "success": True,
        "message": "Produit mis à jour avec succès"
    }


# ============================================================
# DELETE product
# ============================================================

@router.delete("/{product_id}", status_code=status.HTTP_200_OK , dependencies=[Depends(admin_required)])
def delete_product(product_id: int):
    """
    Supprimer un produit
    """
    try:
        sql = "SELECT delete_product(%s);"
        result = execute_query(sql, (product_id,))

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur lors de la suppression du produit : {str(e)}"
        )
    
    if not result[0]["delete_product"]:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Produit avec l'ID {product_id} introuvable"
        )
    
    return {
        "success": True,
        "message": "Produit supprimé avec succès"
    }
