const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

export async function signup(userData: {
  username: string;
  email?: string;
  phone?: string;
  password: string;
  role: string;
}) {
  const res = await fetch(`${API_BASE_URL}/api/auth/signup`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(userData),
  });
  if (!res.ok) throw new Error("회원가입 실패");
  return res.json();
}

export async function login(userData: { username: string; password: string }) {
  const res = await fetch(`${API_BASE_URL}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(userData),
  });
  if (!res.ok) throw new Error("로그인 실패");
  return res.json();
}

export async function getMe(token: string) {
  const res = await fetch(`${API_BASE_URL}/api/auth/me`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) throw new Error("인증 실패");
  return res.json();
}