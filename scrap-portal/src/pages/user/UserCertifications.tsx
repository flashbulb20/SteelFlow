import { useState } from "react";

export default function UserCertifications() {
  const [certs, setCerts] = useState<any[]>([]);

  return (
    <div style={{ padding: "20px" }}>
      <h2>인증 서비스</h2>
      <p>탄소발자국 인증 요청 및 확인을 할 수 있습니다.</p>

      <button>인증 요청하기</button>

      {certs.length === 0 ? (
        <p>등록된 인증서가 없습니다.</p>
      ) : (
        <ul>
          {certs.map((c, idx) => (
            <li key={idx}>
              인증번호: {c.certNumber} - 만료일: {c.expiryDate}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
