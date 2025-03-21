import { Navigate, useLocation } from 'react-router-dom';

const Redirect = () => {
    let location = useLocation();
    const from = location.state?.from || '/home';
    return <Navigate to={from} />;
};

export default Redirect;
