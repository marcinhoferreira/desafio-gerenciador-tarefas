import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './app/App';
import './index.css';
import { SnackbarProvider } from 'notistack';

const root = createRoot(document.getElementById('root'));

root.render(
    <StrictMode>
        <BrowserRouter>
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