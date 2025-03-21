import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle, Grid2 } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import { useSnackbar } from 'notistack';
import useAuth from '../../hooks/useAuth';
import TaskCard from '../../components/TaskCard';
import { FlexBox } from '../../components/FlexBox';
import { api } from '../../services';

const TaskList = () => {
    const { user } = useAuth();
	const [ tasks, setTasks ] = useState([]);
    const [ taskId, setTaskId ] = useState('');
	const [ dialogTitle, setDialogTitle ] = useState('');
	const [ openDialog, setOpenDialog ] = useState(false);
	const { enqueueSnackbar } = useSnackbar();
	const [ isLoading, setIsLoading ] = useState(false);
    const navigate = useNavigate();

	const getTasks = async () => {
		setIsLoading(true);
		try {
			const response = await api.get('/Task');
			if (response.status === 200) {
				const { data } = response.data;
				setTasks(data);
			}	
		} catch (error) {
			const { message } = error;
			enqueueSnackbar(message, { variant: 'error' });
		} finally {
			setIsLoading(false);
		}
	}

    const handleCreateButtonClick = () => {
        navigate('/task', {
            state: {
                action: 'create'
            }
        });
    }

    const handleEditButtonClick = (row) => {
        navigate(`/task/${row.id}`, {
            state: {
                action: 'update',
                data: row
            }
        });
    }

    const handleDeleteButtonClick = (row) => {
        setTaskId(row.id);
        setOpenDialog(true);
    }

    const handleDelete = async () => {
        setIsLoading(true);
        try {
            const response = await api.delete(`/Task/${taskId}`);
            if (response.status === 200) {
                enqueueSnackbar('Tarefa Excluída com Sucesso!', { variant: 'success' });
                await getTasks();
                setOpenDialog(false);
            }
        } catch (error) {
            const { message } = error;
            enqueueSnackbar(message, { variant: 'error' });
        } finally {            
            setIsLoading(false);            
        }
    }

	useEffect(() => {
		getTasks();
	}, []);

    return (
  	    <Box
            sx={
                { margin: '1rem' }
            }
        >
			<FlexBox>
				<Button
                    id='create-button'			
					color='primary'
					variant='contained'
                    onClick={() => {
                        handleCreateButtonClick();
                    }}
				>
					<AddIcon
						fontSize='medium'
					/>
					<span>Nova Tarefa</span>
				</Button>
			</FlexBox>
			<Grid2
				container
				direction='column'
				justifyContent='center'
				alignItems='center'
			>
				<Grid2
					item
					xs={12}
					md={8}
					lg={4}
				>
					{
						tasks.map((task, index) => (
                            <FlexBox
                                sx={
                                    { backgroundColor: 'white' }
                                }
                                key={index}
                                flexDirection={'column'}
                                padding={ '1rem' }
                                margin={ '1rem' }
                            >
                                <TaskCard
                                    key={`tarefa-${task.id}`}
                                    task={task}
                                />
                                <FlexBox
                                    key={`toolbar-${index}`}
                                    gap={ '0.5rem' }
                                >
                                    <Button
                                        color='primary'
                                        variant='contained'
                                        onClick={() => {
                                            handleEditButtonClick(task);
                                        }}
                                    >
                                        <EditIcon />
                                        Editar
                                    </Button>
                                    <Button
                                        color='error'
                                        variant='contained'
                                        onClick={() => {
                                            handleDeleteButtonClick(task);
                                        }}
                                    >
                                        <DeleteIcon />
                                        Deletar
                                    </Button>
                                </FlexBox>
                            </FlexBox>
						))
					}
				</Grid2>
			</Grid2>
            <Dialog
                open={openDialog}
                onClose={() => {
                    setOpenDialog(false);
                }}
            >
                <DialogTitle>
                    Excluir Tarefa
                </DialogTitle>
                <DialogContent>
                    <DialogContentText>
                        Confirma Exclusão da Tarefa?
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button
                        color='error'
                        variant='contained'
                        loading={isLoading}
                        loadingIndicator='Aguarde...'
                        onClick={() => {
                            handleDelete();
                        }}
                    >
                        Excluir
                    </Button>
                    <Button
                        color='primary'
                        variant='outlined'
                        loading={isLoading}
                        loadingIndicator='Aguarde...'
                        onClick={() => {
                            setOpenDialog(false);
                        }}
                    >
                        Desistir
                    </Button>
                </DialogActions>
            </Dialog>
		</Box>
    );
}

export default TaskList;