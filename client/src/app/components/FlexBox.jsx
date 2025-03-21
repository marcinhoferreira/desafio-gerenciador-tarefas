import { Box, styled } from '@mui/material';

// FlexBox - Cria um box, com display flex
const FlexBox = styled(Box)({ display: 'flex' });

// FlexBetween - Cria um box, com flex e com os itens alinhados ao centro, entre o espaço
const FlexBetween = styled(Box)({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
});

// FlexAlignCenter - Cria um box, com alinhamento centralizado
const FlexAlignCenter = styled(Box)({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
});

// FlexJustifyCenter - Cria um box, com alinhamento justificado ao centro
const FlexJustifyCenter = styled(Box)({
  display: 'flex',
  justifyContent: 'center',
});

export { FlexBox, FlexBetween, FlexAlignCenter, FlexJustifyCenter };
