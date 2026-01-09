import "../css/faq.css";

export default function FAQ() {
  return (
    <div className="faq-screen">
      <div className="faq-container">
        <h1>자주 묻는 질문 (FAQ)</h1>
        <ul>
          <li>Q1: 로그인은 어떻게 하나요?</li>
          <li>A1: 상단 메뉴에서 [사용자 로그인]을 클릭하세요.</li>
          <li>Q2: 물동량은 어디에서 입력하나요?</li>
          <li>A2: 로그인 후 [물동량 서비스] 화면에서 입력할 수 있습니다.</li>
        </ul>
      </div>
    </div>
  );
}
