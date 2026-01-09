from pydantic import BaseModel
from datetime import date
from datetime import datetime, timedelta  
from typing import Optional
from models import TradeType

# 거래 서비스
# ✅ 요청용 모델
class TransactionCreate(BaseModel):
    buyer_id: Optional[int]
    seller_id: Optional[int]
    scrap_type: str
    quantity: float
    price: float
    contract_status: str = "PENDING"
    trade_type: TradeType   # Enum

# ✅ 응답용 모델
class TransactionResponse(BaseModel):
    id: int
    buyer_id: Optional[int]
    seller_id: Optional[int]
    scrap_type: str
    quantity: float
    price: float
    trade_type: str
    contract_status: str
    contract_date: Optional[date] = None

    class Config:
        orm_mode = True

# 인증 서비스
class CertificationRequest(BaseModel):
    transaction_id: int
    requester: str

class CertificationRecord(BaseModel):
    id: int
    certification_number: str
    transaction_id: int
    issue_date: date
    expiry_date: date

# 물동량 서비스
class VolumeSummary(BaseModel):
    inbound: float
    outbound: float
    total: float

class VolumeManualInput(BaseModel):
    scrap_type: str
    quality_grade: Optional[str] = None
    location: str
    weight: float

class VolumePrediction(BaseModel):
    my_inventory: float
    region_inventory: float
    total_inventory: float

class RegionStat(BaseModel):
    region: str
    scrap_type: str
    inventory: float

# 수입 서비스
class ImportSummary(BaseModel):
    import_inventory: float
    import_movement: float

# 사용자 서비스
class UserCreate(BaseModel):
    username: str
    password: str
    email: Optional[str] = None
    phone: Optional[str] = None
    role: str

class UserLogin(BaseModel):
    username: str
    password: str

class UserResponse(BaseModel):
    id: int
    username: str
    email: Optional[str] = None
    phone: Optional[str] = None
    role: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

class UserUpdate(BaseModel):
    email: Optional[str] = None
    phone: Optional[str] = None
    password: Optional[str] = None   # 🔑 비밀번호도 선택적으로 수정 가능

    class Config:
        orm_mode = True