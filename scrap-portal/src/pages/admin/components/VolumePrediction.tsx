import { useEffect, useState } from "react";
import axios from "axios";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

interface Prediction {
  my_inventory: number;
  region_inventory: number;
  total_inventory: number;
}

export default function VolumePrediction() {
  const [prediction, setPrediction] = useState<Prediction | null>(null);

  useEffect(() => {
    axios.get(`${API_BASE_URL}/api/admin/volumes/predictions`)
      .then((res) => setPrediction(res.data))
      .catch((err) => console.error(err));
  }, []);

  if (!prediction) return <p>AI 예측 데이터를 불러오는 중...</p>;

  return (
    <div>
      <h2>AI 예측 물동량</h2>
      <p>나의 재고량: {prediction.my_inventory}</p>
      <p>지역 재고량: {prediction.region_inventory}</p>
      <p>총 재고량: {prediction.total_inventory}</p>
    </div>
  );
}
