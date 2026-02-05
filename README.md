# 🏭 SteelFlow: 실시간 철자원 물동량 모니터링 시스템

> **AI 비전 기술 기반의 철스크랩 재고 추적 및 통합 거래 관리 플랫폼**

![Project Status](https://img.shields.io/badge/Status-Prototype-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📖 프로젝트 개요 (Project Overview)

**SteelFlow**는 철강 산업 현장에서 불투명하게 관리되던 철스크랩의 물동량을 디지털화하여 실시간으로 모니터링하는 통합 시스템입니다.  
AI 분석 데이터를 기반으로 야적장의 재고를 시각화하고, 공급-수요 간의 거래 프로세스를 웹(Web)과 모바일(App)로 연결하여 업무 효율성을 극대화합니다.

### 🎯 주요 해결 과제
* **가시성 확보:** 수작업으로 관리되던 야드 내 재고 위치 및 중량을 실시간 히트맵으로 시각화
* **업무 효율화:** 전화/문자로 이루어지던 매입/매출 거래를 디지털 플랫폼으로 전환
* **데이터 통합:** 분산된 물동량 데이터를 수집하여 통계 및 예측 대시보드 제공

---

## 🛠 기술 스택 (Tech Stack)

### Backend
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=flat&logo=fastapi) ![Python](https://img.shields.io/badge/Python-3.12-3776AB?style=flat&logo=python) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=flat&logo=postgresql) ![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-Red?style=flat)
* **API Server:** FastAPI (Async/Await 기반 비동기 처리)
* **Database:** PostgreSQL (복합 쿼리 및 트랜잭션 관리)
* **Auth:** OAuth2 + JWT (Role-based Security)

### Frontend (Web Admin)
![React](https://img.shields.io/badge/React-20232A?style=flat&logo=react&logoColor=61DAFB) ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat&logo=typescript&logoColor=white) ![D3.js](https://img.shields.io/badge/D3.js-F9A03C?style=flat&logo=d3.js&logoColor=white) ![Vite](https://img.shields.io/badge/Vite-646CFF?style=flat&logo=vite&logoColor=white)
* **Framework:** React + TypeScript
* **Visualization:** D3.js (GeoJSON 기반 재고 히트맵), Recharts (물동량 차트)
* **State Management:** Context API & Custom Hooks

### Frontend (Mobile App)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
* **Framework:** Flutter (Android/iOS Cross-platform)
* **Features:** 실시간 거래 요청, 내 물동량 확인, Push 알림 UI

---

## 📂 프로젝트 구조 (Project Structure)

```bash
SteelFlow/
├── backend/            # FastAPI Backend Server
│   ├── routers/        # API Endpoints (Auth, Users, Transactions, etc.)
│   ├── database.py     # DB Connection & Session
│   ├── models.py       # SQLAlchemy ORM Models
│   └── main.py         # App Entry Point
├── scrap-portal/       # React Admin Web Portal
│   ├── src/
│   │   ├── pages/      # Dashboard, Map, Transaction Pages
│   │   ├── components/ # Reusable UI Components
│   │   └── services/   # API Integration Logic
├── scrap_mobile/       # Flutter User Mobile App
│   ├── lib/
│   │   ├── screens/    # App Screens (Login, Dashboard)
│   │   ├── providers/  # State Management
│   │   └── services/   # API Services
└── postgresql/         # Database Initialization Scripts
```

## 🖥 주요 기능 (Key Features)
1. 웹 관리자 포털 (Web Admin Portal)
대시보드: 금일 입출고량, 총 거래량 등 핵심 KPI 실시간 집계

재고 히트맵: 대한민국 지도 기반 야드별 재고 밀도 시각화 (D3.js)

거래 승인: 사용자로부터 들어온 매입/매출 요청 검토 및 계약 체결(Digital Signing)

물동량 분석: 기간별, 품목별 물동량 추이 그래프 제공

2. 모바일 사용자 앱 (Mobile User App)
거래 요청: 언제 어디서나 판매/구매 제안서 등록

현황 조회: 내 거래 진행 상황(요청-심사-체결) 실시간 확인

실적 확인: 월별/연도별 나의 물동량 리포트 조회

3. 백엔드 시스템 (Backend System)
데이터 파이프라인: CSV 및 외부 AI 서버 데이터 수집/적재

보안: JWT 기반 세션 관리 및 비밀번호 암호화(Bcrypt)

## 🚀 설치 및 실행 가이드 (Getting Started)
[실행법 문서를 참고하세요](%28실행법%29실시간%20철%20스크랩%20물동량%20모니터링%20시스템%20실행%20방법.docx)


## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
