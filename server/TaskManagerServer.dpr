program TaskManagerServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  TaskManagerServer.Classe.User in 'src\classes\TaskManagerServer.Classe.User.pas',
  TaskManagerServer.Classe.Task in 'src\classes\TaskManagerServer.Classe.Task.pas',
  TaskManagerServer.Model.Conexao.Interfaces in 'src\interfaces\TaskManagerServer.Model.Conexao.Interfaces.pas',
  TaskManagerServer.Model.Conexao.FireDAC.Conexao in 'src\models\connection\TaskManagerServer.Model.Conexao.FireDAC.Conexao.pas',
  TaskManagerServer.Model.Conexao.FireDAC.Query in 'src\models\connection\TaskManagerServer.Model.Conexao.FireDAC.Query.pas',
  TaskManagerServer.Model.Conexao.FireDAC.StoredProc in 'src\models\connection\TaskManagerServer.Model.Conexao.FireDAC.StoredProc.pas',
  TaskManagerServer.Model.Conexao.Factory in 'src\models\connection\TaskManagerServer.Model.Conexao.Factory.pas',
  TaskManagerServer.Model.Interfaces in 'src\interfaces\TaskManagerServer.Model.Interfaces.pas',
  TaskManagerServer.Model.Security in 'src\models\security\TaskManagerServer.Model.Security.pas',
  TaskManagerServer.Model.Task in 'src\models\task\TaskManagerServer.Model.Task.pas',
  TaskManagerServer.Controller.Interfaces in 'src\interfaces\TaskManagerServer.Controller.Interfaces.pas',
  TaskManagerServer.Controller.System in 'src\controllers\TaskManagerServer.Controller.System.pas',
  TaskManagerServer.Controller.Security in 'src\controllers\TaskManagerServer.Controller.Security.pas',
  TaskManagerServer.Controller.Task in 'src\controllers\TaskManagerServer.Controller.Task.pas',
  TaskManagerServer.Controller in 'src\controllers\TaskManagerServer.Controller.pas';

begin
  try
     // Registra as rotas da api
     TController
        .New
        .RegisterRoutes;
  except
     on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
  end;
end.
