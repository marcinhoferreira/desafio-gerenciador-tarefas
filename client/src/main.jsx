import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './app/App';
import './index.css';
import { SnackbarProvider } from 'notistack';

// Elemento root da aplicação, todas as páginas serão renderizdas aqui
const root = createRoot(document.getElementById('root'));

// Renderiza o app
root.render(
    <StrictMode>
        {/* Habilita a navegação do app */}
        <BrowserRouter>
            {/* Provedor de mensagens toast. As mensagens aparecerão no topo e à esquerda da tela */}
            <SnackbarProvider
                anchorOrigin={
                    { horizontal: 'right', vertical: 'top' }
                }
            >
                <App />
            </SnackbarProvider>
        </BrowserRouter>
    </StrictMode>,
);