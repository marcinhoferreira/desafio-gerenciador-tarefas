unit TaskManagerServer.Controller.Task;

interface

uses
   SysUtils, Classes,
   TaskManagerServer.Controller.Interfaces,
   Horse;

type
   TTaskController = class(TInterfacedObject, IController)
   private
      { Private declarations }
      constructor Create;
      procedure Index(req: THorseRequest; res: THorseResponse);
      procedure Get(req: THorseRequest; res: THorseResponse);
      procedure Post(req: THorseRequest; res: THorseResponse);
      procedure Put(req: THorseRequest; res: THorseResponse);
      procedure Delete(req: THorseRequest; res: THorseResponse);
   protected
      { Protected declarations }
   public
      { Public declarations }
      class function New: IController;
      procedure RegisterRoutes;
   end;

implementation

uses
   System.JSON,
   Horse.JWT,
   JOSE.Core.JWT,
   JOSE.Core.JWS,
   JOSE.Core.Builder,
   TaskManagerServer.Classe.Task,
   TaskManagerServer.Model.Interfaces,
   TaskManagerServer.Model.Task;

{ TTaskController }

constructor TTaskController.Create;
begin

end;

class function TTaskController.New: IController;
begin
   Result := Self.Create;
end;

procedure TTaskController.Delete(req: THorseRequest; res: THorseResponse);
var
   ATaskId: String;
   ARetorno: TJSONObject;
begin
   ARetorno := TJSONObject.Create;
   try
      try
         ATaskId := Req.Params['Id'];
         ARetorno := TTaskModel.New.Delete(ATaskId);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.NoContent)
         else
            Res.Send<TJSONObject>(ARetorno);
      except
         on E: Exception do
            begin
               ARetorno.AddPair('status', 'error');
               ARetorno.AddPair('message', E.Message);
               Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.InternalServerError);
            end;
      end;
   finally
      ARetorno := Nil;
   end;
end;

procedure TTaskController.Get(req: THorseRequest; res: THorseResponse);
var
   ATaskId: String;
   ARetorno: TJSONObject;
begin
   ARetorno := TJSONObject.Create;
   try
      try
         ATaskId := Req.Params['Id'];
         ARetorno := TTaskModel.New.Get(ATaskId);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.NoContent)
         else
            Res.Send<TJSONObject>(ARetorno);
      except
         on E: Exception do
            begin
               ARetorno.AddPair('status', 'error');
               ARetorno.AddPair('message', E.Message);
               Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.InternalServerError);
            end;
      end;
   finally
      ARetorno := Nil;
   end;
end;

procedure TTaskController.RegisterRoutes;
begin
   // Task Routes
   THorse
      .AddCallback(HorseJWT(JWT_KEY))
      .Get('/Task', Index);
   THorse
      .AddCallback(HorseJWT(JWT_KEY))
      .Get('/Task/:id', Get);
   THorse
      .AddCallback(HorseJWT(JWT_KEY))
      .Post('/Task', Post);
   THorse
      .AddCallback(HorseJWT(JWT_KEY))
      .Put('/Task/:id', Put);
   THorse
      .AddCallback(HorseJWT(JWT_KEY))
      .Delete('/Task/:id', Delete);
end;

procedure TTaskController.Index(req: THorseRequest; res: THorseResponse);
var
   ARetorno: TJSONObject;
   AToken: String;
   AUserId: String;
   AJWT: TJWT;
begin
   ARetorno := TJSONObject.Create;
   try
      try
         AToken := Req.Headers['Authorization'];
         if AToken.StartsWith('Bearer ') then
            AToken := AToken.Substring(7);
         AJWT := TJOSE.Verify(JWT_KEY, AToken);
         AUserId := AJWT.Claims.JSON.GetValue<String>('userId');
         ARetorno := TTaskModel.New.List(AUserId);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.NoContent)
         else
            Res.Send<TJSONObject>(ARetorno);
      except
         on E: Exception do
            begin
               ARetorno.AddPair('status', 'error');
               ARetorno.AddPair('message', E.Message);
               Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.InternalServerError);
            end;
      end;
   finally
      ARetorno := Nil;
   end;
end;

procedure TTaskController.Post(req: THorseRequest; res: THorseResponse);
var
   AData,
   ARetorno: TJSONObject;
   ATaskModel: ITaskModel;
begin
   ARetorno := TJSONObject.Create;
   AData := TJSONObject.Create;
   try
      try
         AData := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
         ARetorno := TTaskModel.New.Post(AData);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.BadRequest)
         else
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.Created);
      except
         on E: Exception do
            begin
               ARetorno.AddPair('status', 'error');
               ARetorno.AddPair('message', E.Message);
               Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.InternalServerError);
            end;
      end;
   finally
      AData := Nil;
      ARetorno := Nil;
   end;
end;

procedure TTaskController.Put(req: THorseRequest; res: THorseResponse);
var
   ATaskId: String;
   AData,
   ARetorno: TJSONObject;
begin
   ARetorno := TJSONObject.Create;
   AData := TJSONObject.Create;
   try
      try
         ATaskId := Req.Params['Id'];
         AData := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
         ARetorno := TTaskModel.New.Put(ATaskId, AData);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.NoContent)
         else
            Res.Send<TJSONObject>(ARetorno);
      except
         on E: Exception do
            begin
               ARetorno.AddPair('status', 'error');
               ARetorno.AddPair('message', E.Message);
               Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.InternalServerError);
            end;
      end;
   finally
      AData := Nil;
      ARetorno := Nil;
   end;
end;

end.
