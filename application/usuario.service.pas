unit usuario.service;

interface

uses
  Usuario, IUsuario.Repository, System.RegularExpressions, System.SysUtils;

type
  TUsuarioService = class
  private
    FUsuarioRepository: IUsuarioRepository;

  public
    constructor Create(AUsuarioRepository: IUsuarioRepository); // Construtor com injeção de dependência
    function Login(const AEmail, ASenha: string): TUsuario; // Método de instância
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
  // Validação do nome
  if AUsuario.Nome.Trim.IsEmpty then
    raise Exception.Create('O nome do usuário não pode estar vazio.');

  // Validação do e-mail
  if not TRegEx.IsMatch(AUsuario.Email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') then
    raise Exception.Create('O e-mail do usuário é inválido.');

  // Validação da senha
  if AUsuario.Senha.Length < 6 then
    raise Exception.Create('A senha deve ter pelo menos 6 caracteres.');

  // Se todas as validações passarem, salva o usuário
  FUsuarioRepository.Salvar(AUsuario);
end;

end.
