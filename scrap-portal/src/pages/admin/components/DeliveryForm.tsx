import { useState } from "react";
import axios from "axios";

export default function DeliveryForm({ transactionId }: { transactionId: number }) {
  const [form, setForm] = useState({
    supplier_name: "",
    supplier_phone: "",
    origin_location: "",
    vehicle_number: "",
    driver_name: "",
    delivered_weight: "",
    qualified_weight: "",
    quality_type: 1,
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async () => {
    await axios.post("/api/deliveries", { ...form, transaction_id: transactionId });
    alert("이송 정보가 등록되었습니다!");
  };

  return (
    <div>
      <input name="supplier_name" placeholder="공급자명" onChange={handleChange} />
      <input name="supplier_phone" placeholder="연락처" onChange={handleChange} />
      <input name="origin_location" placeholder="출발지" onChange={handleChange} />
      <input name="vehicle_number" placeholder="차량번호" onChange={handleChange} />
      <input name="driver_name" placeholder="운전자명" onChange={handleChange} />
      <input name="delivered_weight" placeholder="배송 중량(kg)" onChange={handleChange} />
      <input name="qualified_weight" placeholder="인정 중량(kg)" onChange={handleChange} />
      <button onClick={handleSubmit}>이송 등록</button>
    </div>
  );
}
