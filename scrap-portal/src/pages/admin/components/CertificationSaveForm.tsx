import { useState } from "react";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export default function CertificationSaveForm() {
  const [transactionId, setTransactionId] = useState("");
  const [certNumber, setCertNumber] = useState("");
  const [file, setFile] = useState<File | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const formData = new FormData();
    formData.append("transaction_id", transactionId);
    formData.append("certification_number", certNumber);
    if (file) formData.append("file", file);

    await fetch(`${API_BASE_URL}/api/admin/certifications/save`, {
      method: "POST",
      body: formData,
    });

    alert("인증 저장 완료");
  };

  return (
    <div>
      <h2>인증 저장</h2>
      <form onSubmit={handleSubmit}>
        <label>거래 ID: </label>
        <input value={transactionId} onChange={(e) => setTransactionId(e.target.value)} /><br/>

        <label>인증 번호: </label>
        <input value={certNumber} onChange={(e) => setCertNumber(e.target.value)} /><br/>

        <label>인증서 파일: </label>
        <input type="file" onChange={(e) => setFile(e.target.files?.[0] || null)} /><br/>

        <button type="submit">저장</button>
      </form>
    </div>
  );
}
