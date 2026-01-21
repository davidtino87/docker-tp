from fastapi import FastAPI 
from fastapi.middleware.cors import CORSMiddleware 

from app.auth.admin_routes import router as admin_router 
from app.crud.product_routes import router as product_router
from app.crud.category_routes import router as category_router



# ============================================================
# Création de l'application FastAPI
# ============================================================

app = FastAPI(
    title="Sales API",
    description="API REST pour la gestion des produits, catégories et commandes",
    version="1.0.0"
)


# ============================================================
# Inclusion des routes
# ============================================================

app.include_router(admin_router)
app.include_router(product_router)
app.include_router(category_router)




# ============================================================
# Route racine (health check / welcome) 
# ============================================================

@app.get("/", status_code=200)
def root():
    """
    Endpoint de vérification de l'API
    """
    return {
        "success": True,
        "message": "Bienvenue sur l'API Sales",
        "available_endpoints": {
            "products": "/products",
            "categories": "/categories",
            "orders": "/orders",
            "search": "/search"
        }
    }


# ============================================================
# Lancement de l'application
# ============================================================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )