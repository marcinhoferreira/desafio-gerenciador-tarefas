import React, { useState } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import useAuth from '../../hooks/useAuth';
import { Card, Grid2, TextField, Typography, useTheme } from '@mui/material';
import { Button } from '@mui/material';
import { Formik } from 'formik';
import * as Yup from 'yup';
import { FlexBox } from '../../components/FlexBox';
import { useSnackbar } from 'notistack';

// Esquema de validação dos dados digitados
const validationSchema = Yup.object().shape({
    username: Yup.string().required('Digite o seu nome de usuário'),
    password: Yup.string().required('Digite a sua senha')
});

// Função de exibição da tela de login
const JwtLogin = () => {
    const theme = useTheme();
    // Extrai a função de login, do hook autenticação
    const { login } = useAuth();
    // Função de navegação entre as rotas do app
    const navigate = useNavigate();
    // Função de exibição de mensagens em toast
    const { enqueueSnackbar } = useSnackbar();
    // Variável de estado, utilizada para desabilitar e habilitar controles, na tela
    const [ isLoading, setIsLoading ] = useState(false);

    // Função que submete os dados do formulário à função de login
    const handleFormSubmit = async (values) => {
        // Desabilita os controles da tela
        setIsLoading(true);
        try {
            // Executa o login
            await login(values.username, values.password);
            // Exibe mensagem de sucesso, em toast
            enqueueSnackbar('Conectado com sucesso', { variant: 'success' });
            // Redireciona para a rota inicial do app
            navigate('/');
        } catch (error) {
            // Extrai a mensagem de erro
            const{ message } = error;
            // Exibe a mensagem de erro, em toast
            enqueueSnackbar(message, { variant: 'error' });
        } finally {
            // Habilita os controles da tela
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
                        {({ values, errors, touched, handleBlur, handleChange, handleSubmit }) => (
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
                                        helperText={touched.username && errors.username}
                                        error={Boolean(errors.username && touched.username)}
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
                                        helperText={touched.password && errors.password}
                                        error={Boolean(errors.password && touched.password)}
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
                    <FlexBox
                        marginTop={ '1rem' }
                    >
                        <Typography>
                            Não possui uma conta?
                        </Typography>
                        <NavLink
                            style={
                                { color: theme.palette.primary.main, marginLeft: 5 }
                            }
                            to='/signUp'
                        >
                            Cadastre-se
                        </NavLink>
                    </FlexBox>
                </Card>
            </Grid2>
        </Grid2>
    );
}

export default JwtLogin;