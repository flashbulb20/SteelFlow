from fastapi import APIRouter
from pydantic import BaseModel
from datetime import date
from typing import List

router = APIRouter()

class CertificationRequest(BaseModel):
    transaction_id: int
    requester: str

class CertificationRecord(BaseModel):
    id: int
    certification_number: str
    transaction_id: int
    issue_date: date
    expiry_date: date

class Certification(BaseModel):
    id: int
    company_name: str
    certification_type: str
    status: str  # pending / approved / rejected

# 전체 인증 현황 조회
@router.get("/", response_model=List[Certification])
def get_all_certifications():
    return [
        Certification(id=1, company_name="철강주식회사", certification_type="환경인증", status="pending"),
        Certification(id=2, company_name="구리상사", certification_type="안전인증", status="approved"),
        Certification(id=3, company_name="알루미늄유통", certification_type="품질인증", status="rejected"),
    ]

# 인증 요청
@router.post("/request")
def request_certification(req: CertificationRequest):
    return {"message": f"거래 {req.transaction_id} 에 대한 인증 요청이 접수되었습니다."}

# 인증 저장 (예시)
@router.post("/save", response_model=CertificationRecord)
def save_certification(record: CertificationRecord):
    return record
