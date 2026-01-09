/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
  // 다른 변수가 있다면 여기에 추가합니다.
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}