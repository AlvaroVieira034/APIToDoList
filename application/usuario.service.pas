unit usuario.service;

interface

uses
  Usuario, IUsuario.Repository, System.RegularExpressions, System.SysUtils;

type
  TUsuarioService = class
  private
    FUsuarioRepository: IUsuarioRepository;

  public
    constructor Create(AUsuarioRepository: IUsuarioRepository); // Construtor com inje��o de depend�ncia
    function Login(const AEmail, ASenha: string): TUsuario; // M�todo de inst�ncia
    procedure Cadastrar(const AUsuario: TUsuario);
    function ListarTodos: TArray<TUsuario>;

  end;

implementation

constructor TUsuarioService.Create(AUsuarioRepository: IUsuarioRepository);
begin
  inherited Create;
  FUsuarioRepository := AUsuarioRepository;
end;

function TUsuarioService.ListarTodos: TArray<TUsuario>;
begin
  Result := FUsuarioRepository.BuscarTodos;
end;

function TUsuarioService.Login(const AEmail, ASenha: string): TUsuario;
var Usuario: TUsuario;
begin
  Usuario := FUsuarioRepository.BuscarPorEmail(AEmail);
  if (Usuario <> nil) and (Usuario.Senha = ASenha) then
    Result := Usuario
  else
    Result := nil;
end;

procedure TUsuarioService.Cadastrar(const AUsuario: TUsuario);
begin
  // Valida��o do nome
  if AUsuario.Nome.Trim.IsEmpty then
    raise Exception.Create('O nome do usu�rio n�o pode estar vazio.');

  // Valida��o do e-mail
  if not TRegEx.IsMatch(AUsuario.Email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') then
    raise Exception.Create('O e-mail do usu�rio � inv�lido.');

  // Valida��o da senha
  if AUsuario.Senha.Length < 6 then
    raise Exception.Create('A senha deve ter pelo menos 6 caracteres.');

  // Se todas as valida��es passarem, salva o usu�rio
  FUsuarioRepository.Salvar(AUsuario);
end;

end.
