from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models import UserAccount
from schemas import UserUpdate
from routers.auth import get_current_user
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/me")
def read_users_me(current_user: UserAccount = Depends(get_current_user)):
    return {
        "id": current_user.id,
        "username": current_user.username,
        "email": current_user.email,
        "phone": current_user.phone,
        "role": current_user.role,
    }

# 내 정보 수정
@router.put("/me")
def update_user_info(
    update: UserUpdate,
    db: Session = Depends(get_db),
    current_user: UserAccount = Depends(get_current_user),
):
    if update.email:
        current_user.email = update.email
    if update.phone:
        current_user.phone = update.phone
    if update.password:  # 🔑 비밀번호 업데이트
        current_user.hashed_password = pwd_context.hash(update.password)

    db.commit()
    db.refresh(current_user)
    return {"message": "정보 수정 완료", "user": current_user}

# 회원 탈퇴
@router.delete("/me")
def delete_user(
    db: Session = Depends(get_db),
    current_user: UserAccount = Depends(get_current_user),
):
    db.delete(current_user)
    db.commit()
    return {"message": "회원 탈퇴 완료"}
