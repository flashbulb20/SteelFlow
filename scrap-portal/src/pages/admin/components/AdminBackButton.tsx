import { useNavigate } from "react-router-dom";

export default function AdminBackButton() {
  const navigate = useNavigate();

  return (
    <button
      onClick={() => navigate("/admin")}
      style={{
        marginBottom: "15px",
        padding: "5px 10px",
        backgroundColor: "#007bff",
        color: "white",
        border: "none",
        borderRadius: "4px",
        cursor: "pointer",
      }}
    >
      홈으로
    </button>
  );
}
