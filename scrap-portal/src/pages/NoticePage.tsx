import { useState } from "react";

interface Notice {
  id: number;
  title: string;
  content: string;
  date: string;
}

export default function NoticePage() {
  const [notices, setNotices] = useState<Notice[]>([
    {
      id: 1,
      title: "시스템 점검 안내",
      content: "현재 개발중인 사이트 입니다.",
      date: "2025-10-10",
    },
    {
      id: 2,
      title: "물동량 시각화 기능 추가",
      content: "그래프를 통해 물동량 현황을 확인할 수 있도록 하였습니다",
      date: "2025-10-12",
    },
  ]);

  return (
    <div style={{ padding: "40px" }}>
      <h1>📢 공지사항</h1>
      {notices.map((n) => (
        <div
          key={n.id}
          style={{
            border: "1px solid #ccc",
            margin: "10px 0",
            padding: "10px",
            borderRadius: "5px",
          }}
        >
          <h3>{n.title}</h3>
          <p>{n.content}</p>
          <small>{n.date}</small>
        </div>
      ))}
    </div>
  );
}
