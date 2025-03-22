unit tarefa.repository;

interface

uses  Tarefa, itarefa.repository,  FireDAC.Comp.Client;

type
  TTarefaRepository = class(TInterfacedObject, ITarefaRepository)
  public
    function BuscarPorUsuarioId(const AUsuarioId: Integer): TArray<TTarefa>;
    procedure Salvar(const ATarefa: TTarefa);
    procedure Concluir(const AId: Integer);
    procedure Excluir(const AId: Integer);
  end;

implementation

uses database.config, System.SysUtils;

function TTarefaRepository.BuscarPorUsuarioId(const AUsuarioId: Integer): TArray<TTarefa>;
var Conn: TFDConnection;
    Query: TFDQuery;
    Tarefas: TArray<TTarefa>;
    I: Integer;
begin
  Conn := TDatabaseConfig.GetConnection;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.SQL.Text := 'SELECT * FROM tarefas WHERE usuario_id = :usuario_id';
      Query.ParamByName('usuario_id').AsInteger := AUsuarioId;
      Query.Open;

      SetLength(Tarefas, Query.RecordCount);
      I := 0;
      while not Query.Eof do
      begin
        Tarefas[I] := TTarefa.Create;
        Tarefas[I].Id := Query.FieldByName('id').AsInteger;
        Tarefas[I].UsuarioId := Query.FieldByName('usuario_id').AsInteger;
        Tarefas[I].Descricao := Query.FieldByName('descricao').AsString;
        Tarefas[I].Concluida := Query.FieldByName('concluida').AsBoolean;
        Query.Next;
        Inc(I);
      end;
      Result := Tarefas;
    finally
      Query.Free;
    end;
  finally
    Conn.Free;
  end;
end;

procedure TTarefaRepository.Salvar(const ATarefa: TTarefa);
var Conn: TFDConnection;
    Query: TFDQuery;
begin
  Conn := TDatabaseConfig.GetConnection;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.SQL.Text := 'INSERT INTO tarefas (usuario_id, descricao) VALUES (:usuario_id, :descricao)';
      Query.ParamByName('usuario_id').AsInteger := ATarefa.UsuarioId;
      Query.ParamByName('descricao').AsString := ATarefa.Descricao;
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  finally
    Conn.Free;
  end;
end;

procedure TTarefaRepository.Concluir(const AId: Integer);
var Conn: TFDConnection;
    Query: TFDQuery;
begin
  Conn := TDatabaseConfig.GetConnection;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.SQL.Text := 'UPDATE tarefas SET concluida = 1 WHERE id = :id';
      Query.ParamByName('id').AsInteger := AId;
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  finally
    Conn.Free;
  end;
end;

procedure TTarefaRepository.Excluir(const AId: Integer);
var Conn: TFDConnection;
    Query: TFDQuery;
begin
  Conn := TDatabaseConfig.GetConnection;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := Conn;
      Query.SQL.Text := 'DELETE FROM tarefas WHERE id = :id';
      Query.ParamByName('id').AsInteger := AId;
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  finally
    Conn.Free;
  end;
end;

end.

