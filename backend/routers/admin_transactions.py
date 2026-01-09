from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from models import ScrapTransaction
from database import get_db
from schemas import TransactionCreate, TransactionResponse

router = APIRouter()

# 📌 거래 전체 조회
@router.get("/transactions", response_model=List[TransactionResponse])
def get_all_transactions(db: Session = Depends(get_db)):
    transactions = db.query(ScrapTransaction).all()
    return transactions  # ORM 객체여도 orm_mode 때문에 자동 변환됨

# 📌 거래 등록
@router.post("/transactionpost", response_model=TransactionResponse)
def create_transaction(tx: TransactionCreate, db: Session = Depends(get_db)):
    new_tx = ScrapTransaction(**tx.dict())
    db.add(new_tx)
    db.commit()
    db.refresh(new_tx)
    return new_tx  # orm_mode 덕분에 자동 변환됨

@router.patch("/transactions/{tx_id}/status")
def update_transaction_status(tx_id: int, status: str, db: Session = Depends(get_db)):
    valid_status = ["PENDING", "SIGNED", "CANCELLED", "COMPLETE"]
    if status not in valid_status:
        return {"error": "잘못된 상태값입니다. (PENDING, SIGNED, CANCELLED, COMPLETE 만 허용)"}

    tx = db.query(ScrapTransaction).filter(ScrapTransaction.id == tx_id).first()
    if not tx:
        return {"error": "거래를 찾을 수 없습니다."}

    tx.contract_status = status
    db.commit()
    db.refresh(tx)
    return tx