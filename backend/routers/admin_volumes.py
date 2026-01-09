from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from database import get_db
from models import ScrapTransaction, ScrapInventory, AiPrediction, ScrapDeliveryAnalysis, ScrapFlow
from schemas import VolumeSummary, VolumeManualInput, VolumePrediction, RegionStat
from collections import defaultdict
from datetime import date, datetime
from typing import Optional, List
from pydantic import BaseModel

router = APIRouter()

# 📊 거래 물동량 요약
@router.get("/summary", response_model=VolumeSummary)
def get_volume_summary(db: Session = Depends(get_db)):
    # ✅ 입고량: 실제 납품 완료된 물량
    inbound = (
        db.query(func.coalesce(func.sum(ScrapDeliveryAnalysis.qualified_weight), 0.0))
        .scalar()
    )

    # ✅ 출고량: scrap_flow 기준
    outbound = (
        db.query(func.coalesce(func.sum(ScrapFlow.weight), 0.0))
        .scalar()
    )

    # ✅ 총거래량: scrap_flow 총합
    total = outbound

    return VolumeSummary(
        inbound=float(inbound or 0),
        outbound=float(outbound or 0),
        total=float(total or 0),
    )

# 📈 일자별 거래량 추세
from sqlalchemy import cast, Date

@router.get("/daily")
def get_daily_volumes(db: Session = Depends(get_db)):
    inbound_data = (
        db.query(
            cast(ScrapDeliveryAnalysis.delivery_datetime, Date).label("day"),
            func.sum(ScrapDeliveryAnalysis.qualified_weight).label("inbound")
        )
        .group_by(cast(ScrapDeliveryAnalysis.delivery_datetime, Date))
        .order_by(cast(ScrapDeliveryAnalysis.delivery_datetime, Date))
        .all()
    )

    outbound_data = (
        db.query(
            cast(ScrapFlow.timestamp, Date).label("day"),
            func.sum(ScrapFlow.weight).label("outbound")
        )
        .group_by(cast(ScrapFlow.timestamp, Date))
        .order_by(cast(ScrapFlow.timestamp, Date))
        .all()
    )

    daily_map = {}
    for row in inbound_data:
        day = str(row.day)
        if day not in daily_map:
            daily_map[day] = {"day": day, "inbound": 0.0, "outbound": 0.0}
        daily_map[day]["inbound"] = float(row.inbound or 0)

    for row in outbound_data:
        day = str(row.day)
        if day not in daily_map:
            daily_map[day] = {"day": day, "inbound": 0.0, "outbound": 0.0}
        daily_map[day]["outbound"] = float(row.outbound or 0)

    return sorted(daily_map.values(), key=lambda x: x["day"])


# ✍️ 수동 입력
@router.post("/manual-input")
def manual_volume_input(input: VolumeManualInput, db: Session = Depends(get_db)):
    new_record = ScrapInventory(
        scrap_type=input.scrap_type,
        quality_grade=input.quality_grade,
        location=input.location,
        weight=input.weight,
    )
    db.add(new_record)
    db.commit()
    db.refresh(new_record)
    return {"message": "물동량 수동 입력 완료", "id": new_record.id}

# 📍 지역별 통계
@router.get("/stats", response_model=List[RegionStat])
def get_region_stats(db: Session = Depends(get_db)):
    records = db.query(ScrapInventory).all()

    stats = defaultdict(lambda: defaultdict(float))  
    # 구조: {지역: {스크랩종류: 재고량}}

    for r in records:
        stats[r.location][r.scrap_type] += float(r.weight)

    result = []
    for region, scrap_dict in stats.items():
        for scrap_type, weight in scrap_dict.items():
            result.append(RegionStat(region=region, scrap_type=scrap_type, inventory=weight))

    return result

# 🤖 AI 예측
@router.get("/predictions", response_model=VolumePrediction)
def get_ai_prediction(db: Session = Depends(get_db)):
    today = date.today()

    prediction = (
        db.query(AiPrediction)
        .filter(AiPrediction.prediction_date == today)
        .order_by(AiPrediction.id.desc())
        .first()
    )
    if not prediction:
        return VolumePrediction(my_inventory=0, region_inventory=0, total_inventory=0)

    return VolumePrediction(
        my_inventory=prediction.predicted_quantity * 0.2,
        region_inventory=prediction.predicted_quantity * 0.3,
        total_inventory=prediction.predicted_quantity,
    )
