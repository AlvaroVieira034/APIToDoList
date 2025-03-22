unit tarefa.dto;

interface

type
  TTarefaRequestDTO = class
  private
    FUsuarioId: Integer;
    FDescricao: string;
    FConcluida: Boolean;

  public
    property UsuarioId: Integer read FUsuarioId write FUsuarioId;
    property Descricao: string read FDescricao write FDescricao;
    property Concluida: Boolean read FConcluida write FConcluida;

  end;

  TTarefaResponseDTO = class
  private
    FId: Integer;
    FUsuarioId: Integer;
    FDescricao: string;
    FConcluida: Boolean;

  public
    property Id: Integer read FId write FId;
    property UsuarioId: Integer read FUsuarioId write FUsuarioId;
    property Descricao: string read FDescricao write FDescricao;
    property Concluida: Boolean read FConcluida write FConcluida;

  end;

implementation

end.
