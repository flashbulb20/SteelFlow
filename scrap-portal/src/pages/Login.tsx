import { useState } from "react";
import { login, getMe } from "../services/auth";
import "../css/login.css";
import { Link } from "react-router-dom";

export default function Login() {
  const [form, setForm] = useState({ username: "", password: "" });
  const [message, setMessage] = useState("");

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const res = await login(form);
      localStorage.setItem("token", res.access_token);

      const user = await getMe(res.access_token);
      localStorage.setItem("user", JSON.stringify(user));

      if (user.role === "admin") {
        window.location.href = "/admin";
      } else {
        window.location.href = "/user";
      }
    } catch (err) {
      setMessage("로그인 실패. 아이디나 비밀번호를 확인하세요.");
    }
  };

  return (
    <div className="login-screen">
      <div className="login-container">
        <div className="login-logo">
          Scrap<span>Platform</span>
        </div>
        <form onSubmit={handleSubmit}>
          <input
            type="text"
            name="username"
            placeholder="아이디"
            value={form.username}
            onChange={handleChange}
          />
          <input
            type="password"
            name="password"
            placeholder="비밀번호"
            value={form.password}
            onChange={handleChange}
          />
          <button type="submit">로그인</button>
        </form>

        {/* 회원가입 버튼만 오른쪽 아래 배치 */}
        <div className="login-links">
          <Link to="/signup">회원가입</Link>
        </div>

        {message && <p>{message}</p>}
      </div>
    </div>
  );
}
