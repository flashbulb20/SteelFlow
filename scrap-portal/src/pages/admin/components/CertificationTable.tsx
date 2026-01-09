import { useEffect, useState } from "react";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

interface Certification {
  id: number;
  transaction_id: number;
  certification_number: string;
  issue_date: string;
  expiry_date: string;
}

export default function CertificationTable() {
  const [certs, setCerts] = useState<Certification[]>([]);

  useEffect(() => {
    fetch(`${API_BASE_URL}/api/admin/certifications`)
      .then((res) => res.json())
      .then((data) => setCerts(data));
  }, []);

  return (
    <div>
      <h2>인증 현황</h2>
      <table border={1} cellPadding={5}>
        <thead>
          <tr>
            <th>ID</th>
            <th>거래 ID</th>
            <th>인증번호</th>
            <th>발급일</th>
            <th>만료일</th>
          </tr>
        </thead>
        <tbody>
          {certs.map((c) => (
            <tr key={c.id}>
              <td>{c.id}</td>
              <td>{c.transaction_id}</td>
              <td>{c.certification_number}</td>
              <td>{c.issue_date}</td>
              <td>{c.expiry_date}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
