import { Navigate, useLocation } from 'react-router-dom';

// Função utilizada para redirecionar o app para a rota
const Redirect = () => {
    const location = useLocation();
    const from = location.state?.from || '/home';
    return <Navigate to={from} />;
};

export default Redirect;
