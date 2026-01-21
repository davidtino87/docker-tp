from fastapi import APIRouter, HTTPException, status
from app.database import execute_query
from app.auth.auth_utils import hash_password, verify_password, create_access_token

router = APIRouter(
    prefix="/admin",
    tags=["Admin Auth"]
)

# ============================================================
# REGISTER ADMIN
# ============================================================

@router.post("/register", status_code=status.HTTP_201_CREATED)
def register_admin(email: str, password: str):

    if not email or not password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email et mot de passe requis"
        )

    try:
        password_hash = hash_password(password)
        sql = "SELECT add_admin(%s, %s);"
        result = execute_query(sql, (email, password_hash))

        return {
            "success": True,
            "admin_id": result[0]["add_admin"],
            "message": "Admin créé avec succès"
        }

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erreur serveur : {str(e)}"
        )


# ============================================================
# LOGIN ADMIN
# ============================================================

@router.post("/login", status_code=status.HTTP_200_OK)
def login_admin(email: str, password: str):

    try:
        sql = "SELECT * FROM get_admin_by_email(%s);"
        result = execute_query(sql, (email,))

    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Erreur serveur"
        )

    if not result or result[0].get("admin_id") is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Admin introuvable"
        )

    admin = result[0]

    if not verify_password(password, admin["password_hash"]):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Mot de passe incorrect"
        )

    token = create_access_token({
        "sub": admin["email"],
        "role": "admin"
    })

    return {
        "success": True,
        "access_token": token,
        "token_type": "bearer"
    }
