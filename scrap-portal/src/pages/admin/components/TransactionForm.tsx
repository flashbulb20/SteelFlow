import { useState } from "react";
import { useNavigate } from "react-router-dom";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export default function TransactionForm() {
  const [formData, setFormData] = useState({
    trade_type: "판매자제안",
    scrap_type: "고급재",
    quantity: "",
    price: "",
    content: "",
  });

  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await fetch(`${API_BASE_URL}/api/admin/transactionpost`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formData),
    });
    navigate("/transactions"); // 등록 후 목록 페이지로 이동
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>거래 등록</h1>
      <form onSubmit={handleSubmit} style={{ border: "1px solid #ccc", padding: "15px" }}>
        <div>
          <label>거래 유형: </label>
          <select name="trade_type" value={formData.trade_type} onChange={handleChange}>
            <option value="판매자제안">판매자 제안</option>
            <option value="구매자제안">구매자 제안</option>
            <option value="입찰공고">입찰 공고</option>
          </select>
        </div>
        <div>
          <label>스크랩 종류: </label>
          <select name="scrap_type" value={formData.scrap_type} onChange={handleChange}>
            <option value="고급재">고급재</option>
            <option value="저급재">저급재</option>
            <option value="압축재">압축재</option>
            <option value="생철">생철</option>
          </select>
        </div>
        <div>
          <label>수량(ton): </label>
          <input type="number" name="quantity" value={formData.quantity} onChange={handleChange} required />
        </div>
        <div>
          <label>가격(원): </label>
          <input type="number" name="price" value={formData.price} onChange={handleChange} required />
        </div>
        <div>
          <label>설명: </label>
          <textarea name="content" value={formData.content} onChange={handleChange} />
        </div>
        <button type="submit" style={{ marginTop: "10px" }}>등록</button>
      </form>
    </div>
  );
}
