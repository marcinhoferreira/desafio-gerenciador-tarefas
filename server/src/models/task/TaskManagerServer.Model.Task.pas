unit TaskManagerServer.Model.Task;

interface

uses
   SysUtils, Classes, System.JSON,
   TaskManagerServer.Model.Conexao.Interfaces,
   TaskManagerServer.Model.Interfaces,
   TaskManagerServer.Classe.Task;

type
   TTaskModel = class(TInterfacedObject, ITaskModel)
   private
      { Private declarations }
      fQuery: IModelQuery;
      constructor Create;
   protected
      { Protected declarations }
   public
      { Public declarations }
      class function New: ITaskModel;
      procedure Open(const Where: String = '');
      function GetTask(const Id: String): TTask;
      function GetTaskList(const UserId: String): TTaskList;
      function List(const UserId: String): TJSONObject;
      function Get(const Id: String): TJSONObject;
      function Post(const data: TJSONObject): TJSONObject;
      function Put(const Id: String; const data: TJSONObject): TJSONObject;
      function Delete(const Id: String): TJSONObject;
   end;

implementation

uses
   System.DateUtils, Data.DB, REST.Json,
   JOSE.Core.JWT, JOSE.Core.Builder,
   DataSet.Serialize,
   TaskManagerServer.Model.Conexao.Factory;

{ TTaskModel }

constructor TTaskModel.Create;
begin
   fQuery := TModelConexaoFactory.New.Query;
end;

function TTaskModel.Delete(const Id: String): TJSONObject;
var
   ARetorno: TJSONObject;
begin
   Result := TJSONObject.Create;
   Open(Format('WHERE id = %s', [QuotedStr(Id)]));
   with fQuery do
      begin
         ARetorno := TJSONObject.Create;
         try
            if Query.IsEmpty then
               begin
                  Result.AddPair('status', 'error');
                  Result.AddPair('message', 'Task not encountered');
               end
            else
               begin
                  Query.Delete;
                  Result.AddPair('status', 'success');
                  Result.AddPair('message', 'Task deleted');
               end;
         finally
            ARetorno := Nil;
         end;
      end;
end;

function TTaskModel.Get(const Id: String): TJSONObject;
var
   ARetorno: TJSONObject;
begin
   Result := TJSONObject.Create;
   Open(Format('WHERE id = %s', [QuotedStr(Id)]));
   with fQuery do
      begin
         ARetorno := TJSONObject.Create;
         try
            if Query.IsEmpty then
               begin
                  Result.AddPair('status', 'error');
                  Result.AddPair('message', 'Task not encountered');
               end
            else
               begin
                  ARetorno := Query.ToJSONObject();
                  Result.AddPair('status', 'success');
                  Result.AddPair('message', 'Task encountered');
                  Result.AddPair('data', ARetorno);
               end;
         finally
            ARetorno := Nil;
         end;
      end;
end;

