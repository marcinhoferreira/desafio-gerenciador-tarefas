import React, { useState } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { Box, Button, Card, FormControl, FormControlLabel, FormLabel, Radio, RadioGroup, TextField, Typography } from '@mui/material';
import { Formik } from 'formik';
import * as Yup from 'yup';
import { FlexBox } from '../../components/FlexBox';
import { useSnackbar } from 'notistack';
import { api } from '../../services';
import useAuth from '../../hooks/useAuth';

// Esquema de validação das entradas de dados
const validationSchema = Yup.object().shape({
    title: Yup.string()
        .required('É obrigatório informar o t´´itulo da tarefa!'),
    description: Yup.string()
        .required('É obrigatório informar a descrição da tarefa!'),
});

// Função de renderização do form de task
const TaskForm = () => {
    const { id } = useParams();
    const location = useLocation();
    const { state } = location;
    const { user } = useAuth();
    const [ isLoading, setIsLoading ] = useState(false);
    const { enqueueSnackbar } = useSnackbar();
    const navigate = useNavigate();

    // Funcção que submete os dados do formulário à api
    const handleFormSubmit = async (values) => {
        // Desabilita controles
        setIsLoading(true);
        try {
            let response = null;
            if (state.action === 'create') {
                response = await api.post('/Task', values);                
                if (response.status === 201) {
                    enqueueSnackbar('Tarefa Criada com Sucesso!', { variant: 'success' });
                    navigate(-1);
                }
            } else {
                response = await api.put(`/Task/${id}`, values);
                if (response.status === 200) {
                    enqueueSnackbar('Tarefa Atualizada com Sucesso!', { variant: 'success' });
                    navigate(-1);
                }
            }
        } catch (error) {
            // Extrai a mensagem de erro
            const { message } = error;
            // Exibe a mensagem de erro, em toast
            enqueueSnackbar(message, { variant: 'error' });
        } finally {
            // Habilita controles
            setIsLoading(false);
        }
    }

    return (
        <Box
            sx={
                { padding: '1rem', color: 'inherit', backgroundColor: 'white' }
            }
        >
            <Typography
                variant='h5'
                color='primary'
                fontWeight={'bold'}
            >
                {
                    state.action === 'create' ? 'Criar Tarefa' : 'Editar Tarefa'
                }
            </Typography>
            <Formik
                initialValues={
                    {
                        userId: user.id || null,
                        title: state.data?.title || '',
                        description: state.data?.description || '',
                        priority: state.data?.priority || 'LOW',
                        status: state.data?.status || 'PENDING'
                    }
                }
                validationSchema={validationSchema}
                onSubmit={handleFormSubmit}
            >
                {
                    ({ values, errors, touched, handleChange, handleBlur, handleSubmit }) => (
                        <form
                            onSubmit={handleSubmit}
                        >
                            <Card
                                sx={
                                    { padding: '1rem' }
                                }
                            >
                                <TextField
                                    sx={
                                        { marginTop: '1rem' }
                                    }
                                    name='title'
                                    type='text'
                                    size='small'
                                    label='Título'
                                    placeholder='Digite o título da tarefa'
                                    value={values.title}
                                    onBlur={handleBlur}
                                    onChange={handleChange}
                                    InputLabelProps={
                                        { shrink: true }
                                    }
                                    helperText={touched.title && errors.title}
                                    error={Boolean(errors.title && touched.title)}
                                    fullWidth
                                />
                                <TextField
                                    sx={
                                        { marginTop: '1rem' }
                                    }
                                    name='description'
                                    type='text'
                                    size='small'
                                    label='Descrição'
                                    placeholder='Descreva a tarefa'
                                    value={values.description}
                                    multiline
                                    rows={3}
                                    onBlur={handleBlur}
                                    onChange={handleChange}
                                    InputLabelProps={
                                        { shrink: true }
                                    }
                                    helperText={touched.description && errors.description}
                                    error={Boolean(errors.description && touched.description)}
                                    fullWidth
                                />
                                <FlexBox
                                    marginTop={ '1rem' }
                                    gap={ '0.5rem' }
                                >
                                    <FormControl>
                                        <FormLabel>
                                            Prioridade
                                        </FormLabel>
                                        <RadioGroup
                                            sx={
                                                { border: 1, padding: 2, flexDirection: 'row' }
                                            }
                                            name='priority'
                                            value={values.priority}
                                            onChange={handleChange}
                                        >
                                            <FormControlLabel
                                                label='Baixa'
                                                value={'LOW'}
                                                control={<Radio />}
                                            />
                                            <FormControlLabel
                                                label='Alta'
                                                value={'HIGH'}
                                                control={<Radio />}
                                            />
                                        </RadioGroup>
                                    </FormControl>
                                    <FormControl>
                                        <FormLabel>
                                            Status
                                        </FormLabel>
                                        <RadioGroup
                                            sx={
                                                { border: 1, padding: 2, flexDirection: 'row' }
                                            }
                                            name='status'
                                            value={values.status}
                                            onChange={handleChange}
                                        >
                                            <FormControlLabel
                                                label='Pendente'
                                                value={'PENDING'}
                                                control={<Radio
                                                />}
                                            />
                                            <FormControlLabel
                                                label='Em andamento'
                                                value={'INPROGRESS'}
                                                control={<Radio/>}
                                            />
                                            <FormControlLabel
                                                label='Concluído'
                                                value={'COMPLETED'}
                                                control={<Radio/>}
                                            />
                                        </RadioGroup>
                                    </FormControl>
                                </FlexBox>
                            </Card>
                            <FlexBox
                                marginTop={ '1rem' }
                                flexDirection={'row'}
                                alignItems={'flex-end'}
                                gap={ '0.5rem' }
                            >
                                <Button
                                    id='save-button'
                                    type='submit'
                                    color='success'
                                    variant='contained'
                                    loading={isLoading}
                                    loadingIndicator='Aguarde...'
                                >
                                    Gravar
                                </Button>
                                <Button
                                    id='cancel-button'
                                    color='error'
                                    variant='contained'
                                    loading={isLoading}
                                    loadingIndicator='Aguarde...'
                                    onClick={() => navigate(-1)}
                                >
                                    Desistir
                                </Button>
                            </FlexBox>
                        </form>
                    )
                }
            </Formik>
        </Box>
    );
}

export default TaskForm;