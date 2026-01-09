from sqlalchemy import Column, Integer, String, DECIMAL, Float, Date, ForeignKey, TIMESTAMP, Table, DateTime, ForeignKey, Enum, Text
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime
import enum

class TradeType(str, enum.Enum):
    SELLER_OFFER = "판매자제안"
    BUYER_OFFER = "구매자제안"
    BIDDING = "입찰공고"

class ScrapTransaction(Base):
    __tablename__ = "scrap_transaction"

    id = Column(Integer, primary_key=True, index=True)
    buyer_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    seller_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    scrap_type = Column(String(50), nullable=False)
    quantity = Column(Float, nullable=False)
    price = Column(Float, nullable=False)
    contract_status = Column(String(50), default="제안")
    trade_type = Column(Enum(TradeType), nullable=False)
    contract_date = Column(Date, nullable=True)

class ScrapInventory(Base):
    __tablename__ = "scrap_inventory"
    id = Column(Integer, primary_key=True, index=True)
    scrap_type = Column(String(50))
    weight = Column(Float)
    location = Column(String(100))
    timestamp = Column(TIMESTAMP)

# --- 4. scrap_delivery_analysis ---
class ScrapDeliveryAnalysis(Base):
    __tablename__ = "scrap_delivery_analysis"

    id = Column(Integer, primary_key=True, index=True)
    message_id = Column(Integer, unique=True)
    supplier_name = Column(String(100))
    supplier_phone = Column(String(20))
    origin_location = Column(String(100))
    vehicle_number = Column(String(20))
    driver_name = Column(String(50))
    delivered_weight = Column(DECIMAL(10, 2))
    qualified_weight = Column(DECIMAL(10, 2))
    delivery_datetime = Column(TIMESTAMP)
    quality_type = Column(Integer)
    transaction_id = Column(Integer, ForeignKey("scrap_transaction.id"))

# --- 5. scrap_flow ---
class ScrapFlow(Base):
    __tablename__ = "scrap_flow"

    id = Column(Integer, primary_key=True, index=True)
    source_location = Column(String(100))
    destination_location = Column(String(100))
    scrap_type = Column(String(50))
    weight = Column(DECIMAL(10, 2))
    timestamp = Column(TIMESTAMP)

class AiPrediction(Base):
    __tablename__ = "ai_prediction"
    id = Column(Integer, primary_key=True, index=True)
    scrap_type = Column(String(50))
    predicted_quantity = Column(Float)
    prediction_date = Column(Date)
    model_version = Column(String(20))


class UserAccount(Base):
    __tablename__ = "user_account"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    username = Column(String(50), unique=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    email = Column(String(100))
    phone = Column(String(20))
    role = Column(String(50), nullable=False, default="user")  # ✅ role 추가
    created_at = Column(DateTime, default=datetime.utcnow)