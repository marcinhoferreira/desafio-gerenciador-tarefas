import React, { useState } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { Button, Card, Grid2, TextField, Typography, useTheme } from '@mui/material';
import useAuth from '../../hooks/useAuth';
import { Formik } from 'formik';
import * as Yup from 'yup';
import { useSnackbar } from 'notistack';
import { FlexBox } from '../../components/FlexBox';

const validationSchema = Yup.object().shape({
    username: Yup.string().required('Digite o seu nome de usuário'),
    password: Yup.string().required('Digite a sua senha')
});

const JwtRegister = () => {
    const theme = useTheme();
    const { register } = useAuth();
    const navigate = useNavigate();
    const { enqueueSnackbar } = useSnackbar();
    const [ isLoading, setIsLoading ] = useState(false);

    const handleFormSubmit = async (values) => {
        setIsLoading(true);
        try {
            await register(values.username, values.email, values.password);
            enqueueSnackbar('Cadastrado com sucesso', { variant: 'success' });
            navigate('/signin');
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
            >
                <Card
                    sx={
                        { width: 320, padding: '1rem' }
                    }
                    elevation={3}
                >
                    <Typography
                        variant='h6'
                        color='primary'
                        align='center'
                    >
                        Cadastre-se
                    </Typography>
                    <Formik
                        initialValues={{
                            username: '',
                            email: '',
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
                                    marginTop={ '1rem' }
                                    marginBottom={ '1rem' }
                                    flexDirection={ 'column' }
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
                                        type='email'
                                        name='email'
                                        size='small'
                                        variant='outlined'
                                        placeholder='Digite o seu email'
                                        value={values.email}
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
                                    Cadastrar
                                </Button>
                            </form>
                        )}
                    </Formik>
                    <FlexBox
                        marginTop={ '1rem' }
                    >
                        <Typography>
                            Já possui cadastro?
                        </Typography>
                        <NavLink
                            style={
                                { color: theme.palette.primary.main, marginLeft: 5 }
                            }
                            to='/signin'
                        >
                            Acessar
                        </NavLink>
                    </FlexBox>
                </Card>
            </Grid2>
        </Grid2>
    );
}

export default JwtRegister;