unit TaskManagerServer.Controller.Security;

interface

uses
   SysUtils, Classes,
   TaskManagerServer.Controller.Interfaces,
   Horse;

type
   TSecurityController = class(TInterfacedObject, IController)
   private
      { Private declarations }
      constructor Create;
      procedure SignIn(req: THorseRequest; res: THorseResponse);
      procedure SignUp(req: THorseRequest; res: THorseResponse);
      procedure Profile(req: THorseRequest; res: THorseResponse);
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
   TaskManagerServer.Model.Interfaces,
   TaskManagerServer.Model.Security;

{ TSecurityController }

constructor TSecurityController.Create;
begin

end;

class function TSecurityController.New: IController;
begin
   Result := Self.Create;
end;

procedure TSecurityController.Profile(req: THorseRequest; res: THorseResponse);
var
   ARetorno: TJSONObject;
   AToken: String;
   AUserId: String;
   AJWT: TJWT;
   ASecurityModel: ISecurityModel;
begin
   ARetorno := TJSONObject.Create;
   try
      try
         AToken := Req.Headers['Authorization'];
         if AToken.StartsWith('Bearer ') then
            AToken := AToken.Substring(7);
         AJWT := TJOSE.Verify(JWT_KEY, AToken);
         AUserId := AJWT.Claims.JSON.GetValue<String>('userId');
         ARetorno := TSecurityModel.New.Profile(AUserId);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.Unauthorized)
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

procedure TSecurityController.RegisterRoutes;
begin
   // Security Routes
   THorse.Post('/Security/SignIn', SignIn);
   THorse.Post('/Security/SignUp', SignUp);
   THorse
      .AddCallback(HorseJWT(JWT_KEY))
      .Get('/Security/Profile', Profile);
end;

procedure TSecurityController.SignIn(req: THorseRequest; res: THorseResponse);
var
   ABody: TJSONValue;
   ARetorno: TJSONObject;
   AUserName,
   APassword: String;
   ASecurityModel: ISecurityModel;
begin
   ARetorno := TJSONObject.Create;
   ABody := TJSONValue.Create;
   try
      try
         ABody := TJSONObject.ParseJSONValue(Req.Body);
         // Ler o valor da chave username
         AUserName := ABody.GetValue<String>('username');
         // Ler o valor da chave password
         APassword := ABody.GetValue<String>('password');
         // Executa o método login
         ARetorno := TSecurityModel.New.SignIn(AUserName, APassword);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.Unauthorized)
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
      ABody := Nil;
      ARetorno := Nil;
   end;
end;

procedure TSecurityController.SignUp(req: THorseRequest; res: THorseResponse);
var
   ABody: TJSONValue;
   ARetorno: TJSONObject;
   AUserName,
   AEmail,
   APassword: String;
   ASecurityModel: ISecurityModel;
begin
   ARetorno := TJSONObject.Create;
   ABody := TJSONValue.Create;
   try
      try
         ABody := TJSONObject.ParseJSONValue(Req.Body);
         // Ler o valor da chave username
         AUserName := ABody.GetValue<String>('username');
         // Ler o valor da chave e-mail
         AEmail := ABody.GetValue<String>('email');
         // Ler o valor da chave password
         APassword := ABody.GetValue<String>('password');
         // Executa o método login
         ARetorno := TSecurityModel.New.SignUp(AUserName, AEmail, APassword);
         // Retorna o resultado
         if ARetorno.GetValue<String>('status') = 'error' then
            Res.Send<TJSONObject>(ARetorno).Status(THTTPStatus.Unauthorized)
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
      ABody := Nil;
      ARetorno := Nil;
   end;
end;

end.
