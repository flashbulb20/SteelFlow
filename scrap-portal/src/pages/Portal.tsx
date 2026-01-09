import { Link } from "react-router-dom";
import "../css/portal.css";

export default function Portal() {
  return (
    <div className="portal-screen">
      <header className="portal-header">
        <div className="portal-logo">Scrap<span>Platform</span></div>
        <nav className="portal-nav">
          <Link to="/login">로그인</Link>
          <Link to="/signup">회원가입</Link>
          <Link to="/guide">이용 가이드</Link>
          <Link to="/faq">FAQ</Link>
          <Link to="/notice">공지사항</Link>
        </nav>
      </header>

      <section className="portal-hero">
        <h1>철스크랩 물류의 새로운 표준</h1>
        <p>
          거래 · 물동량 관리 · 탄소인증 · AI 품질분석까지  
          철스크랩 산업을 위한 통합 플랫폼입니다.
        </p>
        <div className="portal-actions">
          <Link to="/signup" className="portal-btn primary">지금 시작하기</Link>
          <Link to="/faq" className="portal-btn ghost">더 알아보기</Link>
        </div>
      </section>

      <section className="portal-features">
        <div className="feature-card">
          <div className="feature-icon">📊</div>
          <h3>실시간 데이터</h3>
          <p>거래 및 물동량 데이터를 실시간으로 확인하고 분석할 수 있습니다.</p>
        </div>
        <div className="feature-card">
          <div className="feature-icon">🌱</div>
          <h3>탄소인증</h3>
          <p>친환경 경영을 위한 탄소배출 인증 및 관리 기능을 제공합니다.</p>
        </div>
        <div className="feature-card">
          <div className="feature-icon">🤖</div>
          <h3>AI 품질 분석</h3>
          <p>AI 기반으로 스크랩 품질을 자동 판별하여 효율을 극대화합니다.</p>
        </div>
        <div className="feature-card">
          <div className="feature-icon">🚚</div>
          <h3>운송 최적화</h3>
          <p>실시간 위치 기반으로 최적의 운송 경로를 추천하여 비용을 절감합니다.</p>
        </div>
      </section>

      <section className="portal-stats">
        <div className="stat-card">
          <h4>누적 거래량</h4>
          <p className="stat-value">120,000톤+</p>
        </div>
        <div className="stat-card">
          <h4>탄소 절감 효과</h4>
          <p className="stat-value">25%</p>
        </div>
        <div className="stat-card">
          <h4>파트너사</h4>
          <p className="stat-value">300+</p>
        </div>
      </section>

      <footer className="portal-footer">
        <p>© 2025 Scrap Platform. All rights reserved.</p>
        <p className="footer-sub">문의: support@scrapplatform.com</p>
      </footer>
    </div>
  );
}
