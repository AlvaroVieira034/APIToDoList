unit usuario.dto;

interface

type
  TUsuarioRequestDTO = class
  private
    FNome: string;
    FEmail: string;
    FSenha: string;

  public
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;
    property Senha: string read FSenha write FSenha;

  end;

  TUsuarioResponseDTO = class
  private
    FId: Integer;
    FNome: string;
    FEmail: string;

  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;

  end;

implementation

end.
