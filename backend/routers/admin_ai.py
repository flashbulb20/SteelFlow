from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class ModelStatus(BaseModel):
    version: str
    trained_on: str
    accuracy: float

# 모델 생성
@router.post("/train")
def train_model():
    return {"message": "AI 모델 학습이 시작되었습니다."}

# 모델 상태 조회
@router.get("/status", response_model=ModelStatus)
def get_model_status():
    return ModelStatus(version="v0.1", trained_on="2025-08-20", accuracy=0.85)
