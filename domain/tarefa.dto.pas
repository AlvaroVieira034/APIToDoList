unit tarefa.dto;

interface

type
  TTarefaRequestDTO = class
  private
    FDescricao: string;
    FConcluida: Boolean;

  public
    property Descricao: string read FDescricao write FDescricao;
    property Concluida: Boolean read FConcluida write FConcluida;

  end;

  TTarefaResponseDTO = class
  private
    FId: Integer;
    FDescricao: string;
    FConcluida: Boolean;

  public
    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Concluida: Boolean read FConcluida write FConcluida;

  end;

implementation

end.
