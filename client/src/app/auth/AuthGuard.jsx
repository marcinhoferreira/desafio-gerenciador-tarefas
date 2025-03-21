import { Navigate, useLocation } from 'react-router-dom';
import useAuth from '../hooks/useAuth';

// Função para permitir acesso às rotas do app, somente após a autenticação
const AuthGuard = ({ children }) => {
    const { pathname } = useLocation();
     // extrai a variável de estado da autenticação
    const { isAuthenticated } = useAuth();

     // se já estiver autenticado, redireciona para rota filha
    if (isAuthenticated) return <>{children}</>;

     // se não estiver autenticado, redireciona para a tela de login
    return <Navigate replace to='/signin' state={{ from: pathname }} />;
};

export default AuthGuard;
