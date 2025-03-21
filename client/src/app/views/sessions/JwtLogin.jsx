import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import useAuth from '../../hooks/useAuth';
import { Grid2, TextField, Typography } from '@mui/material';
import { Button } from '@mui/material';
import { Formik } from 'formik';
import * as Yup from 'yup';
import { FlexBox } from '../../components/FlexBox';
import { useSnackbar } from 'notistack';

const validationSchema = Yup.object().shape({
    username: Yup.string().required('Digite o seu nome de usuário'),
    password: Yup.string().required('Digite a sua senha')
});

const JwtLogin = () => {
    const { login } = useAuth();
    const navigate = useNavigate();
    const { enqueueSnackbar } = useSnackbar();
    const [ isLoading, setIsLoading ] = useState(false);

    const handleFormSubmit = async (values) => {
        setIsLoading(true);
        try {
            await login(values.username, values.password);
            enqueueSnackbar('Conectado com sucesso', { variant: 'success' });
            navigate('/');
        } catch (error) {
            const{ message } = error;
            enqueueSnackbar(message, { variant: 'error' });
        } finally {
            setIsLoading(false);
        }
    }

    return (
        <Grid2
            container                
            direction='column'
            justifyContent='center'
            alignItems='center'
        >
            <Grid2
                sx={
                    {
                        flexDirection: 'column',
                        padding: '1rem',
                        backgroundColor: 'white',                             
                        color: 'black',
                        borderRadius: '5px'
                    }
                }
                item
                xs={12}
                md={8}
                lg={4}                    
                justifyContent={'center'}
                alignItems={'center'}
            >
                <Typography
                    variant='h6'
                    color='inherit'
                    align='center'
                >
                    Acesso ao Aplicativo
                </Typography>
                <Formik
                    initialValues={{
                        username: '',
                        password: '',
                    }}
                    validationSchema={validationSchema}
                    onSubmit={handleFormSubmit}
                >
                    {({ values, handleBlur, handleChange, handleSubmit }) => (
                        <form
                            onSubmit={handleSubmit}
                        >
                            <FlexBox
                                marginTop={'1rem'}
                                marginBottom={'1rem'}
                                flexDirection={'column'}
                                justifyContent='center'
                                alignItems='center'
                                gap={'1rem'}
                            >
                                <TextField
                                    type='text'
                                    name='username'
                                    size='small'
                                    variant='outlined'
                                    placeholder='Digite o seu nome de usuário'
                                    value={values.username}
                                    onBlur={handleBlur}
                                    onChange={handleChange}
                                    fullWidth
                                />
                                <TextField
                                    type='password'
                                    name='password'
                                    size='small'
                                    variant='outlined'
                                    placeholder='Digite a sua senha'
                                    value={values.password}
                                    onBlur={handleBlur}
                                    onChange={handleChange}
                                    fullWidth
                                />
                            </FlexBox>
                            <Button
                                type='submit'
                                color='primary'
                                variant='contained'
                                loading={isLoading}
                                loadingIndicator='Aguarde...'
                            >
                                Entrar
                            </Button>
                        </form>
                    )}
                </Formik>
            </Grid2>
        </Grid2>
    );
}

export default JwtLogin;