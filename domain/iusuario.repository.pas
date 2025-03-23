unit iusuario.repository;

interface

uses Usuario;

type
  IUsuarioRepository = interface
    ['{20F18D58-50B8-4D14-B220-5D9500ED4A14}']
    function BuscarPorEmail(const AEmail: string): TUsuario;
    function BuscarTodos: TArray<TUsuario>;
    procedure Salvar(const AUsuario: TUsuario);
  end;

implementation

end.
