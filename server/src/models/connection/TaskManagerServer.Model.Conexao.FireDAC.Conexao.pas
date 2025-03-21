unit TaskManagerServer.Model.Conexao.FireDAC.Conexao;

interface

uses
  TaskManagerServer.Model.Conexao.Interfaces,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;

type
   TModelConexaoFireDACConexao = class(TInterfacedObject, IModelConexao)
   private
      { Private declarations }
      fDriverLink: TFDPhysDriverLink;
      fConexao: TFDConnection;
      procedure CreateTables;
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      class function New: IModelConexao;
      function Connection: TObject;
      function Driver: String;
   end;

implementation

uses
   SysUtils, System.IOUtils;

{ TModelConexaoFireDACConexao }

function TModelConexaoFireDACConexao.Connection: TObject;
begin
   Result := fConexao;
end;

constructor TModelConexaoFireDACConexao.Create;
var
   AFileName: TFileName;
   AHomePath: String;
begin
   AHomePath := ExtractFilePath(ParamStr(0));
   AFileName := 'TaskManager.s3db';
   // SQLite driver link
   fDriverLink := TFDPhysSQLiteDriverLink.Create(Nil);
   fDriverLink.VendorHome := AHomePath;
   {$IFDEF MSWINDOWS}
   AHomePath := TPath.Combine(AHomePath, 'data');
   if not DirectoryExists(AHomePath) then
      ForceDirectories(AHomePath);
   {$ELSE}
   AHomePath := TPath.GetDocumentsPath;
   {$ENDIF}
   AFileName := TPath.Combine(AHomePath, AFileName);
   // Connection create
   fConexao := TFDConnection.Create(Nil);
   with fConexao do
      begin
         ConnectedStoredUsage := ConnectedStoredUsage - [auDesignTime, auRunTime];
         Params.DriverID := 'SQLite';
         Params.Values['Server'] := 'localhost';
         Params.Values['Port'] := '0';
         Params.DataBase := AFileName;
         if not FileExists(Params.Values['Database']) then
            Params.Values['OpenMode'] := 'CreateUTF8'
         else
            Params.Values['OpenMode'] := 'ReadWrite';
         Params.Values['LockingMode'] := 'Normal';
         Params.UserName := '';
         Params.Password := '';
         try
            Connected := True;
         except
            on E: Exception do
               raise Exception.Create('Error trying to establish a connection to the host:'#10 + E.Message);
         end;
      end;
   if fConexao.Connected then
      CreateTables;
end;

procedure TModelConexaoFireDACConexao.CreateTables;
var
   AInstrucaoSQL: String;
begin
   // Criando a tabela de usuários
   AInstrucaoSQL := '';
   AInstrucaoSQL := AInstrucaoSQL + 'CREATE TABLE IF NOT EXISTS users (';
   AInstrucaoSQL := AInstrucaoSQL + '  id varchar(255) not null primary key,';
   AInstrucaoSQL := AInstrucaoSQL + '  name varchar(255) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  email varchar(255) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  password varchar(255) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  active boolean not null default true';
   AInstrucaoSQL := AInstrucaoSQL + ')';
   try
      fConexao.ExecSQL(AInstrucaoSQL);
   except
      on E: Exception do
         raise Exception.Create('Error creating users table:'#10 + E.Message);
   end;
   // Criando a tabela de tarefas
   AInstrucaoSQL := '';
   AInstrucaoSQL := AInstrucaoSQL + 'CREATE TABLE IF NOT EXISTS tasks (';
   AInstrucaoSQL := AInstrucaoSQL + '  id varchar(255) not null primary key,';
   AInstrucaoSQL := AInstrucaoSQL + '  user_id varchar(255) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  title varchar(255) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  description text not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  priority varchar(10) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  status varchar(20) not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  created_at timestamp not null,';
   AInstrucaoSQL := AInstrucaoSQL + '  updated_at timestamp';
   AInstrucaoSQL := AInstrucaoSQL + ')';
   try
      fConexao.ExecSQL(AInstrucaoSQL);
   except
      on E: Exception do
         raise Exception.Create('Error creating users table:'#10 + E.Message);
   end;
end;

destructor TModelConexaoFireDACConexao.Destroy;
begin
   FreeAndNil(fConexao);
   FreeAndNil(fDriverLink);
   inherited;
end;

function TModelConexaoFireDACConexao.Driver: String;
begin
   Result := fConexao.Params.DriverID;
end;

class function TModelConexaoFireDACConexao.New: IModelConexao;
begin
   Result := Self.Create;
end;

end.
