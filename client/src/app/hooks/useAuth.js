import { useContext } from 'react';
import AuthContext from '../contexts/JWTAuthContext';

// Hook utilizado para utilizar os métodos de autenticação, do contexto
const useAuth = () => useContext(AuthContext);

export default useAuth;
