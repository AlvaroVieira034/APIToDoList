unit usuario.controller;

interface

uses  Horse, Horse.Session, usuario.service, usuario, usuario.session, IUsuario.Repository, usuario.repository,
      usuario.dto, System.SysUtils, System.JSON;

procedure Login(Req: THorseRequest; Res: THorseResponse);
procedure Cadastrar(Req: THorseRequest; Res: THorseResponse);
procedure ListarUsuarios(Req: THorseRequest; Res: THorseResponse);
procedure ConfigurarCORS(Req: THorseRequest; Res: THorseResponse);

implementation

procedure Login(Req: THorseRequest; Res: THorseResponse);
var
  Usuario: TUsuario;
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

    UsuarioRepository := TUsuarioRepository.Create;
    UsuarioService := TUsuarioService.Create(UsuarioRepository);

    Usuario := UsuarioService.Login(Email, Senha);

    if Usuario <> nil then
    begin
      JSON := TJSONObject.Create;
      JSON.AddPair('id', TJSONNumber.Create(Usuario.Id));
      JSON.AddPair('nome', TJSONString.Create(Usuario.Nome));
      JSON.AddPair('message', TJSONString.Create('Login efetuado com sucesso!'));

      // Retorna a resposta e NÃO libera o JSON manualmente
      Res.Send(JSON);
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
  UsuarioRequest: TUsuarioRequestDTO;
  Usuario: TUsuario;
  UsuarioService: TUsuarioService;
  UsuarioRepository: IUsuarioRepository;
begin
  UsuarioRequest := TUsuarioRequestDTO.Create;
  try
    // Converte o JSON recebido em um DTO
    UsuarioRequest.Nome := Req.Body<TJSONObject>.GetValue<string>('nome');
    UsuarioRequest.Email := Req.Body<TJSONObject>.GetValue<string>('email');
    UsuarioRequest.Senha := Req.Body<TJSONObject>.GetValue<string>('senha');

    // Converte o DTO em uma entidade de domínio
    Usuario := TUsuario.Create;
    try
      Usuario.Nome := UsuarioRequest.Nome;
      Usuario.Email := UsuarioRequest.Email;
      Usuario.Senha := UsuarioRequest.Senha;

      UsuarioRepository := TUsuarioRepository.Create;
      UsuarioService := TUsuarioService.Create(UsuarioRepository);

      UsuarioService.Cadastrar(Usuario);

      Res.Status(201).Send('Usuário cadastrado com sucesso');
    finally
      Usuario.Free;
    end;
  finally
    UsuarioRequest.Free;
  end;
end;

procedure ListarUsuarios(Req: THorseRequest; Res: THorseResponse);
var
  UsuarioService: TUsuarioService;
  UsuarioRepository: IUsuarioRepository;
  Usuarios: TArray<TUsuario>;
  JSONArray: TJSONArray;
  Usuario: TUsuario;
begin
  try
    UsuarioRepository := TUsuarioRepository.Create;
    UsuarioService := TUsuarioService.Create(UsuarioRepository);

    Usuarios := UsuarioService.ListarTodos;

    JSONArray := TJSONArray.Create;
    for Usuario in Usuarios do
    begin
      JSONArray.AddElement(
        TJSONObject.Create
          .AddPair('id', TJSONNumber.Create(Usuario.Id))
          .AddPair('nome', TJSONString.Create(Usuario.Nome))
          .AddPair('email', TJSONString.Create(Usuario.Email))
      );
    end;

    Res.Send(JSONArray);
  except
    on E: Exception do
      Res.Status(500).Send('Erro interno: ' + E.Message);
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
