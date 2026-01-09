import { useNavigate } from "react-router-dom";

export default function DashboardHeader() {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    navigate("/"); // 로그아웃 후 포탈로 이동
  };

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "center",
        padding: "10px 20px",
        backgroundColor: "#f8f9fa",
        borderBottom: "1px solid #ddd",
        marginBottom: "20px",
      }}
    >
      <div>
        <button
          onClick={() => navigate("/")}
          style={{
            marginRight: "10px",
            padding: "6px 12px",
            backgroundColor: "#007bff",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
          }}
        >
          포탈로
        </button>

        <button
          onClick={() => navigate("/profile")}
          style={{
            padding: "6px 12px",
            backgroundColor: "#28a745",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
          }}
        >
          내 정보
        </button>
      </div>

      <button
        onClick={handleLogout}
        style={{
          padding: "6px 12px",
          backgroundColor: "#dc3545",
          color: "white",
          border: "none",
          borderRadius: "4px",
          cursor: "pointer",
        }}
      >
        로그아웃
      </button>
    </div>
  );
}
