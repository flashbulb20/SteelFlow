import { useState, useEffect } from "react";
import { Link, Routes, Route } from "react-router-dom";
import Transactions from "./Transactions";
import Certifications from "./Certifications";
import Volume from "./Volumes";
import AiModels from "./AiModel";
import Imports from "./ImportService";
import "../../css/adminDashboard.css";

export default function AdminDashboard() {
  const [stats, setStats] = useState({
    transactions: 120,
    certifications: 30,
    volumes: 12000,
    aiModels: 5,
    imports: 18,
  });
  const [lastUpdate, setLastUpdate] = useState<Date>(new Date());

  // 랜덤 값 갱신
  useEffect(() => {
    const interval = setInterval(() => {
      setStats({
        transactions: Math.floor(Math.random() * 200),
        certifications: Math.floor(Math.random() * 50),
        volumes: Math.floor(Math.random() * 20000),
        aiModels: Math.floor(Math.random() * 10),
        imports: Math.floor(Math.random() * 100),
      });
      setLastUpdate(new Date());
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="dashboard">
      {/* 상단 네비게이션 바 */}
      <div className="dashboard-topbar">
        <Link to="/">포탈로</Link>
        <Link to="/profile">내정보</Link>
        <Link to="/">로그아웃</Link>
      </div>

      {/* 메인 컨텐츠 */}
      <main className="dashboard-main">
        <h1>관리자 대시보드</h1>
        <p className="subtitle">플랫폼 운영 현황과 주요 서비스를 확인하세요.</p>

        <div className="dashboard-grid">
          <Link to="transactions" className="dashboard-card transactions">
            <h3>거래 서비스</h3>
            <p>실시간 거래 현황 및 내역 관리</p>
            <div className="stat">{stats.transactions} 건</div>
            <div className="update-time">{lastUpdate.toLocaleTimeString()} 업데이트</div>
          </Link>

          <Link to="certifications" className="dashboard-card certifications">
            <h3>인증 서비스</h3>
            <p>탄소인증 및 품질 인증 관리</p>
            <div className="stat">{stats.certifications} 건</div>
            <div className="update-time">{lastUpdate.toLocaleTimeString()} 업데이트</div>
          </Link>

          <Link to="volumes" className="dashboard-card volumes">
            <h3>물동량 서비스</h3>
            <p>철스크랩 물동량 관리 및 추적</p>
            <div className="stat">{stats.volumes.toLocaleString()} 톤</div>
            <div className="update-time">{lastUpdate.toLocaleTimeString()} 업데이트</div>
          </Link>

          <Link to="ai-model" className="dashboard-card aimodels">
            <h3>AI 모델 생성</h3>
            <p>AI 기반 품질 분석 및 추천 모델 관리</p>
            <div className="stat">{stats.aiModels} 개</div>
            <div className="update-time">{lastUpdate.toLocaleTimeString()} 업데이트</div>
          </Link>

          <Link to="import-service" className="dashboard-card imports">
            <h3>수입 서비스</h3>
            <p>수입 관련 물류 및 서류 처리</p>
            <div className="stat">{stats.imports} 건</div>
            <div className="update-time">{lastUpdate.toLocaleTimeString()} 업데이트</div>
          </Link>
        </div>

        <Routes>
          <Route path="transactions" element={<Transactions />} />
          <Route path="certifications" element={<Certifications />} />
          <Route path="volumes" element={<Volume />} />
          <Route path="ai-model" element={<AiModels />} />
          <Route path="import-service" element={<Imports />} />
        </Routes>
      </main>
    </div>
  );
}
