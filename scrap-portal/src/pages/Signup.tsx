import { useState } from "react";
import { signup } from "../services/auth";
import "../css/signup.css";

export default function Signup() {
  const [form, setForm] = useState({
    username: "",
    password: "",
    email: "",
    phone: "",
    role: "user", // 기본값
  });
  const [message, setMessage] = useState("");

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    console.log("회원가입 데이터:", form);
    try {
      await signup(form);
      setMessage("회원가입 성공! 로그인 해주세요.");
    } catch (err) {
      setMessage("회원가입 실패. 아이디가 이미 존재할 수 있습니다.");
    }
  };

  return (
    <div className="signup-screen">
      <div className="signup-container">
        <h1>회원가입</h1>
        <form onSubmit={handleSubmit}>
          <input
            name="username"
            placeholder="아이디"
            value={form.username}
            onChange={handleChange}
            required
          />
          <input
            name="password"
            type="password"
            placeholder="비밀번호"
            value={form.password}
            onChange={handleChange}
            required
          />
          <input
            name="email"
            type="email"
            placeholder="이메일"
            value={form.email}
            onChange={handleChange}
          />
          <input
            name="phone"
            placeholder="전화번호"
            value={form.phone}
            onChange={handleChange}
          />
          <select name="role" value={form.role} onChange={handleChange} required>
            <option value="user">사용자</option>
            <option value="admin">관리자</option>
          </select>
          <button type="submit">가입하기</button>
        </form>
        {message && <p>{message}</p>}
      </div>
    </div>
  );
}
