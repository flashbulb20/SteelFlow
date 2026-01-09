import { useState } from "react";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export default function CertificationRequestForm() {
  const [transactionId, setTransactionId] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    fetch(`${API_BASE_URL}/api/admin/certifications/request`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ transaction_id: transactionId }),
    }).then(() => alert("인증 요청 완료"));
  };

  return (
    <div>
      <h2>인증 요청</h2>
      <form onSubmit={handleSubmit}>
        <label>거래 ID: </label>
        <input value={transactionId} onChange={(e) => setTransactionId(e.target.value)} /><br/>
        <button type="submit">요청</button>
      </form>
    </div>
  );
}
