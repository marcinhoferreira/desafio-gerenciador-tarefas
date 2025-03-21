unit TaskManagerServer.Model.Security;

interface

uses
   SysUtils, Classes, System.JSON,
   TaskManagerServer.Model.Conexao.Interfaces,
   TaskManagerServer.Model.Interfaces;

type
   TSecurityModel = class(TInterfacedObject, ISecurityModel)
   private
      { Private declarations }
      fQuery: IModelQuery;
      constructor Create;
   protected
      { Protected declarations }
   public
      { Public declarations }
      class function New: ISecurityModel;
      procedure Open(const Where: String = '');
      function SignUp(const UserName: String; const Email: String; const Password: String): TJSONObject;
      function SignIn(const UserName: String; const Password: String): TJSONObject;
      function Profile(const Id: String): TJSONObject;
   end;

implementation

uses
   System.DateUtils,
   JOSE.Core.JWT,
   JOSE.Core.Builder,
   TaskManagerServer.Model.Conexao.Factory;

{ TSecurityModel }

{
   SignUp - Insere um novo usuário
}
function TSecurityModel.SignUp(const UserName, Email,
  Password: String): TJSONObject;
var
   ARetorno: TJSONObject;
begin
   Open(Format('WHERE name = %s', [QuotedStr(UserName)]));
   with fQuery do
      begin
         Result := TJSONObject.Create;
         if not Query.IsEmpty then
            begin
               Result.AddPair('status', 'error');
               Result.AddPair('message', 'User already exists');
            end
         else
            begin
               ARetorno := TJSONObject.Create;
               try
                  try
                     Query.Append;
                     Query.FieldByName('id').AsString := TGUID.NewGuid.ToString().Replace('{', '').Replace('}', '');
                     Query.FieldByName('name').AsString := UserName;
                     Query.FieldByName('email').AsString := Email;
                     Query.FieldByName('password').AsString := Password;
                     Query.FieldByName('active').AsBoolean := True;
                     Query.Post;

                     ARetorno.AddPair('id', Query.FieldByName('id').AsString);
                     ARetorno.AddPair('name', Query.FieldByName('name').AsString);
                     ARetorno.AddPair('email', Query.FieldByName('email').AsString);
                     ARetorno.AddPair('password', Query.FieldByName('password').AsString);
                     ARetorno.AddPair('active', Query.FieldByName('active').AsBoolean);

                     Result.AddPair('status', 'success');
                     Result.AddPair('message', 'User registered successfully');
                     Result.AddPair('data', ARetorno);
                  except
                     on E: Exception do
                        begin
                           Result.AddPair('status', 'error');
                           Result.AddPair('message', E.Message);
                        end;
                  end;
               finally
                  ARetorno := Nil;
               end;
            end;
      end;
end;

{
   SignIn - Autentica o usuário, retornando um token de autenticação
}
function TSecurityModel.SignIn(const UserName: String; const Password: String): TJSONObject;
var
   AJWT: TJWT;
   AToken: String;
   ARetorno: TJSONObject;
begin
   Open(Format('WHERE name = %s', [QuotedStr(UserName)]));
   with fQuery do
      begin
         Result := TJSONObject.Create;
         if Query.IsEmpty then
            begin
               Result.AddPair('status', 'error');
               Result.AddPair('message', 'Error authenticating: Please check your credentials');
            end
         else
            begin
               if Query.FieldByName('password').AsString <> Password then
                  begin
                     Result.AddPair('status', 'error');
                     Result.AddPair('message', 'Error authenticating: Please check your credentials');
                  end
               else
                  begin
                     ARetorno := TJSONObject.Create;
                     AJWT := TJWT.Create;
                     try
                        AJWT.Claims.SetClaimOfType<String>('userId', Query.FieldByName('id').AsString);
                        AJWT.Claims.Expiration := IncDay(Now(), 7);
                        AToken := TJOSE.SHA512CompactToken(JWT_KEY, AJWT);

                        ARetorno.AddPair('tokenType', 'Bearer');
                        ARetorno.AddPair('accessToken', AToken);
                        ARetorno.AddPair('expiresIn', DateTimeToMilliseconds(AJWT.Claims.Expiration));

                        Result.AddPair('status', 'success');
                        Result.AddPair('message', 'User authenticated successfully');
                        Result.AddPair('data', ARetorno);
                     finally
                        FreeAndNil(AJWT);
                        ARetorno := Nil;
                     end;
                  end;
            end;
      end;
end;

constructor TSecurityModel.Create;
begin
   fQuery := TModelConexaoFactory.New.Query;
end;

class function TSecurityModel.New: ISecurityModel;
begin
   Result := Self.Create;
end;

procedure TSecurityModel.Open(const Where: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, name, email, password, active ';
   ASQL := ASQL + 'FROM users ';
   if Where <> '' then
      ASQL := ASQL + Where;
   fQuery.Open(ASQL);
end;

function TSecurityModel.Profile(const Id: String): TJSONObject;
var
   ARetorno: TJSONObject;
begin
   Open(Format('WHERE id = %s', [QuotedStr(Id)]));
   with fQuery do
      begin
         Result := TJSONObject.Create;
         if Query.IsEmpty then
            begin
               Result.AddPair('status', 'error');
               Result.AddPair('message', 'User does not exist');
            end
         else
            begin
               ARetorno := TJSONObject.Create;
               try
                  ARetorno.AddPair('id', Query.FieldByName('id').AsString);
                  ARetorno.AddPair('name', Query.FieldByName('name').AsString);
                  ARetorno.AddPair('email', Query.FieldByName('email').AsString);
                  ARetorno.AddPair('password', Query.FieldByName('password').AsString);
                  ARetorno.AddPair('active', Query.FieldByName('active').AsBoolean);
                  Result.AddPair('status', 'success');
                  Result.AddPair('message', 'User registered successfully');
                  Result.AddPair('data', ARetorno);
               finally
                  ARetorno := Nil;
               end;
            end;
      end;
end;

end.
