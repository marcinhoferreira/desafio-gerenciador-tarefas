import React, { useState } from 'react';
import useAuth from '../../hooks/useAuth';
import { Button, Container, Typography } from '@mui/material';
import { useSnackbar } from 'notistack';
import TaskList from '../task/TaskList';
import { useNavigate } from 'react-router-dom';

const Home = () => {	
    const { user, logout } = useAuth();
	const { enqueueSnackbar } = useSnackbar();
	const [ isLoading, setIsLoading ] = useState(false);
	const navigate = useNavigate();

	const handleExitButtonClick = () => {
		setIsLoading(true);
		try {
			logout();
			enqueueSnackbar('Desconectado com sucesso!', { variant: 'success' });
			navigate('/signin');
		} catch (error) {
			const { message } = error;
			enqueueSnackbar(message, { variant: 'error' });
		} finally {
			setIsLoading(false);
		}
	}

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