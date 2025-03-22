unit tarefa.controller;

interface

uses Horse, usuario, usuario.service, usuario.repository, usuario.session, iusuario.repository, tarefa, tarefa.service, itarefa.repository,
     tarefa.repository, tarefa.dto, System.JSON, System.SysUtils;

procedure ListarTarefas(Req: THorseRequest; Res: THorseResponse);
procedure CriarTarefa(Req: THorseRequest; Res: THorseResponse);
procedure ConcluirTarefa(Req: THorseRequest; Res: THorseResponse);
procedure ExcluirTarefa(Req: THorseRequest; Res: THorseResponse);

implementation

procedure ListarTarefas(Req: THorseRequest; Res: THorseResponse);
var Usuario: TUsuario;
    UsuarioSession: TUsuarioSession;
    JSON: TJSONObject;
    Email, Senha: string;
    TarefaService: TTarefaService;
    TarefaRepository: ITarefaRepository;
    UsuarioService: TUsuarioService;
    UsuarioRepository: IUsuarioRepository;
begin
  try
    if not Req.Body<TJSONObject>.TryGetValue<string>('email', Email) then
    begin
      Res.Status(400).Send('Campo "email" não encontrado');
      Exit;
    end;

    if not Req.Body<TJSONObject>.TryGetValue<string>('senha', Senha) then
    begin
      Res.Status(400).Send('Campo "senha" não encontrado');
      Exit;
    end;

    // Cria o repositório e o serviço de usuário
    UsuarioRepository := TUsuarioRepository.Create;
    UsuarioService := TUsuarioService.Create(UsuarioRepository);

    // Chama o método de instância Login
    Usuario := UsuarioService.Login(Email, Senha);

    if Usuario <> nil then
    begin
      UsuarioSession := Req.Session<TUsuarioSession>;
      UsuarioSession.UsuarioId := Usuario.Id;

      // Cria o repositório e o serviço de tarefa
      TarefaRepository := TTarefaRepository.Create;
      TarefaService := TTarefaService.Create(TarefaRepository);

      JSON := TJSONObject.Create;
      try
        JSON.AddPair('id', TJSONNumber.Create(Usuario.Id));
        JSON.AddPair('nome', TJSONString.Create(Usuario.Nome));
        Res.Send(JSON);
      finally
        JSON.Free;
      end;
    end
    else
      Res.Status(401).Send('Login falhou');
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
    // Converte o JSON recebido em um DTO
    TarefaRequest.Descricao := Req.Body<TJSONObject>.GetValue<string>('descricao');
    TarefaRequest.Concluida := Req.Body<TJSONObject>.GetValue<Boolean>('concluida');

    // Converte o DTO em uma entidade de domínio
    Tarefa := TTarefa.Create;
    try
      Tarefa.Descricao := TarefaRequest.Descricao;
      Tarefa.Concluida := TarefaRequest.Concluida;

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
