import React from 'react';
import {
    Button,
    Card,
    FormControl,
    FormControlLabel,
    FormLabel,
    Radio,
    RadioGroup,
    Typography
} from '@mui/material';
import { FlexBox } from './FlexBox';

// Cria uma exibição em card, da tarefa
const TaskCard = ({
    task
}) => {    
    return (
        <Card
            sx={
                { marginTop: 2, marginBottom: 2, padding: '1rem' }
            }
            key={`task-${task.id}`}
            elevation={3}
        >
            <Typography
                variant='h4'
                align='center'
                color={'primary'}
            >
                { task.title }
            </Typography>
            <Typography
                variant='body2'
                align='center'
            >
                { task.description }
            </Typography>
            <FlexBox
                marginTop={ '1rem' }
                gap={ '0.5rem' }
            >
                {/* Prioridade da tarefa LOW e HIGH */}
                <FormControl>
                    <FormLabel>
                        Prioridade
                    </FormLabel>
                    <RadioGroup
                        sx={
                            { border: 1, padding: 2, flexDirection: 'row' }
                        }
                        name='priority'
                        value={task.priority}
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
                {/* Status da tarefa: PENDING, INPROGRESS, COMPLETED */}
                <FormControl>
                    <FormLabel>
                        Status da Tarefa
                    </FormLabel>
                    <RadioGroup
                        sx={
                            { border: 1, padding: 2, flexDirection: 'row' }
                        }
                        defaultValue={task.status}
                        value={task.status}
                    >
                        <FormControlLabel
                            value={'PENDING'}
                            label='Pendente'
                            control={<Radio/>}
                        />
                        <FormControlLabel
                            value={'INPROGRESS'}
                            label='Em andamento'
                            control={<Radio/>}
                        />
                        <FormControlLabel
                            value={'COMPLETED'}
                            label='Concluído'
                            control={<Radio/>}
                        />
                    </RadioGroup>
                </FormControl>
            </FlexBox>
        </Card>
    );
}

export default TaskCard;