unit TaskManagerServer.Model.Conexao.FireDAC.Query;

interface

uses
  TaskManagerServer.Model.Conexao.Interfaces,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
   TModelConexaoFireDACQuery = class(TInterfacedObject, IModelQuery)
   private
      { Private declarations }
      fConexao: IModelConexao;
      fQuery: TFDQuery;
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create(const Value: IModelConexao);
      destructor Destroy; override;
      class function New(const Value: IModelConexao): IModelQuery;
      function Query: TDataSet;
      function Open(ASQL: String): IModelQuery;
      function ExecSQL(ASQL: String) : iModelQuery;
   end;

implementation

{ TModelConexaoFireDACQuery }

constructor TModelConexaoFireDACQuery.Create(const Value: IModelConexao);
begin
   fConexao := Value;
   fQuery := TFDQuery.Create(Nil);
   fQuery.Connection := TFDConnection(fConexao.Connection);
end;

destructor TModelConexaoFireDACQuery.Destroy;
begin
   fQuery.Destroy;
   inherited;
end;

function TModelConexaoFireDACQuery.ExecSQL(ASQL: String): iModelQuery;
begin
  Result := Self;
  fQuery.ExecSQL(ASQL);
end;

class function TModelConexaoFireDACQuery.New(const Value: IModelConexao): IModelQuery;
begin
   Result := Self.Create(Value);
end;

function TModelConexaoFireDACQuery.Open(ASQL: String): IModelQuery;
begin
   Result := Self;
   fQuery.Open(ASQL);
end;

function TModelConexaoFireDACQuery.Query: TDataSet;
begin
   Result := fQuery;
end;

end.
