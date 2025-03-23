unit usuario.service;

interface

uses
  Usuario, IUsuario.Repository;

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
var
  Usuario: TUsuario;
begin
  Usuario := FUsuarioRepository.BuscarPorEmail(AEmail);
  if (Usuario <> nil) and (Usuario.Senha = ASenha) then
    Result := Usuario
  else
    Result := nil;
end;

procedure TUsuarioService.Cadastrar(const AUsuario: TUsuario);
begin
  FUsuarioRepository.Salvar(AUsuario);
end;

end.
