import { useEffect, useState } from "react";
import Papa from "papaparse";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";

interface MonthlyData {
  name: string;
  철강재: number;
  전철강: number;
  연도: string;
}

interface YearlyData {
  year: string;
  months: MonthlyData[];
}

export default function VolumeChart() {
  const [data, setData] = useState<YearlyData[]>([]);
  const [year, setYear] = useState<string>("2024");

  const parseNumber = (value?: string): number => {
    if (!value) return 0;
    const cleaned = value.replace(/[^0-9.-]/g, "");
    return parseFloat(cleaned) || 0;
  };

  useEffect(() => {
    fetch("/assets/tendency_year.csv")
      .then((response) => response.text())
      .then((csvText) => {
        const results = Papa.parse(csvText, {
          header: false,
          skipEmptyLines: true,
        });

        const rows = results.data as string[][];
        const filteredRows = rows.filter((r) => r[0] && /^\d{4}$/.test(r[0]));

        const parsedData: YearlyData[] = filteredRows.map((row) => {
          const year = row[0];
          const months = Array.from({ length: 12 }, (_, i) => ({
            name: `${i + 1}월`,
            철강재: parseNumber(row[9 + i * 8]),
            전철강: parseNumber(row[10 + i * 8]),
            연도: year,
          }));
          return { year, months };
        });

        setData(parsedData);
      })
      .catch((error) => console.error("CSV 로드 오류:", error));
  }, []);

  const currentYearData = data.find((d) => d.year === year)?.months || [];

  return (
    <div style={{ padding: "20px" }}>
      <h2>📈 철강재 / 전철강 월별 물동량</h2>

      {data.length > 0 && (
        <div style={{ marginBottom: "10px" }}>
          <label>연도 선택: </label>
          <select
            value={year}
            onChange={(e) => setYear(e.target.value)}
            style={{ marginLeft: "10px" }}
          >
            {data.map((d) => (
              <option key={d.year} value={d.year}>
                {d.year}
              </option>
            ))}
          </select>
        </div>
      )}

      {currentYearData.length > 0 && (
        <div style={{ width: "100%", height: 400 }}>
          <ResponsiveContainer>
            <LineChart data={currentYearData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line type="monotone" dataKey="철강재" stroke="#8884d8" />
              <Line type="monotone" dataKey="전철강" stroke="#82ca9d" />
            </LineChart>
          </ResponsiveContainer>
        </div>
      )}
    </div>
  );
}
