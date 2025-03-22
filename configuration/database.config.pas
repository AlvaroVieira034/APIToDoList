unit database.config;

interface

uses
  FireDAC.Comp.Client;

type
  TDatabaseConfig = class
  public
    class function GetConnection: TFDConnection;
  end;

implementation

class function TDatabaseConfig.GetConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.DriverName := 'SQLite';
  Result.Params.Database := 'bancoteste.db';
  Result.Connected := True;
end;

end.
