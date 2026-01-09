import { Link } from "react-router-dom";
import DashboardHeader from "../../components/DashboardHeader";

export default function UserDashboard() {
  return (
    <div style={{ padding: "20px" }}>
      <DashboardHeader />

      <h1>사용자 대시보드</h1>
      <p>여기에서 거래, 인증, 물동량 입력 기능을 사용할 수 있습니다.</p>

      <ul>
        <li><Link to="/user/transactions">거래 서비스</Link></li>
        <li><Link to="/user/certifications">인증 서비스</Link></li>
        <li><Link to="/user/volumes">물동량 입력</Link></li>
      </ul>
    </div>
  );
}
