unit tarefa.controller;

interface

uses Horse, usuario, usuario.service, usuario.repository, usuario.session, iusuario.repository, tarefa, tarefa.service, itarefa.repository,
     tarefa.repository, tarefa.dto, global, System.JSON, System.SysUtils;

procedure ListarTarefas(Req: THorseRequest; Res: THorseResponse);
procedure CriarTarefa(Req: THorseRequest; Res: THorseResponse);
procedure ConcluirTarefa(Req: THorseRequest; Res: THorseResponse);
procedure ExcluirTarefa(Req: THorseRequest; Res: THorseResponse);

implementation

procedure ListarTarefas(Req: THorseRequest; Res: THorseResponse);
var
  TarefaService: TTarefaService;
  TarefaRepository: ITarefaRepository;
  Tarefas: TArray<TTarefa>;
  JSONArray: TJSONArray;
  Tarefa: TTarefa;
begin
  try
    TarefaRepository := TTarefaRepository.Create;
    TarefaService := TTarefaService.Create(TarefaRepository);

    // Busca tarefas do usuário logado
    Tarefas := TarefaService.ListarPorUsuarioId(UsuarioLogado);
    //Tarefas := TarefaService.ListarPorUsuarioId(Tarefa.UsuarioId);

    // Converte para JSON
    JSONArray := TJSONArray.Create;
    for Tarefa in Tarefas do
    begin
      JSONArray.AddElement(
        TJSONObject.Create
          .AddPair('id', TJSONNumber.Create(Tarefa.Id))
          .AddPair('descricao', TJSONString.Create(Tarefa.Descricao))
          .AddPair('concluida', TJSONBool.Create(Tarefa.Concluida))
      );
    end;

    Res.Send(JSONArray);
  except
    on E: Exception do
      Res.Status(500).Send('Erro interno: ' + E.Message);
  end;
end;

procedure CriarTarefa(Req: THorseRequest; Res: THorseResponse);
var
  TarefaRequest: TTarefaRequestDTO;
  Tarefa: TTarefa;
  TarefaService: TTarefaService;
  TarefaRepository: ITarefaRepository;
begin
  TarefaRequest := TTarefaRequestDTO.Create;
  try
    TarefaRequest.Descricao := Req.Body<TJSONObject>.GetValue<string>('descricao');
    Tarefa := TTarefa.Create;
    try
      Tarefa.Descricao := TarefaRequest.Descricao;
      Tarefa.UsuarioId := TarefaRequest.UsuarioId;
      TarefaRepository := TTarefaRepository.Create;
      TarefaService := TTarefaService.Create(TarefaRepository);
      TarefaService.Criar(Tarefa);
      Res.Status(201).Send('Tarefa criada com sucesso');
    finally
      Tarefa.Free;
    end;
  finally
    TarefaRequest.Free;
  end;
end;

procedure ConcluirTarefa(Req: THorseRequest; Res: THorseResponse);
var
  Id: Integer;
  TarefaService: TTarefaService;
  TarefaRepository: ITarefaRepository;
begin
  Id := Req.Params['id'].ToInteger;

  TarefaRepository := TTarefaRepository.Create;
  TarefaService := TTarefaService.Create(TarefaRepository);

  TarefaService.Concluir(Id);
  Res.Send('Tarefa concluída com sucesso');
end;

procedure ExcluirTarefa(Req: THorseRequest; Res: THorseResponse);
var
  Id: Integer;
  TarefaService: TTarefaService;
  TarefaRepository: ITarefaRepository;
begin
  Id := Req.Params['id'].ToInteger;

  TarefaRepository := TTarefaRepository.Create;
  TarefaService := TTarefaService.Create(TarefaRepository);

  TarefaService.Excluir(Id);
  Res.Send('Tarefa excluída com sucesso');
end;

end.
