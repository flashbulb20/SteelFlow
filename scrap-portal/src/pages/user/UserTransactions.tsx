import { useState } from "react";

export default function UserTransactions() {
  const [transactions, setTransactions] = useState<any[]>([]);

  return (
    <div style={{ padding: "20px" }}>
      <h2>사용자 거래 서비스</h2>
      <p>거래 제안 및 거래 현황을 확인할 수 있습니다.</p>

      {transactions.length === 0 ? (
        <p>아직 거래 내역이 없습니다.</p>
      ) : (
        <ul>
          {transactions.map((t, idx) => (
            <li key={idx}>
              {t.type} - {t.quantity}톤 - {t.status}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