function TTaskModel.GetTask(const Id: String): TTask;
begin
   Result := TTask.Create;
   Open(Format('WHERE id = %s', [QuotedStr(Id)]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Result.Id := Query.FieldByName('id').AsString;
            Result.Title := Query.FieldByName('title').AsString;
            Result.Description := Query.FieldByName('description').AsString;
            Result.Priority := Query.FieldByName('priority').AsString;
            Result.Status := Query.FieldByName('status').AsString;
            Result.CreatedAt := Query.FieldByName('created_at').AsDateTime;
            if not Query.FieldByName('updated_at').isNull then
               Result.UpdatedAt := Query.FieldByName('updated_at').AsDateTime;
         end;
end;

function TTaskModel.GetTaskList(const UserId: String): TTaskList;
var
   ATask: TTask;
begin
   Result := TTaskList.Create;
   Open(Format('WHERE user_id = %s', [QuotedStr(userId)]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            while not Query.Eof do
               begin
                  ATask := TTask.Create;
                  ATask.Id := Query.FieldByName('id').AsString;
                  ATask.Title := Query.FieldByName('title').AsString;
                  ATask.Description := Query.FieldByName('description').AsString;
                  ATask.Priority := Query.FieldByName('priority').AsString;
                  ATask.Status := Query.FieldByName('status').AsString;
                  ATask.CreatedAt := Query.FieldByName('created_at').AsDateTime;
                  if not Query.FieldByName('updated_at').isNull then
                     ATask.UpdatedAt := Query.FieldByName('updated_at').AsDateTime;
                  Result.Add(ATask);
                  Query.Next;
               end;
         end;
end;

function TTaskModel.List(const UserId: String): TJSONObject;
var
//   ATaskList: TTaskList;
   AJSONObject: TJSONObject;
   ARetorno: TJSONArray;
begin
   Result := TJSONObject.Create;
   Open(Format('WHERE user_id = %s', [QuotedStr(userId)]));
   with fQuery do
      begin
         if Query.IsEmpty then
            begin
               Result.AddPair('status', 'error');
               Result.AddPair('message', 'Tasks not found');
            end
         else
            begin
               ARetorno := TJSONArray.Create;
               try
                  ARetorno := Query.ToJSONArray();
                  Result.AddPair('status', 'success');
                  Result.AddPair('message', 'Tasks encountered');
                  Result.AddPair('data', ARetorno);
               finally
                  ARetorno := Nil;
               end;
            end;
      end;
end;

class function TTaskModel.New: ITaskModel;
begin
   Result := Self.Create;
end;

procedure TTaskModel.Open(const Where: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, user_id, title, description, priority, status, ';
   ASQL := ASQL + 'created_at, updated_at ';
   ASQL := ASQL + 'FROM tasks ';
   if Where <> '' then
      ASQL := ASQL + Where + ' ';
   ASQL := ASQL + 'ORDER BY created_at DESC ';
   fQuery.Open(ASQL);
end;

function TTaskModel.Post(const data: TJSONObject): TJSONObject;
var
   ARetorno: TJSONObject;
   ATask: TTask;
begin
   Result := TJSONObject.Create;
   ARetorno := TJSONObject.Create;
   ATask := TTask.Create;
   try
      try
         ATask := TTask.FromJSON(data);
         Open('WHERE id IS NULL');
         with fQuery do
            begin
               Query.Append;
               Query.FieldByName('id').AsString := TGUID.NewGuid.ToString().Replace('{', '').Replace('}', '');
               Query.FieldByName('user_id').AsString := ATask.UserId;
               Query.FieldByName('title').AsString := ATask.Title;
               Query.FieldByName('description').AsString := ATask.Description;
               Query.FieldByName('priority').AsString := ATask.Priority;
               Query.FieldByName('status').AsString := 'PENDING';
               Query.FieldByName('created_at').AsDateTime := Now();
               Query.Post;
               ARetorno := Query.ToJSONObject();
               Result.AddPair('status', 'success');
               Result.AddPair('message', 'Task created sucessfuly');
               Result.AddPair('data', ARetorno);
            end;
      except
         on E: Exception do
            raise Exception.Create('Invalid JSON object');
      end;
   finally
      FreeAndNil(ATask);
      ARetorno := Nil;
   end;
end;

function TTaskModel.Put(const Id: String; const data: TJSONObject): TJSONObject;
var
   ATask: TTask;
   ARetorno: TJSONObject;
begin
   Result := TJSONObject.Create;
   ARetorno := TJSONObject.Create;
   ATask := TTask.Create;
   try
      Open(Format('WHERE id = %s', [QuotedStr(Id)]));
      with fQuery do
         begin
            ARetorno := TJSONObject.Create;
            try
               if Query.IsEmpty then
                  begin
                     Result.AddPair('status', 'error');
                     Result.AddPair('message', 'Task not encountered');
                  end
               else
                  begin
                     try
                        ATask := TTask.FromJSON(data);
                        Query.Edit;
                        Query.FieldByName('user_id').AsString := ATask.UserId;
                        Query.FieldByName('title').AsString := ATask.Title;
                        Query.FieldByName('description').AsString := ATask.Description;
                        Query.FieldByName('priority').AsString := ATask.Priority;
                        Query.FieldByName('status').AsString := ATask.Status;
                        Query.FieldByName('updated_at').AsDateTime := Now();
                        Query.Post;
                        ARetorno := Query.ToJSONObject();
                        Result.AddPair('status', 'success');
                        Result.AddPair('message', 'Task updated sucessfuly');
                        Result.AddPair('data', ARetorno);
                     except
                        on E: Exception do
                           raise Exception.Create('Invalid JSON object');
                     end;
                  end;
            finally
               ARetorno := Nil;
            end;
         end;
   finally
      FreeAndNil(ATask);
      ARetorno := Nil;
   end;
end;

end.
