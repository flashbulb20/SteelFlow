import { useState } from "react";
import axios from "axios";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export default function VolumeInputForm() {
  const [scrapType, setScrapType] = useState("");
  const [quality, setQuality] = useState("");
  const [location, setLocation] = useState("");
  const [weight, setWeight] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      await axios.post(`${API_BASE_URL}/api/admin/volumes/manual-input`, {
        scrap_type: scrapType,
        quality_grade: quality,
        location,
        weight: parseFloat(weight),
      });

      alert("물동량 수동 입력이 완료되었습니다.");
      setScrapType("");
      setQuality("");
      setLocation("");
      setWeight("");
    } catch (err) {
      console.error(err);
      alert("입력 중 오류가 발생했습니다.");
    }
  };

  return (
    <div style={{ maxWidth: "400px", margin: "0 auto" }}>
      <h3>✍️ 물동량 수동 입력</h3>
      <form onSubmit={handleSubmit}>
        <div>
          <label>스크랩 종류:</label>
          <select
            value={scrapType}
            onChange={(e) => setScrapType(e.target.value)}
            required
          >
            <option value="">선택하세요</option>
            <option value="생철">생철</option>
            <option value="생압">생압</option>
            <option value="중량">중량</option>
            <option value="경량">경량</option>
            <option value="선반">선반</option>
            <option value="슈레더">슈레더</option>
            <option value="길로틴">길로틴</option>
            <option value="압축">압축</option>
            <option value="모터블록">모터블록</option>                        
          </select>
        </div>

        <div>
          <label>품질 등급:</label>
          <select
            value={quality}
            onChange={(e) => setQuality(e.target.value)}
          >
            <option value="">선택하세요 (선택 사항)</option>
            <option value="A">A</option>
            <option value="B">B</option>
            <option value="C">C</option>
            <option value="D">D</option>
            <option value="E">E</option>
            <option value="AL">AL</option>
            <option value="BL">BL</option>
            <option value="L">L</option>
          </select>
        </div>

        <div>
          <label>지역:</label>
          <input
            type="text"
            placeholder="예: 부산 야드"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            required
          />
        </div>

        <div>
          <label>무게(톤):</label>
          <input
            type="number"
            step="0.01"
            value={weight}
            onChange={(e) => setWeight(e.target.value)}
            required
          />
        </div>

        <button type="submit" style={{ marginTop: "15px" }}>
          저장
        </button>
      </form>
    </div>
  );
}
