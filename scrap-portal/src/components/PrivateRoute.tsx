import { Navigate } from "react-router-dom";

interface PrivateRouteProps {
  children: React.ReactNode;
  requiredRole?: "admin" | "user";
}

export default function PrivateRoute({ children, requiredRole }: PrivateRouteProps) {
  const token = localStorage.getItem("token");
  const user = token ? JSON.parse(localStorage.getItem("user") || "{}") : null;

  if (!token) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole && user?.role !== requiredRole) {
    return <Navigate to="/" replace />;
  }

  return children;
}
