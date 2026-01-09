import { useEffect, useState } from "react";
import axios from "axios";
import DeliveryForm from "./components/DeliveryForm";
import AdminBackButton from "./components/AdminBackButton";
import "../../css/transactions.css"; // ✅ CSS 적용 경로

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

interface Transaction {
  id: number;
  buyer_id: number;
  seller_id: number;
  scrap_type: string;
  quantity: number;
  price: number;
  contract_status: string;
}

const statusLabel: Record<string, string> = {
  PENDING: "대기중",
  SIGNED: "계약됨",
  CANCELLED: "취소됨",
  COMPLETE: "완료됨",
};

export default function Transactions() {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [newTx, setNewTx] = useState({
    buyer_id: "",
    seller_id: "",
    scrap_type: "",
    quantity: "",
    price: "",
  });
  const [selectedTx, setSelectedTx] = useState<Transaction | null>(null);

  const fetchTransactions = async () => {
    const res = await axios.get(`${API_BASE_URL}/api/admin/transactions/transactions`);
    setTransactions(res.data.reverse());
  };

  useEffect(() => {
    fetchTransactions();
  }, []);

  const handleSubmit = async () => {
    if (!newTx.scrap_type || !newTx.quantity) {
      alert("필수 정보를 입력해주세요.");
      return;
    }
    await axios.post(`${API_BASE_URL}/api/admin/transactions/transactionpost`, {
      ...newTx,
      quantity: parseFloat(newTx.quantity),
      price: parseFloat(newTx.price),
    });
    setNewTx({ buyer_id: "", seller_id: "", scrap_type: "", quantity: "", price: "" });
    fetchTransactions();
  };

  const updateStatus = async (id: number, status: string) => {
    await axios.patch(`${API_BASE_URL}/api/admin/transactions/${id}/status?status=${status}`);
    fetchTransactions();
  };

  return (
    <div className="transaction-container">
      <AdminBackButton />
      <h1 className="transaction-title">🧾 거래 서비스</h1>

      {/* 거래 등록 섹션 */}
      <div className="transaction-form">
        <h3>➕ 거래 등록</h3>
        <div className="form-fields">
          <input
            placeholder="판매자 ID"
            value={newTx.seller_id}
            onChange={(e) => setNewTx({ ...newTx, seller_id: e.target.value })}
          />
          <input
            placeholder="구매자 ID"
            value={newTx.buyer_id}
            onChange={(e) => setNewTx({ ...newTx, buyer_id: e.target.value })}
          />
          <input
            placeholder="철스크랩 종류"
            value={newTx.scrap_type}
            onChange={(e) => setNewTx({ ...newTx, scrap_type: e.target.value })}
          />
          <input
            placeholder="수량(톤)"
            value={newTx.quantity}
            onChange={(e) => setNewTx({ ...newTx, quantity: e.target.value })}
          />
          <input
            placeholder="가격(원)"
            value={newTx.price}
            onChange={(e) => setNewTx({ ...newTx, price: e.target.value })}
          />
          <button className="btn-submit" onClick={handleSubmit}>
            등록
          </button>
        </div>
      </div>

      {/* 거래 목록 */}
      <h3 className="table-title">📋 거래 목록</h3>
      <table className="transaction-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>판매자</th>
            <th>구매자</th>
            <th>종류</th>
            <th>수량</th>
            <th>가격</th>
            <th>상태</th>
            <th>동작</th>
          </tr>
        </thead>
        <tbody>
          {transactions.map((tx) => (
            <tr key={tx.id} onClick={() => setSelectedTx(tx)}>
              <td>{tx.id}</td>
              <td>{tx.seller_id}</td>
              <td>{tx.buyer_id}</td>
              <td>{tx.scrap_type}</td>
              <td>{tx.quantity}</td>
              <td>{tx.price}</td>
              <td>{statusLabel[tx.contract_status]}</td>
              <td>
                {tx.contract_status === "PENDING" && (
                  <button
                    className="btn-accept"
                    onClick={(e) => {
                      e.stopPropagation();
                      updateStatus(tx.id, "SIGNED");
                    }}
                  >
                    수락
                  </button>
                )}
                {tx.contract_status === "SIGNED" && (
                  <button
                    className="btn-complete"
                    onClick={(e) => {
                      e.stopPropagation();
                      updateStatus(tx.id, "COMPLETE");
                    }}
                  >
                    완료
                  </button>
                )}
                {tx.contract_status !== "COMPLETE" && (
                  <button
                    className="btn-cancel"
                    onClick={(e) => {
                      e.stopPropagation();
                      updateStatus(tx.id, "CANCELLED");
                    }}
                  >
                    취소
                  </button>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* ✅ 팝업 모달 */}
      {selectedTx && (
        <div className="modal-overlay" onClick={() => setSelectedTx(null)}>
          <div
            className="modal-content"
            onClick={(e) => e.stopPropagation()} // 내부 클릭 시 닫히지 않게
          >
            <div className="modal-header">
              <h2>거래 상세 정보</h2>
              <button className="modal-close" onClick={() => setSelectedTx(null)}>
                ✕
              </button>
            </div>

            <div className="modal-body">
              <div className="modal-section">
                <p><strong>거래 ID:</strong> {selectedTx.id}</p>
                <p><strong>판매자 ID:</strong> {selectedTx.seller_id}</p>
                <p><strong>구매자 ID:</strong> {selectedTx.buyer_id}</p>
              </div>

              <div className="modal-section">
                <p><strong>철스크랩 종류:</strong> {selectedTx.scrap_type}</p>
                <p><strong>수량:</strong> {selectedTx.quantity} 톤</p>
                <p><strong>가격:</strong> {selectedTx.price.toLocaleString()} 원</p>
                <p><strong>상태:</strong> {statusLabel[selectedTx.contract_status]}</p>
              </div>

              {selectedTx.contract_status === "SIGNED" && (
                <div className="delivery-section">
                  <div className="delivery-header">
                    <h4>🚛 이송 정보 등록</h4>
                    <span className="delivery-subtitle">
                      거래가 계약된 후, 이송 정보를 입력하세요.
                    </span>
                  </div>
                  <DeliveryForm transactionId={selectedTx.id} />
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
