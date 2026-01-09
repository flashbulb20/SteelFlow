import { useEffect, useState } from "react";
import AdminBackButton from "./components/AdminBackButton";
import "../../css/importService.css";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

interface ImportData {
  import_inventory: number; // 수입 재고량
  import_movement: number;  // 수입 이동량
}

export default function ImportService() {
  const [data, setData] = useState<ImportData | null>(null);

  useEffect(() => {
    fetch(`${API_BASE_URL}/api/admin/imports/summary`)
      .then((res) => res.json())
      .then(setData)
      .catch(() => setData(null));
  }, []);

  return (
    <div>
      <AdminBackButton />

      <h1>수입 서비스 관리</h1>

      <div style={{ padding: "20px" }}>
      <p>한국철강협회 데이터를 확인해보세요.</p>

      <div style={{ border: "1px solid #ccc", height: "800px" }}>
        <iframe
          src="https://www.kosa.or.kr/statistics/tendency_2011.jsp?ITEM_NAME=%EC%88%98%EC%B6%9C"
          title="KOSA 통계포털"
          width="100%"
          height="100%"
          style={{ border: "none" }}
        />
      </div>
    </div>
    <section className="import-section">
        {data ? (
          <div className="import-stats">
            <div className="stat-card">
              <h3>수입 재고량</h3>
              <p>{data.import_inventory.toLocaleString()} 톤</p>
            </div>
            <div className="stat-card">
              <h3>수입 이동량</h3>
              <p>{data.import_movement.toLocaleString()} 톤</p>
            </div>
          </div>
        ) : (
          <p className="import-empty">
            데이터 불러오는 중이거나 아직 등록된 수입 정보가 없습니다.
          </p>
        )}
      </section>
    </div>
    
  );
}
