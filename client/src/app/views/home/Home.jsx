import React, { useState } from 'react';
import useAuth from '../../hooks/useAuth';
import { Container, Typography } from '@mui/material';
import { useSnackbar } from 'notistack';
import TaskList from '../task/TaskList';

const Home = () => {	
    const { user } = useAuth();
	const { enqueueSnackbar } = useSnackbar();
	const [ isLoading, setIsLoading ] = useState(false);

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
			<TaskList/>
		</Container>
    );
}

export default Home;