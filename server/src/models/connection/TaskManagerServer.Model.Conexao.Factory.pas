unit TaskManagerServer.Model.Conexao.Factory;

interface

uses
  TaskManagerServer.Model.Conexao.Interfaces;

type
   TModelConexaoFactory = class(TInterfacedObject, IModelConexaoFactory)
   private
      { Private declarations }
      constructor Create;
   protected
      { Protected declarations }
   public
      { Public declarations }
      destructor Destroy; override;
      class function New(): IModelConexaoFactory;
      function Conexao: IModelConexao;
      function Query: IModelQuery;
      function StoredProc: IModelStoredProc;
   end;

implementation

uses
  TaskManagerServer.Model.Conexao.FireDAC.Conexao,
  TaskManagerServer.Model.Conexao.FireDAC.Query,
  TaskManagerServer.Model.Conexao.FireDAC.StoredProc;

{ TModelConexaoFactory }

function TModelConexaoFactory.Conexao: IModelConexao;
begin
   Result := TModelConexaoFireDACConexao.New;
end;

constructor TModelConexaoFactory.Create;
begin

end;

destructor TModelConexaoFactory.Destroy;
begin

  inherited;
end;

class function TModelConexaoFactory.New: IModelConexaoFactory;
begin
   Result := Self.Create;
end;

function TModelConexaoFactory.Query: IModelQuery;
begin
   Result := TModelConexaoFireDACQuery.New(Self.Conexao);
end;

function TModelConexaoFactory.StoredProc: IModelStoredProc;
begin
   Result := TModelConexaoFireDACStoredProc.New(Self.Conexao);
end;

end.
