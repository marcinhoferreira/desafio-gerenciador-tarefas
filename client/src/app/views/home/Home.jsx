import React, { useState } from 'react';
import useAuth from '../../hooks/useAuth';
import { Button, Container, Typography } from '@mui/material';
import { useSnackbar } from 'notistack';
import TaskList from '../task/TaskList';
import { useNavigate } from 'react-router-dom';

// Página inicial da aplicação. Acessível somenta após o login
const Home = () => {
	// Extrai o user e a função logout, do hook autenticação
    const { user, logout } = useAuth();
	// Extrai a função para exibição de mensagens em toast
	const { enqueueSnackbar } = useSnackbar();
	// Variávl de estado utilizada para desabilitar controles, quando necessário
	const [ isLoading, setIsLoading ] = useState(false);
	// função de navegação entre as rotas do app
	const navigate = useNavigate();
	// função executada ao clicar no botão sair
	const handleExitButtonClick = () => {
		// isLoading = true -> desabilita os controles
		setIsLoading(true);
		try {
			// Executa o logout
			logout();
			// Exibe mensagem de operação realizada
			enqueueSnackbar('Desconectado com sucesso!', { variant: 'success' });
			// Redireciona para a tela de login
			navigate('/signin');
		} catch (error) {
			// Extrai a mensagem de erro
			const { message } = error;
			// Exibe a mensagem de erro, em toast
			enqueueSnackbar(message, { variant: 'error' });
		} finally {
			// isLoading = false -> habilita os controles
			setIsLoading(false);
		}
	}

	// Retorno da função: o JSX renderizado
    return (
  	    <Container>
			<Typography
				 sx={
					{ mt: 2 }
				}
				variant='h4'
				align='center'
			>
				Olá, {user.name}!
			</Typography>
			<Typography
				variant='body1'
				align='center'
			>
				Seja bem-vindo ao sistema de gerenciamento de tarefas.
			</Typography>
			<Button
				color='primary'
				variant='contained'
				loading={isLoading}
				loadingIndicator='Aguarde...'
				onClick={() => {
					handleExitButtonClick();
				}}
			>
				Sair
			</Button>
			<TaskList/>
		</Container>
    );
}

export default Home;