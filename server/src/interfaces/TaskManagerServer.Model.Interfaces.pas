unit TaskManagerServer.Model.Interfaces;

interface

uses
   Classes, System.JSON;

const
   JWT_KEY: String = 'HmAyhAJbFwXuZkWn0fUtEe72ggidz8hOdrWiXsVuI9ZtfsdNTad6605c1a5ba342';

type
   IModel = interface
      ['{D56FB72F-3FFD-41D4-9A3E-3516A70890B3}']
      procedure Open(const Where: String = '');
   end;

   ISecurityModel = interface(IModel)
      ['{907A6E88-34B8-4DC2-BC42-ADFA82A979DE}']
      function SignIn(const UserName: String; const Password: String): TJSONObject;
      function SignUp(const UserName: String; const Email: String; const Password: String): TJSONObject;
      function Profile(const Id: String): TJSONObject;
   end;

   ITaskModel = interface(IModel)
      ['{353FF3B5-6472-40EC-A121-9EE5C93E5084}']
      function List(const UserId: String): TJSONObject;
      function Get(const Id: String): TJSONObject;
      function Post(const data: TJSONObject): TJSONObject;
      function Put(const Id: String; const data: TJSONObject): TJSONObject;
      function Delete(const Id: String): TJSONObject;
   end;

implementation

end.
