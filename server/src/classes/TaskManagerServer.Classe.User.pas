unit TaskManagerServer.Classe.User;

interface

uses
   SysUtils, Classes;

type
   TUser = class(TObject)
   private
      { Private declarations }
      fId: String;
      fName: String;
      fEmail: String;
      fPassword: String;
      fActive: Boolean;
      function GetActive: Boolean;
      function GetEmail: String;
      function GetId: String;
      function GetName: String;
      function GetPassword: String;
      procedure SetActive(const Value: Boolean);
      procedure SetEmail(const Value: String);
      procedure SetId(const Value: String);
      procedure SetName(const Value: String);
      procedure SetPassword(const Value: String);
   protected
      { Protected declarations }
   public
      { Public declarations }
      property Id: String Read GetId Write SetId;
      property Name: String Read GetName Write SetName;
      property Email: String Read GetEmail Write SetEmail;
      property Password: String Read GetPassword Write SetPassword;
      property Active: Boolean Read GetActive Write SetActive;
   end;

   TArrayUsers = Array Of TUser;

   TListaUsers = class(TObject)
   private
      { Private declarations }
      fItems: TArrayUsers;
   protected
      { Protected declarations }
   public
      { Public declarations }
      function Tamanho: Integer;
      function Add(User: TUser): Integer;
      property Items: TArrayUsers Read fItems Write fItems;
   end;

implementation

{ TUser }

function TUser.GetActive: Boolean;
begin
   Result := fActive;
end;

function TUser.GetEmail: String;
begin
   Result := fEmail;
end;

function TUser.GetId: String;
begin
   Result := fId;
end;

function TUser.GetName: String;
begin
   Result := fName;
end;

function TUser.GetPassword: String;
begin
   Result := fPassword;
end;

procedure TUser.SetActive(const Value: Boolean);
begin
   if Value <> fActive then
      fActive := Value;
end;

procedure TUser.SetEmail(const Value: String);
begin
    if Value <> fEmail then
       fEmail := Value;
end;

procedure TUser.SetId(const Value: String);
begin
   if Value <> fId then
      fId := Value;
end;

procedure TUser.SetName(const Value: String);
begin
   if Value <> fName then
      fName := Value;
end;

procedure TUser.SetPassword(const Value: String);
begin
   if Value <> fPassword then
      fPassword := Value;
end;

{ TListaUsers }

function TListaUsers.Add(User: TUser): Integer;
begin
   SetLength(fItems, Tamanho + 1);
   fItems[High(fItems)] := User;
   Result := High(fItems);
end;

function TListaUsers.Tamanho: Integer;
begin
   Result := Length(fItems);
end;

end.
