unit usuario.repository;

interface

uses Usuario, IUsuario.Repository, FireDAC.Comp.Client;

type
  TUsuarioRepository = class(TInterfacedObject, IUsuarioRepository)
  public
    function BuscarPorEmail(const AEmail: string): TUsuario;
    procedure Salvar(const AUsuario: TUsuario);

  end;

implementation

uses database.config, System.SysUtils;

function TUsuarioRepository.BuscarPorEmail(const AEmail: string): TUsuario;
var Conn: TFDConnection;
    Query: TFDQuery;
begin
  Conn := TDatabaseConfig.GetConnection;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.SQL.Text := 'SELECT * FROM usuarios WHERE email = :email';
      Query.ParamByName('email').AsString := AEmail;
      Query.Open;

      if not Query.IsEmpty then
      begin
        Result := TUsuario.Create;
        Result.Id := Query.FieldByName('id').AsInteger;
        Result.Nome := Query.FieldByName('nome').AsString;
        Result.Email := Query.FieldByName('email').AsString;
        Result.Senha := Query.FieldByName('senha').AsString;
      end
      else
        Result := nil;
    finally
      Query.Free;
    end;
  finally
    Conn.Free;
  end;
end;

procedure TUsuarioRepository.Salvar(const AUsuario: TUsuario);
var Conn: TFDConnection;
    Query: TFDQuery;
begin
  Conn := TDatabaseConfig.GetConnection;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.SQL.Text := 'INSERT INTO usuarios (nome, email, senha) VALUES (:nome, :email, :senha)';
      Query.ParamByName('nome').AsString := AUsuario.Nome;
      Query.ParamByName('email').AsString := AUsuario.Email;
      Query.ParamByName('senha').AsString := AUsuario.Senha;
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  finally
    Conn.Free;
  end;
end;

end.
