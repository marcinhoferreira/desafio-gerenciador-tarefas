import { useRoutes } from 'react-router-dom';
import { AuthProvider } from './contexts/JWTAuthContext';
import routes from './Routes';
import './App.css';

const App = () => {
    const content = useRoutes(routes); // Carrega as rotas do app

    return (
        // compartilha o provedor de autenticação, com o restante do app
        <AuthProvider>
            {content}
        </AuthProvider>
    );
}

export default App;
