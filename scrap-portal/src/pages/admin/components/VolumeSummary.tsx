import { useEffect, useState } from "react";
import axios from "axios";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  LineChart,
  Line,
} from "recharts";

interface VolumeSummaryData {
  inbound: number;
  outbound: number;
  total: number;
}

interface DailyVolume {
  day: string;
  inbound: number;
  outbound: number;
}

export default function VolumeSummary() {
  const [summary, setSummary] = useState<VolumeSummaryData>({
    inbound: 0,
    outbound: 0,
    total: 0,
  });
  const [dailyData, setDailyData] = useState<DailyVolume[]>([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [summaryRes, dailyRes] = await Promise.all([
          axios.get(`${API_BASE_URL}/api/admin/volumes/summary`),
          axios.get(`${API_BASE_URL}/api/admin/volumes/daily`),
        ]);
        setSummary(summaryRes.data);
        setDailyData(dailyRes.data);
      } catch (err) {
        console.error("물동량 데이터 불러오기 실패:", err);
      }
    };
    fetchData();
  }, []);

  const barData = [
    { name: "입고량", value: summary.inbound },
    { name: "출고량", value: summary.outbound },
    { name: "총 거래량", value: summary.total },
  ];

  return (
    <div style={{ textAlign: "center" }}>
      <h2>📊 거래 물동량 요약</h2>

      {/* 요약 수치 */}
      <div style={{ marginBottom: "15px" }}>
        <p>입고량: {summary.inbound.toLocaleString()} 톤</p>
        <p>출고량: {summary.outbound.toLocaleString()} 톤</p>
        <p>총 거래량: {summary.total.toLocaleString()} 톤</p>
      </div>

      {/* 요약 그래프 */}
      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={barData}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="name" />
          <YAxis />
          <Tooltip formatter={(value: number) => `${value.toLocaleString()} 톤`} />
          <Legend />
          <Bar dataKey="value" fill="#4A90E2" barSize={60} />
        </BarChart>
      </ResponsiveContainer>

      <h3 style={{ marginTop: "40px" }}>📈 일자별 거래 추세</h3>

      {/* 일자별 거래 추세 (라인차트) */}
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={dailyData}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="day" />
          <YAxis />
          <Tooltip formatter={(value: number) => `${value.toLocaleString()} 톤`} />
          <Legend />
          <Line type="monotone" dataKey="inbound" stroke="#4A90E2" name="입고량" />
          <Line type="monotone" dataKey="outbound" stroke="#E94E77" name="출고량" />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
