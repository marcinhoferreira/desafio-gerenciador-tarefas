import { Navigate, useLocation } from 'react-router-dom';
import useAuth from '../hooks/useAuth';

const AuthGuard = ({ children }) => {
  const { pathname } = useLocation();
  const { isAuthenticated } = useAuth();

  if (isAuthenticated) return <>{children}</>;

  return <Navigate replace to='/signIn' state={{ from: pathname }} />;
};

export default AuthGuard;
