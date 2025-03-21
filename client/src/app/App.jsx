import { useState } from 'react';
import { useRoutes } from 'react-router-dom';
import { AuthProvider } from './contexts/JWTAuthContext';
import routes from './Routes';
import './App.css';

const App = () => {
    const content = useRoutes(routes);

    return (
        <AuthProvider>
            {content}
        </AuthProvider>
    );
}

export default App;
