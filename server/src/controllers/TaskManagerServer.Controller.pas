unit TaskManagerServer.Controller;

interface

uses
   SysUtils, Classes,
   TaskManagerServer.Controller.Interfaces,
   Horse;

type
   TController = class(TInterfacedObject, IController)
   private
      { Private declarations }
      constructor Create;
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
   Horse.CORS,
   Horse.Jhonson,
   TaskManagerServer.Controller.System,
   TaskManagerServer.Controller.Security,
   TaskManagerServer.Controller.Task;

{ TController }

constructor TController.Create;
begin
   // Definindo a porta da api
   THorse.Port := 3000;
end;

class function TController.New: IController;
begin
   Result := Self.Create;
end;

procedure TController.RegisterRoutes;
begin
   HorseCORS
      .AllowedHeaders('*');

   THorse
      .Use(CORS)
      .Use(Jhonson());

   // Register System routes
   TSystemController
      .New
      .RegisterRoutes;

   // Register Security Routes
   TSecurityController
      .New
      .RegisterRoutes;

   // Register Task Routes
   TTaskController
      .New
      .RegisterRoutes;

   THorse.Listen(
      procedure()
      begin
         WriteLn(Format('Server is running, on port %d', [THorse.Port]));
      end);
end;

end.
