import { useState } from "react";

export default function UserVolumes() {
  const [stock, setStock] = useState<number>(0);
  const [outbound, setOutbound] = useState<number>(0);

  return (
    <div style={{ padding: "20px" }}>
      <h2>물동량 입력</h2>

      <div>
        <label>
          재고량 입력:
          <input
            type="number"
            value={stock}
            onChange={(e) => setStock(Number(e.target.value))}
          />
        </label>
      </div>

      <div>
        <label>
          출고량 입력:
          <input
            type="number"
            value={outbound}
            onChange={(e) => setOutbound(Number(e.target.value))}
          />
        </label>
      </div>

      <p>총 물동량: {stock - outbound} 톤</p>
    </div>
  );
}
