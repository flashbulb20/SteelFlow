import { useEffect, useState, useRef } from "react";
import axios from "axios";
import * as d3 from "d3";
import "../../../css/volumeStats.css";
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;


interface GeoFeature {
  type: string;
  properties: { NAME_1: string };
  geometry: any;
}

interface RegionStat {
  region: string;       // 예: "부산 야드", "인천 항만"
  scrap_type: string;   // 예: "고급재", "저급재"
  inventory: number;    // 수량
}

interface RegionSummary {
  region: string;
  total: number;
  details: Record<string, number>; // { 고급재: 1000, 저급재: 2000, ... }
}

export default function VolumeStats() {
  const [geoData, setGeoData] = useState<GeoFeature[]>([]);
  const [regionStats, setRegionStats] = useState<RegionSummary[]>([]);
  const [selected, setSelected] = useState<string | null>(null);
  const [showPanel, setShowPanel] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const panelRef = useRef<HTMLDivElement>(null);

  // ✅ API에서 지역별 데이터 가져오기
  useEffect(() => {
    const fetchStats = async () => {
      try {
        const res = await axios.get<RegionStat[]>(`${API_BASE_URL}/api/admin/volumes/stats`);
        const grouped = res.data.reduce((acc: Record<string, RegionSummary>, cur) => {
          const shortRegion = cur.region.slice(0, 2); // "부산 야드" → "부산"
          if (!acc[shortRegion]) {
            acc[shortRegion] = { region: shortRegion, total: 0, details: {} };
          }
          acc[shortRegion].total += cur.inventory;
          acc[shortRegion].details[cur.scrap_type] =
            (acc[shortRegion].details[cur.scrap_type] || 0) + cur.inventory;
          return acc;
        }, {});
        setRegionStats(Object.values(grouped));
      } catch (err: any) {
        setError(err.message);
      }
    };

    fetchStats();
  }, []);

  // ✅ 지도 데이터 로드
  useEffect(() => {
    fetch(`${import.meta.env.BASE_URL}korea-provinces.json`)
      .then((res) => res.json())
      .then((data) => setGeoData(data.features))
      .catch((err) => setError(err.message));
  }, []);

  const projection = d3.geoMercator()
    .center([128, 36])
    .scale(8500)
    .translate([400, 500]);

  const path = d3.geoPath().projection(projection);

  const regionNameMap: Record<string, string> = {
    "Seoul": "서울", "Busan": "부산", "Daegu": "대구", "Incheon": "인천",
    "Gwangju": "광주", "Daejeon": "대전", "Ulsan": "울산", "Gyeonggi-do": "경기",
    "Gangwon-do": "강원", "Chungcheongbuk-do": "충북", "Chungcheongnam-do": "충남",
    "Jeollabuk-do": "전북", "Jeollanam-do": "전남", "Gyeongsangbuk-do": "경북",
    "Gyeongsangnam-do": "경남", "Jeju": "제주", "Sejong": "세종"
  };

  const colorMap: Record<string, string> = {
    "서울": "#0096c7", "부산": "#00b4d8", "대구": "#0077b6", "인천": "#48cae4",
    "광주": "#90e0ef", "대전": "#caf0f8", "울산": "#76c893", "경기": "#57cc99",
    "강원": "#80ed99", "충북": "#b5e48c", "충남": "#90be6d", "전북": "#f6bd60",
    "전남": "#f4a261", "경북": "#f28482", "경남": "#e5989b", "제주": "#ffb4a2",
    "세종": "#ffd6a5",
  };

  const selectedRegion = regionStats.find((r) => r.region === selected);

  const handleSelectRegion = (name: string) => {
    setSelected(name);
    setShowPanel(true);
  };

  // ✅ 패널 외부 클릭 시 닫기
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (panelRef.current && !panelRef.current.contains(event.target as Node)) {
        setShowPanel(false);
        setTimeout(() => setSelected(null), 300);
      }
    };
    if (showPanel) document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, [showPanel]);

  return (
    <div className="map-page-modal">
      <h2>📦 지역별 물동량 현황</h2>
      {error && <p className="error-text">{error}</p>}

      <svg viewBox="0 0 800 1000" className="korea-svg">
        {geoData.map((feature, idx) => {
          const rawName = feature.properties.NAME_1;
          const name = regionNameMap[rawName] || rawName;
          const d = path(feature as any);
          if (!d) return null;
          const centroid = path.centroid(feature as any);
          const color = colorMap[name] || "#ccc";
          const active = selected === name;

          return (
            <g key={idx} onClick={() => handleSelectRegion(name)}>
              <path
                d={d}
                fill={active ? "#023e8a" : color}
                stroke="#fff"
                strokeWidth={active ? 3 : 1.2}
                className="region-shape"
              />
              {centroid && (
                <text
                  x={centroid[0]}
                  y={centroid[1]}
                  textAnchor="middle"
                  className="region-label"
                >
                  {name}
                </text>
              )}
            </g>
          );
        })}
      </svg>

      {/* 오른쪽 정보 패널 */}
      <div ref={panelRef} className={`info-slide ${showPanel ? "show" : ""}`}>
        {selectedRegion && (
          <div className="info-content">
            <h3>{selectedRegion.region} 지역 재고 현황</h3>
            <p className="volume-text">
              총 재고량: <strong>{selectedRegion.total.toLocaleString()} 톤</strong>
            </p>
            {Object.entries(selectedRegion.details).map(([type, weight]) => (
              <p key={type}>🔹 {type}: {weight.toLocaleString()} 톤</p>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
