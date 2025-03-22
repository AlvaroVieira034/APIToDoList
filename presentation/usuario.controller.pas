unit usuario.controller;

interface

uses  Horse, Horse.Session, usuario.service, usuario, usuario.session, IUsuario.Repository, usuario.repository,
      System.SysUtils, System.JSON;

procedure Login(Req: THorseRequest; Res: THorseResponse);
procedure Cadastrar(Req: THorseRequest; Res: THorseResponse);
procedure ConfigurarCORS(Req: THorseRequest; Res: THorseResponse);

implementation

procedure Login(Req: THorseRequest; Res: THorseResponse);
var
  Usuario: TUsuario;
  UsuarioSession: TUsuarioSession;
  JSON: TJSONObject;
  Email, Senha: string;
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

    // Cria o repositório e o serviço
    UsuarioRepository := TUsuarioRepository.Create;
    UsuarioService := TUsuarioService.Create(UsuarioRepository);

    // Chama o método de instância Login
    Usuario := UsuarioService.Login(Email, Senha);

    if Usuario <> nil then
    begin
      UsuarioSession := Req.Session<TUsuarioSession>;
      if UsuarioSession = nil then
      begin
        Res.Status(500).Send('Erro ao criar sessão');
        Exit;
      end;

      UsuarioSession.UsuarioId := Usuario.Id;

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


procedure Cadastrar(Req: THorseRequest; Res: THorseResponse);
var
  Usuario: TUsuario;
  UsuarioService: TUsuarioService;
  UsuarioRepository: IUsuarioRepository;
begin
  Usuario := TUsuario.Create;
  try
    Usuario.Nome := Req.Body<TJSONObject>.GetValue<string>('nome');
    Usuario.Email := Req.Body<TJSONObject>.GetValue<string>('email');
    Usuario.Senha := Req.Body<TJSONObject>.GetValue<string>('senha');

    UsuarioRepository := TUsuarioRepository.Create;
    UsuarioService := TUsuarioService.Create(UsuarioRepository);

    UsuarioService.Cadastrar(Usuario);

    Res.Status(201).Send('Usuário cadastrado com sucesso');
  finally
    Usuario.Free;
  end;
end;

procedure ConfigurarCORS(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('OK');
end;

initialization
  THorse.Post('/login', Login);
  THorse.Post('/cadastro', Cadastrar);
  THorse.Get('/cadastro', ConfigurarCORS);

end.
