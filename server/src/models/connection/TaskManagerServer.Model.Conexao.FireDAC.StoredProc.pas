unit TaskManagerServer.Model.Conexao.FireDAC.StoredProc;

interface

uses
  TaskManagerServer.Model.Conexao.Interfaces,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
   TModelConexaoFireDACStoredProc = class(TInterfacedObject, IModelStoredProc)
   private
      { Private declarations }
      fConexao: IModelConexao;
      fStoredProc: TFDStoredProc;
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create(const Value: IModelConexao);
      destructor Destroy; override;
      class function New(const Value: IModelConexao): IModelStoredProc;
      function StoredProc: TDataSet;
      function Open(ASQL: String): IModelStoredProc;
      function ExecProc(ASQL: String): IModelStoredProc;
   end;

implementation

{ TModelConexaoFireDACStoredProc }

constructor TModelConexaoFireDACStoredProc.Create(const Value: IModelConexao);
begin
   fConexao := Value;
   fStoredProc := TFDStoredProc.Create(Nil);
   fStoredProc.Connection := TFDConnection(fConexao.Connection);
end;

destructor TModelConexaoFireDACStoredProc.Destroy;
begin
   fStoredProc.Destroy;
   inherited;
end;

function TModelConexaoFireDACStoredProc.ExecProc(ASQL: String): IModelStoredProc;
begin
  Result := Self;
  fStoredProc.ExecProc;
end;

class function TModelConexaoFireDACStoredProc.New(const Value: IModelConexao): IModelStoredProc;
begin
   Result := Self.Create(Value);
end;

function TModelConexaoFireDACStoredProc.Open(ASQL: String): IModelStoredProc;
begin
   Result := Self;
   fStoredProc.Open(ASQL);
end;

function TModelConexaoFireDACStoredProc.StoredProc: TDataSet;
begin
   Result := fStoredProc;
end;

end.
