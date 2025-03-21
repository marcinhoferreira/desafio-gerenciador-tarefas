import { useNavigate } from 'react-router-dom';
import { Box, Button, styled, Typography } from '@mui/material';
import { FlexAlignCenter } from '../../components/FlexBox';

// styled components
const FlexBox = styled(Box)({
    display: 'flex',
    alignItems: 'center',
});

const JustifyBox = styled(FlexBox)({
    maxWidth: 320,
    flexDirection: 'column',
    justifyContent: 'center',
});

const IMG = styled('img')({
    width: '100%',
    marginBottom: '32px',
});

const NotFoundRoot = styled(FlexAlignCenter)({
    width: '100%',
    height: '100vh !important',
});

const NotFound = () => {
    const navigate = useNavigate();

    return (
        <NotFoundRoot>
            <JustifyBox>
                <Typography
                    sx={
                        { fontWeight: 'bold', marginBottom: '16px' }
                    }
                    variant='h2'
                >
                    Página não encontrada
                </Typography>
                <Button
                    color='primary'
                    variant='contained'
                    sx={{ textTransform: 'capitalize' }}
                    onClick={() => navigate(-1)}
                >
                    Voltar
                </Button>
            </JustifyBox>
        </NotFoundRoot>
    );
};

export default NotFound;
