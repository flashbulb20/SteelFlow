import { useState } from "react";
import VolumeSummary from "./components/VolumeSummary";
import VolumeInputForm from "./components/VolumeInputForm";
import VolumeStats from "./components/VolumeStats";
import VolumePrediction from "./components/VolumePrediction";
import AdminBackButton from "./components/AdminBackButton";
import VolumeChart from "./components/VolumeChart";
import "../../css/volumes.css";

type Tab = "summary" | "input" | "stats" | "prediction" | "chart";

export default function Volumes() {
  const [activeTab, setActiveTab] = useState<Tab>("summary");

  return (
    <div className="volumes-container">
      <AdminBackButton />

      {/* 헤더 */}
      <header className="volumes-header">
        <h1>운영자 물동량 서비스</h1>
        <p className="subtext">
          거래 물동량 관리, 수동 입력, 통계 현황, AI 예측 기능을 제공합니다.
        </p>
      </header>

      {/* 탭 메뉴 */}
      <nav className="volume-tabs">
        <button
          className={activeTab === "summary" ? "active" : ""}
          onClick={() => setActiveTab("summary")}
        >
          거래 물동량
        </button>
        <button
          className={activeTab === "input" ? "active" : ""}
          onClick={() => setActiveTab("input")}
        >
          물동량 수동 입력
        </button>
        <button 
          className={activeTab === "chart" ? "active" : ""}
          onClick={() => setActiveTab("chart")}
        >
          물동량 그래프
        </button>
        <button
          className={activeTab === "stats" ? "active" : ""}
          onClick={() => setActiveTab("stats")}
        >
          지역별 물동량 현황
        </button>
        <button
          className={activeTab === "prediction" ? "active" : ""}
          onClick={() => setActiveTab("prediction")}
        >
          AI 예측
        </button>
      </nav>

      {/* 콘텐츠 */}
      <main className="volume-section">
        {activeTab === "summary" && (
          <div className="card">
            <VolumeSummary />
          </div>
        )}
        {activeTab === "input" && (
          <div className="card">
            <VolumeInputForm />
          </div>
        )}
        {activeTab === "chart" && 
          <div className="card">
            <VolumeChart />
          </div>        
        }
        {activeTab === "stats" && (
          <div className="card">
            <VolumeStats />
          </div>
        )}
        {activeTab === "prediction" && (
          <div className="card">
            <VolumePrediction />
          </div>
        )}
      </main>
    </div>
  );
}
