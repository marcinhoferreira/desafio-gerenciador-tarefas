unit TaskManagerServer.Model.Conexao.Interfaces;

interface

uses
   Data.DB;

type
   IModelConexao = interface
      ['{1D8A3136-22F2-4EF8-B87E-F56C41C8B452}']
      function Connection: TObject;
   end;

   IModelQuery = interface
      ['{9D0F5BEA-BAF9-47A3-BE9C-C258E64D579E}']
      function Query: TDataSet;
      function Open(ASQL: String): IModelQuery;
      function ExecSQL(ASQL: String): IModelQuery;
   end;

   IModelStoredProc = interface
      ['{48CFB89F-27BC-4A76-908E-BEEA47117CC2}']
      function StoredProc: TDataSet;
      function ExecProc(AProcName: String): IModelStoredProc;
   end;

   IModelConexaoFactory = interface
      ['{D2B6B6DE-751C-484B-917D-E2FE8376884C}']
      function Conexao: IModelConexao;
      function Query: IModelQuery;
      function StoredProc: IModelStoredProc;
   end;

implementation

end.
