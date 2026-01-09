import { useState } from "react";
import CertificationRequestForm from "./components/CertificationRequestForm";
import CertificationSaveForm from "./components/CertificationSaveForm";
import CertificationTable from "./components/CertificationTable";
import AdminBackButton from "./components/AdminBackButton";
import "../../css/certifications.css";

export default function Certifications() {
  const [activeTab, setActiveTab] = useState("list");

  return (
    <div className="certifications-container">
      <AdminBackButton />

      <h1>인증 서비스 관리</h1>

      {/* 탭 버튼 */}
      <div className="certification-tabs">
        <button
          className={activeTab === "list" ? "active" : ""}
          onClick={() => setActiveTab("list")}
        >
          인증 현황
        </button>
        <button
          className={activeTab === "request" ? "active" : ""}
          onClick={() => setActiveTab("request")}
        >
          인증 요청
        </button>
        <button
          className={activeTab === "save" ? "active" : ""}
          onClick={() => setActiveTab("save")}
        >
          인증 저장
        </button>
      </div>

      {/* 탭별 화면 */}
      <div className="certification-section">
        {activeTab === "list" && <CertificationTable />}
        {activeTab === "request" && <CertificationRequestForm />}
        {activeTab === "save" && <CertificationSaveForm />}
      </div>
    </div>
  );
}
