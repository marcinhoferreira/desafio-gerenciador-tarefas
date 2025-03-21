import axios from 'axios';

// Instãncia axios, para consumo da api
const api = axios.create({
    baseURL: import.meta.env.VITE_APP_API_BASE_URL,
});

export default api;