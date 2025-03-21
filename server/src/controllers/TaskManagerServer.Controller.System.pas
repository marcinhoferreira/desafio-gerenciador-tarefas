unit TaskManagerServer.Controller.System;

interface

uses
   SysUtils, Classes,
   TaskManagerServer.Controller.Interfaces,
   Horse;

type
   TSystemController = class(TInterfacedObject, IController)
   private
      { Private declarations }
      constructor Create;
      procedure StatusVerify(req: THorseRequest; res: THorseResponse);
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
   Horse.Jhonson;

{ TSystemController }

constructor TSystemController.Create;
begin

end;

class function TSystemController.New: IController;
begin
   Result := Self.Create;
end;

procedure TSystemController.RegisterRoutes;
begin
   // System Routes - Status Verify
   THorse.Get('/System/StatusVerify', StatusVerify);
end;

procedure TSystemController.StatusVerify(req: THorseRequest; res: THorseResponse);
var
   ARetorno: TJSONObject;
begin
   ARetorno := TJSONObject.Create;
   try
      // Generate return information
      with ARetorno do
         begin
            AddPair('status', 'success');
            AddPair('message', 'Server is running, on port ' + THorse.Port.toString);
         end;
      Res.Send<TJSONObject>(ARetorno);
   finally
      ARetorno := Nil;
   end;
end;

end.
