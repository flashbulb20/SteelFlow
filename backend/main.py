from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routers import (
    admin_transactions,
    admin_certifications,
    admin_volumes,
    admin_ai,
    admin_imports,
    auth,
    users,
    deliveries
)

app = FastAPI(title="철스크랩 플랫폼 API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173", "http://172.30.1.20:5173"],  # React dev server
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 라우터 등록
app.include_router(admin_transactions.router, prefix="/api/admin/transactions", tags=["Transactions"])
app.include_router(admin_certifications.router, prefix="/api/admin/certifications", tags=["Certifications"])
app.include_router(admin_volumes.router, prefix="/api/admin/volumes", tags=["Volumes"])
app.include_router(admin_ai.router, prefix="/api/admin/ai", tags=["AI"])
app.include_router(admin_imports.router, prefix="/api/admin/imports", tags=["Imports"])
app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])
app.include_router(users.router, prefix='/api/users', tags=['users'])
app.include_router(deliveries.router)

@app.get("/")
def root():
    return {"message": "철스크랩 플랫폼 API 서버 실행 중"}
