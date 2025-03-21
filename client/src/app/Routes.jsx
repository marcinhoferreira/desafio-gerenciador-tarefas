import AuthGuard from './auth/AuthGuard';
import Redirect from './auth/Redirect';
import NotFound from './views/sessions/NotFound';
import JwtLogin from './views/sessions/JwtLogin';
import Home from './views/home/Home';
import TaskList from './views/task/TaskList';
import TaskForm from './views/task/TaskForm';
import JwtRegister from './views/sessions/JwtRegister';

// Aqui, serão definidas todas as rotas da aplicação
const routes = [
    {
        element: (
            <AuthGuard>
                <Home />
            </AuthGuard>
        ),
        children: [
            { path: '/home', element: <Home /> },
        ],
    },
    { path: '/signIn', element: <JwtLogin /> },
    { path: '/signUp', element: <JwtRegister /> },
    { path: '/task-list', element: <TaskList /> },
    { path: '/task', element: <TaskForm /> },
    { path: '/task/:id', element: <TaskForm /> },
    { path: '/', element: <Redirect /> },    
    { path: '*', element: <NotFound /> },
];

export default routes;
