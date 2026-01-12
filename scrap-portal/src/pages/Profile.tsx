import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export default function Profile() {
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    username: "",
    email: "",
    phone: "",
    password: "",
  });

  // 로그인된 사용자 정보 불러오기
  useEffect(() => {
    const storedUser = localStorage.getItem("user");
    if (storedUser) {
      const parsedUser = JSON.parse(storedUser);
      setFormData({
        username: parsedUser.username || "",
        email: parsedUser.email || "",
        phone: parsedUser.phone || "",
        password: "",
      });
    }
  }, []);

  // 입력 변경 핸들러
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  // ✅ 정보 수정 API 호출
  const handleUpdate = async () => {
    try {
      const token = localStorage.getItem("token");
      const res = await fetch(`${API_BASE_URL}/users/me`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(formData),
      });
      if (!res.ok) throw new Error("수정 실패");
      alert("내 정보가 수정되었습니다 ✅");

      // 수정된 사용자 정보를 다시 localStorage에 저장
      localStorage.setItem("user", JSON.stringify(formData));
    } catch (err) {
      console.error(err);
      alert("수정 중 오류가 발생했습니다.");
    }
  };

  // ❌ 회원 탈퇴 API 호출
  const handleDelete = async () => {
    if (!window.confirm("정말 탈퇴하시겠습니까?")) return;

    try {
      const token = localStorage.getItem("token");
      const res = await fetch(`${API_BASE_URL}/users/me`, {
        method: "DELETE",
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      if (!res.ok) throw new Error("탈퇴 실패");

      alert("회원 탈퇴가 완료되었습니다.");
      localStorage.removeItem("user");
      localStorage.removeItem("token");
      navigate("/portal");
    } catch (err) {
      console.error(err);
      alert("탈퇴 중 오류가 발생했습니다.");
    }
  };

  // 로그아웃
  const handleLogout = () => {
    localStorage.removeItem("user");
    localStorage.removeItem("token");
    navigate("/portal");
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>내 프로필</h1>

      <div>
        <label>아이디: </label>
        <input type="text" value={formData.username} disabled />
      </div>

      <div>
        <label>이메일: </label>
        <input
          type="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
        />
      </div>

      <div>
        <label>전화번호: </label>
        <input
          type="text"
          name="phone"
          value={formData.phone}
          onChange={handleChange}
        />
      </div>

      <div>
        <label>새 비밀번호: </label>
        <input
          type="password"
          name="password"
          value={formData.password}
          onChange={handleChange}
        />
      </div>

      <div style={{ marginTop: "20px" }}>
        <button onClick={handleUpdate}>정보 수정</button>
        <button onClick={handleDelete} style={{ marginLeft: "10px", color: "red" }}>
          회원 탈퇴
        </button>
      </div>

      <div style={{ marginTop: "20px" }}>
        <button onClick={() => navigate("/")}>포탈로</button>
        <button onClick={handleLogout} style={{ marginLeft: "10px" }}>
          로그아웃
        </button>
      </div>
    </div>
  );
}
