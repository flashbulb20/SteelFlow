from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import ScrapDeliveryAnalysis, ScrapTransaction
from pydantic import BaseModel
from datetime import datetime

router = APIRouter(prefix="/deliveries", tags=["Deliveries"])

class DeliveryCreate(BaseModel):
    transaction_id: int
    supplier_name: str
    supplier_phone: str
    origin_location: str
    vehicle_number: str
    driver_name: str
    delivered_weight: float
    qualified_weight: float
    quality_type: int

@router.post("/", summary="이송 정보 등록")
def create_delivery(data: DeliveryCreate, db: Session = Depends(get_db)):
    tx = db.query(ScrapTransaction).filter(ScrapTransaction.id == data.transaction_id).first()
    if not tx:
        raise HTTPException(status_code=404, detail="거래를 찾을 수 없습니다.")
    if tx.contract_status != "SIGNED":
        raise HTTPException(status_code=400, detail="SIGNED 상태의 거래만 등록할 수 있습니다.")

    new_delivery = ScrapDeliveryAnalysis(
        supplier_name=data.supplier_name,
        supplier_phone=data.supplier_phone,
        origin_location=data.origin_location,
        vehicle_number=data.vehicle_number,
        driver_name=data.driver_name,
        delivered_weight=data.delivered_weight,
        qualified_weight=data.qualified_weight,
        quality_type=data.quality_type,
        delivery_datetime=datetime.now(),
        transaction_id=data.transaction_id,
    )

    db.add(new_delivery)

    # ✅ (선택 기능) 등록 완료 시 거래 상태를 COMPLETE로 자동 변경
    tx.contract_status = "COMPLETE"

    db.commit()
    db.refresh(new_delivery)
    return {"message": "이송 정보가 등록되었습니다.", "delivery_id": new_delivery.id}
