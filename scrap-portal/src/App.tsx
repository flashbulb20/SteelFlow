import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Portal from "./pages/Portal";
import Login from "./pages/Login";
import Signup from "./pages/Signup";
import FAQ from "./pages/FAQ";
import Profile from "./pages/Profile";
import AdminDashboard from "./pages/admin/AdminDashboard";
import Transactions from "./pages/admin/Transactions";
import Certifications from "./pages/admin/Certifications";
import Volumes from "./pages/admin/Volumes";
import AiModel from "./pages/admin/AiModel";
import ImportService from "./pages/admin/ImportService";
import PrivateRoute from "./components/PrivateRoute";
import UserDashboard from "./pages/user/UserDashboard";
import UserTransactions from "./pages/user/UserTransactions";
import UserCertifications from "./pages/user/UserCertifications";
import UserVolumes from "./pages/user/UserVolumes";

function App() {
  return (
    <Router>
      <Routes>
        {/* 기본 포털 페이지 */}
        <Route path="/" element={<Portal />} />
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/faq" element={<FAQ />} />

        {/* 운영자(Admin) 전용 페이지 */}
        <Route
          path="/admin"
          element={
            <PrivateRoute requiredRole="admin">
              <AdminDashboard />
            </PrivateRoute>
          }
        />
        <Route
          path="/admin/transactions"
          element={
            <PrivateRoute requiredRole="admin">
              <Transactions />
            </PrivateRoute>
          }
        />
        <Route
          path="/admin/certifications"
          element={
            <PrivateRoute requiredRole="admin">
              <Certifications />
            </PrivateRoute>
          }
        />
        <Route
          path="/admin/volumes"
          element={
            <PrivateRoute requiredRole="admin">
              <Volumes />
            </PrivateRoute>
          }
        />
        <Route
          path="/admin/ai-model"
          element={
            <PrivateRoute requiredRole="admin">
              <AiModel />
            </PrivateRoute>
          }
        />
        <Route
          path="/admin/import-service"
          element={
            <PrivateRoute requiredRole="admin">
              <ImportService />
            </PrivateRoute>
          }
        />

        {/* 사용자(User) 전용 페이지 */}
        <Route
          path="/user"
          element={
            <PrivateRoute requiredRole="user">
              <UserDashboard />
            </PrivateRoute>
          }
        />
        <Route
          path="/user/transactions"
          element={
            <PrivateRoute requiredRole="user">
              <UserTransactions />
            </PrivateRoute>
          }
        />
        <Route
          path="/user/certifications"
          element={
            <PrivateRoute requiredRole="user">
              <UserCertifications />
            </PrivateRoute>
          }
        />
        <Route
          path="/user/volumes"
          element={
            <PrivateRoute requiredRole="user">
              <UserVolumes />
            </PrivateRoute>
          }
        />
        {/* 프로필 페이지 (운영자/사용자 모두 접근 가능) */}
        <Route
          path="/profile"
          element={
            <PrivateRoute> {/* 사용자 & 운영자 둘 다 허용할 경우 조정 필요 */}
              <Profile />
            </PrivateRoute>
          }
        />
      </Routes>
    </Router>
  );
}

export default App;
