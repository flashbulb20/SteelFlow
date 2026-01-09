from fastapi import APIRouter
from schemas import ImportSummary

router = APIRouter()

@router.get("/summary", response_model=ImportSummary)
def get_import_summary():
    return ImportSummary(import_inventory=1200.5, import_movement=450.3)
