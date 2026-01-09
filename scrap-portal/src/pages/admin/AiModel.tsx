import AdminBackButton from "./components/AdminBackButton";
import "../../css/aiModel.css";

export default function AiModel() {
  return (
    <div className="ai-container">
      <AdminBackButton />

      <h1>AI 모델 생성 서비스</h1>
      <p className="ai-warning">
        ⚠️ 현재 개발 중인 기능입니다. 이후 AI 학습 및 예측 기능이 연동될 예정입니다.
      </p>

      <section className="ai-section">
        <h2>모델 생성</h2>
        <button disabled>모델 생성 실행</button>
      </section>

      <section className="ai-section">
        <h2>모델 상태</h2>
        <ul>
          <li>최신 모델 버전: -</li>
          <li>학습 데이터: -</li>
          <li>생성 일자: -</li>
        </ul>
      </section>

      <section className="ai-section">
        <h2>모델 관리</h2>
        <div className="ai-actions">
          <button disabled>모델 갱신</button>
          <button disabled>병렬 처리 실행</button>
        </div>
      </section>
    </div>
  );
}
