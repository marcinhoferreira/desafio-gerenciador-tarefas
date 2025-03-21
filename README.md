# Gerenciador de Lista de Tarefas

Esta aplicação foi criada para solucionar o desafio de uma lista de tarefas, definida conforme a seguir:

## Definição do problema

Criar uma aplicação simples de lista de tarefas (To-Do List) com controle de usuário e armazenamento em SQLite.

### Requisitos Mínimos

    1. Autenticação de usuário:
        Criar um sistema de login e cadastro básico utilizando SQLite como banco de dados.
        O usuário deve ser autenticado antes de acessar a lista de tarefas.

    2. Gerenciamento de tarefas:
        Cada usuário pode criar, visualizar, concluir e excluir suas próprias tarefas.
        As tarefas devem ser salvas no banco de dados.

    3. Back-end:
        Criar uma API simples Delphi para gerenciar usuários e tarefas.
        O banco de dados SQLite deve armazenar as informações.

    4. Front-end:
        Criar componentes reutilizáveis.
        Utilizar React Hooks (useState, useEffect).
        Código deve estar comentado.

## Solução

### Backend

Aplicação console deve ser iniciada antes de executar o frontend. O banco de dados é criado automaticamente, ao estabelecer uma conexão

##### Tecnologias utilizadas

    - RAD Studio 12 Athens
    - FireDAC
        - SQLite
    - Boss
    - Horse

##### Instalação e execução

    - Clonar o repositório
    - Caso não possua a dll do SQLite, utilizar a da pasta libs. Basta copiar para a mesma pasta do executável e descompactar
    - Abrir o TaskManagerServer.dpr, através do RAD Studio
    - Compilar e executar
    
    IMPORTANTE: O servidor está escutando a porta 3000. Está fixo no código. Caso esta porta não esteja disponível, deve indicar outra, no código fonte do controller principal.

### Frontend

Aplicação web, tipo SPA, implementada em ReactJs

#### Tecnologias utilizadas

    - ReactJs
    - MUI
    - JWT-Decode
    - Axios

#### Instalação e execução

    - Clonar o repositório
    - Executar o comando: npm install
    - Abrir a pasta client, através do VS Code
    - Criar o arquivo .env, baseado no .env.example substituindo o valor da chave pela url base do backend (por exemplo: http://localhost:3000)
    - executar o comando: npm run dev

* Autor: Marcio Roberto Leal Ferreira
* E-mail: marcio.sistemas@gmail.com