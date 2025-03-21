unit TaskManagerServer.Classe.Task;

interface

uses
   SysUtils, Classes, System.JSON;

type
   TTask = class(TObject)
   private
      { Private declarations }
      fId: String;
      fUserId: String;
      fTitle: String;
      fDescription: String;
      fPriority: String;
      fStatus: String;
      fCreatedAt: TDateTime;
      fUpdatedAt: TDateTime;
      function GetCreatedAt: TDateTime;
      function GetDescription: String;
      function GetId: String;
      function GetPriority: String;
      function GetStatus: String;
      function GetTitle: String;
      function getUpdatedAt: TDateTime;
      function GetUserId: String;
      procedure SetCreatedAt(const Value: TDateTime);
      procedure SetDescription(const Value: String);
      procedure SetId(const Value: String);
      procedure SetPriority(const Value: String);
      procedure SetStatus(const Value: String);
      procedure SetTitle(const Value: String);
      procedure SetUpdatedAt(const Value: TDateTime);
      procedure SetUserId(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      property Id: String Read GetId Write SetId;
      property UserId: String Read GetUserId Write SetUserId;
      property Title: String Read GetTitle Write SetTitle;
      property Description: String Read GetDescription Write SetDescription;
      property Priority: String Read GetPriority Write SetPriority;
      property Status: String Read GetStatus Write SetStatus;
      property CreatedAt: TDateTime Read GetCreatedAt Write SetCreatedAt;
      property UpdatedAt: TDateTime Read getUpdatedAt Write SetUpdatedAt;
   end;

   TTaskHelper = class Helper for TTask
   private
      { Private declarations }
   protected
      { Protected declarations }
   public
      { Public declarations }
      class function FromJSON(const data: TJSONOBject): TTask;
      class function ToJSON(const ATask: TTask): TJSONObject;
   end;

   TArrayTasks = Array Of TTask;

   TTaskList = class(TObject)
   private
      { Private declarations }
      fItems: TArrayTasks;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(Task: TTask): Integer;
      property Items: TArrayTasks Read fItems Write fItems;
   end;

implementation

uses
   REST.Json;

{ TTask }

constructor TTask.Create;
begin

end;

destructor TTask.Destroy;
begin

  inherited;
end;

function TTask.GetCreatedAt: TDateTime;
begin
   Result := fCreatedAt;
end;

function TTask.GetDescription: String;
begin
   Result := fDescription;
end;

function TTask.GetId: String;
begin
   Result := fId;
end;

function TTask.GetPriority: String;
begin
   Result := fPriority;
end;

function TTask.GetStatus: String;
begin
   Result := fStatus;
end;

function TTask.GetTitle: String;
begin
   Result := fTitle;
end;

function TTask.getUpdatedAt: TDateTime;
begin
   Result := fUpdatedAt;
end;

function TTask.GetUserId: String;
begin
   Result := fUserId;
end;

procedure TTask.SetCreatedAt(const Value: TDateTime);
begin
   if Value <> fCreatedAt then
      fCreatedAt := Value;
end;

procedure TTask.SetDescription(const Value: String);
begin
   if Value <> fDescription then
      fDescription := Value;
end;

procedure TTask.SetId(const Value: String);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TTask.SetPriority(const Value: String);
begin
   if Value <> fPriority then
      fPriority := Value;
end;

procedure TTask.SetStatus(const Value: String);
begin
   if Value <> fStatus then
      fStatus := Value;
end;

procedure TTask.SetTitle(const Value: String);
begin
   if Value <> fTitle then
      fTitle := Value;
end;

procedure TTask.SetUpdatedAt(const Value: TDateTime);
begin
   if Value <> fUpdatedAt then
      fUpdatedAt := Value;
end;

procedure TTask.SetUserId(const Value: String);
begin
   if Value <> fUserId then
      fUserId := Value;
end;

{ TTaskList }

function TTaskList.Add(Task: TTask): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := Task;
   Result := High(fItems);
end;

function TTaskList.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

{ TTaskHelper }

class function TTaskHelper.FromJSON(const data: TJSONOBject): TTask;
begin
   Result := TTask.Create;
   Result := TJson.JsonToObject<TTask>(data);
end;

class function TTaskHelper.ToJSON(const ATask: TTask): TJSONObject;
begin
   Result := TJSONObject.Create;
   Result := Tjson.ObjectToJsonObject(ATask);
end;

end.
